<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageActive" value="dashboard" scope="request"/>

<%-- 이 코드를 추가해서 '공통 스크립트 로드 금지' 플래그를 세웁니다. --%>
<c:set var="disablePageSpecificScript" value="true" scope="request"/>

<%@ include file="../admin/admin-header.jsp" %>

<div class="container-xxl flex-grow-1 container-p-y">
    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap">
        <h4 class="fw-bold py-3 mb-0"><span class="text-muted fw-light">재무관리 /</span> 대시보드</h4>

        <div class="d-flex gap-2">
            <select id="yearFilter" class="form-select w-auto cursor-pointer">
            </select>
            <select id="monthFilter" class="form-select w-auto cursor-pointer">
                <option value="0">연간 전체</option>
                <c:forEach var="m" begin="1" end="12">
                    <option value="${m}">${m}월</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <%-- 1. 연간 요약 카드 --%>
    <div class="row">
        <div class="col-lg-4 col-md-6 col-12 mb-4">
            <div class="card">
                <div class="card-body">
                    <div class="d-flex justify-content-between flex-sm-row flex-column gap-3">
                        <div class="d-flex flex-sm-column flex-row align-items-start justify-content-between">
                            <div class="card-title">
                                <h5 class="text-nowrap mb-2">총 매출</h5>
                                <span class="badge bg-label-success rounded-pill" id="summaryScopeLabel1">Yearly</span>
                            </div>
                            <div class="mt-sm-auto">
                                <h3 class="mb-0" id="totalSales">Loading...</h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4 col-md-6 col-12 mb-4">
            <div class="card">
                <div class="card-body">
                    <div class="d-flex justify-content-between flex-sm-row flex-column gap-3">
                        <div class="d-flex flex-sm-column flex-row align-items-start justify-content-between">
                            <div class="card-title">
                                <h5 class="text-nowrap mb-2">총 지출</h5>
                                <span class="badge bg-label-danger rounded-pill" id="summaryScopeLabel2">Yearly</span>
                            </div>
                            <div class="mt-sm-auto">
                                <h3 class="mb-0" id="totalExpense">Loading...</h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4 col-md-6 col-12 mb-4">
            <div class="card">
                <div class="card-body">
                    <div class="d-flex justify-content-between flex-sm-row flex-column gap-3">
                        <div class="d-flex flex-sm-column flex-row align-items-start justify-content-between">
                            <div class="card-title">
                                <h5 class="text-nowrap mb-2">총 순이익</h5>
                                <span class="badge bg-label-primary rounded-pill" id="summaryScopeLabel3">Yearly</span>
                            </div>
                            <div class="mt-sm-auto">
                                <h3 class="mb-0 text-primary" id="netProfit">Loading...</h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- 2. 월간 요약 카드 --%>
    <div class="row" id="monthlySummaryRow" style="display: none;">
        <div class="col-lg-4 col-md-6 col-12 mb-4">
            <div class="card">
                <div class="card-body">
                    <div class="d-flex justify-content-between flex-sm-row flex-column gap-3">
                        <div class="d-flex flex-sm-column flex-row align-items-start justify-content-between">
                            <div class="card-title">
                                <h5 class="text-nowrap mb-2">월 매출</h5>
                                <span class="badge bg-label-success rounded-pill">Monthly</span>
                            </div>
                            <div class="mt-sm-auto">
                                <h3 class="mb-0" id="monthlySales">Loading...</h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4 col-md-6 col-12 mb-4">
            <div class="card">
                <div class="card-body">
                    <div class="d-flex justify-content-between flex-sm-row flex-column gap-3">
                        <div class="d-flex flex-sm-column flex-row align-items-start justify-content-between">
                            <div class="card-title">
                                <h5 class="text-nowrap mb-2">월 지출</h5>
                                <span class="badge bg-label-danger rounded-pill">Monthly</span>
                            </div>
                            <div class="mt-sm-auto">
                                <h3 class="mb-0" id="monthlyExpense">Loading...</h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4 col-md-6 col-12 mb-4">
            <div class="card">
                <div class="card-body">
                    <div class="d-flex justify-content-between flex-sm-row flex-column gap-3">
                        <div class="d-flex flex-sm-column flex-row align-items-start justify-content-between">
                            <div class="card-title">
                                <h5 class="text-nowrap mb-2">월 순이익</h5>
                                <span class="badge bg-label-primary rounded-pill">Monthly</span>
                            </div>
                            <div class="mt-sm-auto">
                                <h3 class="mb-0 text-primary" id="monthlyNetProfit">Loading...</h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- 3. 물류 현황 카드 (HTML은 사용자가 제공한 JSP에 없음, 하지만 JS에는 있음) --%>
    <h5 class="pb-1 mb-4 text-muted" id="logisticsTitle">물류 현황</h5>
    <div class="row">
        <div class="col-lg-6 col-md-12 mb-4">
            <div class="card h-100">
                <div class="card-body">
                    <div class="d-flex align-items-center justify-content-between">
                        <div class="d-flex align-items-center">
                            <div class="avatar avatar-md me-2">
                                <span class="avatar-initial rounded bg-label-info"><i
                                        class="bx bx-down-arrow-alt fs-4"></i></span>
                            </div>
                            <div>
                                <p class="mb-0 fw-semibold">월 입고량</p>
                                <h4 class="my-1" id="monthlyInbound">0 건</h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-6 col-md-12 mb-4">
            <div class="card h-100">
                <div class="card-body">
                    <div class="d-flex align-items-center justify-content-between">
                        <div class="d-flex align-items-center">
                            <div class="avatar avatar-md me-2">
                                <span class="avatar-initial rounded bg-label-warning"><i
                                        class="bx bx-up-arrow-alt fs-4"></i></span>
                            </div>
                            <div>
                                <p class="mb-0 fw-semibold">월 출고량</p>
                                <h4 class="my-1" id="monthlyOutbound">0 건</h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- 4. 차트 (HTML은 기존 코드 사용) --%>
    <div class="row">
        <div class="col-md-8 col-lg-8 order-1 mb-4">
            <div class="card h-100">
                <div class="card-header d-flex justify-content-between">
                    <h5 class="card-title m-0 me-2" id="mainChartTitle">월별 재무 현황</h5>
                    <small class="text-muted">(단위: 만원)</small>
                </div>
                <div class="card-body px-0">
                    <div id="mainChart" style="width: 100%"></div>
                </div>
            </div>
        </div>
        <div class="col-md-4 col-lg-4 order-2 mb-4">
            <div class="card h-100">
                <div class="card-header d-flex align-items-center justify-content-between">
                    <h5 class="card-title m-0 me-2" id="growthChartTitle">연간 순수익률</h5>
                </div>
                <div class="card-body">
                    <div id="growthChart"></div>
                    <div class="text-center fw-semibold pt-3 mb-2" id="profitMarginText">0% 수익률</div>
                    <div class="d-flex justify-content-around mt-3">
                        <div class="text-center">
                            <small class="text-muted">전월 대비</small>
                            <h6 class="mb-0" id="profitGrowthMoM">-</h6>
                        </div>
                        <div class="text-center">
                            <small class="text-muted">전년 대비</small>
                            <h6 class="mb-0" id="profitGrowthYoY">-</h6>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>
