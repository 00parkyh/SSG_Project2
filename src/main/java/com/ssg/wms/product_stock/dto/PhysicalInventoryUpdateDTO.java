package com.ssg.wms.product_stock.dto;

import lombok.Data;

@Data
public class PhysicalInventoryUpdateDTO {
    private int piId;
    private int realQuantity;
    private String updateState; // '조정 완료' 또는 '예약'
}