<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<html
        lang="ko"
        class="light-style"
        dir="ltr"
        data-theme="theme-default"
        data-assets-path="<c:url value='/resources/assets/'/>"
        data-template="vertical-menu-template-free"
>
<head>
    <meta charset="utf-8"/>
    <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0"
    />

    <title>WMS 로그인</title>
    <meta name="description" content="WMS 로그인"/>

    <link rel="icon" type="image/x-icon" href="<c:url value='/resources/assets/img/favicon/favicon.ico'/>"/>

    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link
            href="https://fonts.googleapis.com/css2?family=Public+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap"
            rel="stylesheet"
    />

    <link rel="stylesheet" href="<c:url value='/resources/assets/vendor/fonts/boxicons.css'/>"/>

    <link rel="stylesheet" href="<c:url value='/resources/assets/vendor/css/core.css'/>"
          class="template-customizer-core-css"/>
    <link rel="stylesheet" href="<c:url value='/resources/assets/vendor/css/theme-default.css'/>"
          class="template-customizer-theme-css"/>
    <link rel="stylesheet" href="<c:url value='/resources/assets/css/demo.css'/>"/>

    <link rel="stylesheet"
          href="<c:url value='/resources/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.css'/>"/>

    <%-- 'page-auth.css'를 사용하지 않아 "사각형 배경" 제거 --%>

    <script src="<c:url value='/resources/assets/vendor/js/helpers.js'/>"></script>
    <script src="<c:url value='/resources/assets/js/config.js'/>"></script>

    <style>
        /* [수정] 페이지 전체를 사용하도록 변경 */
        body {
            background-color: #f5f5f9; /* 템플릿 배경색 */
        }

        .content-wrapper {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding-top: 4rem;
            padding-bottom: 4rem;
        }

        /* [수정] 호버 시 '확대' 효과 */
        .card-link {
            text-decoration: none;
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
            display: block;
            height: 100%;
        }

        .card-link:hover {
            transform: scale(1.03); /* [수정] 줌 효과 */
            box-shadow: 0 0.5rem 1.5rem rgba(0, 0, 0, 0.15) !important;
        }
    </style>
</head>

<body>
<div class="container-xxl">
    <div class="content-wrapper">
        <div class="container-p-y">

            <div class="app-brand justify-content-center mb-5">
                <a href="${pageContext.request.contextPath}/" class="app-brand-link gap-2">
                    <span class="app-brand-text demo text-body fw-bolder text-uppercase" style="font-size: 2rem;">RACL WMS</span>
                </a>
            </div>

            <h2 class="mb-5 text-center fw-bold">어떤 권한으로 로그인하시겠습니까?</h2>

            <div class="row">
                <div class="col-lg-4 col-md-12 mb-4">
                    <a href="${pageContext.request.contextPath}/admin/login" class="card-link">
                        <div class="card h-100">
                            <div class="card-body text-center p-5">
                                <i class="bx bx-user-circle fs-1 text-danger mb-4"></i>
                                <h5 class="card-title text-danger fs-4 fw-bold">총 관리자</h5>
                                <p class="card-text fs-6 mt-3 text-nowrap">
                                    재무 및 시스템 관리
                                </p>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="col-lg-4 col-md-12 mb-4">
                    <a href="${pageContext.request.contextPath}/warehousemanager/login" class="card-link">
                        <div class="card h-100">
                            <div class="card-body text-center p-5">
                                <i class="bx bx-buildings fs-1 text-success mb-4"></i>
                                <h5 class="card-title text-success fs-4 fw-bold">창고 관리자</h5>
                                <p class="card-text fs-6 mt-3 text-nowrap">
                                    창고 입출고/재고 관리
                                </p>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="col-lg-4 col-md-12 mb-4">
                    <a href="${pageContext.request.contextPath}/member/login" class="card-link">
                        <div class="card h-100">
                            <div class="card-body text-center p-5">
                                <i class="bx bx-package fs-1 text-info mb-4"></i>
                                <h5 class="card-title text-info fs-4 fw-bold">고객사 회원</h5>
                                <p class="card-text fs-6 mt-3 text-nowrap">
                                    입출고 요청 및 재고 조회
                                </p>
                            </div>
                        </div>
                    </a>
                </div>
            </div>

        </div>
    </div>
</div>
<script src="<c:url value='/resources/assets/vendor/libs/jquery/jquery.js'/>"></script>
<script src="<c:url value='/resources/assets/vendor/libs/popper/popper.js'/>"></script>
<script src="<c:url value='/resources/assets/vendor/js/bootstrap.js'/>"></script>
<script src="<c:url value='/resources/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js'/>"></script>
<script src="<cm:url value='/resources/assets/vendor/js/menu.js'/>"></script>
<script src="<c:url value='/resources/assets/js/main.js'/>"></script>
</body>
</html>