<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [핵심] 이 페이지가 'sales'임을 알림 --%>
<c:set var="pageActive" value="sales" scope="request"/>

<%@ include file="../admin/admin-header.jsp" %>

<div class="container-xxl flex-grow-1 container-p-y">
    <h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">재무관리 /</span> 매출 관리</h4>

    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">매출 목록</h5>
            <button type="button" class="btn btn-primary" onclick="openRegisterModal()">
                <i class="bx bx-plus me-1"></i> 매출 등록
            </button>
        </div>
        <div class="card-body">
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <label class="form-label">시작일</label>
                    <input type="date" id="startDate" class="form-control"/>
                </div>
                <div class="col-md-3">
                    <label class="form-label">종료일</label>
                    <input type="date" id="endDate" class="form-control"/>
                </div>
                <div class="col-md-4">
                    <label class="form-label">검색어</label>
                    <input type="text" id="keyword" class="form-control" placeholder="고객사명, 카테고리 등"/>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="button" class="btn btn-primary w-100" onclick="loadData(1)">
                        <i class="bx bx-search me-1"></i> 검색
                    </button>
                </div>
            </div>

            <div class="table-responsive text-nowrap">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>관리번호</th>
                        <th>매출일자</th>
                        <th>고객사명</th>
                        <th>창고명</th>
                        <th>카테고리</th>
                        <th class="text-end">금액 (만원)</th>
                        <th>설명</th>
                    </tr>
                    </thead>
                    <tbody id="tableBody"></tbody>
                </table>
            </div>

            <div class="d-flex justify-content-center mt-4">
                <nav>
                    <ul class="pagination" id="pagination"></ul>
                </nav>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="salesModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">매출 등록</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="salesId">
                <div class="row g-2">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">매출일자 <span class="text-danger">*</span></label>
                        <input type="date" id="modalSalesDate" class="form-control"/>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">금액 <span class="text-danger">*</span></label>
                        <input type="number" id="modalAmount" class="form-control" placeholder="숫자만 입력"/>
                    </div>
                </div>
                <div class="row g-2">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">고객사명 <span class="text-danger">*</span></label>
                        <%-- ▼ [수정] input을 select로 변경 --%>
                        <select id="modalClientName" class="form-select">
                            <option value="">고객사를 선택하세요</option>

                            <%-- 1단계에서 Controller가 넘겨준 ${partnerList}를 사용 --%>
                            <c:forEach var="partner" items="${partnerList}">
                                <%--
                                  Sales 테이블은 이름을 저장하므로 value에 이름을 넣습니다.
                                  (partnerName은 PartnerDTO의 필드명으로 가정)
                                --%>
                                <option value="${partner.partnerName}">${partner.partnerName}</option>
                            </c:forEach>
                        </select>
                        <%-- ▲ [수정] ---%>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">창고명 <span class="text-danger">*</span></label>
                        <%-- ▼ [수정] input을 select로 변경 --%>
                        <select id="modalWarehouseName" class="form-select">
                            <option value="">창고를 선택하세요</option>

                            <%-- 1단계에서 Controller가 넘겨준 ${warehouseList}를 사용 --%>
                            <c:forEach var="warehouse" items="${warehouseList}">
                                <option value="${warehouse.warehouseName}">${warehouse.warehouseName}</option>
                            </c:forEach>
                        </select>
                        <%-- ▲ [수정] ---%>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">카테고리 <span class="text-danger">*</span></label>
                    <select id="modalCategory" class="form-select">
                        <option value="">선택하세요</option>
                        <option value="월 이용료">월 이용료</option>
                        <option value="추가 보관료">추가 보관료</option>
                        <option value="작업비">작업비</option>
                        <option value="기타">기타</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">설명</label>
                    <textarea id="modalDescription" class="form-control" rows="3"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-danger" id="btnDelete" style="display:none;"
                        onclick="deleteSales()">삭제
                </button>
                <button type="button" class="btn btn-primary" id="btnUpdate" style="display:none;"
                        onclick="updateSales()">수정
                </button>
                <button type="button" class="btn btn-primary" id="btnSave" onclick="saveSales()">저장</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="../admin/admin-footer.jsp" %>

