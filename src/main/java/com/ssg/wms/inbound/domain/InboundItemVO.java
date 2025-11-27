package com.ssg.wms.inbound.domain;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class InboundItemVO {
    private int inboundId;
    private int inboundItemId;
    private String productId;
    private int quantity;
}