<%@ include file="../admin/admin-footer.jsp" %>

<%-- ========================================================== --%>
<%--                JAVASCRIPT                --%>
<%-- ========================================================== --%>
<script>
    const CONTEXT_PATH = '${pageContext.request.contextPath}';
    const API_URL = CONTEXT_PATH + '/admin/dashboard/api';

    let mainChart, growthChart;

    $(document).ready(function () {
        initEmptyCharts();

        const currentYear = new Date().getFullYear();
        const currentMonth = new Date().getMonth() + 1;

        let yearFilter = $('#yearFilter');
        for (let i = 0; i < 5; i++) {
            yearFilter.append(`<option value="\${currentYear - i}">\${currentYear - i}년</option>`);
        }
        yearFilter.val(currentYear);

        $('#monthFilter').val(currentMonth);
        loadDashboardData(currentYear, currentMonth);

        $('#yearFilter, #monthFilter').change(function () {
            loadDashboardData($('#yearFilter').val(), $('#monthFilter').val());
        });
    });

    function initEmptyCharts() {
        // (메인 차트 초기화)
        const mainChartEl = document.querySelector("#mainChart");
        if (mainChartEl) {
            const mainChartOptions = {
                series: [
                    {name: '매출', data: Array(12).fill(0)},
                    {name: '지출', data: Array(12).fill(0)}
                ],
                chart: {
                    height: 300,
                    type: 'bar',
                    toolbar: {show: false},
                    fontFamily: 'Public Sans',
                    animations: { // 애니메이션 설정
                        enabled: true,
                        speed: 800,
                        animateGradually: {
                            enabled: true,
                            delay: 150
                        },
                        dynamicAnimation: {
                            enabled: true,
                            speed: 350
                        }
                    }
                },
                plotOptions: {bar: {horizontal: false, columnWidth: '40%', borderRadius: 4}},
                dataLabels: {enabled: false},
                stroke: {show: true, width: 2, colors: ['transparent']},
                colors: ['#696cff', '#ff3e1d'],
                xaxis: {categories: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']},
                yaxis: {
                    min: 0,
                    tickAmount: 5, // Y축 눈금 개수 5개로 제한
                    forceNiceScale: true, // 숫자로 강제 변환
                    labels: {
                        formatter: (val) => formatKoreanNumber(val),
                        hideOverlappingLabels: true, // 겹치는 라벨 자동 숨김
                        style: {
                            fontSize: '11px' // 폰트 크기 살짝 줄임
                        }
                    }
                },
                fill: {opacity: 1},
                grid: {borderColor: '#f1f1f1'},
                legend: {position: 'top', horizontalAlign: 'left', markers: {radius: 12}},
                tooltip: {y: {formatter: (val) => formatCurrency(val) + " 원"}},
            };
            mainChart = new ApexCharts(mainChartEl, mainChartOptions);
            mainChart.render();
        }

        // (수익률 차트 초기화)
        const growthChartEl = document.querySelector("#growthChart");
        if (growthChartEl) {
            const growthChartOptions = {
                series: [0],
                chart: {
                    height: 240,
                    type: 'radialBar',
                },
                animations: { // 애니메이션 설정 (유지)
                    enabled: true,
                    speed: 800,
                    dynamicAnimation: {
                        enabled: true,
                        speed: 350
                    }
                },
                plotOptions: {
                    radialBar: {
                        hollow: {size: '70%'},
                        track: {background: '#f5f5f9'},
                        dataLabels: {
                            name: {show: false},
                            value: {
                                fontSize: '22px',
                                color: '#696cff',
                                offsetY: 10,
                                formatter: (val) => val.toFixed(1) + "%"
                            }
                        }
                    }
                },
                colors: ['#696cff']
            };
            growthChart = new ApexCharts(growthChartEl, growthChartOptions);
            growthChart.render();
        }

    }

    // --- loadDashboardData 함수 ---
    function loadDashboardData(year, month) {

        // --- 월 선택 여부에 따라 월간 요약 카드 숨기기/보이기 ---
        if (month == 0) {
            // "연간 전체" 선택 시: 월간 요약 숨기기
            $('#monthlySummaryRow').hide();
        } else {
            // 특정 월 선택 시: 월간 요약 보이기
            $('#monthlySummaryRow').show();
        }

        $.ajax({
            url: API_URL, type: 'GET', data: {year: year, month: month}, dataType: 'json',
            success: function (data) {
                updateTitles(data.selectedYear, data.selectedMonth, month == 0);
                updateSummaryCards(data); // <-- 이 함수가 새 데이터를 처리

                // 메인 차트 (막대)
                const monthlySales = Array(12).fill(0);
                const monthlyExpenses = Array(12).fill(0);
                if (data.netProfitSummary) {
                    data.netProfitSummary.forEach(item => {
                        if (item.month >= 1 && item.month <= 12) {
                            monthlySales[item.month - 1] = item.totalSales;
                            monthlyExpenses[item.month - 1] = item.totalExpenses;
                        }
                    });
                }
                if (mainChart) mainChart.updateSeries([{name: '매출', data: monthlySales}, {
                    name: '지출',
                    data: monthlyExpenses
                }]);

                // 수익률 차트 (원형)
                if (growthChart) {
                    let margin = data.profitMargin || 0;
                    let color = margin >= 0 ? '#696cff' : '#ff3e1d';
                    growthChart.updateOptions({
                        series: [margin],
                        colors: [color],
                        plotOptions: {radialBar: {dataLabels: {value: {color: color}}}}
                    });
                }
            },
            error: function (e) {
                console.error("Dashboard load failed", e);
            }
        });
    }

    function updateTitles(year, month, isYearly) {
        let titleMonth = isYearly ? new Date().getMonth() + 1 : month;
        $('#logisticsTitle').text(`물류 현황 (\${year}년 \${titleMonth}월)`);

        $('#growthChartTitle').text('연간 순수익률');
        $('#summaryScopeLabel1, #summaryScopeLabel2, #summaryScopeLabel3').text('Yearly');
    }


    // 숫자 카운트업 애니메이션 함수
    function animateCountUp(elementId, endValue) {
        const el = document.getElementById(elementId);
        const duration = 1000; // 애니메이션 지속 시간 (1.0초)
        const end = parseInt(endValue) || 0;

        if (el.animator) {
            cancelAnimationFrame(el.animator);
        }
        let startTime = null;

        function animation(currentTime) {
            if (startTime === null) startTime = currentTime;
            const progress = Math.min((currentTime - startTime) / duration, 1);
            const currentNumber = Math.floor(progress * end);

            el.innerHTML = formatCurrency(currentNumber);

            if (progress < 1) {
                el.animator = requestAnimationFrame(animation);
            } else {
                el.innerHTML = formatCurrency(end);
            }
        }

        el.animator = requestAnimationFrame(animation);
    }

    // --- updateSummaryCards 함수 ---
    function updateSummaryCards(data) {
        // 기존 연간 데이터
        animateCountUp('totalSales', data.totalSales);
        animateCountUp('totalExpense', data.totalExpense);
        animateCountUp('netProfit', data.netProfit);

        // --- 새로운 월간 데이터 애니메이션 ---
        // (Controller에서 보낸 'monthlySales' 등을 사용)
        animateCountUp('monthlySales', data.monthlySales);
        animateCountUp('monthlyExpense', data.monthlyExpense);
        animateCountUp('monthlyNetProfit', data.monthlyNetProfit);

        // 수익률 퍼센트 애니메이션
        animatePercentageUp('profitMarginText', data.profitMargin);

        // 물류 카운트
        $('#monthlyInbound').text((data.monthlyInboundCount || 0) + ' 건');
        $('#monthlyOutbound').text((data.monthlyOutboundCount || 0) + ' 건');

        // 전월/전년 대비 애니메이션 함수 호출 (ID에서 # 제거)
        animateGrowthPercentage('profitGrowthMoM', data.profitGrowthMoM);
        animateGrowthPercentage('profitGrowthYoY', data.profitGrowthYoY);
    }

    function formatKoreanNumber(num) {
        if (num === 0 || num === null) return '0';
        if (Math.abs(num) >= 100000000) return (num / 100000000).toFixed(1).replace(/\.0$/, '') + '억';
        if (Math.abs(num) >= 10000) return (num / 10000).toFixed(0) + '만';
        return new Intl.NumberFormat('ko-KR').format(num);
    }

    function formatCurrency(amount) {
        let safeAmount = amount || 0;
        return new Intl.NumberFormat('ko-KR', {style: 'currency', currency: 'KRW'}).format(safeAmount);
    }

    // 퍼센트(%) 숫자 전용 애니메이션 함수
    function animatePercentageUp(elementId, endValue) {
        const el = document.getElementById(elementId);
        const duration = 1000;
        const end = parseFloat(endValue) || 0;

        if (el.animator) cancelAnimationFrame(el.animator);
        let startTime = null;

        function animation(currentTime) {
            if (startTime === null) startTime = currentTime;
            const progress = Math.min((currentTime - startTime) / duration, 1);
            const currentNumber = progress * end;
            el.innerHTML = currentNumber.toFixed(1) + '% 수익률';
            if (progress < 1) {
                el.animator = requestAnimationFrame(animation);
            } else {
                el.innerHTML = end.toFixed(1) + '% 수익률';
            }
        }

        el.animator = requestAnimationFrame(animation);
    }

    // 전월/전년 대비(%) 증감 애니메이션 함수
    function animateGrowthPercentage(elementId, endValue) {
        const el = document.getElementById(elementId);
        const duration = 1000; // 1초
        const end = parseFloat(endValue) || 0;

        if (!el) return;
        if (el.animator) cancelAnimationFrame(el.animator);
        let startTime = null;

        function animation(currentTime) {
            if (startTime === null) startTime = currentTime;
            const progress = Math.min((currentTime - startTime) / duration, 1);
            const currentNumber = progress * end;

            el.classList.remove('text-success', 'text-danger', 'text-muted');
            if (currentNumber > 0.05) {
                el.innerHTML = `▲ \${currentNumber.toFixed(1)}%`;
                el.classList.add('text-success');
            } else if (currentNumber < -0.05) {
                el.innerHTML = `▼ \${Math.abs(currentNumber).toFixed(1)}%`;
                el.classList.add('text-danger');
            } else {
                el.innerHTML = `- 0.0%`;
                el.classList.add('text-muted');
            }

            if (progress < 1) {
                el.animator = requestAnimationFrame(animation);
            } else {
                el.classList.remove('text-success', 'text-danger', 'text-muted');
                if (end > 0) {
                    el.innerHTML = `▲ \${end.toFixed(1)}%`;
                    el.classList.add('text-success');
                } else if (end < 0) {
                    el.innerHTML = `▼ \${Math.abs(end).toFixed(1)}%`;
                    el.classList.add('text-danger');
                } else {
                    el.innerHTML = `- 0.0%`;
                    el.classList.add('text-muted');
                }
            }
        }

        el.animator = requestAnimationFrame(animation);
    }
</script>