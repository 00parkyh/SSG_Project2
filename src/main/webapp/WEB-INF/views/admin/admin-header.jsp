<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html
        lang="ko"
        class="light-style layout-menu-fixed"
        dir="ltr"
        data-theme="theme-default"
        data-assets-path="${pageContext.request.contextPath}/resources/assets/"
        data-template="vertical-menu-template-free"
>
<head>
    <meta charset="utf-8"/>
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0"/>

    <title>RACL WMS | SSG Project</title>

    <meta name="description" content=""/>

    <link rel="icon" type="image/x-icon"
          href="${pageContext.request.contextPath}/resources/assets/img/favicon/favicon.ico"/>

    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap"
          rel="stylesheet"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/vendor/fonts/boxicons.css"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/vendor/css/core.css"
          class="template-customizer-core-css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/vendor/css/theme-default.css"
          class="template-customizer-theme-css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/demo.css"/>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/resources/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/apexcharts@3.41.0/dist/apexcharts.min.css">

    <script src="${pageContext.request.contextPath}/resources/assets/vendor/js/helpers.js"></script>
    <script src="${pageContext.request.contextPath}/resources/assets/js/config.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/apexcharts@3.41.0/dist/apexcharts.min.js"></script>
</head>

<body>
<div class="layout-wrapper layout-content-navbar">
    <div class="layout-container">
        <aside id="layout-menu" class="layout-menu menu-vertical menu bg-menu-theme">
            <div class="app-brand demo">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="app-brand-link">
                    <span class="app-brand-logo demo">
                        <svg width="25" viewBox="0 0 25 42" version="1.1" xmlns="http://www.w3.org/2000/svg"
                             xmlns:xlink="http://www.w3.org/1999/xlink">
                            <defs>
                                <path d="M13.7918663,0.358365126 L3.39788168,7.44174259 C0.566865006,9.69408886 -0.379795268,12.4788597 0.557900856,15.7960551 C0.68998853,16.2305145 1.09562888,17.7872135 3.12357076,19.2293357 C3.8146334,19.7207684 5.32369333,20.3834223 7.65075054,21.2172976 L7.59773219,21.2525164 L2.63468769,24.5493413 C0.445452254,26.3002124 0.0884951797,28.5083815 1.56381646,31.1738486 C2.83770406,32.8170431 5.20850219,33.2640127 7.09180128,32.5391577 C8.347334,32.0559211 11.4559176,30.0011079 16.4175519,26.3747182 C18.0338572,24.4997857 18.6973423,22.4544883 18.4080071,20.2388261 C17.963753,17.5346866 16.1776345,15.5799961 13.0496516,14.3747546 L10.9194936,13.4715819 L18.6192054,7.984237 L13.7918663,0.358365126 Z"
                                      id="path-1"></path>
                                <path d="M5.47320593,6.00457225 C4.05321814,8.216144 4.36334763,10.0722806 6.40359441,11.5729822 C8.61520715,12.571656 10.0999176,13.2171421 10.8577257,13.5094407 L15.5088241,14.433041 L18.6192054,7.984237 C15.5364148,3.11535317 13.9273018,0.573395879 13.7918663,0.358365126 C13.5790555,0.511491653 10.8061687,2.3935607 5.47320593,6.00457225 Z"
                                      id="path-3"></path>

                                <path d="M7.50063644,21.2294429 L12.3234468,23.3159332 C 14.1688022,24.7579751 14.397098,26.4880487 13.008334,28.506154 C 11.6195701,30.5242593 10.3099883,31.790241 9.07958868,32.3040991 C 5.78142938,33.4346997 4.13234973,34 4.13234973,34 2.75489982,33.0538207 2.37032616e-14,31.1614621 C -0.55822714,27.8186216 -0.55822714,26.0572515 -4.05231404e-15,25.8773518 C 0.83734071,25.6075023 2.77988457,22.8248993 3.3049379,22.52991 C 3.65497346,22.3332504 5.05353963,21.8997614 7.50063644,21.2294429 Z"
                                      id="path-4"></path>
                                <path d="M20.6,7.13333333 L25.6,13.8 C26.2627417,14.6836556 26.0836556,15.9372583 25.2,16.6 C24.8538077,16.8596443 24.4327404,17 24,17 L14,17 C12.8954305,17 12,16.1045695 12,15 C12,14.5672596 12.1403557,14.1461923 12.4,13.8 L17.4,7.13333333 C18.0627417,6.24967773 19.3163444,6.07059163 20.2,6.73333333 C20.3516113,6.84704183 20.4862915,6.981722 20.6,7.13333333 Z"
                                      id="path-5"></path>
                            </defs>
                            <g id="g-app-brand" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                <g id="Brand-Logo" transform="translate(-27.000000, -15.000000)">
                                    <g id="Icon" transform="translate(27.000000, 15.000000)">
                                        <g id="Mask" transform="translate(0.000000, 8.000000)">
                                            <mask id="mask-2" fill="white">
                                                <use xlink:href="#path-1"></use>
                                            </mask>
                                            <use fill="#696cff" xlink:href="#path-1"></use>
                                            <g id="Path-3" mask="url(#mask-2)">
                                                <use fill="#696cff" xlink:href="#path-3"></use>
                                                <use fill-opacity="0.2" fill="#FFFFFF" xlink:href="#path-3"></use>
                                            </g>
                                            <g id="Path-4" mask="url(#mask-2)">
                                                <use fill="#696cff" xlink:href="#path-4"></use>
                                                <use fill-opacity="0.2" fill="#FFFFFF" xlink:href="#path-4"></use>
                                            </g>
                                        </g>
                                        <g id="Triangle"
                                           transform="translate(19.000000, 11.000000) rotate(-300.000000) translate(-19.000000, -11.000000) ">
                                            <use fill="#696cff" xlink:href="#path-5"></use>
                                            <use fill-opacity="0.2" fill="#FFFFFF" xlink:href="#path-5"></use>
                                        </g>
                                    </g>
                                </g>
                            </g>
                        </svg>
                    </span>
                    <span class="app-brand-text demo menu-text fw-bolder ms-2">RACL</span>
                </a>
                <a href="javascript:void(0);" class="layout-menu-toggle menu-link text-large ms-auto d-block d-xl-none">
                    <i class="bx bx-chevron-left bx-sm align-middle"></i>
                </a>
            </div>

            <%-- menu --%>
            <div class="menu-inner-shadow"></div>

            <ul class="menu-inner py-1">

                <li class="menu-item ${pageActive == 'dashboard' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-link">
                        <i class="menu-icon tf-icons bx bx-home-circle"></i>
                        <div data-i18n="Analytics">Dashboard</div>
                    </a>
                </li>

                <li class="menu-item">
                    <a href="https://github.com/SSG-2nd-2team/WMS" target="_blank" class="menu-link">
                        <i class="menu-icon tf-icons bx bx-file"></i>
                        <div data-i18n="Documentation">Documentation</div>
                    </a>
                </li>

                <li class="menu-header small text-uppercase">
                    <span class="menu-header-text">Admin Menu</span>
                </li>

                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/members" class="menu-link">
                        <i class="menu-icon tf-icons bx bx-user-check"></i>
                        <div data-i18n="MemberApproval">고객 관리</div>
                    </a>
                </li>

                <li class="menu-item">
                    <a href="javascript:void(0);" class="menu-link menu-toggle">
                        <i class="menu-icon tf-icons bx bx-down-arrow-circle"></i>
                        <div data-i18n="Inbound">입고 관리</div>
                    </a>
                    <ul class="menu-sub">
                        <li class="menu-item">
                            <a href="${pageContext.request.contextPath}/inbound/admin/list" class="menu-link">
                                <div data-i18n="InboundList">입고 요청 조회/승인</div>
                            </a>
                        </li>
                    </ul>
                </li>

                <li class="menu-item">
                    <a href="javascript:void(0);" class="menu-link menu-toggle">
                        <i class="menu-icon tf-icons bx bx-up-arrow-circle"></i>
                        <div data-i18n="Outbound">출고 관리</div>
                    </a>
                    <ul class="menu-sub">
                        <li class="menu-item">
                            <a href="${pageContext.request.contextPath}/admin/outbound" class="menu-link">
                                <div data-i18n="Outbound List">출고지시서 조회/승인</div>
                            </a>
                        </li>
                    </ul>
                </li>

                <li class="menu-item ${(pageActive == 'stock_list' || pageActive == 'physical_inventory' || pageActive == 'stock_product_list') ? 'active open' : ''}">
                    <a href="javascript:void(0);" class="menu-link menu-toggle">
                        <i class="menu-icon tf-icons bx bx-package"></i>
                        <div data-i18n="Stock">재고 관리</div>
                    </a>
                    <ul class="menu-sub">
                        <li class="menu-item ${pageActive == 'stock_list' ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/stock/list" class="menu-link">
                                <div data-i18n="Stock List">재고 조회</div>
                            </a>
                        </li>
                        <li class="menu-item ${pageActive == 'physical_inventory' ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/physical-inventory" class="menu-link">
                                <div data-i18n="Stock Inspection">재고 실사</div>
                            </a>
                        </li>
                        <li class="menu-item ${pageActive == 'stock_product_list' ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/productList/plist" class="menu-link">
                                <div data-i18n="Product Status">품목 현황</div>
                            </a>
                        </li>
                    </ul>
                </li>

                <li class="menu-item ${(pageActive == 'expense' || pageActive == 'sales') ? 'active open' : ''}">
                    <a href="javascript:void(0);" class="menu-link menu-toggle">
                        <i class="menu-icon tf-icons bx bx-wallet"></i>
                        <div data-i18n="Finance">재무 관리</div>
                    </a>
                    <ul class="menu-sub">
                        <li class="menu-item ${pageActive == 'sales' ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/admin/sales/list" class="menu-link">
                                <div data-i18n="Sales">매출 관리</div>
                            </a>
                        </li>
                        <li class="menu-item ${pageActive == 'expense' ? 'active' : ''}">
                            <a href="${pageContext.request.contextPath}/admin/expense/list" class="menu-link">
                                <div data-i18n="Expense">지출 관리</div>
                            </a>
                        </li>
                    </ul>
                </li>

                <li class="menu-item">
                    <a href="javascript:void(0);" class="menu-link menu-toggle">
                        <i class="menu-icon tf-icons bx bx-buildings"></i>
                        <div data-i18n="Warehouse">창고 관리</div>
                    </a>
                    <ul class="menu-sub">
                        <li class="menu-item">
                            <a href="${pageContext.request.contextPath}/admin/warehouses/register" class="menu-link">
                                <div data-i18n="WarehouseRegister">창고 등록</div>
                            </a>
                        </li>
                        <li class="menu-item">
                            <a href="${pageContext.request.contextPath}/admin/warehouses" class="menu-link">
                                <div data-i18n="WarehouseList">창고 목록 조회/수정</div>
                            </a>
                        </li>
                        <li class="menu-item">
                            <a href="#" class="menu-link">
                                <div data-i18n="WarehouseLocation">창고 위치 조회</div>
                            </a>
                        </li>
                    </ul>
                </li>

                <li class="menu-item">
                    <a href="javascript:void(0);" class="menu-link menu-toggle">
                        <i class="menu-icon tf-icons bx bx-store-alt"></i>
                        <div data-i18n="Client">거래처 관리</div>
                    </a>
                    <ul class="menu-sub">
                        <li class="menu-item">
                            <a href="${pageContext.request.contextPath}/partner" class="menu-link">
                                <div data-i18n="ClientList">거래처 조회</div>
                            </a>
                        </li>
                    </ul>
                </li>

                <li class="menu-header small text-uppercase">
                    <span class="menu-header-text">Community</span>
                </li>

                <li class="menu-item">
                    <a href="javascript:void(0);" class="menu-link menu-toggle">
                        <i class="menu-icon tf-icons bx bx-support"></i>
                        <div data-i18n="Support">고객센터</div>
                    </a>
                    <ul class="menu-sub">
                        <li class="menu-item">
                            <a href="${pageContext.request.contextPath}/announcements" class="menu-link">
                                <div data-i18n="Notice">공지사항</div>
                            </a>
                        </li>
                        <li class="menu-item">
                            <a href="${pageContext.request.contextPath}/inquiries" class="menu-link">
                                <div data-i18n="QnA">문의사항</div>
                            </a>
                        </li>
                    </ul>
                </li>

            </ul>
        </aside>
        <div class="layout-page">
            <nav class="layout-navbar container-xxl navbar navbar-expand-xl navbar-detached align-items-center bg-navbar-theme"
                 id="layout-navbar">
                <div class="layout-menu-toggle navbar-nav align-items-xl-center me-3 me-xl-0 d-xl-none">
                    <a class="nav-item nav-link px-0 me-xl-4" href="javascript:void(0)">
                        <i class="bx bx-menu bx-sm"></i>
                    </a>
                </div>

                <div class="navbar-nav-right d-flex align-items-center" id="navbar-collapse">
                    <div class="navbar-nav align-items-center">
                        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">RACL WMS</a>

                    </div>
                    <ul class="navbar-nav flex-row align-items-center ms-auto">
                        <li class="nav-item navbar-dropdown dropdown-user dropdown">
                            <a class="nav-link dropdown-toggle hide-arrow" href="javascript:void(0);"
                               data-bs-toggle="dropdown">
                                <div class="avatar avatar-online">
                                    <img src="${pageContext.request.contextPath}/resources/assets/img/avatars/1.png" alt
                                         class="w-px-40 h-auto rounded-circle"/>
                                </div>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li>
                                    <a class="dropdown-item" href="#">
                                        <div class="d-flex">
                                            <div class="flex-shrink-0 me-3">
                                                <div class="avatar avatar-online">
                                                    <img src="${pageContext.request.contextPath}/resources/assets/img/avatars/1.png"
                                                         alt class="w-px-40 h-auto rounded-circle"/>
                                                </div>
                                            </div>
                                            <div class="flex-grow-1">
                                                <span class="fw-semibold d-block">${loginId != null ? loginId : 'Admin'}</span>
                                                <small class="text-muted">관리자</small>
                                            </div>
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <div class="dropdown-divider"></div>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/mypage">
                                        <i class="bx bx-user me-2"></i>
                                        <span class="align-middle">My Page</span>
                                    </a>
                                </li>
                                <li>
                                    <div class="dropdown-divider"></div>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/logout">
                                        <i class="bx bx-power-off me-2"></i>
                                        <span class="align-middle">Log Out</span>
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </nav>
            <div class="content-wrapper">