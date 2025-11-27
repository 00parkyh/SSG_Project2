package com.ssg.wms.product_stock.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StockLogDTO {
    private LocalDateTime eventTime;    // DB에서 가져오는 필드
    private String eventTimeString;     // JSP에서 표시할 문자열
    private String eventType;
    private int moveQuantity;
    private String destination;
    private String productStatus;
    private String sectionName;
}
