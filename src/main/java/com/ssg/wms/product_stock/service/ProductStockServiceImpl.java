package com.ssg.wms.product_stock.service;

import com.ssg.wms.product_stock.dto.*;
import com.ssg.wms.product_stock.mappers.ProductListMapper;
import com.ssg.wms.product_stock.mappers.ProductStockMapper;
import com.ssg.wms.product_stock.mappers.dropDownMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
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


}
