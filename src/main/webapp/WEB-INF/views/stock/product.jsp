<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageActive" value="product_list" scope="request"/>

<%-- HEADER 포함 --%>
<c:choose>
    <c:when test="${sessionScope.role == 'MANAGER'}">
        <jsp:include page="/WEB-INF/views/warehousemanager/manager-header.jsp" />
    </c:when>
    <c:otherwise>
        <jsp:include page="/WEB-INF/views/admin/admin-header.jsp" />
    </c:otherwise>
</c:choose>

<div class="container-xxl flex-grow-1 container-p-y">
<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">품목 검색</h5>
    </div>
    <div class="card-body">
        <form id="ProductSearchForm" onsubmit="return false;">

            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div>
                        <label class="form-label">상품 ID</label>
                        <input type="text" id="productId" name="productId" class="form-control" placeholder="상품 ID 입력">
                    </div>
                </div>
                <div class="col-md-4">
                    <div>
                        <label class="form-label">카테고리명</label>
                        <select id="categoryName" name="categoryCd" class="form-select">
                            <option value="">선택</option>
                            <c:forEach var="item" items="${categoryList}">
                                <option value="${item.id}">${item.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="col-md-4">
                    <div>
                        <label class="form-label">브랜드</label>
                        <select id="brand" name="partnerId" class="form-select">
                            <option value="">선택</option>
                            <c:forEach var="item" items="${brandList}">
                                <option value="${item.id}">${item.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div>
                        <label class="form-label">창고 이름</label>
                        <select id="warehouseName" name="warehouseId" class="form-select">
                            <option value="">선택</option>
                            <c:forEach var="item" items="${warehouseList}">
                                <option value="${item.id}">${item.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="col-md-4">
                    <div>
                        <label class="form-label">섹션 이름</label>
                        <select id="sectionName" name="sectionId" class="form-select">
                            <option value="">선택</option>
                            <c:forEach var="item" items="${sectionList}">
                                <option value="${item.id}">${item.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="col-md-4">
                </div>
            </div>

            <div class="row g-3">
                <div class="col-12 d-flex justify-content-end">
                    <div class="row g-3 w-auto">
                        <div class="col-auto">
                            <button type="button" class="btn btn-primary w-100" onclick="searchProduct(1)">
                                <i class="bx bx-search me-1"></i> 검색
                            </button>
                        </div>
                        <div class="col-auto">
                            <button type="reset" class="btn btn-secondary w-100">
                                <i class="bx bx-reset me-1"></i> 리셋
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<div class="card2">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">품목 리스트</h5>
    </div>
    <div class="card-body">
        <div class="row g-3 mb-4">
            <div class="col-12 table-responsive">

                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>상품 ID</th>
                        <th>상품 이름</th>
                        <th>브랜드</th>
                        <th>창고 이름</th>
                        <th>섹션 이름</th>
                        <th>수량</th>
                        <th>재고 상태</th>
                        <th>출고 가능 여부</th>
                        <th>입고 날짜</th>
                    </tr>
                    </thead>
                    <tbody id="product-tbody">

                    <tr>
                        <td colspan="9" class="text-center">품목 정보를 불러오는 중입니다...</td>
                    </tr>

                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="card-footer">
        <div class="float-end">
            <ul class="pagination flex-wrap" id="product-pagination-ul">
            </ul>
        </div>
    </div>
</div>
</div>

<%-- FOOTER 포함 --%>
<c:choose>
    <c:when test="${sessionScope.role == 'MANAGER'}">
        <jsp:include page="/WEB-INF/views/warehousemanager/manager-footer.jsp" />
    </c:when>
    <c:otherwise>
        <jsp:include page="/WEB-INF/views/admin/admin-footer.jsp" />
    </c:otherwise>
</c:choose>

<script>
    /**
     * 드롭다운 선택 값을 수집하여 쿼리스트링을 생성
     */
    function getSearchParams(page) {
        // null 대신 빈 문자열을 허용하여 URLSearchParams가 값이 없는 파라미터를 생략하도록 합니다.
        const productId   = document.querySelector('input[name="productId"]').value;
        const categoryCd  = document.querySelector('select[name="categoryCd"]').value;
        const partnerId   = document.querySelector('select[name="partnerId"]').value;
        const warehouseId = document.querySelector('select[name="warehouseId"]').value;
        const sectionId   = document.querySelector('select[name="sectionId"]').value;
        const params = {
            page: page || 1,
            size: 10,
            productId: productId,
            categoryCd: categoryCd,
            partnerId: partnerId,
            warehouseId: warehouseId,
            sectionId: sectionId
        };
        const urlParams = new URLSearchParams();
        Object.keys(params).forEach(key => {
            // 값이 빈 문자열이 아닌 경우에만 URL 파라미터에 추가합니다.
            if (params[key] !== '') urlParams.append(key, params[key]);
        });

        return urlParams.toString();
    }
    /*
     * 재고 검색 버튼 클릭 및 페이지네이션 클릭 시 호출
     */
    function searchProduct(page) {
        // 테이블 로딩 표시
        document.getElementById('product-tbody').innerHTML = '<tr><td colspan="9" class="text-center">검색 중...</td></tr>';
        const queryString = getSearchParams(page);
        const apiUrl = '/productList/api/plist?' + queryString;
        fetch(apiUrl)
            .then(response => {
                if (!response.ok) {
                    // HTTP 상태 코드가 200번대가 아니면 에러를 던집니다.
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .then(responseDTO => {
                console.log("검색 성공, 데이터:", responseDTO);
                // 가져온 데이터로 테이블과 페이지네이션을 갱신합니다.
                setTimeout(() => {
                    updateTable(responseDTO.dtoList);
                    updatePagination(responseDTO);
                    console.log("지연 후 화면 갱신 완료");
                }, 100);
            })
            .catch(error => {
                console.error("AJAX 통신 실패:", error);
                document.getElementById('product-tbody').innerHTML = '<tr><td colspan="9" class="text-center text-danger">검색 요청 처리 실패. 콘솔을 확인하세요.</td></tr>';
                document.getElementById('product-pagination-ul').innerHTML = ''; // 페이지네이션 초기화
                alert("검색 요청 처리 실패. 콘솔을 확인하세요.");
            });
    }
    /**
     * 재고 목록 테이블 갱신
     */
    function updateTable(productList) {
        const tbody = document.getElementById('product-tbody');
        if (!tbody) {
            console.error("DOM Error: 'product-tbody' 요소를 찾을 수 없습니다.");
            return;
        }
        let html = '';
        if (productList && productList.length > 0) {
            productList.forEach(product => {
                html += '<tr>';
                html += '<td>' + product.productId + '</td>';
                html += '<td>' + product.productName + '</td>';
                html += '<td>' + product.brandName + '</td>';
                html += '<td>' + product.warehouseName + '</td>';
                html += '<td>' + product.sectionName + '</td>';
                html += '<td>' + product.quantity + '</td>';
                html += '<td>' + product.productState + '</td>';
                html += '<td>' + product.availableOutbound + '</td>';
                html += '<td>' + product.inboundDate + '</td>';
                html += '</tr>';
            });
        } else {
            html = `<tr><td colspan="9" class="text-center">조회된 재고 정보가 없습니다.</td></tr>`;
        }
        // 💡 최종 디버깅: 할당 직전, 생성된 HTML 문자열의 시작 부분을 확인합니다.
        console.log("DEBUG: Final HTML String:", html.substring(0, 150) + '...');
        // 💡 갱신 직전 tbody의 현재 상태를 확인합니다.
        console.log("DEBUG: tbody before update:", tbody.innerHTML.substring(0, 100) + '...');
        tbody.innerHTML = html;
        // 💡 갱신 직후 tbody의 내용을 확인합니다.
        console.log("DEBUG: tbody after update:", tbody.innerHTML.substring(0, 100) + '...');
    }
    /*
     * 페이지네이션 갱신 (안정적인 문자열 결합 방식으로 수정)
     */
    function updatePagination(responseDTO) {
        const paginationUl = document.getElementById('product-pagination-ul');
        if (!paginationUl) {
            console.error("product-pagination-ul 요소를 찾을 수 없습니다.");
            return;
        }
        // 서버 응답에서 숫자를 명확하게 파싱
        const page  = parseInt(responseDTO.page) || 1;
        const start = parseInt(responseDTO.start) || 1;
        const end   = parseInt(responseDTO.end) || 1;
        const total = parseInt(responseDTO.total) || 0;
        // 이전/다음 여부는 boolean으로 직접 사용
        const prev = responseDTO.prev;
        const next = responseDTO.next;
        // 데이터가 없거나 페이지 번호가 유효하지 않으면 반환
        if (total === 0 || isNaN(page)) {
            paginationUl.innerHTML = '';
            return;
        }
        let html = '';
        // 1. 이전 버튼
        if (prev) {
            const prevPage = start - 1;
            // 💡 템플릿 리터럴 대신 문자열 결합 사용
            html += '<li class="page-item prev">';
            html += '<a class="page-link" onclick="searchProduct(' + prevPage + ')">';
            html += '<i class="tf-icon bx bx-chevrons-left"></i>';
            html += '</a>';
            html += '</li>';
        }
        // 2. 페이지 번호
        for (let i = Number(start); i <= Number(end); i++) {
            const activeClass = (i === page) ? ' active' : '';

            // 💡 템플릿 리터럴 대신 문자열 결합 사용
            html += '<li class="page-item' + activeClass + '">';
            html += '<a class="page-link" onclick="searchProduct(' + i + ')">' + i + '</a>';
            html += '</li>';
        }
        // 3. 다음 버튼
        if (next) {
            const nextPage = end + 1;
            // 💡 템플릿 리터럴 대신 문자열 결합 사용
            html += '<li class="page-item next">';
            html += '<a class="page-link" onclick="searchProduct(' + nextPage + ')">';
            html += '<i class="tf-icon bx bx-chevrons-right"></i>';
            html += '</a>';
            html += '</li>';
        }
        paginationUl.innerHTML = html;
    }
    // 💡 추가된 코드: 페이지 로드 완료 시 초기 재고 목록을 가져오기 위해 searchProduct(1) 호출
    document.addEventListener('DOMContentLoaded', function() {
        console.log("페이지 로드 완료 이벤트 발생, 초기 검색 시작.");
        searchProduct(1);
    });
</script>
