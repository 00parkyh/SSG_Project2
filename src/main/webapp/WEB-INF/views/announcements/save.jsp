<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../admin/admin-header.jsp" %>
<div class="container-xxl flex-grow-1 container-p-y">
    <h4 class="fw-bold py-3 mb-4">
        <span class="text-muted fw-light">커뮤니티 / 공지사항 /</span> 작성
    </h4>

    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">공지사항 작성</h5>
        </div>
        <div class="card-body">
            <!-- 안내 메시지 -->
            <div class="alert alert-info d-flex align-items-center mb-4" role="alert">
                <i class="bx bx-info-circle me-2 fs-5"></i>
                <div>공지사항을 작성해주세요. 모든 사용자가 볼 수 있습니다.</div>
            </div>

            <form method="post" action="/announcements/save">
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
                           value="${announcement.title}"
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
                              required>${announcement.content}</textarea>
                    <c:if test="${not empty errors.content}">
                        <div class="invalid-feedback">
                                ${errors.content}
                        </div>
                    </c:if>
                </div>

                <!-- 중요 공지 체크박스 -->
                <div class="mb-4">
                    <div class="form-check form-switch">
                        <input class="form-check-input"
                               type="checkbox"
                               id="important"
                               name="important"
                               value="true"
                        ${announcement.important ? 'checked' : ''}/>
                        <label class="form-check-label" for="important">
                            <i class="bx bx-bell text-danger me-1"></i>
                            <strong>중요 공지로 설정</strong>
                        </label>
                    </div>
                </div>

                <!-- 버튼 -->
                <div class="d-flex justify-content-between">
                    <a href="/announcements" class="btn btn-outline-secondary">
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

<%@ include file="../admin/admin-footer.jsp" %>
