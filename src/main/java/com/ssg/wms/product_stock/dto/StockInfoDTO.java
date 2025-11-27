package com.ssg.wms.product_stock.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StockInfoDTO {
    private Long psId;          // 재고 번호 (Product_Stock.ps_id)
    private String productId;   // 상품 ID (Product.product_id)
    private String productName; // 상품 이름 (Product.product_name)
    private String brandName;   // 브랜드 (Partner.partner_name)
    private int quantity;       // 수량 (Product_Stock.quantity)
    private String warehouseName; // 창고 이름 (WAREHOUSE.name)
    private String sectionName;   // 섹션 이름 (Section.section_name)
}
