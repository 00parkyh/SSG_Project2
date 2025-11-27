package com.ssg.wms.finance.service;

import com.ssg.wms.finance.dto.DashboardSummaryDTO;

import java.util.List;

public interface DashboardService {
    List<DashboardSummaryDTO> getNetProfitSummary(int year);

    int getMonthlyInboundCount(int year, int month);

    int getMonthlyOutboundCount(int year, int month);

    long getMonthlySales(int year, int month);
    long getMonthlyExpense(int year, int month);
    long getMonthlyNetProfit(int year, int month);
}
