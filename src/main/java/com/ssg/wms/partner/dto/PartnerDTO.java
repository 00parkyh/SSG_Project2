package com.ssg.wms.partner.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PartnerDTO {
    private Integer partnerId;
    private String partnerName;
    private String businessNumber;
    private String address;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
