package com.ssg.wms.outbound.domain.dto;


import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class WaybillDTO {
    private Long waybillId;
    private String waybillNumber;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime waybillDate;
    private String waybillStatus;
    private Long dispatchId;
    private String departureAddress;
    private Integer loadedBox;
    private String arrivalAddress;
    private String senderName;
    private String receiverName;
}
