package com.ssg.wms.product_stock.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PhysicalInventoryDTO {
    private int piId;
    private String piDate;
    private String productId;
    private String piState;
    private int calculatedQuantity; // 전산 수량 (pid_quantity)
    private Integer realQuantity;    // 실제 수량 (real_quantity, NULL 허용)
    private Integer differentQuantity; // 차이 수량 (different_quantity, NULL 허용)
    private String warehouseName;
    private String sectionName;
    private String adjustmentStatus; // 조정 여부 (update_state)
}