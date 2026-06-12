package com.ssg.wms.product_stock.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PhysicalInventoryRequest {
    private Long piId;
    private String inventoryBatchId;

    // Registration request fields
    private LocalDate piDate;
    private String piState;
    private Long staffId; // Staff ID
    private Long warehouseId;
    private Long sectionId;

    // Mapper-only fields used during registration for stock snapshot data
    private Long psId; // Target ProductStock ID
    private int calculatedQuantity; // Snapshot quantity from ProductStock
}
