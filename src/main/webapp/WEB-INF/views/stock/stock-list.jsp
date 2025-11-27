<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageActive" value="stock_list" scope="request"/>
<%@ include file="../admin/admin-header.jsp" %>

<div class="container-xxl flex-grow-1 container-p-y">
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">재고 검색</h5>
        </div>
        <div class="card-body">
            <form id="stockSearchForm" onsubmit="return false;">

            <div class="row g-3 mb-3">

                <div class="col-md-4">
                    <div class="mb-3">
                        <label class="form-label">카테고리명</label>
                        <select id="categoryName" name="categoryCd" class="form-select">
                            <option value="">선택</option>
                            <c:forEach var="item" items="${categoryList}">
                                <option value="${item.id}">${item.name}</option>
                            </c:forEach>
                        </select>
                    </div>
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
                    <div class="mb-3">
                        <label class="form-label">브랜드</label>
                        <select id="brand" name="partnerId" class="form-select">
                            <option value="">선택</option>
                            <c:forEach var="item" items="${brandList}">
                                <option value="${item.id}">${item.name}</option>
                            </c:forEach>
                        </select>
                    </div>
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

                <div class="col-md-4 d-flex flex-column justify-content-end">
                    <div class="row g-3">
                        <div class="col-6">
                            <button type="button" class="btn btn-primary w-100" onclick="searchStock(1)">
                                <i class="bx bx-search me-1"></i> 검색
                            </button>
                        </div>
                        <div class="col-6">
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
            <h5 class="mb-0">재고 리스트</h5>
        </div>
        <div class="card-body">
            <div class="row g-3 mb-4">
                <div class="col-12 table-responsive">

                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>재고 번호</th>
                            <th>상품 ID</th>
                            <th>상품 이름</th>
                            <th>브랜드</th>
                            <th>수량</th>
                            <th>창고 이름</th>
                            <th>섹션 이름</th>
                        </tr>
                        </thead>
                        <tbody id="stock-tbody">

                        <tr>
                            <td colspan="7" class="text-center">재고 정보를 불러오는 중입니다...</td>
                        </tr>

                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="card-footer">
            <div class="float-end">
                <ul class="pagination flex-wrap" id="stock-pagination-ul">
                </ul>
            </div>
        </div>
    </div>
</div>
<%@ include file="../admin/admin-footer.jsp" %>

<script>

    function getSearchParams(page) {
        // null 대신 빈 문자열을 허용하여 URLSearchParams가 값이 없는 파라미터를 생략하도록 합니다.
        const categoryCd  = document.querySelector('select[name="categoryCd"]').value;
        const partnerId   = document.querySelector('select[name="partnerId"]').value;
        const warehouseId = document.querySelector('select[name="warehouseId"]').value;
        const sectionId   = document.querySelector('select[name="sectionId"]').value;

        const params = {
            page: page || 1,
            size: 10,
            categoryCd: categoryCd,
            partnerId: partnerId,
            warehouseId: warehouseId,
            sectionId: sectionId
        };

        const urlParams = new URLSearchParams();
        Object.keys(params).forEach(key => {
            // 값이 빈 문자열이 아닌 경우에만 URL 파라미 추가합니다.
            if (params[key] !== '') urlParams.append(key, params[key]);
        });
        return urlParams.toString();
    }

    function searchStock(page) {
        // 테이블 로딩 표시
        document.getElementById('stock-tbody').innerHTML = '<tr><td colspan="7" class="text-center">검색 중...</td></tr>';

        const queryString = getSearchParams(page);
        const apiUrl = '/stock/search?' + queryString;

        fetch(apiUrl)
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .then(responseDTO => {
                console.log("검색 성공, 데이터:", responseDTO);
                setTimeout(() => {
                    updateTable(responseDTO.dtoList);
                    updatePagination(responseDTO);
                    console.log("지연 후 화면 갱신 완료");
                }, 100);
            })
            .catch(error => {
                console.error("AJAX 통신 실패:", error);
                document.getElementById('stock-tbody').innerHTML = '<tr><td colspan="7" class="text-center text-danger">검색 요청 처리 실패. 콘솔을 확인하세요.</td></tr>';
                document.getElementById('stock-pagination-ul').innerHTML = '';
                alert("검색 요청 처리 실패. 콘솔을 확인하세요.");
            });
    }

    function updateTable(stockList) {
        const tbody = document.getElementById('stock-tbody');
        if (!tbody) {
            console.error("DOM Error: 'stock-tbody' 요소를 찾을 수 없습니다.");
            return;
        }
        let html = '';
        if (stockList && stockList.length > 0) {
            stockList.forEach(stock => {
                html += '<tr>';
                html += '<td>' + stock.psId + '</td>';
                html += '<td><a href="/stock/detail?productId=' + stock.productId + '" class="text-primary">' + stock.productId + '</a></td>';
                html += '<td>' + stock.productName + '</td>';
                html += '<td>' + stock.brandName + '</td>';
                html += '<td>' + stock.quantity + '</td>';
                html += '<td>' + stock.warehouseName + '</td>';
                html += '<td>' + stock.sectionName + '</td>';
                html += '</tr>';
            });
        } else {
            html = `<tr><td colspan="7" class="text-center">조회된 재고 정보가 없습니다.</td></tr>`;
        }

        console.log("DEBUG: Final HTML String:", html.substring(0, 150) + '...');

        console.log("DEBUG: tbody before update:", tbody.innerHTML.substring(0, 100) + '...');

        tbody.innerHTML = html;

        console.log("DEBUG: tbody after update:", tbody.innerHTML.substring(0, 100) + '...');
    }

    function updatePagination(responseDTO) {
        const paginationUl = document.getElementById('stock-pagination-ul');
        if (!paginationUl) {
            console.error("stock-pagination-ul 요소를 찾을 수 없습니다.");
            return;
        }
        const page  = parseInt(responseDTO.page) || 1;
        const start = parseInt(responseDTO.start) || 1;
        const end   = parseInt(responseDTO.end) || 1;
        const total = parseInt(responseDTO.total) || 0;
        const prev = responseDTO.prev;
        const next = responseDTO.next;

        if (total === 0 || isNaN(page)) {
            paginationUl.innerHTML = '';
            return;
        }
        let html = '';
        if (prev) {
            const prevPage = start - 1;
            html += '<li class="page-item prev">';
            html += '<a class="page-link" onclick="searchStock(' + prevPage + ')">';
            html += '<i class="tf-icon bx bx-chevrons-left"></i>';
            html += '</a>';
            html += '</li>';
        }
        for (let i = Number(start); i <= Number(end); i++) {
            const activeClass = (i === page) ? ' active' : '';
            html += '<li class="page-item' + activeClass + '">';
            html += '<a class="page-link" onclick="searchStock(' + i + ')">' + i + '</a>';
            html += '</li>';
        }
        if (next) {
            const nextPage = end + 1;
            html += '<li class="page-item next">';
            html += '<a class="page-link" onclick="searchStock(' + nextPage + ')">';
            html += '<i class="tf-icon bx bx-chevrons-right"></i>';
            html += '</a>';
            html += '</li>';
        }
        paginationUl.innerHTML = html;
    }
    document.addEventListener('DOMContentLoaded', function() {
        console.log("페이지 로드 완료 이벤트 발생, 초기 검색 시작.");
        searchStock(1);
    });
</script>