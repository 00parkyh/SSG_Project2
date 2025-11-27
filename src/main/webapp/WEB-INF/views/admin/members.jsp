<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="admin-header.jsp" %>

    <div class="container-xxl flex-grow-1 container-p-y">
        <h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">관리자 /</span> 고객 관리</h4>

        <!-- 검색 조건 컨테이너 -->
        <div class="card mb-4">
            <div class="card-header">
                <h5 class="mb-0">검색 조건</h5>
            </div>
            <div class="card-body">
                <form method="get" action="${pageContext.request.contextPath}/admin/members">
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label for="keyword" class="form-label">검색어 (이름/아이디)</label>
                            <input type="text"
                                   id="keyword"
                                   name="keyword"
                                   class="form-control"
                                   placeholder="이름 또는 아이디를 입력하세요"
                                   value="${criteria.keyword}"/>
                        </div>

                        <div class="col-md-6">
                            <label for="status" class="form-label">상태</label>
                            <select id="status" name="status" class="form-select">
                                <option value="">전체</option>
                                <option value="ACTIVE" ${criteria.status == 'ACTIVE' ? 'selected' : ''}>활성</option>
                                <option value="INACTIVE" ${criteria.status == 'INACTIVE' ? 'selected' : ''}>비활성</option>
                                <option value="REJECTED" ${criteria.status == 'REJECTED' ? 'selected' : ''}>승인 거절</option>
                                <option value="PENDING" ${criteria.status == 'PENDING' ? 'selected' : ''}>승인 대기</option>
                            </select>
                        </div>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label for="startDate" class="form-label">생성일 (시작)</label>
                            <input type="date"
                                   id="startDate"
                                   name="startDate"
                                   class="form-control"
                                   value="${criteria.startDate}"/>
                        </div>

                        <div class="col-md-6">
                            <label for="endDate" class="form-label">생성일 (종료)</label>
                            <input type="date"
                                   id="endDate"
                                   name="endDate"
                                   class="form-control"
                                   value="${criteria.endDate}"/>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-2">
                        <button type="reset" class="btn btn-outline-secondary">
                            <i class="bx bx-reset me-1"></i> 초기화
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="bx bx-search me-1"></i> 검색
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- 고객 목록 컨테이너 -->
        <div class="list-container">
            <div class="list-header">
                <div class="list-title">고객 목록</div>
                <div class="total-count">전체 <strong>${totalCount != null ? totalCount : 0}</strong>명</div>
            </div>

            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">고객 목록</h5>
                    <span class="badge bg-primary">전체 <strong>${totalCount != null ? totalCount : 0}</strong>명</span>
                </div>
                <div class="card-body">
                    <!-- 테이블 -->
                    <div class="table-responsive text-nowrap">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th>번호</th>
                                <th>아이디</th>
                                <th>이름</th>
                                <th>이메일</th>
                                <th>상태</th>
                                <th>생성일</th>
                                <th>수정일</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty members}">
                                    <tr>
                                        <td colspan="7" class="text-center py-5 text-muted">
                                            조회된 고객이 없습니다.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="member" items="${members}" varStatus="status">
                                        <tr style="cursor: pointer;" onclick="viewMemberDetail(${member.memberId})">
                                            <td>${status.count}</td>
                                            <td>${member.memberLoginId}</td>
                                            <td>${member.memberName}</td>
                                            <td>${member.memberEmail}</td>
                                            <td>
                                            <span class="badge
                                                ${member.status == 'ACTIVE' ? 'bg-success' :
                                                  member.status == 'INACTIVE' ? 'bg-secondary' :
                                                  member.status == 'REJECTED' ? 'bg-danger' :
                                                  'bg-warning'}">
                                                    ${member.status == 'ACTIVE' ? '활성' :
                                                            member.status == 'INACTIVE' ? '비활성' :
                                                                    member.status == 'REJECTED' ? '정지' :
                                                                            member.status == 'PENDING' ? '승인 대기' : member.status}
                                            </span>
                                            </td>
                                            <td>${member.createdAt}</td>
                                            <td>${member.updatedAt}</td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>

            <!-- 📌 페이지네이션 -->
            <!-- 페이지네이션 -->
            <c:if test="${pageDTO.total > 0}">
                <div class="d-flex justify-content-center mt-4">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <c:if test="${pageDTO.prev}">
                                <li class="page-item">
                                    <a class="page-link" href="?pageNum=${pageDTO.startPage - 1}&keyword=${criteria.keyword}&status=${criteria.status}&startDate=${criteria.startDate}&endDate=${criteria.endDate}">
                                        <i class="tf-icon bx bx-chevron-left"></i>
                                    </a>
                                </li>
                            </c:if>

                            <c:forEach begin="${pageDTO.startPage}" end="${pageDTO.endPage}" var="i">
                                <li class="page-item ${i == pageDTO.pageNum ? 'active' : ''}">
                                    <a class="page-link" href="?pageNum=${i}&keyword=${criteria.keyword}&status=${criteria.status}&startDate=${criteria.startDate}&endDate=${criteria.endDate}">
                                            ${i}
                                    </a>
                                </li>
                            </c:forEach>

                            <c:if test="${pageDTO.next}">
                                <li class="page-item">
                                    <a class="page-link" href="?pageNum=${pageDTO.endPage + 1}&keyword=${criteria.keyword}&status=${criteria.status}&startDate=${criteria.startDate}&endDate=${criteria.endDate}">
                                        <i class="tf-icon bx bx-chevron-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>
    </div>

