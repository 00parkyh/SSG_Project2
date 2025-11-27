<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String contextPath = request.getContextPath(); %>
<%@ include file="../../admin/admin-header.jsp" %>

<div class="container mt-4">
    <h4 class="fw-bold mb-3">입고 요청 목록</h4>

    <!-- 입고 요청 리스트 테이블 -->
    <table class="table table-bordered" id="inboundTable">
        <thead>
        <tr>
            <th>입고 번호</th>
            <th>브랜드</th>
            <th>요청자</th>
            <th>요청일시</th>
            <th>
                상태
                <select id="statusFilter" class="form-select w-auto d-inline mb-3">
                    <option value="">전체</option>
                    <option value="request" ${param.status == 'request' ? 'selected' : ''}>처리 대기</option>
                    <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>요청 취소</option>
                    <option value="approved" ${param.status == 'approved' ? 'selected' : ''}>승인 완료</option>
                    <option value="rejected" ${param.status == 'rejected' ? 'selected' : ''}>반려</option>
                </select>
            </th>
        </tr>
        </thead>
        <tbody id="inboundTableBody">
        <c:forEach var="item" items="${list}">
            <tr style="cursor:pointer;">
                <td>${item.inboundId}</td>
                <td>${item.partnerName}</td>
                <td>${item.memberName}</td>
                <td>${item.inboundRequestedDate}</td>
                <td>${item.inboundStatusKor}</td>
            </tr>
        </c:forEach>
        <c:if test="${empty list}">
            <tr>
                <td colspan="5" class="text-center">조회된 데이터가 없습니다.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

<!-- 모달 JSP 인클루드 -->
<%@ include file="inboundModal.jsp" %>

