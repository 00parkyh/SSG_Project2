package com.ssg.wms.warehouse.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.Valid;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.util.ArrayList; // ArrayList import
import java.util.List;


 ///창고 등록 및 수정 요청을 위한 DTO입니다.

@Data
@AllArgsConstructor
@NoArgsConstructor
public class WarehouseSaveDTO {



    @Valid
    private List<SectionDTO> sections = new ArrayList<>(); 

    /// 수정 시에만 사용되므로 등록 시에는 null이 허용됩니다.
    private Long warehouseId;

    /// 창고 이름
    @NotBlank(message = "창고 이름은 필수 입력 항목입니다.")
    private String name;

    ///창고 주소
    @NotBlank(message = "주소는 필수 입력 항목이며, 위치 확인이 필요합니다.")
    private String address;

    ///창고 담당자 ID
    @NotNull(message = "담당자 ID는 필수입니다.")
    private Long adminId;

    /// 창고 종류
    @NotBlank(message = "창고 종류는 필수 선택 항목입니다.")
    private String warehouseType;

    /// 창고 총 수용 용량
    @NotNull(message = "수용 용량은 필수 입력 항목입니다.")
    private Integer warehouseCapacity;

    /// 창고 현재 운영 현황 코드 (1: 운영 중, 0: 점검 중)
    @NotNull(message = "운영 현황은 필수 선택 항목입니다.")
    private Integer warehouseStatus;

    /// Service Geocoding 후 설정할 위도/경도 필드
    @NotNull(message = "위도(latitude) 값은 필수입니다. 주소 확인을 해주세요.")
    private Double latitude;

    @NotNull(message = "경도(longitude) 값은 필수입니다. 주소 확인을 해주세요.")
    private Double longitude;
}