<!-- 상세 모달 -->
<div class="modal fade" id="memberModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">고객 상세 정보</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="modalBody">
                <!-- 동적으로 채워질 내용 -->
            </div>
            <div class="modal-footer" id="modalFooter">
                <!-- 동적으로 채워질 버튼 -->
            </div>
        </div>
    </div>
</div>


<script>
    // 상세 정보 조회
    function viewMemberDetail(memberId){
        if (!memberId) return;
        const modal = new bootstrap.Modal(document.getElementById('memberModal'));
        modal.show();

        console.log('Fetching member detail for ID:', memberId);
        fetch('${pageContext.request.contextPath}/admin/members/' + memberId)
            .then(response => {
                console.log('Response status:', response.status);
                console.log('Response headers:', response.headers.get('content-type'));

                // Content-Type 확인
                const contentType = response.headers.get('content-type');
                if (!contentType || !contentType.includes('application/json')) {
                    throw new Error('서버가 JSON을 반환하지 않았습니다. Content-Type: ' + contentType);
                }

                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }

                return response.json();
            })
            .then(member => {
                console.log('Member data:', member);
                displayMemberDetail(member);
            })
            .catch(error => {
                console.error('Error details:', error);
                alert('고객 정보를 불러오는데 실패했습니다.\n' + error.message);
            });

        // 모달에 고객 정보 표시
        function displayMemberDetail(member) {
            const modalBody = document.getElementById('modalBody');
            const modalFooter = document.getElementById('modalFooter');

            // 날짜 포맷 함수
            const formatDate = (dateString) => {
                if (!dateString) return '-';
                // LocalDateTime 형식 처리 (배열 또는 문자열)
                if (Array.isArray(dateString)) {
                    const [year, month, day, hour, minute] = dateString;
                    return year + '-' + String(month).padStart(2, '0') + '-' + String(day).padStart(2, '0') +
                        ' ' + String(hour).padStart(2, '0') + ':' + String(minute).padStart(2, '0');
                }
                return dateString;
            };

            const formatDateOnly = (dateString) => {
                if (!dateString) return '-';
                // LocalDateTime 형식 처리 (배열 또는 문자열)
                if (Array.isArray(dateString)) {
                    const [year, month, day] = dateString;
                    return year + '-' + String(month).padStart(2, '0') + '-' + String(day).padStart(2, '0');
                }
                return dateString.split(' ')[0]; // 문자열인 경우 날짜 부분만
            };

            // 상태 한글 변환
            const statusText = {
                'ACTIVE': '활성',
                'INACTIVE': '비활성',
                'REJECTED': '승인 거절',
                'PENDING': '승인 대기'
            };

            const statusBadgeClass = {
                'ACTIVE': 'bg-success',
                'INACTIVE': 'bg-secondary',
                'REJECTED': 'bg-danger',
                'PENDING': 'bg-warning'
            };

            // 상세 정보 표시
            modalBody.innerHTML = `
                <div class="row g-0">
            <div class="col-12">
                <div class="table-responsive">
                    <table class="table table-borderless">
                        <tbody>
                            <tr>
                                <td class="text-muted" style="width: 30%;"><strong>로그인 ID</strong></td>
                                <td>\${member.memberLoginId || '-'}</td>
                            </tr>
                            <tr>
                                <td class="text-muted"><strong>이름</strong></td>
                                <td>\${member.memberName || '-'}</td>
                            </tr>
                            <tr>
                                <td class="text-muted"><strong>이메일</strong></td>
                                <td>\${member.memberEmail || '-'}</td>
                            </tr>
                            <tr>
                                <td class="text-muted"><strong>전화번호</strong></td>
                                <td>\${member.memberPhone || '-'}</td>
                            </tr>
                            <tr>
                                <td class="text-muted"><strong>사업자등록번호</strong></td>
                                <td>\${member.businessNumber || '-'}</td>
                            </tr>
                            <tr>
                                <td class="text-muted"><strong>상태</strong></td>
                                <td>
                                    <span class="badge \${statusBadgeClass[member.status] || 'bg-secondary'}">
                                        \${statusText[member.status] || member.status || '-'}
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td class="text-muted"><strong>가입일</strong></td>
                                <td>\${member.createdAt || '-'}</td>
                            </tr>
                            <tr>
                                <td class="text-muted"><strong>수정일</strong></td>
                                <td>\${member.updatedAt || '-'}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
            `;

            // 상태에 따른 버튼 표시
            if (member.status === 'PENDING') {
                modalFooter.innerHTML = `
            <button type="button" class="btn btn-success" onclick="handleMemberStatus(\${member.memberId}, 'approve')">
                <i class="bx bx-check me-1"></i> 승인
            </button>
            <button type="button" class="btn btn-danger" onclick="handleMemberStatus(\${member.memberId}, 'reject')">
                <i class="bx bx-x me-1"></i> 거절
            </button>
            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
        `;
            } else {
                modalFooter.innerHTML = `
            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
        `;
            }

            // 모달 표시
            document.getElementById('memberModal').style.display = 'block';
        }
    }

    // 회원 상태 처리 (승인/거절)
    function handleMemberStatus(memberId, action) {
        const actionText = action === 'approve' ? '승인' : '거절';

        if (!confirm('정말로 이 회원을 ' + actionText + '하시겠습니까?')) {
            return;
        }

        // AJAX로 상태 변경 요청
        fetch('${pageContext.request.contextPath}/admin/members/' + memberId + '/' + action, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            }
        })
            .then(response => {
                if (response.ok) {
                    alert('회원 ' + actionText + ' 처리가 완료되었습니다.');
                    closeModal();
                    location.reload(); // 목록 새로고침
                } else {
                    throw new Error('HTTP error! status: ' + response.status);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('회원 ' + actionText + ' 처리 중 오류가 발생했습니다.');
            });
    }

    // 모달 닫기
    function closeModal(){
        const modal = bootstrap.Modal.getInstance(document.getElementById('memberModal'));
        if (modal) {
            modal.hide();
        }
    }

    // 모달 외부 클릭 시 닫기
    window.onclick = function(event) {
        const modal = document.getElementById('memberModal');
        if (event.target === modal) {
            closeModal();
        }
    }

    // 페이지 이동
    function goToPage(page) {
        const form = document.querySelector('.search-form');
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'page';
        input.value = page;
        form.appendChild(input);
        form.submit();
    }

</script>

<!-- / Content -->
<%@ include file="admin-footer.jsp" %>
