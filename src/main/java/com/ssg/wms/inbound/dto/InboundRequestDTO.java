package com.ssg.wms.inbound.dto;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class InboundRequestDTO {
    // 등록/수정용 DTO
    private int inboundId;
    private int warehouseId;
    private int staffId;
    private Long memberId;             // 필수
    private String inboundStatus;      // 선택, 기본값: "request"
    private String inboundRejectReason; // 선택, 초기에는 null
    private LocalDateTime inboundRequestedAt;
    private LocalDateTime inboundUpdatedAt;
    private LocalDateTime inboundAt;

    private List<InboundRequestItemDTO> inboundRequestItems; // 1:N 입고 품목

}