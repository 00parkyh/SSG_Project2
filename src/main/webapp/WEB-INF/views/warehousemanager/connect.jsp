<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 헤더 include --%>
<%@ include file="manager-header.jsp" %>

<div class="container-xxl flex-grow-1 container-p-y">
    <h4 class="fw-bold py-3 mb-4">
        RACL WMS에 오신 것을 환영합니다, <span class="text-primary">${loginId != null ? loginId : '게스트'}</span>님!
    </h4>

    <div class="row">
        <div class="col-12 mb-4">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">RACL 창고 관리 시스템</h5>
                    <p class="card-text">
                        RACL WMS는 효율적인 창고 운영을 위한 통합 관리 시스템입니다.
                        재고 관리부터 창고 운영까지 모든 업무를 체계적으로 지원합니다.
                    </p>
                    <p class="card-text">
                        오늘도 방문해주셔서 감사합니다.
                        필요하신 작업을 메뉴에서 선택하여 시작해주세요.
                    </p>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-6 mb-4">
            <div class="card h-100">
                <div class="card-body">
                    <h5 class="card-title">
                        <i class="bx bx-info-circle me-2"></i>시스템 소개
                    </h5>
                    <p class="card-text">
                        RACL WMS는 최신 기술을 기반으로 개발된 창고 관리 솔루션입니다.
                        실시간 재고 추적, 효율적인 입출고 관리, 정확한 재고 실사 등
                        창고 운영에 필요한 모든 기능을 제공합니다.
                    </p>
                </div>
            </div>
        </div>

        <div class="col-md-6 mb-4">
            <div class="card h-100">
                <div class="card-body">
                    <h5 class="card-title">
                        <i class="bx bx-support me-2"></i>고객 지원
                    </h5>
                    <p class="card-text">
                        시스템 사용 중 궁금하신 사항이나 도움이 필요하신 경우,
                        언제든지 고객센터를 통해 문의해주시기 바랍니다.
                        신속하고 정확한 답변으로 최상의 서비스를 제공하겠습니다.
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- 푸터 include --%>
<%@ include file="manager-footer.jsp" %>