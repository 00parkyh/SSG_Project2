package com.ssg.wms.product_stock.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
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
    // 등록 요청 필드
    private LocalDate piDate;
    private String piState;
    private Long staffId; // 담당자 ID
    private Long warehouseId;
    private Long sectionId;
    // Mapper 내부 사용 필드 (등록 시 재고 스냅샷 저장용)
    private Long psId; // 대상 Product_Stock ID
    private int calculatedQuantity; // 전산 수량 (PS 테이블에서 조회된 값)
}