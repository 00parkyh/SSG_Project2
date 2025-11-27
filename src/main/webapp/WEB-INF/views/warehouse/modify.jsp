<%--
  Created by IntelliJ IDEA.
  User: jaeho
  Date: 2025-11-11
  Time: 오전 10:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../admin/admin-header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>창고 수정: ${detailDTO.name}</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8284a9e56dbc80e2ab8f41c23c1bbb0a&autoload=false&libraries=services"></script>

    <style>
        #map { width: 400px; height: 300px; margin-top: 10px; border: 1px solid #ccc; }
        .read-only-field { background-color: #f0f0f0; }
    </style>

    <script>
        const CONTEXT_PATH = "${pageContext.request.contextPath}";
        // Controller에서 전달받은 기존 상세 정보 DTO를 JSON으로 가져와 JS에서 사용
        const currentDetailData = ${detailDTO != null ? detailDTO : '{}'};
        let sectionIndex = 0; // 동적 구역 폼 인덱스 시작
    </script>
</head>
<body>
<h1 style="background-color: #f7d8b8; padding: 10px;">창고 수정</h1>

<!-- 폼 Action: POST /admin/warehouses/{whid} 또는 /manager/warehouses/{whid}로 전송 -->
<form action="${pageContext.request.contextPath}/${userRole == 'ADMIN' ? 'admin' : 'manager'}/warehouses/${detailDTO.warehouseId}" method="POST" onsubmit="return validateForm()">

    <!-- 1. 창고 ID (수정 불가) -->
    <div style="margin-bottom: 15px;">
        <label style="background-color: #f7d8b8; padding: 5px;">창고 ID</label>
        <input type="text" value="${detailDTO.warehouseId}" readonly name="warehouseId" class="read-only-field" style="width: 100px;">
    </div>

    <!-- 2. 창고 이름 -->
    <div style="margin-bottom: 15px;">
        <label style="background-color: #f7d8b8; padding: 5px;">창고 이름</label>
        <input type="text" id="name" name="name" value="${detailDTO.name}" required style="width: 250px;">
        <span id="nameCheckResult" style="margin-left: 10px;"></span>
        <!-- 수정 페이지에서는 이름 중복 검사 로직이 복잡해지므로, 변경 시에만 검사 필요 -->
    </div>

    <!-- 3. 창고 주소 -->
    <div style="margin-bottom: 15px;">
        <label style="background-color: #f7d8b8; padding: 5px;">창고 주소</label>
        <input type="text" id="address" name="address" value="${detailDTO.address}" required style="width: 400px;">
    </div>

    <!-- 4. 담당자 ID (WarehouseUpdateDTO의 핵심 필드) -->
    <div style="margin-bottom: 15px;">
        <label style="background-color: #f7d8b8; padding: 5px;">담당자 ID</label>
        <input type="number" id="adminId" name="adminId" value="${detailDTO.adminId}" required style="width: 100px;">
    </div>

    <!-- 5. 창고 종류 -->
    <div style="margin-bottom: 15px;">
        <label style="background-color: #f7d8b8; padding: 5px;">창고 종류</label>
        <select id="warehouseType" name="warehouseType" required>
            <option value="허브" ${detailDTO.warehouseType == '허브' ? 'selected' : ''}>허브</option>
            <option value="스포크" ${detailDTO.warehouseType == '스포크' ? 'selected' : ''}>스포크</option>
        </select>
    </div>

    <!-- 6. 총 수용 용량 -->
    <div style="margin-bottom: 15px;">
        <label style="background-color: #f7d8b8; padding: 5px; display: inline-block;">총 수용 용량</label>
        <input type="number" id="warehouseCapacity" name="warehouseCapacity" value="${detailDTO.warehouseCapacity}" required style="width: 150px;">
    </div>

    <!-- 7. 운영 현황 -->
    <div style="margin-bottom: 15px;">
        <label style="background-color: #f7d8b8; padding: 5px; display: inline-block;">운영 현황</label>
        <select id="warehouseStatus" name="warehouseStatus" required>
            <option value="1" ${detailDTO.warehouseStatus == 1 ? 'selected' : ''}>1 (운영중)</option>
            <option value="0" ${detailDTO.warehouseStatus == 0 ? 'selected' : ''}>0 (점검중)</option>
        </select>
    </div>

    <!-- 8. 구역 정보 동적 입력 UI 삽입 -->
    <h2 style="margin-top: 30px; border-bottom: 2px solid #ccc; padding-bottom: 5px;">구역 정보 수정/대체</h2>
    <div id="sectionContainer">
        <!-- 기존 구역 데이터가 여기에 동적으로 로드됩니다. -->
    </div>
    <button type="button" onclick="addSectionForm()" style="background-color: darkcyan; color: white; padding: 8px 15px; margin-bottom: 20px;">
        + 구역 추가
    </button>

    <!-- 9. 창고 위치 (Geocoding) -->
    <div style="margin-bottom: 15px;">
        <label style="background-color: #f7d8b8; padding: 5px;">창고 위치</label>
        <button type="button" onclick="searchAddress()" style="background-color: green; color: white;">위치 재확인</button>
        <div id="map"></div>
        <!-- 좌표는 변경 시 Service에서 Geocoding을 다시 수행하므로 Hidden으로 유지 -->
        <input type="hidden" id="latitude" name="latitude" value="${detailDTO.latitude}" required>
        <input type="hidden" id="longitude" name="longitude" value="${detailDTO.longitude}" required>
    </div>

    <button type="submit" id="submitBtn" style="background-color: navy; color: white; padding: 10px 20px;">수정 완료</button>

    <button type="button" onclick="location.href='${pageContext.request.contextPath}/${userRole == 'ADMIN' ? 'admin' : 'manager'}/warehouses/${detailDTO.warehouseId}'" style="background-color: darkred; color: white; padding: 10px 20px;">취소</button>
</form>

<!-- ... (에러 메시지 영역 유지) ... -->

<script src="${pageContext.request.contextPath}/static/warehouse/warehouse.js"></script>
<script>
    // 페이지 로드 후 실행 로직
    document.addEventListener("DOMContentLoaded", function() {
        // ... (KakaoMap 로드 로직 유지) ...

        // 1. 지도 초기화 (기존 좌표로 중심 설정)
        ensureKakaoMapsLoaded(function() {
            if(typeof initMapForRegister === 'function') {
                initMapForRegister('map', currentDetailData.latitude, currentDetailData.longitude);
            }
        });

        // 2. 기존 구역 데이터를 기반으로 폼 생성 및 인덱스 설정
        const existingSections = currentDetailData.sections;
        if (existingSections && existingSections.length > 0) {
            existingSections.forEach(function(section) {
                // loadExistingSectionForm 함수는 warehouse.js에 정의되어 있어야 함
                if(typeof loadExistingSectionForm === 'function') {
                    loadExistingSectionForm(section);
                }
            });
        } else {
            addSectionForm(); // 데이터가 없으면 최소 1개 빈 폼 추가
        }
    });

    // NOTE: initMapForRegister, addSectionForm, validateForm 함수는 warehouse.js에 존재합니다.
</script>
</body>
</html>
<%@ include file="../admin/admin-footer.jsp" %>