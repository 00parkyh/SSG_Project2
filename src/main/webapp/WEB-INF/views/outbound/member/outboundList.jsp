<%-- /WEB-INF/views/outbound/member/outboundList.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageActive" value="outbound_list" scope="request"/>
<jsp:include page="/WEB-INF/views/member/member-header.jsp" />

<div class="content-wrapper">
    <div class="container-xxl flex-grow-1 container-p-y">
        <h4 class="fw-bold py-3 mb-4">
            <span class="text-muted fw-light">출고 요청 /</span> 목록 조회
        </h4>

        <!-- 🔎 검색 폼 -->
        <div class="card mb-4">
            <div class="card-body">
                <form id="searchForm" class="row g-3">
                    <div class="col-md-3">
                        <label for="memberIdInput" class="form-label">고객아이디</label>
                        <input type="text" class="form-control" id="memberIdInput" name="memberId" placeholder="고객 ID 입력" value="${param.memberId}">
                    </div>
                    <div class="col-md-3">
                        <label for="statusFilter" class="form-label">배송상태</label>
                        <select id="statusFilter" name="status" class="form-select">
                            <option value="">-- 전체 --</option>₩
                            <option value="PENDING">승인대기</option>
                            <option value="APPROVED">승인</option>
                            <option value="COMPANION">반려</option>

                        </select>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary">조회</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- 📋 출고요청 목록 -->
        <div class="card">
            <h5 class="card-header">출고 요청 목록</h5>
            <div class="table-responsive text-nowrap">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th><input type="checkbox" id="selectAll"></th>
                        <th>번호</th>
                        <th>브랜드</th>
                        <th>출고 요청자</th>
                        <th>출고 요청일</th>
                        <th>배송 상태</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody class="table-border-bottom-0">
                    <c:if test="${not empty outboundList}">
                        <c:forEach var="req" items="${outboundList}" varStatus="loop">
                            <tr>
                                <td><input type="checkbox" name="requestIds" value="${req.outboundRequestId}"></td>
                                <td>${req.outboundRequestId}</td>
                                <td><c:out value="${req.brandName}" default="-" /></td>
                                <td><c:out value="${req.requestUserName}" default="-" /></td>
                                <td>${req.outboundDate}</td>

                                <td>
                                    <c:choose>
                                        <c:when test="${req.approvedStatus == '승인'}">
                                            <span class="badge bg-label-success me-1"><c:out value="${req.approvedStatus}" /></span>
                                        </c:when>
                                        <c:when test="${req.approvedStatus == '승인대기'}">
                                            <span class="badge bg-label-warning me-1"><c:out value="${req.approvedStatus}" /></span>
                                        </c:when>
                                        <c:when test="${req.approvedStatus == '반려'}">
                                            <span class="badge bg-label-danger me-1"><c:out value="${req.approvedStatus}" /></span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-label-secondary me-1"><c:out value="${req.approvedStatus}" /></span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <a href="#"
                                       class="btn btn-sm btn-outline-primary detail-btn"
                                       data-id="${req.outboundRequestId}">
                                        <i class="bx bx-detail"></i> 상세
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty outboundList}">
                        <tr><td colspan="7" class="text-center">조회된 출고 요청 내역이 없습니다.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <!-- 하단 버튼 -->
            <div class="card-footer d-flex justify-content-between align-items-center">
                <a href="${pageContext.request.contextPath}/member/outbound/request/form?${param.memberId}"
                   class="btn btn-primary">출고요청 등록</a>
                <div><nav><ul class="pagination"></ul></nav></div>
            </div>
        </div>

        <!-- 📜 스크립트 -->
        <script>
            const contextPath = '<c:out value="${pageContext.request.contextPath}" />';
            const currentMemberId = "${param.memberId}" || "1";

            console.log("🔧 contextPath:", contextPath);
            console.log("🔧 currentMemberId:", currentMemberId);

            document.addEventListener('DOMContentLoaded', function() {
                console.log("✅ DOM 로드 완료");

                // ✅ 검색 폼
                const searchForm = document.getElementById('searchForm');
                if (searchForm) {
                    searchForm.addEventListener('submit', function(e) {
                        e.preventDefault();
                        const memberId = searchForm.querySelector('#memberIdInput').value.trim();
                        const status = searchForm.querySelector('#statusFilter').value;

                        if (!memberId) {
                            alert('조회할 고객아이디를 입력해 주세요.');
                            return;
                        }

                        let queryString = `?memberId=\${memberId}`;
                        if (status) queryString += `&status=\${status}`;

                        const baseUrl = window.location.origin + contextPath + "/member/outbound/list";
                        window.location.href = baseUrl + queryString;
                    });
                }

                // ✅ 상세보기 버튼 이벤트 - 다른 방식으로 등록
                attachDetailEventListeners();
            });

            function attachDetailEventListeners() {
                const detailBtns = document.querySelectorAll('.detail-btn');
                console.log("🔍 발견된 상세보기 버튼 개수:", detailBtns.length);

                if (detailBtns.length === 0) {
                    console.warn("⚠️ 상세보기 버튼을 찾을 수 없습니다!");
                    return;
                }

                detailBtns.forEach((btn, index) => {
                    const dataId = btn.getAttribute('data-id');
                    console.log(`버튼 \${index + 1} data-id:`, dataId);

                    // 기존 이벤트 제거 후 재등록
                    btn.removeEventListener('click', handleDetailClick);
                    btn.addEventListener('click', handleDetailClick);
                });
            }

            function handleDetailClick(e) {
                e.preventDefault();
                e.stopPropagation();

                console.log("🖱️ 상세보기 버튼 클릭!");
                console.log("this:", this);

                const outboundRequestId = this.getAttribute('data-id');
                console.log("📌 가져온 outboundRequestId:", outboundRequestId);
                console.log("📌 타입:", typeof outboundRequestId);

                if (!outboundRequestId || outboundRequestId === 'null' || outboundRequestId === 'undefined') {
                    console.error("❌ outboundRequestId가 유효하지 않음:", outboundRequestId);
                    alert('요청 ID를 찾을 수 없습니다. 페이지를 새로고침해주세요.');
                    return;
                }

                const memberId = document.querySelector("#memberIdInput")?.value || currentMemberId;
                console.log("📌 사용할 memberId:", memberId);

                const url = `\${contextPath}/member/outbound/request/\${outboundRequestId}?memberId=\${memberId}`;
                console.log("📡 최종 요청 URL:", url);

                // 모달 body에 로딩 표시
                const tbody = document.getElementById('detailTableBody');
                if (tbody) {
                    tbody.innerHTML = '<tr><td colspan="10" class="text-center"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div></td></tr>';
                }

                fetch(url)
                    .then(response => {
                        console.log("📥 Response status:", response.status);
                        console.log("📥 Response OK:", response.ok);

                        if (!response.ok) {
                            throw new Error(`서버 오류: \${response.status} \${response.statusText}`);
                        }
                        return response.json();
                    })
                    .then(data => {
                        console.log("✅ 받은 데이터:", data);
                        console.log("✅ outboundRequestItems:", data.outboundRequestItems);

                        displayDetailModal(data);

                        const modalElement = document.getElementById('shipmentDetailModal');
                        if (!modalElement) {
                            console.error("❌ 모달 요소를 찾을 수 없습니다!");
                            alert('모달을 표시할 수 없습니다.');
                            return;
                        }

                        console.log("🎭 모달 표시 시도...");
                        const modal = new bootstrap.Modal(modalElement);
                        modal.show();
                        console.log("✅ 모달 표시 완료!");
                    })
                    .catch(err => {
                        console.error("❌ Fetch 에러:", err);
                        console.error("❌ 에러 스택:", err.stack);
                        alert('상세 정보를 불러오는 데 실패했습니다: ' + err.message);

                        // 에러 시 테이블 초기화
                        if (tbody) {
                            tbody.innerHTML = '<tr><td colspan="10" class="text-center text-danger">데이터 로드 실패</td></tr>';
                        }
                    });
            }

            let currentOutboundRequestId = null; // 현재 선택된 요청 ID 저장

            function displayDetailModal(data) {
                console.log("📝 모달 데이터 표시 함수 실행");

                // 현재 요청 ID 저장 (삭제 시 사용)
                currentOutboundRequestId = data.outboundRequestId;

                const tbody = document.getElementById('detailTableBody');
                if (!tbody) {
                    console.error("❌ detailTableBody를 찾을 수 없습니다!");
                    return;
                }

                tbody.innerHTML = '';

                if (!data) {
                    console.warn("⚠️ 데이터가 null/undefined");
                    tbody.innerHTML = '<tr><td colspan="10" class="text-center">데이터가 없습니다.</td></tr>';
                    return;
                }

                const items = data.outboundRequestItems || [];
                console.log("📦 출고 품목 개수:", items.length);

                if (items.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="10" class="text-center">출고 품목이 없습니다.</td></tr>';
                    return;
                }

                items.forEach((item, index) => {
                    console.log(`  - 품목 \${index + 1}:`, item.productName, item.outboundQuantity);

                    const row = document.createElement('tr');

                    if (index === 0) {
                        row.innerHTML = `
                    <td rowspan="\${items.length}">\${data.outboundRequestId || '-'}</td>
                    <td rowspan="\${items.length}">\${data.outboundDate || '-'}</td>
                    <td rowspan="\${items.length}">\${data.requestUserName || '-'}</td>
                    <td>\${item.productName || '-'}</td>
                    <td>\${item.outboundQuantity || '0'}</td>
                    <td rowspan="\${items.length}">\${data.outboundAddress || '-'}</td>
                    <td rowspan="\${items.length}">\${data.requestedDeliveryDate || '-'}</td>
                    <td rowspan="\${items.length}">\${data.dispatchStatus || '대기'}</td>
                    <td rowspan="\${items.length}">\${data.approvedStatus || '-'}</td>
                    <td rowspan="\${items.length}">\${data.waybillNumber || '-'}</td>
                `;
                    } else {
                        row.innerHTML = `
                    <td>\${item.productName || '-'}</td>
                    <td>\${item.outboundQuantity || '0'}</td>
                `;
                    }

                    tbody.appendChild(row);
                });

                console.log("✅ 테이블 렌더링 완료! 행 개수:", tbody.children.length);
            }

            // 삭제 버튼 이벤트 리스너 추가
            document.addEventListener('DOMContentLoaded', function() {
                const deleteBtn = document.querySelector('.modal-footer .btn-danger');
                if (deleteBtn) {
                    deleteBtn.addEventListener('click', handleDelete);
                }
            });

            function handleDelete() {
                if (!currentOutboundRequestId) {
                    alert('삭제할 요청을 찾을 수 없습니다.');
                    return;
                }

                if (!confirm(`출고 요청 번호 \${currentOutboundRequestId}을(를) 정말 삭제하시겠습니까?`)) {
                    return;
                }

                const memberId = document.querySelector("#memberIdInput")?.value || currentMemberId;
                const url = `\${contextPath}/member/outbound/request/\${currentOutboundRequestId}?memberId=\${memberId}`;

                console.log("🗑️ 삭제 요청 URL:", url);

                fetch(url, {
                    method: 'DELETE',
                    headers: { 'Content-Type': 'application/json' }
                })
                    .then(async response => {
                        console.log("📥 삭제 응답 상태:", response.status);

                        // ⚠️ 상태코드별 분기처리
                        if (response.status === 403) {
                            const msg = await response.text(); // 승인된 출고요청일 때
                            throw new Error(msg || "승인된 출고요청은 삭제할 수 없습니다.");
                        }

                        if (!response.ok) {
                            const msg = await response.text();
                            throw new Error(msg || `삭제 실패: ${response.status} ${response.statusText}`);
                        }

                        return response.text();
                    })
                    .then(() => {
                        console.log("✅ 삭제 성공");
                        alert("출고 요청이 삭제되었습니다.");

                        // 모달 닫기
                        const modalElement = document.getElementById("shipmentDetailModal");
                        const modal = bootstrap.Modal.getInstance(modalElement);
                        if (modal) modal.hide();

                        // 새로고침
                        location.reload();
                    })
                    .catch(err => {
                        console.error("❌ 삭제 에러:", err);
                        alert("삭제 중 오류가 발생했습니다: " + err.message);
                    });
            }
        </script>

        <!-- 📦 상세 모달 -->
        <div class="modal fade" id="shipmentDetailModal" tabindex="-1" aria-labelledby="detailModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="detailModalLabel">출고 상세 정보</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" id="modalContent">
                        <table class="table table-bordered">
                            <thead>
                            <tr class="table-dark">
                                <th>요청번호</th><th>요청일자</th><th>고객이름</th><th>상품이름</th>
                                <th>수량</th><th>출고주소</th><th>출고희망일</th>
                                <th>배차상태</th><th>요청상태</th><th>운송장</th>
                            </tr>
                            </thead>
                            <tbody id="detailTableBody">
                            <tr><td colspan="10" class="text-center">데이터를 로드하는 중입니다...</td></tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
                        <button type="button" class="btn btn-danger">삭제</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>



<%@ include file="../../member/member-footer.jsp" %>
