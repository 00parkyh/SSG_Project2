package com.ssg.wms.product_stock.service;

import com.ssg.wms.product_stock.dto.DropdownDTO;
import com.ssg.wms.product_stock.dto.PageRequestDTO;
import com.ssg.wms.product_stock.dto.PageResponseDTO;
import com.ssg.wms.product_stock.dto.StockInfoDTO;
import com.ssg.wms.product_stock.dto.StockLogDTO;
import com.ssg.wms.product_stock.dto.StockSummaryDTO;

import java.util.List;

public interface ProductStockService {

    List<DropdownDTO> categoryDropDown();

    List<DropdownDTO> brandDropDown();

    List<DropdownDTO> warehouseDropDown();

    List<DropdownDTO> sectionDropDown();

    List<DropdownDTO> sectionDropDownByWarehouseId(Long warehouseId);

    PageResponseDTO<StockInfoDTO> getStockList(PageRequestDTO pageRequestDTO);

    StockSummaryDTO getProductSummary(String productId);

    List<StockLogDTO> getStockMovementLogs(String productId);

    void decreaseStockByProduct(Long warehouseId, String productId, int quantity);
}
