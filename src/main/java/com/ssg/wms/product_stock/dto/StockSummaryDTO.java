package com.ssg.wms.product_stock.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StockSummaryDTO {
    private String productId;
    private String productName;
    private String warehouseName;
    private String sectionName;
    private int currentQuantity;
}
