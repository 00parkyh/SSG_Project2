package com.ssg.wms.product_stock.service;

import com.ssg.wms.common.AdjustmentStatus;
import com.ssg.wms.product_stock.dto.PageRequestDTO;
import com.ssg.wms.product_stock.dto.PageResponseDTO;
import com.ssg.wms.product_stock.dto.PhysicalInventoryBatchUpdateDTO;
import com.ssg.wms.product_stock.dto.PhysicalInventoryBatchUpdateItemDTO;
import com.ssg.wms.product_stock.dto.PhysicalInventoryDTO;
import com.ssg.wms.product_stock.dto.PhysicalInventoryRequest;
import com.ssg.wms.product_stock.dto.PhysicalInventoryUpdateDTO;
import com.ssg.wms.product_stock.dto.StockSnapshotDTO;
import com.ssg.wms.product_stock.mappers.PhysicalInventoryMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class)
public class PhysicalInventoryServiceImpl implements PhysicalInventoryService {

    private static final String COMPLETED_STATE = "완료";

    private final PhysicalInventoryMapper physicalInventoryMapper;

    @Override
    public int registerPhysicalInventory(PhysicalInventoryRequest request) {
        List<StockSnapshotDTO> stocksToAudit = physicalInventoryMapper.selectStocksForPhysicalInventory(
                request.getWarehouseId(),
                request.getSectionId()
        );

        if (stocksToAudit.isEmpty()) {
            throw new IllegalArgumentException("선택한 창고/섹션에 현재 재고가 존재하지 않습니다. 실사 등록 불가.");
        }

        request.setInventoryBatchId(UUID.randomUUID().toString());

        for (StockSnapshotDTO stock : stocksToAudit) {
            request.setPsId(stock.getPsId());
            request.setCalculatedQuantity(stock.getQuantity());
            physicalInventoryMapper.insertPhysicalInventory(request);
        }

        return stocksToAudit.size();
    }

    @Override
    public PageResponseDTO<PhysicalInventoryDTO> getPhysicalInventoryList(PageRequestDTO pageRequestDTO) {
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
    public List<PhysicalInventoryDTO> getPhysicalInventoryDetailList(String inventoryBatchId) {
        return physicalInventoryMapper.selectPhysicalInventoryDetailList(inventoryBatchId);
    }

    @Override
    @Transactional
    public void updatePhysicalInventory(PhysicalInventoryUpdateDTO updateDTO) {
        physicalInventoryMapper.updatePhysicalInventory(updateDTO);

        if (!COMPLETED_STATE.equals(updateDTO.getPiState())) {
            return;
        }

        if (updateDTO.getRealQuantity() == null || updateDTO.getUpdateState() == null) {
            throw new IllegalArgumentException("완료 상태에서는 실제 수량과 조정 여부가 필요합니다.");
        }

        adjustStockByItem(updateDTO.getPiId(), updateDTO.getRealQuantity(), updateDTO.getUpdateState());
    }

    @Override
    @Transactional
    public void updatePhysicalInventoryBatch(PhysicalInventoryBatchUpdateDTO updateDTO) {
        physicalInventoryMapper.updatePhysicalInventoryStateByBatchId(updateDTO.getInventoryBatchId(), updateDTO.getPiState());

        if (!COMPLETED_STATE.equals(updateDTO.getPiState())) {
            return;
        }

        if (updateDTO.getItems() == null || updateDTO.getItems().isEmpty()) {
            throw new IllegalArgumentException("완료 상태에서는 실사 상세 항목이 필요합니다.");
        }

        for (PhysicalInventoryBatchUpdateItemDTO item : updateDTO.getItems()) {
            if (item.getRealQuantity() == null || item.getUpdateState() == null) {
                throw new IllegalArgumentException("완료 상태에서는 실제 수량과 조정 여부가 필요합니다.");
            }

            PhysicalInventoryUpdateDTO itemUpdate = new PhysicalInventoryUpdateDTO();
            itemUpdate.setPiId(item.getPiId());
            itemUpdate.setPiState(updateDTO.getPiState());
            itemUpdate.setRealQuantity(item.getRealQuantity());
            itemUpdate.setUpdateState(item.getUpdateState());
            physicalInventoryMapper.updatePhysicalInventory(itemUpdate);

            adjustStockByItem(item.getPiId(), item.getRealQuantity(), item.getUpdateState());
        }
    }

    private void adjustStockByItem(int piId, int realQuantity, String updateState) {
        AdjustmentStatus adjustmentStatus = AdjustmentStatus.fromDbValue(updateState);
        if (adjustmentStatus != AdjustmentStatus.COMPLETED) {
            return;
        }

        Long psId = physicalInventoryMapper.getPsIdByPiId(piId);

        Integer calculatedQuantity = physicalInventoryMapper.getCalculatedQuantityByPiId(piId);
        if (calculatedQuantity == null) {
            throw new IllegalStateException("해당 실사 ID의 계산 수량을 찾을 수 없습니다.");
        }

        int quantityDifference = realQuantity - calculatedQuantity;

        if (quantityDifference != 0) {
            physicalInventoryMapper.updateStockQuantity(psId, quantityDifference);

            physicalInventoryMapper.insertStockLog(
                    psId,
                    Math.abs(quantityDifference),
                    quantityDifference > 0 ? "실사증가" : "실사감소",
                    "정상",
                    "실사"
            );
        }
    }
}
