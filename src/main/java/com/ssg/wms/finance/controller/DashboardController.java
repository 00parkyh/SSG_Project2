package com.ssg.wms.finance.controller;

import com.ssg.wms.finance.dto.DashboardSummaryDTO;
import com.ssg.wms.finance.service.DashboardService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDate;
import java.time.Year;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/dashboard")
@RequiredArgsConstructor
@Log4j2
public class DashboardController {

    private final DashboardService dashboardService;

    @GetMapping
    public String dashboard(Model model) {
        return "dashboard/index";
    }

    @GetMapping("/api")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getDashboardDataApi(
            @RequestParam(required = false, defaultValue = "0") int year,
            @RequestParam(required = false, defaultValue = "0") int month) {

        if (year == 0) year = Year.now().getValue();
        // "연간 전체"가 아닐 때의 월(month)과, "연간 전체"일 때 물류 카운트에 사용할 월(queryMonth)을 분리
        int queryMonth = (month == 0) ? LocalDate.now().getMonthValue() : month;

        // 1. 연간 차트 데이터 조회
        List<DashboardSummaryDTO> netProfitSummary = dashboardService.getNetProfitSummary(year);

        // 2. 월간 물류 데이터 조회
        int inboundCount = dashboardService.getMonthlyInboundCount(year, queryMonth);
        int outboundCount = dashboardService.getMonthlyOutboundCount(year, queryMonth);

        // --- ▼ [신규 추가] 3. 월간 카드용 데이터 조회 ---
        long monthlySales = 0;
        long monthlyExpense = 0;
        long monthlyNetProfit = 0;

        if (month != 0) { // "연간 전체"(value 0)가 아닐 때만 계산
            // (이 메서드들은 이전 단계에서 Service/Mapper에 추가한 것을 호출)
            monthlySales = dashboardService.getMonthlySales(year, month);
            monthlyExpense = dashboardService.getMonthlyExpense(year, month);
            monthlyNetProfit = monthlySales - monthlyExpense;
        }
        // --- ▲ [신규 추가] ---

        // 4. 연간 총합 계산 (기존 로직)
        long totalSales = netProfitSummary.stream().mapToLong(DashboardSummaryDTO::getTotalSales).sum();
        long totalExpense = netProfitSummary.stream().mapToLong(DashboardSummaryDTO::getTotalExpenses).sum();
        long netProfit = totalSales - totalExpense;
        double profitMargin = (totalSales == 0) ? 0.0 : ((double) netProfit / totalSales) * 100;

        // 5. 전월/전년 대비 계산 (기존 로직)
        List<DashboardSummaryDTO> prevYearSummary = dashboardService.getNetProfitSummary(year - 1);
        long prevYearSameMonthProfit = prevYearSummary.get(queryMonth - 1).getNetProfit();
        long prevMonthProfit = (queryMonth == 1) ? prevYearSummary.get(11).getNetProfit() : netProfitSummary.get(queryMonth - 2).getNetProfit();
        long currentMonthProfit = netProfitSummary.get(queryMonth - 1).getNetProfit();
        double profitGrowthMoM = calculateGrowthRate(currentMonthProfit, prevMonthProfit);
        double profitGrowthYoY = calculateGrowthRate(currentMonthProfit, prevYearSameMonthProfit);

        // 6. 응답 데이터 구성
        Map<String, Object> response = new HashMap<>();

        // (연간 차트용)
        response.put("netProfitSummary", netProfitSummary);

        // (연간 카드용)
        response.put("totalSales", totalSales);
        response.put("totalExpense", totalExpense);
        response.put("netProfit", netProfit);
        response.put("profitMargin", profitMargin);

        // (월간 물류 카드용)
        response.put("monthlyInboundCount", inboundCount);
        response.put("monthlyOutboundCount", outboundCount);

        // (필터 상태용)
        response.put("selectedYear", year);
        response.put("selectedMonth", queryMonth);

        // (연간 수익률 카드용)
        response.put("profitGrowthMoM", profitGrowthMoM);
        response.put("profitGrowthYoY", profitGrowthYoY);

        // --- 월간 카드용 데이터 추가 ---
        response.put("monthlySales", monthlySales);
        response.put("monthlyExpense", monthlyExpense);
        response.put("monthlyNetProfit", monthlyNetProfit);

        return ResponseEntity.ok(response);
    }

    private double calculateGrowthRate(long current, long previous) {
        if (previous == 0) return (current > 0) ? 100.0 : 0.0;
        return ((double) (current - previous) / Math.abs(previous)) * 100;
    }
}