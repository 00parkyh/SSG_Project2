package com.ssg.wms.partner.domain;

import com.ssg.wms.common.PartnerStatus;
import lombok.*;

import java.time.LocalDate;

@Getter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PartnerContract {
    private Integer contractId;
    private Integer partnerId;
    private LocalDate contractStart;
    private Long contractArea;
    private PartnerStatus status;
}
