package com.ssg.wms.partner.domain;

import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PartnerFee {
    private Integer feeId;
    private Integer partnerId;
    private String feeType;
    private Long price;
    private LocalDateTime applyDate;
}
