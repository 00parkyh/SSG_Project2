<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="isManagerView" value="${sessionScope.role == 'MANAGER'}" />
<c:set var="isMemberView" value="${sessionScope.role == 'MEMBER'}" />
<c:set var="pageActive" value="warehouse_list" scope="request"/>
<c:set var="warehouseBasePath" value="${isManagerView ? '/mgr/warehouses' : (isMemberView ? '/member/warehouses' : '/admin/warehouses')}" />
<c:choose>
  <c:when test="${isManagerView}">
    <jsp:include page="/WEB-INF/views/warehousemanager/manager-header.jsp" />
  </c:when>
  <c:when test="${isMemberView}">
    <jsp:include page="/WEB-INF/views/member/member-header.jsp" />
  </c:when>
  <c:otherwise>
    <jsp:include page="/WEB-INF/views/admin/admin-header.jsp" />
  </c:otherwise>
</c:choose>
<!DOCTYPE html>
<html>
<head>
  <title>창고 목록 조회/수정</title>
  <style>
    body { background-color: #f4f7f9; }
    .page-wrapper {
      width: 90%;
      margin: 30px auto;
      padding: 20px;
      background-color: #fff;
      border-radius: 12px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    }
    h1 {
      color: #333;
      border-bottom: 3px solid #5a5f78;
      padding-bottom: 10px;
      margin-bottom: 25px;
      font-size: 1.8em;
    }
    .register-btn {
      padding: 10px 20px;
      background-color: #007bff;
      color: white;
      border: none;
      border-radius: 6px;
      font-size: 1em;
      cursor: pointer;
      margin-bottom: 20px;
      display: inline-block;
    }
    .register-btn:hover { background-color: #0056b3; }
    .table-responsive {
      overflow-x: auto;
      -webkit-overflow-scrolling: touch;
    }
    table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0;
      margin-bottom: 30px;
      border-radius: 8px;
      overflow: hidden;
    }
    th, td {
      border: none;
      padding: 12px 15px;
      text-align: center;
    }
    th {
      background-color: #5a5f78;
      color: white;
      font-weight: 700;
      font-size: 0.9em;
    }
    tr:nth-child(even) { background-color: #f9f9f9; }
    tr:hover { background-color: #e0f7fa; }
    a {
      text-decoration: none;
      color: #007bff;
      font-weight: 500;
    }
    a:hover { text-decoration: underline; }
    @media (max-width: 768px) {
      .page-wrapper {
        width: 98%;
        margin-top: 10px;
        padding: 10px;
      }
      th, td {
        padding: 8px 10px;
        font-size: 0.8em;
      }
      h1 { font-size: 1.5em; }
    }
  </style>
</head>
<body>
<div class="page-wrapper">
  <h1>창고 목록 조회/수정</h1>

  <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'MANAGER'}">
    <button onclick="location.href='${pageContext.request.contextPath}${warehouseBasePath}/register'" class="register-btn">
      새로운 창고 등록
    </button>
  </c:if>

  <div class="table-responsive">
    <table>
      <thead>
      <tr>
        <th>창고 ID</th>
        <th>창고 이름</th>
        <th>창고 주소</th>
        <th>창고 종류</th>
        <th>운영 현황</th>
      </tr>
      </thead>
      <tbody>
      <c:set var="displayList" value="${tableWarehouseList != null ? tableWarehouseList : warehouseList}" />

      <c:forEach var="warehouse" items="${displayList}">
        <tr>
          <td>${warehouse.warehouseId}</td>
          <td>
            <a href="${pageContext.request.contextPath}${warehouseBasePath}/${warehouse.warehouseId}">
              ${warehouse.warehouseName}
            </a>
          </td>
          <td>${warehouse.address}</td>
          <td>${warehouse.warehouseType}</td>
          <td>
            <c:choose>
              <c:when test="${warehouse.warehouseStatus == 1}">운영 중</c:when>
              <c:when test="${warehouse.warehouseStatus == 2}">준비 중</c:when>
              <c:otherwise>폐쇄 중</c:otherwise>
            </c:choose>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty displayList}">
        <tr>
          <td colspan="5">등록된 창고가 없습니다.</td>
        </tr>
      </c:if>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>
<c:choose>
  <c:when test="${isManagerView}">
    <jsp:include page="/WEB-INF/views/warehousemanager/manager-footer.jsp" />
  </c:when>
  <c:when test="${isMemberView}">
    <jsp:include page="/WEB-INF/views/member/member-footer.jsp" />
  </c:when>
  <c:otherwise>
    <jsp:include page="/WEB-INF/views/admin/admin-footer.jsp" />
  </c:otherwise>
</c:choose>
