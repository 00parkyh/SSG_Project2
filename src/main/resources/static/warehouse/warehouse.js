
//주소 검색 및 좌표 표시
function searchAddress() {
    const address = document.getElementById("address").value.trim();
    // JSP 파일의 <span id="coordResult"> 요소에 메시지를 표시
    const resultElement = document.getElementById("coordResult");

    if (!address) {
        alert("주소를 입력해주세요.");
        if (resultElement) {
            resultElement.textContent = "주소를 입력해 주세요.";
            resultElement.style.color = 'orange';
        }
        return;
    }

    // 검색 시작 시 사용자에게 피드백 제공
    if (resultElement) {
        resultElement.textContent = "위치 확인 중...";
        resultElement.style.color = 'gray';
    }


    const geocoder = new kakao.maps.services.Geocoder();
    geocoder.addressSearch(address, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            const lat = parseFloat(result[0].y);
            const lng = parseFloat(result[0].x);

            // 폼 필드에 위도/경도 값 저장
            document.getElementById("latitude").value = lat;
            document.getElementById("longitude").value = lng;

            const mapContainer = document.getElementById("map");
            const position = new kakao.maps.LatLng(lat, lng);
            const mapOption = { center: position, level: 3 };
            const map = new kakao.maps.Map(mapContainer, mapOption);

            const marker = new kakao.maps.Marker({ position: position });
            marker.setMap(map);


            if (resultElement) {
                resultElement.textContent = `위치 확인 완료: Lat ${lat.toFixed(4)}, Lng ${lng.toFixed(4)}`;
                resultElement.style.color = 'green';
            }
        } else {
            alert("주소를 찾을 수 없습니다. 다시 입력해주세요.");
            // 사용자에게 실패를 알림 (사용자 편의성 향상)
            if (resultElement) {
                resultElement.textContent = "주소를 찾을 수 없습니다.";
                resultElement.style.color = 'red';
            }
        }
    });
}

// ]등록 페이지 지도 초기화
function initMapForRegister(mapId) {
    if (typeof kakao === "undefined" || typeof kakao.maps === "undefined") {
        console.error("Kakao 지도 API가 로드되지 않았습니다."); return;
    }

    const mapContainer = document.getElementById(mapId);
    // 기본 위치를 서울 시청으로 설정
    const defaultPosition = new kakao.maps.LatLng(37.566826, 126.9786567);
    const mapOption = { center: defaultPosition, level: 7 }; // 넓은 범위의 레벨
    const map = new kakao.maps.Map(mapContainer, mapOption);
}

//목록 페이지 지도 표시
function initMapForList(mapId, data) {
    if (typeof kakao === 'undefined' || typeof kakao.maps === 'undefined' || !Array.isArray(data) || data.length === 0) {
        // 지도를 표시할 수 없는 경우 처리
        console.warn("창고 목록 데이터가 없거나 Kakao API가 로드되지 않아 지도를 표시할 수 없습니다.");
        return;
    }

    const mapContainer = document.getElementById(mapId);

    // 데이터가 있을 경우 첫 번째 창고를 기준으로 중심 설정 아니면 서울
    const first = data.find(w => w.latitude && w.longitude);
    const lat = Number(first?.latitude) || 37.566826;
    const lng = Number(first?.longitude) || 126.9786567;
    const center = new kakao.maps.LatLng(lat, lng);

    const map = new kakao.maps.Map(mapContainer, { center, level: 8 });
    const bounds = new kakao.maps.LatLngBounds();

    data.forEach(w => {
        if (w.latitude && w.longitude) {
            const position = new kakao.maps.LatLng(Number(w.latitude), Number(w.longitude));

            // 마커 생성
            const marker = new kakao.maps.Marker({ position, map });

            // 항상 보이는 말풍선(CustomOverlay) 생성
            const overlay = new kakao.maps.CustomOverlay({
                map: map,
                position: position,
                content: `<div style="
                    background: #fff;
                    border: 1px solid #000;
                    padding: 3px 6px;
                    font-weight: bold;
                    font-size: 12px;
                    border-radius: 4px;
                    box-shadow: 2px 2px 2px rgba(0,0,0,0.3);
                    white-space: nowrap;
                    text-align: center;
                ">${w.name}</div>`,
                yAnchor: 1 // 마커 바로 위
            });

            bounds.extend(position);
        }
    });

    // 모든 마커가 보이도록 지도 범위 재설정
    if (data.length > 0) {
        map.setBounds(bounds);
    }
}

//상세 페이지 지도 표시
function initMapForDetail(mapId, warehouse) {
    if (!warehouse || !warehouse.latitude || !warehouse.longitude) return;

    const lat = Number(warehouse.latitude);
    const lng = Number(warehouse.longitude);
    const position = new kakao.maps.LatLng(lat, lng);
    const mapContainer = document.getElementById(mapId);

    const mapOption = { center: position, level: 4 };
    const map = new kakao.maps.Map(mapContainer, mapOption);

    const marker = new kakao.maps.Marker({ position });
    marker.setMap(map);

    // 창고 이름 표시
    const overlay = new kakao.maps.CustomOverlay({
        map: map,
        position: position,
        content: `<div style="
            background: #fff;
            border: 1px solid #000;
            padding: 3px 6px;
            font-weight: bold;
            font-size: 12px;
            border-radius: 4px;
            box-shadow: 2px 2px 2px rgba(0,0,0,0.3);
            white-space: nowrap;
            text-align: center;
        ">${warehouse.name}</div>`,
        yAnchor: 1
    });
}