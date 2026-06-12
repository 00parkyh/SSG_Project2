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
    private String inventoryBatchId;
    private String piDate;
    private String productId;
    private String piState;
    private int calculatedQuantity; // Snapshot quantity (pid_quantity)
    private Integer realQuantity; // Actual quantity (real_quantity, nullable)
    private Integer differentQuantity; // Difference quantity (different_quantity, nullable)
    private String warehouseName;
    private String sectionName;
    private String adjustmentStatus; // Adjustment status (update_state)
}
