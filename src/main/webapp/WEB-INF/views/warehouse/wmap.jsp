<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="isManagerView" value="${sessionScope.role == 'MANAGER'}" />
<c:set var="isMemberView" value="${sessionScope.role == 'MEMBER'}" />
<c:set var="pageActive" value="warehouse_location" scope="request"/>
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
  <title>창고 위치 조회</title>
  <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8284a9e56dbc80e2ab8f41c23c1bbb0a&autoload=false&libraries=services"></script>
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
    .map-layout {
      display: grid;
      grid-template-columns: minmax(0, 1fr) 320px;
      gap: 20px;
      align-items: start;
    }
    #map {
      width: 100%;
      height: 560px;
      border-radius: 8px;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }
    .warehouse-panel {
      border: 1px solid #e0e0e0;
      border-radius: 8px;
      overflow: hidden;
      background-color: #fff;
    }
    .warehouse-panel h2 {
      margin: 0;
      padding: 14px 16px;
      font-size: 1rem;
      background-color: #5a5f78;
      color: #fff;
    }
    .warehouse-list {
      max-height: 500px;
      overflow-y: auto;
    }
    .warehouse-item {
      width: 100%;
      padding: 12px 16px;
      border: 0;
      border-bottom: 1px solid #eee;
      background: #fff;
      text-align: left;
      cursor: pointer;
    }
    .warehouse-item:hover { background-color: #eef6ff; }
    .warehouse-name {
      display: block;
      font-weight: 700;
      color: #333;
      margin-bottom: 4px;
    }
    .warehouse-address {
      display: block;
      color: #666;
      font-size: 0.85rem;
      line-height: 1.35;
    }
    .empty-message {
      padding: 16px;
      color: #666;
      text-align: center;
    }
    .marker-label {
      background-color: #fff;
      border: 1px solid #333;
      padding: 3px 6px;
      font-size: 12px;
      font-weight: bold;
      color: #000;
      text-align: center;
      border-radius: 3px;
      box-shadow: 2px 2px 2px rgba(0,0,0,0.25);
      white-space: nowrap;
      cursor: pointer;
    }
    @media (max-width: 992px) {
      .map-layout {
        grid-template-columns: 1fr;
      }
      #map {
        height: 420px;
      }
    }
  </style>
</head>
<body>
<div class="page-wrapper">
  <h1>창고 위치 조회</h1>

  <div class="map-layout">
    <div id="map"></div>

    <aside class="warehouse-panel">
      <h2>창고 목록</h2>
      <div class="warehouse-list" id="warehouseListPanel">
        <c:set var="displayList" value="${tableWarehouseList != null ? tableWarehouseList : warehouseList}" />
        <c:forEach var="warehouse" items="${displayList}">
          <button type="button" class="warehouse-item" data-warehouse-id="${warehouse.warehouseId}">
            <span class="warehouse-name">${warehouse.warehouseName}</span>
            <span class="warehouse-address">${warehouse.address}</span>
          </button>
        </c:forEach>
        <c:if test="${empty displayList}">
          <div class="empty-message">표시할 창고가 없습니다.</div>
        </c:if>
      </div>
    </aside>
  </div>
</div>

<script type="application/json" id="warehouseDataJson"><c:choose><c:when test="${empty jsWarehouseData}">[]</c:when><c:otherwise><c:out value="${jsWarehouseData}" escapeXml="false" /></c:otherwise></c:choose></script>
<script type="text/javascript">
  const rawWarehouseData = document.getElementById('warehouseDataJson').textContent.trim() || '[]';
  let warehouseData = [];

  try {
    warehouseData = JSON.parse(rawWarehouseData);
  } catch (error) {
    console.error('창고 위치 데이터 파싱 오류:', error);
  }

  function escapeHtml(value) {
    return String(value || '')
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
  }

  function initWarehouseMap() {
    const container = document.getElementById('map');
    const defaultCenter = new kakao.maps.LatLng(37.5665, 126.9780);
    const map = new kakao.maps.Map(container, {
      center: defaultCenter,
      level: 7
    });
    const bounds = new kakao.maps.LatLngBounds();
    const markerMap = {};
    let hasValidCoords = false;

    warehouseData.forEach(function(warehouse) {
      const lat = Number(warehouse.latitude);
      const lng = Number(warehouse.longitude);

      if (Number.isNaN(lat) || Number.isNaN(lng) || lat === 0 || lng === 0) {
        return;
      }

      hasValidCoords = true;
      const position = new kakao.maps.LatLng(lat, lng);
      const marker = new kakao.maps.Marker({
        position: position,
        map: map
      });
      const warehouseName = escapeHtml(warehouse.warehouseName);
      const warehouseAddress = escapeHtml(warehouse.address);
      const overlay = new kakao.maps.CustomOverlay({
        position: position,
        content: '<div class="marker-label">' + warehouseName + '</div>',
        map: map,
        yAnchor: 1
      });
      const infowindow = new kakao.maps.InfoWindow({
        content: '<div style="padding:8px; min-width:160px;"><strong>' + warehouseName + '</strong><br/>' + warehouseAddress + '</div>'
      });

      kakao.maps.event.addListener(marker, 'click', function() {
        infowindow.open(map, marker);
      });
      kakao.maps.event.addListener(overlay, 'click', function() {
        infowindow.open(map, marker);
      });

      markerMap[String(warehouse.warehouseId)] = {
        marker: marker,
        position: position,
        infowindow: infowindow
      };
      bounds.extend(position);
    });

    if (hasValidCoords) {
      map.setBounds(bounds);
    }

    document.querySelectorAll('.warehouse-item').forEach(function(button) {
      button.addEventListener('click', function() {
        const target = markerMap[button.dataset.warehouseId];
        if (!target) {
          return;
        }
        map.setCenter(target.position);
        map.setLevel(4);
        target.infowindow.open(map, target.marker);
      });
    });
  }

  if (window.kakao && kakao.maps) {
    kakao.maps.load(initWarehouseMap);
  } else {
    console.error('카카오 지도 SDK를 불러오지 못했습니다.');
  }
</script>
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