<!-- JS 라이브러리 로드 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>

    function submitApprove() {
        const inboundId = document.getElementById('inboundId').value;
        const warehouseId = document.getElementById('warehouseId').value;

        if (!inboundId) {
            alert('입고 번호가 없습니다.');
            return;
        }
        if (!warehouseId) {
            alert('입고 창고를 선택해주세요.');
            return;
        }

        // hidden input에 값 세팅
        document.getElementById('approveInboundId').value = inboundId;
        document.getElementById('approveWarehouseId').value = warehouseId;

        // form submit
        document.getElementById('approveForm').submit();
    }

    function submitReject() {
        const inboundId = document.getElementById('inboundId').value.trim();
        const reason = document.getElementById('inboundRejectReason').value.trim();

        if (!inboundId) {
            alert('입고 번호가 없습니다.');
            return;
        }
        if (!reason) {
            alert('반려 사유를 입력해주세요.');
            return;
        }

        // hidden input에 값 세팅
        document.getElementById('rejectInboundId').value = inboundId;
        document.getElementById('rejectReasonInput').value = reason;

        // form submit
        document.getElementById('rejectForm').submit();
    }


    $(document).ready(function() {
        // 모달 초기화
        const inboundModalElement = document.getElementById('inboundModal');
        const inboundModal = new bootstrap.Modal(inboundModalElement);

        // 상태 필터 변경 시 리스트 새로고침
        $("#statusFilter").change(function() {
            const status = $(this).val();
            $.ajax({
                url: "<%=contextPath%>/inbound/admin/list",
                type: "get",
                data: { status: status },
                success: function(data) {
                    const newBody = $(data).find("#inboundTableBody").html();
                    $("#inboundTableBody").html(newBody);
                },
                error: function() {
                    alert("리스트 조회 중 오류가 발생했습니다.");
                }
            });
        });

        // 테이블 행 클릭 시 상세 모달 띄우기
        $(document).on('click', '#inboundTableBody tr', function() {
            const inboundId = $(this).find('td:first').text().trim();
            openInboundModal(inboundId);
        });

        // 날짜 포맷팅 함수
        function formatDate(dateInput) {
            if (!dateInput) return '';
            if (typeof dateInput === 'string') {
                return dateInput.length >= 16 ? dateInput.substring(0,16).replace('T',' ') : dateInput;
            }
            if (dateInput instanceof Date) {
                return dateInput.toISOString().substring(0,16).replace('T',' ');
            }
            return String(dateInput);
        }




        // 입고 상품 렌더링
        function renderInboundItems(items) {
            const tbody = document.getElementById('inboundItemsBody');
            tbody.innerHTML = '';

            if (items && items.length > 0) {
                items.forEach(item => {
                    // DTO 구조에 따라 item 객체의 속성에 직접 접근합니다.
                    const row = `
                        <tr>
                            <td>\${item.productId || ''}</td>
                            <td>\${item.categoryName || '미분류'}</td>
                            <td>\${item.productName || ''}</td>
                            <td class="text-end">\${item.quantity ? item.quantity.toLocaleString() : '0'}</td>
                        </tr>`;
                    tbody.insertAdjacentHTML('beforeend', row);
                });
            } else {
                tbody.innerHTML = `
                    <tr>
                        <td colspan="4" class="text-center text-muted py-3">
                            입고 상품이 없습니다.
                        </td>
                    </tr>`;
            }
        }

        // 입고 상세 모달 열기
        function openInboundModal(inboundId) {
            axios.get("<%=contextPath%>/inbound/admin/" + inboundId)
                .then(function(response) {
                    const data = response.data;


                    console.log('--- Axios 응답 전체 데이터 ---');
                    console.log(data);
                    console.log('--- 렌더링에 전달될 아이템 배열 ---');
                    console.log(data.inboundItems);



                    if (!data) {
                        alert('데이터를 불러올 수 없습니다.');
                        return;
                    }

                    // 기본 정보 세팅
                    document.getElementById('inboundId').value = data.inboundId || '';
                    document.getElementById('inboundStatus').value = data.inboundStatus || '';
                    document.getElementById('inboundStatus').value = data.inboundStatusKor || '';


                    // status에 따른 상태별 색상 변화 추가
                    const inboundStatusEl = document.getElementById('inboundStatus');
                    // 기존 Bootstrap 클래스 제거
                    inboundStatusEl.classList.remove('bg-success', 'bg-primary', 'bg-danger', 'text-white');
                    // 상태에 따라 Bootstrap 클래스 추가
                    switch(data.inboundStatus) {
                        case 'approved':
                            inboundStatusEl.classList.add('bg-success', 'text-white');
                            break;
                        case 'request':
                            inboundStatusEl.classList.add('bg-primary', 'text-white');
                            break;
                        case 'rejected':
                        case 'cancelled':
                            inboundStatusEl.classList.add('bg-danger', 'text-white');
                            break;
                    }


                    document.getElementById('warehouseId').value = data.warehouseId || '';
                    document.getElementById('partnerName').value = data.partnerName || '';
                    document.getElementById('memberName').value = data.memberName || '';
                    document.getElementById('staffName').value = data.staffName || '미지정';

                    // 날짜 포맷팅
                    document.getElementById('inboundRequestedAt').value = formatDate(data.inboundRequestedAt);
                    document.getElementById('inboundAt').value = formatDate(data.inboundAt);

                    // 반려 사유 처리
                    const rejectSection = document.getElementById('rejectReasonSection');
                    const rejectTextarea = document.getElementById('inboundRejectReason');
                    // 항상 textarea 보이도록
                    rejectTextarea.style.display = 'block';

                    if (data.inboundStatus === 'request') {
                        // request 상태일 때만 입력 가능
                        rejectTextarea.value = '';
                        rejectTextarea.readOnly = false;
                    } else {
                        // 그 외 상태에서는 읽기 전용
                        rejectTextarea.value = data.inboundRejectReason || '';
                        rejectTextarea.readOnly = true;
                    }

                    // 승인/반려 버튼 element 가져오기
                    const approveBtn = document.querySelector('#approveForm button');
                    const rejectBtn = document.querySelector('#rejectForm button');
                    const warehouseSelect = document.getElementById('warehouseId');

                    if (data.inboundStatus === 'request') { // 대기 상태일 때만 버튼 표시
                        approveBtn.style.display = 'inline-block';
                        rejectBtn.style.display = 'inline-block';
                        warehouseSelect.disabled = false;
                    } else { // cancelled / approved / rejected 상태이면 버튼 숨김
                        approveBtn.style.display = 'none';
                        rejectBtn.style.display = 'none';
                        warehouseSelect.disabled = true;
                    }


                    // 상품 목록 렌더링
                    renderInboundItems(data.inboundItems);

                    // 모달 표시
                    inboundModal.show();
                })
                .catch(function(error) {
                    console.error('입고 상세 조회 오류:', error);
                    alert('입고 상세 조회 중 오류가 발생했습니다.');
                });
        }

        // 전역 함수로 노출
        /*현재 스코프에 있는 openInboundModal 함수를 전역 객체 window의 openInboundModal 속성으로 등록.
            이렇게 하면 어디서든 window.openInboundModal() 혹은 단순히 openInboundModal()로 호출 가능.*/
        window.openInboundModal = openInboundModal;
    });
</script>

<%@ include file="../../admin/admin-footer.jsp" %>
