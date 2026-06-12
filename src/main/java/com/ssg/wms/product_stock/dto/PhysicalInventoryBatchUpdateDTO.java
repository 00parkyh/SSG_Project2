package com.ssg.wms.product_stock.dto;

import lombok.Data;

import java.util.List;

@Data
public class PhysicalInventoryBatchUpdateDTO {
    private String inventoryBatchId;
    private String piState;
    private List<PhysicalInventoryBatchUpdateItemDTO> items;
}
