package com.ssg.wms.warehouse.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class WarehouseSearchDTO {

    /// 창고 이름
    private String warehouseName;

    /// 창고 주소 검색어
    private String warehouseAddress;

    /// 창고 종류 필터 조건
    private String warehouseType;

    /// 창고 상태 필터 조건 추가
    private Integer warehouseStatus; 
}
