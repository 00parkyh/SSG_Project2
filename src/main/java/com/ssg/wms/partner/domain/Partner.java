package com.ssg.wms.partner.domain;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Partner {
    private Integer partnerId;
    private String partnerName;
    private String businessNumber;
    private String address;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
