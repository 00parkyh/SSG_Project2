package com.ssg.wms.finance.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SalesSaveDTO { // 매출 등록/수정용
    private LocalDate salesDate;
    private String warehouseName;
    private String category;
    private String clientName;
    private Long amount;
    private String description;
}
