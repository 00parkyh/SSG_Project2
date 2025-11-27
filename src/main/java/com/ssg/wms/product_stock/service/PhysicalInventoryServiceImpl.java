package com.ssg.wms.product_stock.service;

import com.ssg.wms.product_stock.dto.*;
import com.ssg.wms.product_stock.mappers.PhysicalInventoryMapper;
import com.ssg.wms.product_stock.mappers.ProductStockMapper;
import com.ssg.wms.product_stock.mappers.dropDownMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class)
public class PhysicalInventoryServiceImpl implements PhysicalInventoryService {

    private final PhysicalInventoryMapper physicalInventoryMapper;

    @Override
    public int registerPhysicalInventory(PhysicalInventoryRequest request) {
        // 1. 해당 섹션의 현재 재고 목록(스냅샷)을 가져옵니다.
        List<StockSnapshotDTO> stocksToAudit = physicalInventoryMapper.selectStocksForPhysicalInventory(
                request.getWarehouseId(),
                request.getSectionId()
        );

        if (stocksToAudit.isEmpty()) {
            throw new IllegalArgumentException("선택된 창고/섹션에 현재 재고가 존재하지 않습니다. 실사 등록 불가.");
        }

        // 2. 각 재고 항목별로 Physical_Inventory 레코드를 생성합니다.
        for (StockSnapshotDTO stock : stocksToAudit) {

            // 등록 요청 DTO에 스냅샷 데이터 추가
            request.setPsId(stock.getPsId()); // 대상 재고 ID
            request.setCalculatedQuantity(stock.getQuantity()); // 전산 수량 스냅샷

            physicalInventoryMapper.insertPhysicalInventory(request);
        }
        return stocksToAudit.size(); // 등록된 항목 수 반환
    }

    @Override
    public PageResponseDTO<PhysicalInventoryDTO> getPhysicalInventoryList(PageRequestDTO pageRequestDTO) {
        // ... (리스트 조회 및 페이지네이션 로직) ...
        pageRequestDTO.normalize();
        int total = physicalInventoryMapper.selectPhysicalInventoryTotalCount(pageRequestDTO);
        List<PhysicalInventoryDTO> piList = physicalInventoryMapper.selectPhysicalInventoryList(pageRequestDTO);

        return PageResponseDTO.<PhysicalInventoryDTO>withAll()
                .dtoList(piList)
                .total(total)
                .pageRequestDTO(pageRequestDTO)
                .build();
    }

    @Override
    @Transactional
    public void updatePhysicalInventory(PhysicalInventoryUpdateDTO updateDTO) {
        // 1. PI 테이블 업데이트 (실제 수량, 차이 수량, 조정 여부 반영)
        physicalInventoryMapper.updatePhysicalInventory(updateDTO);

        // 2. 조정 완료('조정 완료') 상태일 경우 재고 반영 로직 실행
        if ("조정 완료".equals(updateDTO.getUpdateState())) {

            Long psId = physicalInventoryMapper.getPsIdByPiId(updateDTO.getPiId());

            // 업데이트된 PI 정보를 다시 조회하여 차이 수량 계산 (DB에서 계산된 값 재사용)
            Integer calculatedQuantity = physicalInventoryMapper.getCalculatedQuantityByPiId(updateDTO.getPiId());
            if (calculatedQuantity == null) {
                throw new IllegalStateException("해당 실사 ID의 전산 수량(스냅샷)을 찾을 수 없습니다.");
            }
            int quantityDifference = updateDTO.getRealQuantity() - calculatedQuantity;

            if (quantityDifference != 0) {
                // 2-1. Product_Stock 수량 조정
                physicalInventoryMapper.updateStockQuantity(psId, quantityDifference);

                // 2-2. 재고 로그 기록
                physicalInventoryMapper.insertStockLog(
                        psId,
                        Math.abs(quantityDifference), // 이동량의 절대값
                        (quantityDifference > 0) ? "실사증가" : "실사감소",
                        "정상",
                        "실사"
                );
            }
        }
    }
}
