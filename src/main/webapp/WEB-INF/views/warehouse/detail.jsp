<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="../admin/admin-header.jsp" %>

<!DOCTYPE html>
<html>
<head>
  <title>창고 상세 정보: ${detail.name}</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8284a9e56dbc80e2ab8f41c23c1bbb0a"></script>
  <style>

    #map { width: 400px; height: 350px; margin-top: 10px; border: 1px solid #ccc; }
    .detail-container { display: flex; flex-wrap: wrap; gap: 20px; }
    .info-box, .map-box, .section-list-box {
      border: 1px solid #e0e0e0;
      padding: 20px;
      border-radius: 8px;
      background-color: #fff;
    }
    .info-box { flex-basis: 55%; }
    .map-box { flex-basis: 40%; }
    .section-list-box { flex-basis: 100%; margin-top: 20px; }


    table.info-table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
    table.info-table th, table.info-table td { border: 1px solid #ddd; padding: 10px; text-align: left; }
    table.info-table th { background-color: #f7f7f7; width: 30%; font-weight: 600; }

    .section-header {
      background-color: #e9e9ff; /* 섹션 헤더 색상 변경 */
      color: #333;
      padding: 10px;
      margin-top: 15px;
      font-size: 1.1em;
      font-weight: bold;
      border-radius: 4px;
    }
    /* 구역별 위치 테이블 스타일 */
    .location-table th, .location-table td { font-size: 0.9em; padding: 6px; }
    .location-container { display: flex; flex-wrap: wrap; gap: 20px; margin-top: 10px;}
    .single-section { flex: 1 1 48%; min-width: 300px; border: 1px dashed #ccc; padding: 10px; border-radius: 4px; }


    .action-buttons {
      margin-top: 20px;
      display: flex;
      gap: 10px;
    }
    .action-buttons button {
      padding: 12px 25px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-weight: bold;
      font-size: 16px;
    }

    /* 모달 기본 스타일 유지 */
    .modal {
      display: none;
      position: fixed;
      z-index: 1000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      overflow: auto;
      background-color: rgba(0,0,0,0.4);
    }
  </style>
</head>
<body>
<h1>창고 상세 페이지</h1>

<div class="detail-container">

  <div class="info-box">
    <h2>창고 기본 정보</h2>
    <table class="info-table">
      <tr><th>창고 ID</th><td>${detail.warehouseId}</td></tr>
      <tr><th>창고 이름</th><td>${detail.name}</td></tr>
      <tr><th>담당자 ID</th><td>${detail.adminId}</td></tr>
      <tr><th>창고 주소</th><td>${detail.address}</td></tr>
      <tr><th>창고 종류</th><td>${detail.warehouseType}</td></tr>
      <tr><th>수용 용량</th><td>${detail.warehouseCapacity}</td></tr>
      <tr><th>운영 현황</th><td>${detail.warehouseStatus == 1 ? '운영 중' : '점검 중'}</td></tr>
      <tr><th>등록 일자</th><td>${detail.registrationDate}</td></tr>
      <tr><th>최종 수정</th><td>${detail.latestUpdateDate}</td></tr>
    </table>
  </div>

  <div class="map-box">
    <h2>창고 위치</h2>
    <div id="map"></div>
  </div>

  <div class="section-list-box">
    <h2>창고 구역 정보</h2>
    <c:choose>
      <c:when test="${not empty detail.sections}">
        <div class="location-container">
          <c:forEach items="${detail.sections}" var="section">
            <div class="single-section">
              <div class="section-header">
                <span>${section.sectionName}</span> (${section.sectionType})
              </div>

              <table class="info-table">
                <tr><th>보관 목적</th><td>${section.sectionPurpose}</td></tr>
                <tr><th>보관 면적</th><td>${section.allocatedArea}</td></tr>
              </table>
<%--              리팩토링 해야함.--%>
                <%--
                <h4>창고구역 정보</h4>
                <table class="info-table location-table">
                  <thead>
                  <tr>
                    <th>위치 코드</th>
                    <th>층수</th>
                    <th>최대 부피</th>
                  </tr>
                  </thead>
                  <tbody>
                  <c:forEach items="${section.locations}" var="location">
                    <tr>
                      <td>${location.locationCode}</td>
                      <td>${location.floorNum}</td>
                      <td>${location.maxVolume}</td>
                    </tr>
                  </c:forEach>
                  <c:if test="${empty section.locations}">
                    <tr><td colspan="3">등록된 위치가 없습니다.</td></tr>
                  </c:if>
                  </tbody>
                </table>
                --%>
            </div>
          </c:forEach>
        </div>
      </c:when>
      <c:otherwise>
        <div class="section-header">등록된 구역 정보가 없습니다.</div>
        <p style="margin-top: 10px;">창고에 구역 정보가 없습니다. 창고 구역을 등록해주세요.</p>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<hr>

<c:if test="${userRole == 'ADMIN' || userRole == 'MANAGER'}">
  <div class="action-buttons">
    <button onclick="showDeleteModal()" style="background-color: darkred; color: white;">삭제</button>
    <button onclick="location.href='${pageContext.request.contextPath}/admin/warehouses'" style="background-color: navy; color: white;">목록으로</button>
  </div>
</c:if>

<%-- 삭제 모달 기능 유지 --%>
<div id="deleteModal" class="modal" style="display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4);">
  <div class="modal-content" style="background-color: #fefefe; margin: 15% auto; padding: 30px; border: 1px solid #888; width: 80%; max-width: 450px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">

    <div style="text-align: center; color: #d9534f; margin-bottom: 20px;">
      <span style="font-size: 40px;">⚠️</span>
    </div>

    <h2 style="font-size: 20px; color: #333; margin-top: 0; text-align: center;">**창고 삭제 경고**</h2>
    <p style="text-align: center; color: #666; line-height: 1.5; border-top: 1px dashed #eee; padding-top: 15px;">
      정말로 **창고 ${detail.name}** (ID: ${detail.warehouseId}) 정보를 삭제하시겠습니까?
    </p>
    <p style="text-align: center; color: darkred; font-weight: bold; margin-bottom: 25px;">
      이 작업은 되돌릴 수 없으며, 모든 관련 데이터가 영구적으로 삭제됩니다.
    </p>

    <form action="${pageContext.request.contextPath}/${userRole == 'ADMIN' ? 'admin' : 'manager'}/warehouses/${detail.warehouseId}/delete" method="POST" style="text-align: center;">
      <button type="submit" style="background-color: darkred; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; margin-right: 10px; transition: background-color 0.3s ease;">영구 삭제</button>
      <button type="button" onclick="hideDeleteModal()" style="background-color: #ccc; color: #333; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; transition: background-color 0.3s ease;">취소</button>
    </form>
  </div>
</div>

<script src="${pageContext.request.contextPath}/static/warehouse/warehouse.js"></script>
<script>
  // 마커 표시를 위한 데이터
  const detailData = {
    latitude: ${detail.latitude},
    longitude: ${detail.longitude},
    name: '${detail.name}'
  };

  // 지도 초기화
  kakao.maps.load(function() {
    if (typeof initMapForDetail === 'function') {
      initMapForDetail('map', detailData);
    } else {
      console.error("initMapForDetail 함수를 찾을 수 없습니다. warehouse.js를 확인해주세요.");
    }
  });

  // 모달 제어 함수
  function showDeleteModal() {
    document.getElementById('deleteModal').style.display = 'block';
  }
  function hideDeleteModal() {
    document.getElementById('deleteModal').style.display = 'none';
  }
</script>
</body>
</html>
<%@ include file="../admin/admin-footer.jsp" %>