<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="member-header.jsp" %>

<div class="container-xxl flex-grow-1 container-p-y">
    <h4 class="fw-bold py-3 mb-4">
        <span class="text-muted fw-light">설정 /</span> 내 정보
    </h4>

    <div class="row">
        <div class="col-md-12">

            <div class="card mb-4">
                <h5 class="card-header">프로필 정보</h5>
                <hr class="my-0"/>
                <div class="card-body">
                    <form id="formAccountSettings" method="POST" onsubmit="return false">
                        <div class="row">
                            <div class="mb-3 col-md-6">
                                <label for="memberName" class="form-label">이름</label>
                                <input class="form-control" type="text" id="memberName" name="memberName"
                                       value="${loginMember.memberName}" readonly/>
                            </div>
                            <div class="mb-3 col-md-6">
                                <label for="memberLoginId" class="form-label">아이디</label>
                                <input class="form-control" type="text" name="memberLoginId" id="memberLoginId"
                                       value="${loginMember.memberLoginId}" readonly/>
                            </div>
                            <div class="mb-3 col-md-6">
                                <label for="memberEmail" class="form-label">이메일</label>
                                <input class="form-control" type="text" id="memberEmail" name="memberEmail"
                                       value="${loginMember.memberEmail}" placeholder="example@racl.com"/>
                            </div>
                            <div class="mb-3 col-md-6">
                                <label class="form-label" for="memberPhone">전화번호</label>
                                <div class="input-group input-group-merge">
                                    <span class="input-group-text">KR (+82)</span>
                                    <input type="text" id="memberPhone" name="memberPhone" class="form-control"
                                           value="${loginMember.memberPhone}" placeholder="010-1234-5678"/>
                                </div>
                            </div>
                            <div class="mb-3 col-md-6">
                                <label for="role" class="form-label">권한</label>
                                <input type="text" class="form-control" id="role" name="role" value="${loginMember.role}"
                                       readonly/>
                            </div>
                            <div class="mb-3 col-md-6">
                                <label for="createdAt" class="form-label">가입일</label>
                                <input type="text" class="form-control" id="createdAt" name="createdAt"
                                       value="${loginMember.createdAt}" readonly/>
                            </div>
                            <div class="mb-3 col-md-6">
                                <label for="businessNumber" class="form-label">사업자등록번호</label>
                                <input type="text" class="form-control" id="businessNumber" name="businessNumber"
                                       value="${loginMember.businessNumber}" readonly/>
                            </div>
                            <div class="mb-3 col-md-6">
                                <label for="status" class="form-label">계정상태</label>
                                <input type="text" class="form-control" id="status" name="status"
                                       value="${loginMember.status}" readonly/>
                            </div>

                        </div>
                        <div class="mt-2">
                            <button type="submit" class="btn btn-primary me-2">변경사항 저장</button>
                            <button type="reset" class="btn btn-outline-secondary">취소</button>
                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
    const roleMap = {
        ADMIN: "총관리자",
        MANAGER: "창고관리자",
        MEMBER: "일반회원"
    };

    const statusMap = {
        PENDING: "승인대기",
        REJECTED: "승인거절",
        ACTIVE: "활성",
        INACTIVE: "비활성"
    };

    document.addEventListener('DOMContentLoaded', function() {
        const roleInput = document.getElementById("role");
        const statusInput = document.getElementById("status");

        if (roleInput && roleMap[roleInput.value]) {
            roleInput.value = `\${roleMap[roleInput.value]}`;
        }

        if (statusInput && statusMap[statusInput.value]) {
            statusInput.value = `\${statusMap[statusInput.value]}`;
        }


        const form = document.getElementById('formAccountSettings');
        const submitBtn = form.querySelector('button[type="submit"]');
        const resetBtn = form.querySelector('button[type="reset"]');

        // 초기 값 저장
        const initialValues = {
            memberEmail: document.getElementById('memberEmail').value,
            memberPhone: document.getElementById('memberPhone').value
        };

        // 폼 제출 처리
        form.addEventListener('submit', async function(e) {
            e.preventDefault();

            const memberEmail = document.getElementById('memberEmail').value.trim();
            const memberPhone = document.getElementById('memberPhone').value.trim();

            // 유효성 검사
            if (!validateEmail(memberEmail)) {
                alert('올바른 이메일 형식을 입력해주세요.');
                return;
            }

            if (!validatePhone(memberPhone)) {
                alert('올바른 전화번호 형식을 입력해주세요. (예: 010-1234-5678)');
                return;
            }

            // 버튼 비활성화
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>저장 중...';

            try {
                // CSRF 토큰 가져오기
                const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
                const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content');

                const headers = {
                    'Content-Type': 'application/json'
                };

                // CSRF 토큰이 있으면 헤더에 추가
                if (csrfToken && csrfHeader) {
                    headers[csrfHeader] = csrfToken;
                }

                const response = await fetch('/member/update', {
                    method: 'POST',
                    headers: headers,
                    body: JSON.stringify({
                        memberEmail: memberEmail,
                        memberPhone: memberPhone
                    })
                });

                if (response.ok) {
                    showAlert('success', '회원 정보가 성공적으로 수정되었습니다.');
                    initialValues.memberEmail = memberEmail;
                    initialValues.memberPhone = memberPhone;
                } else {
                    showAlert('danger', data.message || '정보 수정에 실패했습니다.');
                }
            } catch (error) {
                console.error('Error:', error);
                showAlert('danger', '서버와의 통신 중 오류가 발생했습니다.');
            } finally {
                submitBtn.disabled = false;
                submitBtn.innerHTML = '변경사항 저장';
            }
        });

        // 취소 버튼 처리
        resetBtn.addEventListener('click', function(e) {
            e.preventDefault();
            document.getElementById('memberEmail').value = initialValues.memberEmail;
            document.getElementById('memberPhone').value = initialValues.memberPhone;
            showAlert('info', '변경사항이 취소되었습니다.');
        });

        function validateEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }

        function validatePhone(phone) {
            const phoneRegex = /^01[0-9]-\d{3,4}-\d{4}$/;
            return phoneRegex.test(phone);
        }

        function showAlert(type = 'info', message = 'message') {
            const existingAlert = document.querySelector('.alert-custom');
            if (existingAlert) {
                existingAlert.remove();
            }

            const alertDiv = document.createElement('div');
            alertDiv.className = `alert alert-\${type} alert-dismissible alert-custom`;
            alertDiv.role = 'alert';
            alertDiv.innerHTML = `<span>\${message}</span>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>`;

            form.insertAdjacentElement('beforebegin', alertDiv);

            setTimeout(() => {
                alertDiv.remove();
            }, 3000);
        }
    });
</script>
<%-- 푸터 include (필수!) --%>
<%@ include file="member-footer.jsp" %>