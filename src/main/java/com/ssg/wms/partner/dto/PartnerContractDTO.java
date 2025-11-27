package com.ssg.wms.partner.dto;

import com.ssg.wms.common.PartnerStatus;
import lombok.*;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PartnerContractDTO {
    private Integer contractId;
    private Integer partnerId;
    private LocalDate contractStart;
    private Long contractArea;
    private PartnerStatus status;
}
