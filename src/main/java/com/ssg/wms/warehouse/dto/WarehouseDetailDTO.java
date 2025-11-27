package com.ssg.wms.warehouse.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor

/// 창고 상세 DTO 입니다!!

public class WarehouseDetailDTO {
    /// 창고 식별 ID
    private Long warehouseId;

    /// 창고 담당자 ID
    private Long adminId;

    /// 창고 상세 정보 목록
    private String name;
    private String warehouseType;
    private Integer warehouseCapacity;
    private Integer warehouseStatus;
    private String address;
    private Double latitude;
    private Double longitude;

    ///창고 등록 일자
    private LocalDate registrationDate;

    ///창고 최종 수정 일시
    private LocalDateTime latestUpdateDate;

    // --- 연관 정보 ---

    ///창고 구역 목록
    private List<SectionDTO> sections;

    ///창고 위치 목록
    private List<LocationDTO> locations;
}