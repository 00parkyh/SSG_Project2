package com.ssg.wms.product_stock.dto;

import lombok.Data;

@Data
public class StockSnapshotDTO {
    private Long psId;           // Product_Stock 고유 ID
    private String productId;    // 상품 ID (참조용)
    private int quantity;        // 현재 전산 수량 (스냅샷)
    private Long warehouseId;
    private Long sectionId;
}