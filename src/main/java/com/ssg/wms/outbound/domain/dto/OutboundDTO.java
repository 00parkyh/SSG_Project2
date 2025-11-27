package com.ssg.wms.outbound.domain.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class OutboundDTO {

    private Long outboundRequestId;

    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate outboundDate;

    private String approvedStatus;
    private String outboundAddress;
    private String brandName;
    private String requestUserName;
    
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate requestedDeliveryDate;

    private Long memberId;
    private String staffName;
    private String staffId;
    private Long warehouseId;
    private String dispatchStatus;
    private String waybillNumber;
    private String waybillStatus;
    private List<OutboundItemDTO> outboundRequestItems;

    // ========== 배차 정보 ==========
    private Long dispatchId;                    // 배차 ID
    private Integer carId;                      // 차량 ID
    private String carType;                     // 차량종류
    private String driverName;                  // 기사이름
    private Integer loadedBox;                  // 적재박스수
    private Integer maximumBOX;                 // 최대적재량


}