<script>
    const CONTEXT_PATH = '${pageContext.request.contextPath}';
    const API_BASE_URL = CONTEXT_PATH + '/admin/sales/api';

    $(document).ready(function () {
        loadData(1);
    });

    function loadData(page) {
        $.ajax({
            url: API_BASE_URL + '/list', type: 'GET',
            data: {
                page: page,
                size: 10,
                dateFrom: $('#startDate').val(),
                dateTo: $('#endDate').val(),
                keyword: $('#keyword').val()
            },
            dataType: 'json',
            success: function (res) {
                // [수정] DTO에 salesCode가 포함된 sales 리스트를 사용
                renderTable(res.sales);
                renderPagination(res);
            },
            error: function () {
                $('#tableBody').html('<tr><td colspan="7" class="text-center py-3 text-danger">데이터 로드 실패</td></tr>');
            }
        });
    }

    // --- ▼ [수정] 날짜 포맷팅과 salesCode를 사용하도록 수정한 최종본 ---
    function renderTable(list) {
        let tbody = $('#tableBody').empty();

        if (!list || list.length === 0) {
            tbody.append('<tr><td colspan="7" class="text-center py-3">데이터가 없습니다.</td></tr>');
            return;
        }

        list.forEach(item => {
            // 금액 포맷
            let amtInManWon = Math.floor(item.amount / 10000).toLocaleString('ko-KR');

            // 날짜 포맷: "2025,11,10" -> "2025-11-10"
            let formattedDate = item.salesDate ? String(item.salesDate).replace(/,/g, '-') : '-';

            // DTO의 salesCode 필드를 사용 (Service에서 생성한 값)
            tbody.append(`<tr style="cursor:pointer" onclick="openDetailModal(\${item.id})">
                <td>\${item.salesCode}</td>
                <td>\${formattedDate}</td>
                <td><strong>\${item.clientName}</strong></td>
                <td>\${item.warehouseName}</td>
                <td><span class="text-success fw-bold">\${item.category}</span></td>
                <td class="text-end fw-bold text-success">\${amtInManWon}</td>
                <td>\${item.description || '-'}</td>
            </tr>`);
        });
    }

    // --- ▲ [수정] ---

    const salesModal = new bootstrap.Modal(document.getElementById('salesModal'));

    function openRegisterModal() {
        $('#salesId').val('');
        $('#modalSalesDate').val(new Date().toISOString().split('T')[0]);
        // [수정] Select2 로직 제거, input 값 비우기로 원복
        $('#modalClientName, #modalWarehouseName, #modalCategory, #modalAmount, #modalDescription').val('');
        $('#modalCategory').val('');
        $('#modalTitle').text('신규 매출 등록');
        $('#btnSave').show();
        $('#btnUpdate, #btnDelete').hide();
        salesModal.show();
    }

    function openDetailModal(id) {
        $.get(API_BASE_URL + '/' + id, function (data) {
            $('#salesId').val(data.id);

            // [수정] 날짜 포맷팅 적용 (쉼표를 하이픈으로)
            $('#modalSalesDate').val(data.salesDate ? String(data.salesDate).replace(/,/g, '-') : '');

            // [수정] Select2 로직 제거, input 값 채우기로 원복
            $('#modalClientName').val(data.clientName);
            $('#modalWarehouseName').val(data.warehouseName);

            $('#modalCategory').val(data.category);
            $('#modalAmount').val(data.amount);
            $('#modalDescription').val(data.description);
            $('#modalTitle').text('매출 상세 정보');
            $('#btnSave').hide();
            $('#btnUpdate, #btnDelete').show();
            salesModal.show();
        }).fail(function () {
            alert('데이터 로드 실패');
        });
    }

    function saveSales() {
        sendRequest('POST', API_BASE_URL, '저장되었습니다.');
    }

    function updateSales() {
        sendRequest('PUT', API_BASE_URL + '/' + $('#salesId').val(), '수정되었습니다.');
    }

    function deleteSales() {
        if (confirm('삭제하시겠습니까?')) sendRequest('DELETE', API_BASE_URL + '/' + $('#salesId').val(), '삭제되었습니다.');
    }

    // [수정] Select2가 아닌 input의 val()을 사용 (기존 코드와 동일)
    function sendRequest(method, url, msg) {
        $.ajax({
            url: url, type: method, contentType: 'application/json',
            data: method === 'DELETE' ? null : JSON.stringify({
                salesDate: $('#modalSalesDate').val(),
                clientName: $('#modalClientName').val(),
                warehouseName: $('#modalWarehouseName').val(),
                category: $('#modalCategory').val(),
                amount: $('#modalAmount').val(),
                description: $('#modalDescription').val()
            }),
            success: function () {
                alert(msg);
                salesModal.hide();
                loadData(1);
            },
            error: function (e) {
                alert('요청 실패: ' + e.status);
            }
        });
    }

    function renderPagination(res) {
        let $ul = $('#pagination').empty();
        let totalPages = Math.ceil(res.total / res.size);
        let startPage = Math.floor((res.page - 1) / 10) * 10 + 1;
        let endPage = Math.min(startPage + 9, totalPages);
        if (res.page > 1) $ul.append(`<li class="page-item"><a class="page-link" href="javascript:loadData(\${res.page - 1})"><i class="bx bx-chevron-left"></i></a></li>`);
        for (let i = startPage; i <= endPage; i++) $ul.append(`<li class="page-item \${i === res.page ? 'active' : ''}"><a class="page-link" href="javascript:loadData(\${i})">\${i}</a></li>`);
        if (res.page < totalPages) $ul.append(`<li class="page-item"><a class="page-link" href="javascript:loadData(\${res.page + 1})"><i class="bx bx-chevron-right"></i></a></li>`);
    }
</script>