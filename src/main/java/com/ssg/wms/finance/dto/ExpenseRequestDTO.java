package com.ssg.wms.finance.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ExpenseRequestDTO { // 지출 검색용
    private String keyword;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate dateFrom;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate dateTo;

    @Builder.Default
    private int page = 1;
    @Builder.Default
    private int size = 10;

    // Mybatis 에서 offset 계산을 위한 getter
    public int getOffset() {
        return (page - 1) * size;
    }
}
