<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../admin/admin-header.jsp" %>
<div class="container-xxl flex-grow-1 container-p-y">
    <h4 class="fw-bold py-3 mb-4">
        <span class="text-muted fw-light">커뮤니티 / 공지사항 /</span> 수정
    </h4>

    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">공지사항 수정</h5>
        </div>
        <div class="card-body">
            <!-- 안내 메시지 -->
            <div class="alert alert-warning d-flex align-items-center mb-4" role="alert">
                <i class="bx bx-edit me-2 fs-5"></i>
                <div>공지사항을 수정합니다.</div>
            </div>

            <form method="post" action="/announcements/${announcement.announcementId}/edit">
                <input type="hidden" name="announcementId" value="${announcement.announcementId}"/>

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
                    <a href="/announcements/${announcement.announcementId}"
                       class="btn btn-outline-secondary">
                        <i class="bx bx-x me-1"></i> 취소
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="bx bx-save me-1"></i> 수정완료
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<%@ include file="../admin/admin-footer.jsp" %>

