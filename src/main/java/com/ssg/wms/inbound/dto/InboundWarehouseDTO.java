package com.ssg.wms.inbound.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class InboundWarehouseDTO {
    private int warehouseId;
    private String warehouseName;
}
