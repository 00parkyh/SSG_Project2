package com.ssg.wms.product_stock.mappers;

import com.ssg.wms.product_stock.dto.PageRequestDTO;
import com.ssg.wms.product_stock.dto.PhysicalInventoryRequest;
import com.ssg.wms.product_stock.dto.PhysicalInventoryUpdateDTO;
import com.ssg.wms.product_stock.dto.StockSnapshotDTO;
import com.ssg.wms.product_stock.dto.PhysicalInventoryDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface PhysicalInventoryMapper {

    List<PhysicalInventoryDTO> selectPhysicalInventoryList(PageRequestDTO pageRequestDTO);

    int selectPhysicalInventoryTotalCount(PageRequestDTO pageRequestDTO);

    List<PhysicalInventoryDTO> selectPhysicalInventoryDetailList(@Param("inventoryBatchId") String inventoryBatchId);

    void insertPhysicalInventory(PhysicalInventoryRequest piRequest);

    void updatePhysicalInventory(PhysicalInventoryUpdateDTO updateDTO);

    void updatePhysicalInventoryStateByBatchId(@Param("inventoryBatchId") String inventoryBatchId,
                                               @Param("piState") String piState);

    List<StockSnapshotDTO> selectStocksForPhysicalInventory(@Param("warehouseId") Long warehouseId,
                                                            @Param("sectionId") Long sectionId);

    Long getPsIdByPiId(int piId);

    Integer getCalculatedQuantityByPiId(int piId);

    void updateStockQuantity(@Param("psId") Long psId, @Param("quantityChange") int quantityChange);

    void insertStockLog(@Param("psId") Long psId,
                        @Param("moveQuantity") int moveQuantity,
                        @Param("eventType") String eventType,
                        @Param("productStatus") String productStatus,
                        @Param("destination") String destination);
}
