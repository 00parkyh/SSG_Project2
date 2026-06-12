package com.ssg.wms.product_stock.mappers;

import com.ssg.wms.product_stock.dto.PageRequestDTO;
import com.ssg.wms.product_stock.dto.StockInfoDTO;
import com.ssg.wms.product_stock.dto.StockLogDTO;
import com.ssg.wms.product_stock.dto.StockSummaryDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ProductStockMapper {

    List<StockInfoDTO> findStockList(PageRequestDTO pageRequestDTO);

    int countStockList(PageRequestDTO pageRequestDTO);

    StockSummaryDTO getProductSummaryById(String productId);

    List<StockLogDTO> getStockMovementLogs(String productId);

    StockInfoDTO selectStockForUpdate(@Param("psId") int psId);

    List<StockInfoDTO> selectStocksForUpdateByWarehouseAndProduct(@Param("warehouseId") Long warehouseId,
                                                                  @Param("productId") String productId);

    int updateStockQuantity(@Param("psId") int psId, @Param("quantity") int quantity);

    int insertStockLog(@Param("psId") long psId,
                       @Param("moveQuantity") int moveQuantity,
                       @Param("eventType") String eventType,
                       @Param("productStatus") String productStatus,
                       @Param("destination") String destination);
}
