package com.ssg.wms.finance.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ExpenseSaveDTO { // 지출 등록/수정용
    private LocalDate expenseDate;
    private String warehouseName;
    private String category;
    private Long amount;
    private String description;
}
