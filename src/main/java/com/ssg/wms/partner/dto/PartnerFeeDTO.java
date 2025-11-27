package com.ssg.wms.partner.dto;

import lombok.*;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PartnerFeeDTO {
    private Integer feeId;
    private Integer partnerId;
    private String feeType;
    private Long price;
    private LocalDateTime applyDate;
}
