package com.ssg.wms.product_stock.service;

import com.ssg.wms.product_stock.dto.*;
import com.ssg.wms.product_stock.mappers.ProductListMapper;
import com.ssg.wms.product_stock.mappers.ProductStockMapper;
import com.ssg.wms.product_stock.mappers.dropDownMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.beans.Transient;
import java.util.List;

@Service
@RequiredArgsConstructor
@Log4j2
public class ProductStockServiceImpl implements ProductStockService{

    private final dropDownMapper dropDownMapper;
    private final ProductStockMapper productStockMapper;

    @Override
    public List<DropdownDTO> categoryDropDown() {
        return dropDownMapper.categoryDropDown();
    }

    @Override
    public List<DropdownDTO> brandDropDown() {
        return dropDownMapper.brandDropDown();
    }

    @Override
    public List<DropdownDTO> warehouseDropDown() {
        return dropDownMapper.warehouseDropDown();
    }

    @Override
    public List<DropdownDTO> sectionDropDown() {
        return dropDownMapper.sectionDropDown();
    }

    @Override
    public PageResponseDTO<StockInfoDTO> getStockList(PageRequestDTO pageRequestDTO) {

        pageRequestDTO.normalize();
        int totalCount = productStockMapper.countStockList(pageRequestDTO);
        List<StockInfoDTO> dtoList = productStockMapper.findStockList(pageRequestDTO);

        return PageResponseDTO.<StockInfoDTO>withAll()
                .pageRequestDTO(pageRequestDTO)
                .dtoList(dtoList)
                .total(totalCount)
                .build();
    }

    @Override
    public StockSummaryDTO getProductSummary(String productId) {
        return  productStockMapper.getProductSummaryById(productId);
    }

    @Override
    public List<StockLogDTO> getStockMovementLogs(String productId) {
        List<StockLogDTO> logs = productStockMapper.getStockMovementLogs(productId);
        // LocalDateTime → String 변환
        logs.forEach(log -> {
            if (log.getEventTime() != null) {
                log.setEventTimeString(log.getEventTime()
                        .format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));
            } else {
                log.setEventTimeString("");
            }
        });
        return logs;
    }

    // 동시성 제어 를 위해 추가함
    @Transactional
    public void decreaseStock(int psId, int quantity) {
        log.info("재고 차감 시도 (Lock 획득대기 ) psId : {}",psId);
        // 1. SELECT ... FOR UPDATE로 락 걸고 조회
        StockInfoDTO stock = productStockMapper.selectStockForUpdate(psId);

        if (stock == null) {
            throw new RuntimeException("해당 재고 정보를 찾을 수 없습니다. psId: " + psId);
        }

        // 2. 수량 검증
        if (stock.getQuantity() < quantity) {
            log.error(" 재고 부족 - 현재: {}, 요청: {}", stock.getQuantity(), quantity);
            throw new RuntimeException("재고가 부족합니다.");
        }

        // 3. 차감 계산
        int newQuantity = stock.getQuantity() - quantity;

        // 4. 업데이트 실행
        productStockMapper.updateStockQuantity(psId, newQuantity);

        log.info("재고 차감 완료 - psId: {}, 차감량: {}, 잔여량: {}", psId, quantity, newQuantity);
    }
}
