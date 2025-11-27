package com.ssg.wms.inbound.domain;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class InboundVO {

    private int inboundId;
    private int warehouseId;
    private int staffId;
    private Long memberId;
    private String inboundStatus;         // request, cancelled, approved, rejected
    private String inboundRejectReason;
    private LocalDateTime inboundRequestedAt;
    private LocalDateTime inboundUpdatedAt;
    private LocalDateTime inboundAt;

    private List<InboundItemVO> inboundItems;

}
