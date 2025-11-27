<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 같은 admin 폴더 내에 있으므로 경로 없이 바로 include --%>
<%@ include file="admin-header.jsp" %>

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
                    <div class="row">
                        <div class="mb-3 col-md-6">
                            <label for="staffName" class="form-label">이름</label>
                            <input class="form-control" type="text" id="staffName" name="staffName"
                                   value="${loginAdmin.staffName}" readonly/>
                        </div>
                        <div class="mb-3 col-md-6">
                            <label for="staffLoginId" class="form-label">아이디</label>
                            <input class="form-control" type="text" name="staffLoginId" id="staffLoginId"
                                   value="${loginAdmin.staffLoginId}" readonly/>
                        </div>
                        <div class="mb-3 col-md-6">
                            <label for="staffEmail" class="form-label">이메일</label>
                            <input class="form-control" type="text" id="staffEmail" name="staffEmail"
                                   value="${loginAdmin.staffEmail}" readonly/>
                        </div>
                        <div class="mb-3 col-md-6">
                            <label class="form-label" for="staffPhone">전화번호</label>
                            <div class="input-group input-group-merge">
                                <span class="input-group-text">KR (+82)</span>
                                <input type="text" id="staffPhone" name="staffPhone" class="form-control"
                                       value="${loginAdmin.staffPhone}" readonly/>
                            </div>
                        </div>
                        <div class="mb-3 col-md-6">
                            <label for="role" class="form-label">권한</label>
                            <input type="text" class="form-control" id="role" name="role" value="${loginAdmin.role}"
                                   readonly/>
                        </div>
                        <div class="mb-3 col-md-6">
                            <label for="createdAt" class="form-label">가입일</label>
                            <input type="text" class="form-control" id="createdAt" name="createdAt"
                                   value="${loginAdmin.createdAt}" readonly/>
                        </div>
                        <div class="mb-3 col-md-6">
                            <label for="status" class="form-label">계정상태</label>
                            <input type="text" class="form-control" id="status" name="status"
                                   value="${loginAdmin.status}" readonly/>
                        </div>
                    </div>
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

    window.addEventListener("DOMContentLoaded", () => {
        const roleInput = document.getElementById("role");
        const statusInput = document.getElementById("status");

        if (roleInput && roleMap[roleInput.value]) {
            roleInput.value = `\${roleMap[roleInput.value]}`;
        }

        if (statusInput && statusMap[statusInput.value]) {
            statusInput.value = `\${statusMap[statusInput.value]}`;
        }
    });
</script>

<%-- 푸터 include (필수!) --%>
<%@ include file="admin-footer.jsp" %>