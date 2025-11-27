<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    <h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">커뮤니티 /</span> 공지사항</h4>

    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">공지사항 목록</h5>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <a href="/announcements/save" class="btn btn-primary">
                    <i class="bx bx-plus me-1"></i> 글쓰기
                </a>
            </c:if>
        </div>
        <div class="card-body">
            <!-- 검색 영역 -->
            <form action="/announcements" method="get" class="mb-4">
                <div class="row g-3 mb-4">
                    <div class="col-md-10">
                        <label class="form-label">검색어</label>
                        <input type="text" name="keyword" class="form-control"
                               placeholder="제목, 작성자 등" value="${keyword}"/>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bx bx-search me-1"></i> 검색
                        </button>
                    </div>
                </div>
            </form>

            <!-- 테이블 -->
            <div class="table-responsive text-nowrap">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th style="width: 8%;">중요</th>
                        <th style="width: 10%;">번호</th>
                        <th style="width: 47%;">제목</th>
                        <th style="width: 15%;">작성자</th>
                        <th style="width: 20%;">작성일</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty announcements}">
                            <tr>
                                <td colspan="5" class="text-center py-5 text-muted">
                                    등록된 공지사항이 없습니다.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:set var="listSize" value="${announcements.size()}" />
                            <c:forEach var="announcement" items="${announcements}" varStatus="status">
                                <tr>
                                    <td class="text-center">
                                        <c:if test="${announcement.important}">
                                            <span class="badge bg-danger">중요</span>
                                        </c:if>
                                    </td>
                                    <td class="text-center">${listSize - status.index}</td>
                                    <td>
                                        <a href="/announcements/${announcement.announcementId}"
                                           class="text-dark text-decoration-none">
                                                ${announcement.title}
                                        </a>
                                    </td>
                                    <td>${announcement.writer}</td>
                                    <td>${announcement.createdAt}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- 페이지네이션 -->
            <c:if test="${not empty announcements}">
                <div class="d-flex justify-content-center mt-4">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <!-- 처음 페이지 -->
                            <li class="page-item first ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=1&keyword=${keyword}">
                                    <i class="tf-icon bx bx-chevrons-left"></i>
                                </a>
                            </li>
                            <!-- 이전 페이지 -->
                            <li class="page-item prev ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}&keyword=${keyword}">
                                    <i class="tf-icon bx bx-chevron-left"></i>
                                </a>
                            </li>

                            <!-- 페이지 번호 -->
                            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&keyword=${keyword}">
                                            ${i}
                                    </a>
                                </li>
                            </c:forEach>

                            <!-- 다음 페이지 -->
                            <li class="page-item next ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}&keyword=${keyword}">
                                    <i class="tf-icon bx bx-chevron-right"></i>
                                </a>
                            </li>
                            <!-- 마지막 페이지 -->
                            <li class="page-item last ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${totalPages}&keyword=${keyword}">
                                    <i class="tf-icon bx bx-chevrons-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </c:if>
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