<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<%-- [수정 1] JSTL을 사용하기 위해 이 코드를 파일 맨 위에 추가합니다. --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Footer -->
<footer class="content-footer footer bg-footer-theme">
    <div class="container-xxl d-flex flex-wrap justify-content-between py-2 flex-md-row flex-column">
        <div class="mb-2 mb-md-0">
            ©RACL
            대표자: 엄현석 | 사업자번호: 000-00-00000
            이메일: heathcliff4736@example.com
            전화번호: 070-1111-0000 | 주소: 서울 강남구 삼성로 000-0 6층
        </div>

    </div>
</footer>
<!-- / Footer -->

<div class="content-backdrop fade"></div>
</div>
<!-- Content wrapper -->
</div>
<!-- / Layout page -->
</div>

<!-- Overlay -->
<div class="layout-overlay layout-menu-toggle"></div>
</div>
<!-- / Layout wrapper -->

<!-- Core JS -->
<!-- build:js assets/vendor/js/core.js -->
<script src="${pageContext.request.contextPath}/resources/assets/vendor/libs/jquery/jquery.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/vendor/libs/popper/popper.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/vendor/js/bootstrap.js"></script>
<script src="${pageContext.request.contextPath}/resources/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>

<script src="${pageContext.request.contextPath}/resources/assets/vendor/js/menu.js"></script>
<!-- endbuild -->

<!-- Vendors JS -->
<script src="${pageContext.request.contextPath}/resources/assets/vendor/libs/apex-charts/apexcharts.js"></script>

<!-- Main JS -->
<script src="${pageContext.request.contextPath}/resources/assets/js/main.js"></script>

<!-- Page JS -->
<%-- [수정 2] 이 스크립트 태그를 c:if로 감싸줍니다. --%>
<c:if test="${empty disablePageSpecificScript}">
    <script src="${pageContext.request.contextPath}/resources/assets/js/dashboards-analytics.js"></script>
</c:if>

<!-- Place this tag in your head or just before your close body tag. -->
<script async defer src="https://buttons.github.io/buttons.js"></script>

</body>
</html>