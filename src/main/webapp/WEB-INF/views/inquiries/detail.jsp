<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:choose>
    <c:when test="${sessionScope.role eq 'ADMIN'}">
        <jsp:include page="/WEB-INF/views/admin/admin-header.jsp" />
    </c:when>
    <c:when test="${sessionScope.role eq 'MANAGER'}">
        <jsp:include page="/WEB-INF/views/warehousemanager/manager-header.jsp" />
    </c:when>
    <c:otherwise>
        <jsp:include page="/WEB-INF/views/member/member-header.jsp" />
    </c:otherwise>
</c:choose>

<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

<div class="container-xxl flex-grow-1 container-p-y">
    <h4 class="fw-bold py-3 mb-4">
        <span class="text-muted fw-light">커뮤니티 / 문의사항 /</span> 상세보기
    </h4>

    <div class="card">
        <!-- 제목 및 메타 정보 -->
        <div class="card-header">
            <div class="d-flex justify-content-between align-items-start">
                <div class="flex-grow-1">
                    <h5 class="mb-3">${inquiry.title}</h5>
                    <div class="d-flex flex-wrap gap-3 text-muted small">
                        <span>
                            <i class="bx bx-user me-1"></i>
                            <strong>작성자:</strong> ${inquiry.writer}
                        </span>
                        <span>
                            <i class="bx bx-calendar me-1"></i>
                            <strong>작성일:</strong> ${fn:replace(inquiry.createdAt, 'T', ' ')}

                        </span>
                        <span>
                            <i class="bx bx-edit me-1"></i>
                            <strong>수정일:</strong> ${fn:replace(inquiry.updatedAt, 'T', ' ')}
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 본문 내용 -->
        <div class="card-body">
            <div class="inquiry-content" style="min-height: 200px; line-height: 1.8;">
                ${inquiry.content}
            </div>
        </div>

        <!-- 버튼 영역 -->
        <div class="card-footer">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <a href="/inquiries" class="btn btn-outline-secondary">
                        <i class="bx bx-list-ul me-1"></i> 목록으로
                    </a>
                </div>

                <c:if test="${sessionScope.loginId == inquiry.writer}">
                    <div class="d-flex gap-2">
                        <a href="/inquiries/${inquiry.inquiryId}/edit"
                           class="btn btn-primary">
                            <i class="bx bx-edit me-1"></i> 수정
                        </a>

                        <button type="button" class="btn btn-danger" onclick="openDeleteModal(${inquiry.inquiryId})">
                            <i class="bx bx-trash me-1"></i> 삭제
                        </button>

                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- ✅ 비밀번호 입력 모달 -->
    <div class="modal" id="deleteModal" tabindex="-1" style="display:none;">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">비밀번호 확인</h5>
                    <button type="button" class="btn-close" onclick="closeDeleteModal()"></button>
                </div>
                <div class="modal-body">
                    <p>삭제를 진행하려면 비밀번호를 입력하세요.</p>
                    <input type="password" id="deletePassword" class="form-control" placeholder="비밀번호 입력">
                    <input type="hidden" id="deleteInquiryId">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeDeleteModal()">취소</button>
                    <button type="button" class="btn btn-danger" onclick="confirmDelete()">삭제</button>
                </div>
            </div>
        </div>
    </div>

    <!-- ✅ form은 JS에서 동적으로 제출 -->
    <form id="deleteForm" method="post" style="display:none;"></form>

    <!-- 답글 섹션 -->
    <div class="card mt-4">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">답글 목록 (<span id="replyCount">0</span>)</h5>
            <button class="btn btn-primary" onclick="openCreateModal()">
                <i class="bx bx-plus me-1"></i> 답글 작성
            </button>
        </div>
        <div class="card-body">
            <div id="replyList">
                <div class="text-center py-4 text-muted">답글을 불러오는 중...</div>
            </div>
        </div>
    </div>
</div>

<!-- 답글 상세보기 모달 -->
<div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">답글 상세보기</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <div class="d-flex gap-3 text-muted small mb-3">
                        <span>
                            <i class="bx bx-user me-1"></i>
                            <strong>작성자:</strong> <span id="detailWriter"></span>
                        </span>
                        <span>
                            <i class="bx bx-calendar me-1"></i>
                            <strong>작성일:</strong> <span id="detailCreatedAt"></span>
                        </span>
                    </div>
                </div>
                <div class="border-top pt-3">
                    <div id="detailContent" style="min-height: 100px; line-height: 1.8;"></div>
                </div>
            </div>
            <div class="modal-footer" id="detailModalFooter">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<!-- 답글 작성 모달 -->
