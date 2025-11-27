package com.ssg.wms.warehouse.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.Valid;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.util.ArrayList; // ArrayList import 추가
import java.util.List;

/// 창고 구역 DTO

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SectionDTO {

    private Long sectionId;
    private Long warehouseId;

    /// 위치 DTO

    @Valid
    private List<LocationDTO> locations = new ArrayList<>();

    ///창고 구역 이름 (A구역/B구역/C구역/D구역)
    @NotBlank(message = "구역 이름은 필수 입력 항목입니다.")
    private String sectionName;

    ///창고 구역의 종류
    @NotBlank(message = "구역 타입은 필수 선택 항목입니다.")
    private String sectionType;

    /// 창고 구역의 목적 (창고 구역에 해당하는 목적 설명.)
    private String sectionPurpose;

    /// 창고 구역에 할당된 면적
    @NotNull(message = "면적은 필수 입력 항목입니다.")
    private double allocatedArea;



}