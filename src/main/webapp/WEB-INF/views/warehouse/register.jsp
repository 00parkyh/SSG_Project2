<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../admin/admin-header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>창고 등록</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8284a9e56dbc80e2ab8f41c23c1bbb0a&libraries=services"></script>

    <script>
        const CONTEXT_PATH = '${pageContext.request.contextPath}';
    </script>

    <script src="${pageContext.request.contextPath}/static/warehouse/warehouse.js"></script>

    <style>
        /* 새로운 스타일 - 화면 꽉 채우기 반영 */
        body {
            font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
            background-color: #f4f7f6;
            /* body의 padding을 0으로 설정하여 꽉 채우기 시작 */
            padding: 0;
            margin: 0; /* 마진 제거 */
            color: #333;
            min-width: 320px; /* 최소 너비 설정 (모바일 대응) */
        }
        .container {
            /* max-width: 1000px; 제거 */
            width: 100%; /* 너비를 100%로 설정하여 꽉 채움 */
            margin: 0 auto;
            background: #ffffff;
            /* 내부 콘텐츠의 여백을 위해 padding-left/right 적용 */
            padding: 40px 50px; /* 상하 40px, 좌우 50px */
            border-radius: 0; /* 꽉 채우기 위해 둥근 모서리 제거 */
            box-shadow: none; /* 꽉 채우는 디자인에 맞게 그림자 제거 또는 변경 */
        }

        /* 좁은 화면 대응을 위한 미디어 쿼리 (선택사항) */
        @media (max-width: 768px) {
            .container {
                padding: 20px 20px; /* 모바일에서 좌우 여백 줄이기 */
            }
        }

        /* ------------------------------------------------------------- */
        /* 이하 기존 스타일 유지 */

        h1 {
            font-size: 28px;
            color: #1a202c;
            border-bottom: 3px solid #4299e1;
            padding-bottom: 15px;
            margin-bottom: 30px;
            font-weight: 700;
        }
        h2 {
            font-size: 22px;
            color: #2d3748;
            margin-top: 30px;
            margin-bottom: 20px;
            font-weight: 600;
        }
        label {
            display: block;
            margin-top: 15px;
            margin-bottom: 5px;
            font-weight: 600;
            color: #4a5568;
        }
        input[type="text"], select {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }
        input[type="text"]:focus, select:focus {
            border-color: #4299e1;
            outline: none;
            box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.5);
        }
        .input-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .input-group input, .input-group select {
            flex-grow: 1;
        }

        /* 버튼 스타일 */
        button {
            padding: 10px 18px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: background-color 0.3s;
        }
        .name-check-group button {
            background-color: #4a5568;
            color: white;
        }
        .name-check-group button:hover {
            background-color: #2d3748;
        }

        /* 구역/위치 컨테이너 */
        .section-container {
            border: 1px solid #e2e8f0;
            padding: 20px;
            margin-top: 20px;
            border-radius: 8px;
            background-color: #f7fafc;
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            border-bottom: 1px dashed #cbd5e0;
            padding-bottom: 10px;
        }
        .section-header h4 {
            color: #4299e1;
            font-size: 18px;
            margin: 0;
        }
        .location-list {
            border: 1px solid #bee3f8;
            padding: 15px;
            margin-top: 10px;
            border-radius: 6px;
            background-color: #ebf8ff;
        }
        .location-list h6 {
            color: #3182ce;
            margin-top: 0;
            font-size: 14px;
        }

        /* 구역/위치 추가/삭제 버튼 */
        .remove-btn {
            background-color: #e53e3e;
            color: white;
            font-size: 12px;
            padding: 5px 10px;
        }
        .remove-btn:hover {
            background-color: #c53030;
        }
        .add-section-btn {
            background-color: #38a169;
            color: white;
            margin-top: 20px;
        }
        .add-section-btn:hover {
            background-color: #2f855a;
        }
        .add-location-btn {
            background-color: #3182ce;
            color: white;
            margin-top: 10px;
            font-size: 14px;
            padding: 6px 12px;
        }
        .add-location-btn:hover {
            background-color: #2c5282;
        }

        /* 지도 및 위치 확인 스타일 */
        .map-container {
            margin-top: 25px;
            padding: 20px;
            border-radius: 8px;
            background-color: #f7fafc;
            border: 1px solid #e2e8f0;
        }
        #map {
            width: 100%;
            height: 400px;
            margin-top: 15px;
            border-radius: 4px;
            border: 1px solid #cbd5e0;
        }
        .map-controls button {
            background-color: #4299e1;
            color: white;
            margin-right: 10px;
        }
        .map-controls button:hover {
            background-color: #3182ce;
        }
        #coordResult {
            color: #38a169;
            font-weight: 700;
        }

        /* 알림 및 구분선 */
        .error-message {
            color: #e53e3e;
            font-weight: bold;
            padding: 15px;
            border: 1px solid #e53e3e;
            background-color: #fff5f5;
            margin-bottom: 25px;
            border-radius: 6px;
        }
        hr {
            border: 0;
            height: 1px;
            background: #e2e8f0;
            margin: 30px 0;
        }

        /* 최종 버튼 스타일 */
        .form-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            padding-top: 20px;
            border-top: 1px solid #e2e8f0;
            margin-top: 30px;
        }
        .form-buttons .submit {
            background-color: #48bb78;
            color: white;
        }
        .form-buttons .submit:hover {
            background-color: #38a169;
        }
        .form-buttons .cancel {
            background-color: #a0aec0;
            color: white;
        }
        .form-buttons .cancel:hover {
            background-color: #718096;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>창고 등록</h1>

    <c:if test="${not empty error}">
        <div class="error-message">
                ${error}
        </div>
    </c:if>

    <form id="warehouseRegisterForm" action="${pageContext.request.contextPath}/admin/warehouses/register" method="post" onsubmit="return validateForm();">

        <h2>창고 기본 정보</h2>

        <label for="warehouseName">창고 이름</label>
        <div class="input-group name-check-group">
            <input type="text" id="warehouseName" name="warehouseName" required onchange="document.getElementById('isNameChecked').value='false'; document.getElementById('nameCheckResult').textContent='';">
            <button type="button" onclick="checkDuplication()">중복 확인</button>
        </div>
        <div id="nameCheckResult" style="margin-bottom: 10px;"></div>
        <input type="hidden" id="isNameChecked" value="false">

        <label for="address">창고 주소</label>
        <div class="input-group">
            <input type="text" id="address" name="address" required>
        </div>

        <label for="adminId">담당자 ID</label>
        <div class="input-group">
            <input type="text" id="adminId" name="adminId" required>
        </div>

        <label for="warehouseType">창고 종류</label>
        <div class="input-group">
            <select id="warehouseType" name="warehouseType" required>
                <option value="">선택하세요</option>
                <option value="Hub">허브</option>
                <option value="Spoke">스포크</option>
            </select>
        </div>

        <label for="warehouseCapacity">총 수용 용량 (예 : ton)</label>
        <div class="input-group">
            <input type="text" id="warehouseCapacity" name="warehouseCapacity" required pattern="[0-9]*" title="숫자만 입력 가능합니다.">
        </div>

        <label for="warehouseStatus">운영 현황</label>
        <div class="input-group">
            <select id="warehouseStatus" name="warehouseStatus" required>
                <option value="">선택하세요</option>
                <option value="2">운영 중</option>
                <option value="1">준비 중</option>
                <option value="0">점검 중</option>

            </select>
        </div>

        <input type="hidden" id="latitude" name="latitude" value="">
        <input type="hidden" id="longitude" name="longitude" value="">

        <hr>

        <h2>📦구역 정보 등록</h2>
        <div id="sectionsContainer">
            <div class="section-container" id="section-1">
                <div class="section-header">
                    <h4>새 구역 1</h4>
                    <button type="button" onclick="removeSection(1)" class="remove-btn">삭제</button>
                </div>

                <label for="sections_0_name">구역 이름 (예: 나이키 보관구역)</label>
                <input type="text" name="sections[0].sectionName" required>

                <label for="sections_0_type">구역 타입</label>
                <select name="sections[0].sectionType" required>
                    <option value="">선택</option>
                    <option value="A">A구역</option>
                    <option value="B">B구역</option>
                    <option value="C">C구역</option>
                    <option value="D">D구역</option>
                </select>

                <label for="sections_0_purpose">구역 목적</label>
                <select name="sections[0].sectionPurpose" required>
                    <option value="">선택</option>
                    <option value="보관">보관 구역</option>
                    <option value="검수">검수 구역</option>
                </select>

                <label for="sections_0_area">면적 (단위: 제곱미터(m2))</label>
                <input type="text" name="sections[0].allocatedArea" required pattern="[0-9]*" title="숫자만 입력 가능합니다.">


<%--                리팩토링 예정--%>
<%--                <h5 style="margin-top: 25px; color: #4a5568;">📍 구역 위치 정보</h5>--%>
<%--                <div id="locationsContainer_0">--%>
<%--                    <div class="location-list" id="location-1">--%>
<%--                        <div style="display: flex; justify-content: space-between; align-items: center;">--%>
<%--                            <h6>위치 #1</h6>--%>
<%--                            <button type="button" onclick="removeLocation(1)" class="remove-btn">X</button>--%>
<%--                        </div>--%>

<%--                        <label>위치 코드</label>--%>
<%--                        <input type="text" name="sections[0].locations[0].locationCode" required>--%>

<%--                        <label>층수</label>--%>
<%--                        <select name="sections[0].locations[0].floorNum" required>--%>
<%--                            <option value="">선택</option>--%>
<%--                            <option value="1">1층</option>--%>
<%--                            <option value="2">2층</option>--%>
<%--                        </select>--%>

<%--                        <label>최대 부피 (단위 : m^3)</label>--%>
<%--                        <input type="text" name="sections[0].locations[0].maxVolume" required pattern="[0-9]*" title="숫자만 입력 가능합니다.">--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--                <button type="button" onclick="addLocation(0)" class="add-location-btn">+ 위치 추가</button>--%>
<%--            </div>--%>
<%--        </div>--%>

<%--        <button type="button" onclick="addSection()" class="add-section-btn">+ 구역 추가</button>--%>

<%--        <hr>--%>


        <h2>🗺️ 창고 위치 설정</h2>
        <div class="map-container">
            <div class="map-controls">
                <button type="button" onclick="searchAddress()">주소로 위치 확인</button>
                <span id="coordResult"></span>
            </div>
            <div id="map"></div>
        </div>

        <hr>

        <div class="form-buttons">
            <button type="submit" class="submit">창고 등록</button>
            <button type="button" class="cancel" onclick="location.href='${pageContext.request.contextPath}/admin/warehouses'">취소</button>
        </div>

    </form>
</div>

<script>
    // locationCounter를 1로 시작합니다. (기본 위치 1개 이미 생성)
    let locationCounter = 1;

    // ==================== [AJAX URL 수정 및 팝업 추가된] 중복 확인 함수 ====================
    function checkDuplication() {
        const warehouseName = $('#warehouseName').val().trim();
        const resultElement = $('#nameCheckResult');
        const isNameChecked = $('#isNameChecked');

        if (warehouseName === "") {
            resultElement.text("이름을 입력해주세요.").css('color', 'orange');
            isNameChecked.val("false");
            return;
        }

        // Controller의 실제 매핑 경로를 CONTEXT_PATH와 결합합니다.
        const url = CONTEXT_PATH + '/admin/warehouses/api/check/name';

        $.ajax({
            url: url,
            type: 'GET',
            data: { warehouseName: warehouseName },
            dataType: 'json',
            success: function(isDuplicated) {
                if (isDuplicated === true) {
                    resultElement.text("이미 사용 중인 이름입니다.").css('color', 'red');
                    isNameChecked.val("false");
                    alert("중복된 이름입니다. 다른 이름을 사용해주세요.");
                } else {
                    resultElement.text("사용 가능한 이름입니다.").css('color', '#38a169'); /* 성공 색상 변경 */
                    isNameChecked.val("true");
                    alert("사용 가능한 이름입니다.");
                }
            },
            error: function(xhr) {
                console.error("중복 확인 AJAX 호출 실패. Status:", xhr.status, "URL:", url);
                resultElement.text("서버 또는 네트워크 오류 발생").css('color', '#e53e3e').css('font-weight', 'bold');
                isNameChecked.val("false");
                alert("서버 오류로 중복 확인에 실패했습니다. (상태 코드: " + xhr.status + ")");
            }
        });
    }

    // ==================== [수정된] 유효성 검사 함수 ====================
    function validateForm() {
        const nameChecked = document.getElementById("isNameChecked").value === "true";
        if (!nameChecked) {
            alert("창고 이름 중복 확인을 해주세요.");
            return false;
        }

        const lat = document.getElementById("latitude").value;
        const lng = document.getElementById("longitude").value;
        if (!lat || !lng) {
            alert("창고 주소를 입력하고 [주소로 위치 확인] 버튼을 눌러 위치를 설정해주세요.");
            return false;
        }

        const sectionCount = document.getElementById("sectionsContainer").children.length;
        if (sectionCount === 0) {
            alert("최소한 하나 이상의 구역 정보를 등록해야 합니다.");
            return false;
        }

        // 구역/위치 내 숫자 필드의 유효성 검사 추가 (패턴 검사는 input 태그에 있지만 최종 확인 차원)
        let isValid = true;
        // 면적 확인
        $('[name$=".allocatedArea"]').each(function() {
            if (!/^[0-9]*$/.test($(this).val())) {
                alert("면적은 숫자만 입력해야 합니다.");
                isValid = false;
                return false;
            }
        });
        if (!isValid) return false;

        // 최대 부피 확인
        $('[name$=".maxVolume"]').each(function() {
            if (!/^[0-9]*$/.test($(this).val())) {
                alert("최대 부피는 숫자만 입력해야 합니다.");
                isValid = false;
                return false;
            }
        });
        if (!isValid) return false;

        return true;
    }

    // ==================== [수정된] 구역 추가 함수 ====================
    function addSection() {
        // 현재 존재하는 섹션 개수를 정확한 인덱스로 사용 (0, 1, 2...)
        const index = $('#sectionsContainer > div.section-container').length;
        const displayCount = index + 1; // 화면 표시용 번호

        const container = $('#sectionsContainer');
        const newSectionHtml = `
      <div class="section-container" id="section-${displayCount}">
        <div class="section-header">
          <h4>새 구역 ${displayCount}</h4>
          <button type="button" onclick="removeSection(${displayCount})" class="remove-btn">삭제</button>
        </div>

        <label for="sections_${index}_name">구역 이름 (예: 나이키 보관구역)</label>
        <input type="text" name="sections[${index}].sectionName" required>

        <label for="sections_${index}_type">구역 타입</label>
        <select name="sections[${index}].sectionType" required>
          <option value="">선택</option>
          <option value="A">A구역</option>
          <option value="B">B구역</option>
          <option value="C">C구역</option>
          <option value="D">D구역</option>
        </select>

        <label for="sections_${index}_purpose">구역 목적</label>
        <select name="sections[${index}].sectionPurpose" required>
          <option value="">선택</option>
          <option value="보관">보관 구역</option>
          <option value="검수">검수 구역</option>
        </select>

        <label for="sections_${index}_area">면적 (단위: 제곱미터(m2))</label>
        <input type="text" name="sections[${index}].allocatedArea" required pattern="[0-9]*" title="숫자만 입력 가능합니다.">

        <h5 style="margin-top: 25px; color: #4a5568;">📍 구역 위치 정보</h5>
        <div id="locationsContainer_${index}">
          </div>
        <button type="button" onclick="addLocation(${index})" class="add-location-btn">+ 위치 추가</button>
      </div>
    `;
        container.append(newSectionHtml);
    }

    // ==================== [수정된] 위치 추가 함수 (층수 Select 반영) ====================
    function addLocation(sectionIndex) {
        // 현재 해당 섹션 내에 존재하는 location 개수를 정확한 location 인덱스로 사용
        const locationIndex = $(`#locationsContainer_${sectionIndex} > div.location-list`).length;
        locationCounter++; // 전체 카운터 증가 (화면 표시용)

        const container = $(`#locationsContainer_${sectionIndex}`);
        const locationHtml = `
      <div class="location-list" id="location-${locationCounter}">
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <h6>위치 #${locationCounter}</h6>
          <button type="button" onclick="removeLocation(${locationCounter})" class="remove-btn">X</button>
        </div>

        <label>위치 코드</label>
        <input type="text" name="sections[${sectionIndex}].locations[${locationIndex}].locationCode" required>

        <label>층수</label>
        <select name="sections[${sectionIndex}].locations[${locationIndex}].floorNum" required>
          <option value="">선택</option>
          <option value="1">1층</option>
          <option value="2">2층</option>
        </select>

        <label>최대 부피 (단위: $m^3$ / 부피)</label>
        <input type="text" name="sections[${sectionIndex}].locations[${locationIndex}].maxVolume" required pattern="[0-9]*" title="숫자만 입력 가능합니다.">
      </div>
    `;
        container.append(locationHtml);
    }

    // ==================== 기타 함수 유지 ====================

    $(document).ready(function() {
        // 페이지 로드 시 지도 초기화 (warehouse.js의 함수 사용)
        kakao.maps.load(function() {
            if (typeof initMapForRegister === 'function') {
                initMapForRegister('map');
            } else {
                console.error("initMapForRegister 함수를 찾을 수 없습니다. warehouse.js를 확인해주세요.");
            }
        });

        // 주소 입력 필드에서 Enter 키 눌렀을 때 위치 확인 실행
        $('#address').keypress(function(e) {
            if (e.which == 13) {
                e.preventDefault();
                searchAddress();
            }
        });
    });

    // 구역 삭제 함수
    function removeSection(id) {
        $(`#section-${id}`).remove();
    }

    // 위치 삭제 함수
    function removeLocation(id) {
        $(`#location-${id}`).remove();
    }
</script>

</body>
</html>
<%@ include file="../admin/admin-footer.jsp" %>
