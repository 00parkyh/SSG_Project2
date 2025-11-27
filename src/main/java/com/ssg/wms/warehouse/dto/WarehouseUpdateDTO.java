package com.ssg.wms.warehouse.dto;
/// 창고 수정 요청 DTO입니다!!!!
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/// -> 피드백 반영-> 창고수정은 창고 담당자 ID만 수정 .
@Data
@AllArgsConstructor
@NoArgsConstructor

public class WarehouseUpdateDTO {

    ///창고 담당자 ID
    private Long adminId;

    /// 수정 대상 창고 ID
    private Long warehouseId;

    /// 창고명
    private String name;

    /// 창고주소
    private String address;


    ///창고 종류 Hub or spoke
    private String warehouseType;

    ///창고 총 수용 용량
    private Integer warehouseCapacity;

    /// 창고 현재 운영 현황
    private Integer warehouseStatus;
}