<div class="modal fade" id="formModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="formModalTitle">답글 작성</h5>
            </div>
            <div class="modal-body">
                <form id="replyForm">
                    <input type="hidden" id="replyId" name="replyId">
                    <div class="mb-3">
                        <label for="content" class="form-label">
                            내용 <span class="text-danger">*</span>
                        </label>
                        <textarea id="content"
                                  name="content"
                                  class="form-control"
                                  rows="6"
                                  placeholder="답글 내용을 입력하세요"
                                  required></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal" onclick="closeFormModal()">취소</button>
                <button type="button" class="btn btn-primary" onclick="submitReply()">
                    <i class="bx bx-check me-1"></i> 저장
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    const inquiryId = '${inquiry.inquiryId}';
    const loginId = '${sessionScope.loginId}';
    let currentReply = null;

    // 날짜/시간 포맷
    function formatDateTime(dateTime) {
        if (!dateTime) return '-';

        // 배열 형식인 경우 (예: [2025, 11, 11, 17, 28, 26])
        if (Array.isArray(dateTime)) {
            const year = dateTime[0];
            const month = String(dateTime[1]).padStart(2, '0');
            const day = String(dateTime[2]).padStart(2, '0');
            const hours = String(dateTime[3] || 0).padStart(2, '0');
            const minutes = String(dateTime[4] || 0).padStart(2, '0');
            const seconds = String(dateTime[5] || 0).padStart(2, '0');

            return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
        }

        const date = new Date(dateTime);
        if (isNaN(date.getTime())) return '-';

        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');

        return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes;
    }

    // 페이지 로드 시 답글 목록 조회
    document.addEventListener('DOMContentLoaded', function() {
        // 모달 열기
        function openDeleteModal(inquiryId) {
            document.getElementById("deleteInquiryId").value = inquiryId;
            document.getElementById("deletePassword").value = "";
            document.getElementById("deleteModal").style.display = "block";
        }
        window.openDeleteModal = openDeleteModal; // 전역으로 노출
        loadReplies();
    });

    // 답글 목록 조회
    async function loadReplies() {
        try {
            // ✅ 기존 경로 유지 (/api/inquiries/{inquiryId})
            const response = await axios.get('/api/inquiries/' + inquiryId);
            console.log('API 응답:', response.data);

            // ✅ 서버 응답에 replies가 포함되어 있을 경우
            const replies = Array.isArray(response.data.replies)
                ? response.data.replies
                : (Array.isArray(response.data) ? response.data : []);

            console.log('변환된 replies:', replies);
            document.getElementById('replyCount').textContent = replies.length;

            const replyList = document.getElementById('replyList');
            if (replies.length === 0) {
                replyList.innerHTML = '<div class="empty-message">등록된 답글이 없습니다.</div>';
                return;
            }

            // ✅ reply.replyId 사용 (전역 replyId 제거)
            replyList.innerHTML = replies.map(reply => {
                const id = reply.replyId;
                if (!id) return '';

                const safeContent = escapeHtml(reply.content || '');
                const safeWriter = escapeHtml(reply.writer || '');

                // 날짜 포맷 변환
                let safeDate = '';
                if (Array.isArray(reply.createdAt)) {
                    const [year, month, day, hour, minute, second] = reply.createdAt;
                    const dateObj = new Date(year, month - 1, day, hour, minute, second);
                    safeDate = dateObj.toLocaleString('ko-KR', {
                        year: 'numeric',
                        month: '2-digit',
                        day: '2-digit',
                        hour: '2-digit',
                        minute: '2-digit',
                        second: '2-digit'
                    });
                } else {
                    safeDate = escapeHtml(reply.createdAt || '');
                }

                return (
                    '<div class="reply-item" style="border: 2px solid lightslategray; padding: 10px; margin: 10px 0; cursor:pointer;" ' +
                    'onclick="showReplyDetail(' + id + ')">' + '<span>   </span>' +
                    '<div class="reply-item-header">' +
                    '<span class="reply-writer">' + safeWriter + '</span>' +
                    '<span class="reply-date">' + safeDate + '</span>' +
                    '</div>' +
                    '<div class="reply-content-preview">' + safeContent + '</div>' +
                    '</div>'
                );
            }).join('');
        } catch (error) {
            console.error('답글 목록 조회 실패:', error);
            alert('답글 목록을 불러오는데 실패했습니다.');
        }
    }

    // 답글 상세보기
    async function showReplyDetail(replyId) {
        console.log("replyId 클릭됨:", replyId);
        try {
            const response = await axios.get('/api/inquiries/' + inquiryId + '/reply/' + replyId);
            currentReply = response.data;
            console.log('상세 조회 응답:', currentReply);

            const writerEl = document.getElementById('detailWriter');
            const createdEl = document.getElementById('detailCreatedAt');
            const contentEl = document.getElementById('detailContent');

            if (writerEl) writerEl.textContent = currentReply.writer || '';
            if (createdEl) createdEl.textContent = formatDateTime(currentReply.createdAt) || '';
            if (contentEl) contentEl.textContent = currentReply.content || '';

            const footer = document.getElementById('detailModalFooter');
            if (footer) {
                // ✅ 공백 제거 + 대소문자 무시 비교
                if (
                    loginId &&
                    currentReply.writer &&
                    loginId.trim().toLowerCase() === currentReply.writer.trim().toLowerCase()
                ) {
                    footer.innerHTML =
                        '<button class="btn btn-secondary" onclick="closeDetailModal()">닫기</button>' +
                        '<button class="btn btn-danger" onclick="deleteReply()">삭제</button>';
                } else {
                    footer.innerHTML =
                        '<button class="btn btn-secondary" onclick="closeDetailModal()">닫기</button>';
                }
            }

            document.getElementById('detailModal').style.display = 'block';
            document.getElementById('detailModal').classList.add('show');
        } catch (error) {
            console.error('답글 상세 조회 실패:', error);
            alert('답글을 불러오는데 실패했습니다.');
        }
    }

    // 답글 작성 모달 열기
    function openCreateModal() {
        document.getElementById('formModalTitle').textContent = '답글 작성';
        document.getElementById('replyForm').reset();
        document.getElementById('replyId').value = '';
        document.getElementById('formModal').classList.add('show');
        document.getElementById('formModal').style.display = 'block';
    }

    // 답글 저장
    async function submitReply() {
        const replyId = document.getElementById('replyId').value;
        const content = document.getElementById('content').value.trim();

        if (!content) {
            alert('내용을 입력해주세요.');
            return;
        }

        const replyDTO = { content: content, writer: loginId };

        try {
            // ✅ 신규 등록
            await axios.post('/api/inquiries/' + inquiryId + '/reply', replyDTO);
            alert('답글이 등록되었습니다.');

            closeFormModal();
            loadReplies();
        } catch (error) {
            console.error('답글 저장 실패:', error);
            alert('답글 저장에 실패했습니다.');
        }
    }

    // 답글 삭제
    async function deleteReply() {
        if (!confirm('정말 삭제하시겠습니까?')) return;

        try {
            await axios.put('/api/inquiries/' + inquiryId + '/reply/' + currentReply.replyId);
            alert('답글이 삭제되었습니다.');
            closeDetailModal();
            loadReplies();
        } catch (error) {
            console.error('답글 삭제 실패:', error);
            alert('답글 삭제에 실패했습니다.');
        }
    }

    // 모달 닫기
    function closeDetailModal() {
        const modal = document.getElementById('detailModal');
        modal.style.display = 'none';
        modal.classList.remove('show');
        currentReply = null;
    }

    function closeFormModal() {
        const modal = document.getElementById('formModal');
        modal.style.display = 'none';
        modal.classList.remove('show');
    }

    // HTML 이스케이프 함수
    function escapeHtml(text) {
        const map = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' };
        return text ? text.toString().replace(/[&<>"']/g, m => map[m]) : '';
    }

    /* 문의글 지우는 모달 */

    // 모달 닫기
    function closeDeleteModal() {
        document.getElementById("deleteModal").style.display = "none";
    }

    // 삭제 확인
    function confirmDelete() {
        const password = document.getElementById("deletePassword").value.trim();
        const inquiryId = document.getElementById("deleteInquiryId").value;

        if (!password) {
            alert("비밀번호를 입력해주세요.");
            return;
        }

        if (confirm("정말 삭제하시겠습니까?")) {
            // POST form 생성
            const form = document.getElementById("deleteForm");
            form.action = `/inquiries/\${inquiryId}/delete`;
            form.method = "post";

            // ✅ 기존 form 내용 초기화
            form.innerHTML = '';

            // ✅ inquiryId 파라미터 추가
            const inquiryIdInput = document.createElement("input");
            inquiryIdInput.type = "hidden";
            inquiryIdInput.name = "inquiryId";
            inquiryIdInput.value = inquiryId;
            form.appendChild(inquiryIdInput);

            // ✅ 비밀번호 파라미터 추가
            const passwordInput = document.createElement("input");
            passwordInput.type = "hidden";
            passwordInput.name = "password";
            passwordInput.value = password;
            form.appendChild(passwordInput);

            form.submit();
        }
    }

</script>

<c:choose>
    <c:when test="${sessionScope.role eq 'ADMIN'}">
        <jsp:include page="/WEB-INF/views/admin/admin-footer.jsp" />
    </c:when>
    <c:when test="${sessionScope.role eq 'MANAGER'}">
        <jsp:include page="/WEB-INF/views/warehousemanager/manager-footer.jsp" />
    </c:when>
    <c:otherwise>
        <jsp:include page="/WEB-INF/views/member/member-footer.jsp" />
    </c:otherwise>
</c:choose>