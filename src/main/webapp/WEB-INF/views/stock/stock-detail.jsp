<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageActive" value="stock_detail" scope="request"/>
<%@ include file="../admin/admin-header.jsp" %>

<div class="container-xxl flex-grow-1 container-p-y">
    <h4 class="fw-bold py-3 mb-4">
        <span class="text-muted fw-light">재고 관리 /</span> 상품 상세 정보
    </h4>

    <div class="card mb-4">
        <div class="card-header">
            <h5 class="mb-0">상품 기본 정보</h5>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-9">
                    <div class="row g-3">
                        <div class="col-6 col-md-4">
                            <label class="form-label fw-bold">상품 ID</label>
                            <p class="form-control-static">${summary.productId}</p>
                        </div>
                        <div class="col-6 col-md-4">
                            <label class="form-label fw-bold">상품 이름</label>
                            <p class="form-control-static">${summary.productName}</p>
                        </div>
                        <div class="col-6 col-md-4">
                            <label class="form-label fw-bold">보관 창고</label>
                            <p class="form-control-static">${summary.warehouseName}</p>
                        </div>
                        <div class="col-6 col-md-4">
                            <label class="form-label fw-bold">보관 섹션</label>
                            <p class="form-control-static">${summary.sectionName}</p>
                        </div>
                        <div class="col-6 col-md-4">
                            <label class="form-label fw-bold">현재 재고 수량</label>
                            <p class="form-control-static fw-bolder">${summary.currentQuantity}</p>
                        </div>
                    </div>
                </div>

                <!-- QR 코드 자리 -->
                <div class="col-md-3 d-flex justify-content-center align-items-center">
                    <div style="width: 150px; height: 150px; border: 1px solid #ddd; background-color: #f8f8f8; text-align: center; line-height: 150px; font-size: 1.5rem; color: #666;">
                        QR 코드
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">재고 이동 기록</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead>
                    <tr>
                        <th>일자</th>
                        <th>입/출고</th>
                        <th>이동 수량</th>
                        <th>출발/도착 장소</th>
                        <th>재고 상태</th>
                        <th>섹션 이름</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty logList}">
                            <c:forEach var="log" items="${logList}">
                                <tr>
                                    <td>${log.eventTimeString}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${log.eventType eq 'IN'}"><span class="badge bg-label-success">입고</span></c:when>
                                            <c:when test="${log.eventType eq 'OUT'}"><span class="badge bg-label-danger">출고</span></c:when>
                                            <c:when test="${log.eventType eq 'MOVE'}"><span class="badge bg-label-info">이동</span></c:when>
                                            <c:otherwise><span class="badge bg-label-secondary">${log.eventType}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="fw-bold">${log.moveQuantity}</td>
                                    <td>${log.destination}</td>
                                    <td>${log.productStatus}</td>
                                    <td>${log.sectionName}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="text-center">해당 상품의 재고 이동 기록이 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="card-footer d-flex justify-content-end">
            <a href="javascript:void(0)" class="btn btn-secondary" onclick="history.back()">
                <i class="bx bx-list-ul me-1"></i> 목록으로 돌아가기
            </a>
        </div>

    </div>
</div>
<%@ include file="../admin/admin-footer.jsp" %>
