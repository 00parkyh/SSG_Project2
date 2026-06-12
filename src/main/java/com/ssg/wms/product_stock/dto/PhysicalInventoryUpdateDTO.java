package com.ssg.wms.product_stock.dto;

import lombok.Data;

@Data
public class PhysicalInventoryUpdateDTO {
    private int piId;
    private String piState;
    private Integer realQuantity;
    private String updateState;
}
