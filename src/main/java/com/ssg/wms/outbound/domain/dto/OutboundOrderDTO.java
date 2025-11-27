package com.ssg.wms.outbound.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class OutboundOrderDTO {

    private Long approvedOrderID; // 출고지시서 인덱스
    private LocalDateTime approvedDate; // 승인일자
    private String instructionNo; // 지시서번호
    private String approvedStatus; // 지시상태
    private Long outboundRequestID; // 출고요청 FK
    private LocalDateTime outboundDate; // 출고 요청일자 (JOIN을 통해 조회)

    // 차량 및 배차 정보
    private Integer carId;
    private String dispatchStatus;
    private String driverName;
    private String carType;
    private String orderStatus;

    // 운송장 정보
    private String waybillNumber;
    private String waybillStatus;

    // 적재 정보
    private int loadedBox;
    private int maximumBOX;
    private long dispatchId;

    // 거래처 및 제품 정보
    private String partnerName;
    private String productName;

    // ✨ 창고 정보 추가
    private Long warehouseId;           // 창고 ID (필수)
    private String warehouseName;       // 창고명 (조회용)

}
