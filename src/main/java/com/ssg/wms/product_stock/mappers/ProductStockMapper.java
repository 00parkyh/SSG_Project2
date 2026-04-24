package com.ssg.wms.product_stock.mappers;

import com.ssg.wms.product_stock.dto.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

//재고 조회
@Mapper
public interface ProductStockMapper {

    List<StockInfoDTO> findStockList(PageRequestDTO pageRequestDTO);

    int countStockList(PageRequestDTO pageRequestDTO);

    /** 특정 상품 ID에 대한 상세 정보 (현재 재고, 위치 등)를 조회 */
    StockSummaryDTO getProductSummaryById(String productId);

    /** 특정 상품 ID에 대한 재고 이동 로그 목록을 조회 */
    List<StockLogDTO> getStockMovementLogs(String productId);

    //동시성 제어 | 비관적 락을 사용해서 재고 조회
    StockInfoDTO selectStockForUpdate(int psdId);

    //재고 수량 변경 (차감 또는 증가)
    int updateStockQuantity(int psId, int quantity);
}