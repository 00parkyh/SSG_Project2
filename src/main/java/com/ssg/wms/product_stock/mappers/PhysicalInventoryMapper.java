package com.ssg.wms.product_stock.mappers;

import com.ssg.wms.product_stock.dto.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface PhysicalInventoryMapper {

    /* 실사 리스트 조회 */
    List<PhysicalInventoryDTO> selectPhysicalInventoryList(PageRequestDTO pageRequestDTO);

    /* 실사 리스트 전체 카운트 */
    int selectPhysicalInventoryTotalCount(PageRequestDTO pageRequestDTO);

    /* 실사 등록 (PS_ID별로 레코드 생성) */
    void insertPhysicalInventory(PhysicalInventoryRequest piRequest);

    /* 실사 정보 업데이트 (실제 수량, 차이 수량, 조정 여부 반영) */
    void updatePhysicalInventory(PhysicalInventoryUpdateDTO updateDTO);

    /** 특정 창고/섹션의 현재 재고 목록을 조회 (실사 스냅샷용) */
    List<StockSnapshotDTO> selectStocksForPhysicalInventory(
            @Param("warehouseId") Long warehouseId,
            @Param("sectionId") Long sectionId
    );

    Long getPsIdByPiId(int piId);

    Integer getCalculatedQuantityByPiId(int piId);

    void updateStockQuantity(@Param("psId") Long psId, @Param("quantityChange") int quantityChange);

    void insertStockLog(
            @Param("psId") Long psId,
            @Param("moveQuantity") int moveQuantity,
            @Param("eventType") String eventType,
            @Param("productStatus") String productStatus,
            @Param("destination") String destination
    );

}