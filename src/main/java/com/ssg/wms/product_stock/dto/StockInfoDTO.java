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
    private Long psId;
    private String productId;
    private String productName;
    private String brandName;
    private int quantity;
    private String productStatus;
    private String warehouseName;
    private String sectionName;
}
