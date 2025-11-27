package com.ssg.wms.finance.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DashboardSummaryDTO { // 총정산 내역 조회
    private Integer year;
    private Integer month;
    private Long totalSales;
    private Long totalExpenses;
    private Long netProfit; // (Service에서 계산)
}
