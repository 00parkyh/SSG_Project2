package com.ssg.wms.warehouse.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;


/// 창고 목록 항목 DTO 입니다.!!

@Data
@AllArgsConstructor
@NoArgsConstructor
public class WarehouseListDTO {

    /// 창고 ID
    private Long warehouseId;

    /// 창고 이름
    private String name;

    /// 창고 종류
    private String warehouseType;

    /// 창고 주소
    private String address;

    /// 위도(카카오톡 Map)
    private Double latitude;

    /// 경도 (지도 마커 표시용)
    private Double longitude;


    /// 운영 현황 (0:점검 중, 1:운영 중)
    private Byte warehouseStatus;


    /// 최종 수정 일자
    private Date latestUpdateDate;

    private Date registrationDate;

}