package com.ssg.wms.product_stock.dto;

import lombok.Data;

@Data
public class PhysicalInventoryBatchUpdateItemDTO {
    private int piId;
    private Integer realQuantity;
    private String updateState;
}
