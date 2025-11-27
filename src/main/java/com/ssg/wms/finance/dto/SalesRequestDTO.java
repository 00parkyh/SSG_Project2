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
public class SalesRequestDTO { // 매출 검색용
    private String keyword;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate dateFrom;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate dateTo;

    @Builder.Default
    private int page = 1;
    @Builder.Default
    private int size = 10;

    public int getOffset() {
        return (page - 1) * size;
    }
}
