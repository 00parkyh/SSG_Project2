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
        <span class="text-muted fw-light">커뮤니티 / 공지사항 /</span> 상세보기
    </h4>

    <div class="card">
        <!-- 제목 및 메타 정보 -->
        <div class="card-header">
            <div class="d-flex justify-content-between align-items-start">
                <div class="flex-grow-1">
                    <h5 class="mb-3">${announcement.title}</h5>
                    <div class="d-flex flex-wrap gap-3 text-muted small">
                        <span>
                            <i class="bx bx-user me-1"></i>
                            <strong>작성자:</strong> ${announcement.writer}
                        </span>
                        <span>
                            <i class="bx bx-calendar me-1"></i>
                            <strong>작성일:</strong> ${announcement.createdAt}
                        </span>
                        <span>
                            <i class="bx bx-edit me-1"></i>
                            <strong>수정일:</strong> ${announcement.updatedAt}
                        </span>
                        <c:if test="${announcement.important}">
                            <span>
                                <span class="badge bg-danger">
                                    <i class="bx bx-bell me-1"></i>중요 공지
                                </span>
                            </span>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- 본문 내용 -->
        <div class="card-body">
            <div class="announcement-content" style="min-height: 300px; line-height: 1.8;">
                ${announcement.content}
            </div>
        </div>

        <!-- 버튼 영역 -->
        <div class="card-footer">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <a href="/announcements" class="btn btn-outline-secondary">
                        <i class="bx bx-list-ul me-1"></i> 목록으로
                    </a>
                </div>

                <c:if test="${sessionScope.role == 'ADMIN' and sessionScope.loginId == announcement.writer}">
                    <div class="d-flex gap-2">
                        <a href="/announcements/${announcement.announcementId}/edit"
                           class="btn btn-primary">
                            <i class="bx bx-edit me-1"></i> 수정
                        </a>

                        <form method="post"
                              action="/announcements/${announcement.announcementId}/delete"
                              style="display: inline;"
                              onsubmit="return confirmDelete()">
                            <button type="submit" class="btn btn-danger">
                                <i class="bx bx-trash me-1"></i> 삭제
                            </button>
                        </form>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script>
    function confirmDelete() {
        return confirm('이 공지사항을 삭제하시겠습니까?');
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