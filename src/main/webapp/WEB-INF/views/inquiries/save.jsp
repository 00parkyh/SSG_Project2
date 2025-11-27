<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<div class="container-xxl flex-grow-1 container-p-y">
    <h4 class="fw-bold py-3 mb-4">
        <span class="text-muted fw-light">커뮤니티 / 문의사항 /</span> 작성
    </h4>

    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">문의사항 작성</h5>
        </div>
        <div class="card-body">
            <!-- 안내 메시지 -->
            <div class="alert alert-info d-flex align-items-center mb-4" role="alert">
                <i class="bx bx-info-circle me-2 fs-5"></i>
                <div>문의사항을 작성해주세요. 모든 사용자가 볼 수 있습니다.</div>
            </div>

            <form method="post" action="/inquiries/save">
                <!-- 작성자 -->
                <div class="mb-3">
                    <label class="form-label" for="writer">
                        <strong>작성자</strong>
                    </label>
                    <input type="text"
                           class="form-control"
                           id="writer"
                           name="writer"
                           value="${sessionScope.loginId}"
                           readonly/>
                </div>

                <!-- 제목 -->
                <div class="mb-3">
                    <label class="form-label" for="title">
                        제목 <span class="text-danger">*</span>
                    </label>
                    <input type="text"
                           class="form-control ${not empty errors.title ? 'is-invalid' : ''}"
                           id="title"
                           name="title"
                           value="${inquiry.title}"
                           placeholder="제목을 입력하세요"
                           required/>
                    <c:if test="${not empty errors.title}">
                        <div class="invalid-feedback">
                                ${errors.title}
                        </div>
                    </c:if>
                </div>

                <!-- 내용 -->
                <div class="mb-3">
                    <label class="form-label" for="content">
                        내용 <span class="text-danger">*</span>
                    </label>
                    <textarea class="form-control ${not empty errors.content ? 'is-invalid' : ''}"
                              id="content"
                              name="content"
                              rows="10"
                              placeholder="내용을 입력하세요"
                              required>${inquiry.content}</textarea>
                    <c:if test="${not empty errors.content}">
                        <div class="invalid-feedback">
                                ${errors.content}
                        </div>
                    </c:if>
                </div>

                <!-- 비밀번호 -->
                <div class="mb-4">
                    <label class="form-label" for="password">
                        비밀번호 <span class="text-danger">*</span>
                    </label>
                    <input type="password"
                           class="form-control ${not empty errors.password ? 'is-invalid' : ''}"
                           id="password"
                           name="password"
                           placeholder="비밀번호를 입력하세요"
                           required/>
                    <c:if test="${not empty errors.password}">
                        <div class="invalid-feedback">
                                ${errors.password}
                        </div>
                    </c:if>
                    <div class="form-text">
                        <i class="bx bx-lock me-1"></i>
                        비밀번호는 문의글 수정 및 삭제 시 사용됩니다.
                    </div>
                </div>

                <!-- 버튼 -->
                <div class="d-flex justify-content-between">
                    <a href="/inquiries" class="btn btn-outline-secondary">
                        <i class="bx bx-x me-1"></i> 취소
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="bx bx-check me-1"></i> 등록
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

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
