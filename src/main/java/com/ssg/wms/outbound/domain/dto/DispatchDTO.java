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
public class DispatchDTO {
    private Long dispatchId;
    private Integer carId;
    private String carType;
    private String driverName;
    private LocalDateTime assignedDate;
    private String dispatchStatus;
    private int loadedBox;
    private int maximumBox;
    private Long shipmentOrderId;
    private Long warehouseId;
    private String carNumber;

    private Long approvedOrderID; // 출고지시서 인덱스
    private LocalDateTime approvedDate; // 승인일자
    private int instructionNo; // 지시서번호
    private String approvedStatus; // 지시상태
    private Long outboundRequestID; // 출고요청 FK
    private LocalDateTime outboundDate; // 출고 요청일자 (JOIN을 통해 조회)
    private String orderStatus;
    private String WaybillNumber;
    private String partnerName;
    private String productName;
}
