<%--
  Created by IntelliJ IDEA.
  User: jang
  Date: 2025. 11. 11.
  Time: 오후 5:20
  To change this template use File | Settings | File Templates.
--%>
<%-- /WEB-INF/views/outbound/member/detail.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/member/member-header.jsp" />

<div class="container mt-5">
  <h3>출고 요청 상세</h3>

  <!-- 기본 정보 -->
  <div class="card mb-4">
    <div class="card-header bg-primary text-white">
      <h5 class="mb-0">기본 정보</h5>
    </div>
    <div class="card-body">
      <div class="row mb-3">
        <div class="col-md-3">
          <strong>요청번호:</strong>
          <p id="outboundRequestId" class="mb-0">${outbound.outboundRequestId}</p>
        </div>
        <div class="col-md-3">
          <strong>브랜드:</strong>
          <p id="brandName" class="mb-0">${outbound.brandName}</p>
        </div>
        <div class="col-md-3">
          <strong>입고 요청자:</strong>
          <p id="requestUserName" class="mb-0">${outbound.requestUserName}</p>
        </div>
        <div class="col-md-3">
          <strong>출고 요청일:</strong>
          <p id="outboundDate" class="mb-0">
            <fmt:formatDate value="${outbound.outboundDate}" pattern="yyyy-MM-dd"/>
          </p>
        </div>
      </div>
      <div class="row">
        <div class="col-md-3">
          <strong>배송 상태:</strong>
          <p id="approvedStatus" class="mb-0">
            <c:choose>
              <c:when test="${outbound.approvedStatus == 'PENDING'}">
                <span class="badge bg-warning">PENDING</span>
              </c:when>
              <c:when test="${outbound.approvedStatus == 'APPROVED'}">
                <span class="badge bg-success">승인대기</span>
              </c:when>
              <c:when test="${outbound.approvedStatus == 'REJECTED'}">
                <span class="badge bg-danger">반려</span>
              </c:when>
              <c:otherwise>
                <span class="badge bg-secondary">${outbound.approvedStatus}</span>
              </c:otherwise>
            </c:choose>
          </p>
        </div>
        <div class="col-md-3">
          <strong>출고 희망일:</strong>
          <p id="requestedDeliveryDate" class="mb-0">
            <fmt:formatDate value="${outbound.requestedDeliveryDate}" pattern="yyyy-MM-dd"/>
          </p>
        </div>
        <div class="col-md-6">
          <strong>출고 주소:</strong>
          <p id="outboundAddress" class="mb-0">${outbound.outboundAddress}</p>
        </div>
      </div>
    </div>
  </div>

  <!-- 출고 상세 목록 -->
  <div class="card">
    <div class="card-header bg-secondary text-white">
      <h5 class="mb-0">출고 상세 목록</h5>
    </div>
    <div class="card-body">
      <table class="table table-bordered table-hover">
        <thead class="table-dark">
        <tr>
          <th>요청번호</th>
          <th>요청일자</th>
          <th>고객 이름</th>
          <th>상품 이름</th>
          <th>상품 수량</th>
          <th>출고수량</th>
          <th>목적지주소</th>
          <th>관리직원</th>
          <th>출고희망일</th>
          <th>배송상태</th>
          <th>요청상태</th>
          <th>운송장</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="item" items="${outbound.outboundRequestItems}" varStatus="status">
          <tr>
            <c:if test="${status.index == 0}">
              <td rowspan="${outbound.outboundRequestItems.size()}">${outbound.outboundRequestId}</td>
              <td rowspan="${outbound.outboundRequestItems.size()}">
                <fmt:formatDate value="${outbound.outboundDate}" pattern="yyyy-MM-dd"/>
              </td>
              <td rowspan="${outbound.outboundRequestItems.size()}">${outbound.requestUserName}</td>
            </c:if>
            <td>${item.productName}</td>
            <td>${item.outboundQuantity}</td>
            <td>대기</td>
            <c:if test="${status.index == 0}">
              <td rowspan="${outbound.outboundRequestItems.size()}">${outbound.outboundAddress}</td>
              <td rowspan="${outbound.outboundRequestItems.size()}">대기</td>
              <td rowspan="${outbound.outboundRequestItems.size()}">
                <fmt:formatDate value="${outbound.requestedDeliveryDate}" pattern="yyyy-MM-dd"/>
              </td>
              <td rowspan="${outbound.outboundRequestItems.size()}">대기</td>
              <td rowspan="${outbound.outboundRequestItems.size()}">
                <c:choose>
                  <c:when test="${outbound.approvedStatus == 'PENDING'}">
                    <span class="badge bg-warning">PENDING</span>
                  </c:when>
                  <c:when test="${outbound.approvedStatus == 'APPROVED'}">
                    <span class="badge bg-success">승인대기</span>
                  </c:when>
                  <c:when test="${outbound.approvedStatus == 'REJECTED'}">
                    <span class="badge bg-danger">반려</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge bg-secondary">${outbound.approvedStatus}</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td rowspan="${outbound.outboundRequestItems.size()}">대기</td>
            </c:if>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </div>

  <!-- 버튼 영역 -->
  <div class="mt-4 mb-5">
    <button type="button" class="btn btn-secondary" onclick="window.print()">인쇄</button>
    <button type="button" class="btn btn-primary" onclick="history.back()">목록으로</button>
  </div>
</div>

<style>
  @media print {
    .btn, .navbar, .card-header {
      display: none !important;
    }
    .card {
      border: 1px solid #000 !important;
      box-shadow: none !important;
    }
  }
</style>

<%@ include file="../../member/member-footer.jsp" %>