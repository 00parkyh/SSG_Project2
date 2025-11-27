package com.ssg.wms.inbound.dto;

import lombok.Data;

@Data
public class InboundRequestItemDTO {
    private int inboundItemId;
    private int inboundId;
    private String productId; // 필수
    private Integer quantity;  // 필수
}
