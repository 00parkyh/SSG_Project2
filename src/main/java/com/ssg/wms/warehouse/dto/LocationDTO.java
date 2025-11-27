package com.ssg.wms.warehouse.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LocationDTO {

    /// 수정시만 등록
    private Long locationId;


    private Long sectionId;

    /// - 위치가 속한 창고 ID
    private Long warehouseId;

    /// 위치 코드 (예: A-01-01)
    @NotBlank(message = "위치 코드는 필수 입력 항목입니다.")
    private String locationCode;

    /// 위치가 있는 층수
    @NotNull(message = "층수는 필수 입력 항목입니다.")
    private Integer floorNum;

    /// 위치의 유형 코드
    private String locationTypeCode;

    ///해당 위치의 최대 적재 가능 부피
    @NotNull(message = "최대 부피는 필수 입력 항목입니다.")
    private double maxVolume;


}