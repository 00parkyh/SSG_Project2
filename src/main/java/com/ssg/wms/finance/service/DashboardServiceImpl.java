package com.ssg.wms.finance.service;

import com.ssg.wms.finance.dto.DashboardSummaryDTO;
import com.ssg.wms.finance.mappers.DashboardMapper;
import com.ssg.wms.finance.mappers.ExpenseMapper;
import com.ssg.wms.finance.mappers.SalesMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Service
@RequiredArgsConstructor
public class DashboardServiceImpl implements DashboardService {

    private final ExpenseMapper expenseMapper;
    private final SalesMapper salesMapper;
    private final DashboardMapper dashboardMapper;

    @Override
    public List<DashboardSummaryDTO> getNetProfitSummary(int year) {
        // 1. 월별 매출 데이터 조회
        Map<Integer, Long> salesMap = salesMapper.findMonthlySummary(year).stream()
                .collect(Collectors.toMap(DashboardSummaryDTO::getMonth, DashboardSummaryDTO::getTotalSales));

        // 2. 월별 지출 데이터 조회
        Map<Integer, Long> expenseMap = expenseMapper.findMonthlySummary(year).stream()
                .collect(Collectors.toMap(DashboardSummaryDTO::getMonth, DashboardSummaryDTO::getTotalExpenses));

        // 3. 1월~12월을 돌면서 매출과 지출을 조합하고 순수익 계산
        return IntStream.rangeClosed(1, 12).mapToObj(month -> {
            long totalSales = salesMap.getOrDefault(month, 0L);
            long totalExpenses = expenseMap.getOrDefault(month, 0L);
            long netProfit = totalSales - totalExpenses; // 순수익 계산

            DashboardSummaryDTO dto = new DashboardSummaryDTO();
            dto.setYear(year);
            dto.setMonth(month);
            dto.setTotalSales(totalSales);
            dto.setTotalExpenses(totalExpenses);
            dto.setNetProfit(netProfit);
            return dto;
        }).collect(Collectors.toList());
    }

    @Override
    public int getMonthlyInboundCount(int year, int month) {
        return dashboardMapper.countMonthlyInbound(year, month);
    }

    @Override
    public int getMonthlyOutboundCount(int year, int month) {
        return dashboardMapper.countMonthlyOutbound(year, month);
    }

    @Override
    public long getMonthlySales(int year, int month) {
        return salesMapper.findTotalSalesByMonth(year, month);
    }

    @Override
    public long getMonthlyExpense(int year, int month) {
        return expenseMapper.findTotalExpenseByMonth(year, month);
    }

    @Override
    public long getMonthlyNetProfit(int year, int month) {
        long monthlySales = salesMapper.findTotalSalesByMonth(year, month);
        long monthlyExpense = expenseMapper.findTotalExpenseByMonth(year, month);
        return monthlySales - monthlyExpense;
    }
}