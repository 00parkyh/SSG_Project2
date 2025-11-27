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
        <span class="text-muted fw-light">관리 /</span> 거래처 관리
    </h4>
    <p class="text-muted mb-4">거래처 정보 및 계약 현황을 확인하세요</p>

    <div class="row">
        <!-- 사이드바 -->
        <div class="col-lg-4 col-md-5 mb-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">거래처 목록</h5>
                </div>
                <div class="card-body">
                    <!-- 검색 박스 -->
                    <div class="mb-3">
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bx bx-search"></i>
                            </span>
                            <input type="text"
                                   class="form-control"
                                   placeholder="거래처명 또는 사업자번호 검색..."
                                   onkeyup="filterPartners(this.value)">
                        </div>
                    </div>

                    <!-- 거래처 리스트 -->
                    <div id="partnerList" style="max-height: 600px; overflow-y: auto;">
                        <c:forEach items="${partners}" var="partner">
                            <div class="card mb-2 partner-card"
                                 style="cursor: pointer; transition: all 0.2s;"
                                 data-partner-id="${partner.partnerId}"
                                 data-partner-name="${partner.partnerName}"
                                 data-business-number="${partner.businessNumber}"
                                 onclick="loadPartnerDetail(${partner.partnerId})"
                                 onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 8px rgba(0,0,0,0.1)'"
                                 onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow=''">
                                <div class="card-body p-3">
                                    <h6 class="mb-2">${partner.partnerName}</h6>
                                    <div class="d-flex align-items-center text-muted small mb-1">
                                        <i class="bx bx-file me-1"></i>
                                        <span>${partner.businessNumber}</span>
                                    </div>
                                    <div class="d-flex align-items-center text-muted small">
                                        <i class="bx bx-map me-1"></i>
                                        <span>
                                            <c:choose>
                                                <c:when test="${not empty partner.address}">
                                                    ${partner.address}
                                                </c:when>
                                                <c:otherwise>
                                                    주소 미등록
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <c:if test="${empty partners}">
                            <div class="text-center py-5 text-muted">
                                <i class="bx bx-package display-4 mb-3"></i>
                                <div>등록된 거래처가 없습니다</div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- 메인 컨텐츠 -->
        <div class="col-lg-8 col-md-7">
            <div id="mainContent">
                <div class="card">
                    <div class="card-body text-center py-5">
                        <i class="bx bx-pointer display-1 text-muted mb-3"></i>
                        <h5 class="text-muted">거래처를 선택해주세요</h5>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .partner-card.active {
        border: 2px solid #696cff !important;
        background-color: #f8f9ff !important;
    }
</style>

<script>
    let currentPartnerId = null;

    // 거래처 필터링
    function filterPartners(searchText) {
        const cards = document.querySelectorAll('.partner-card');
        const search = searchText.toLowerCase().trim();

        cards.forEach(card => {
            const name = card.dataset.partnerName.toLowerCase();
            const businessNumber = card.dataset.businessNumber.toLowerCase();

            if (name.includes(search) || businessNumber.includes(search)) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    }

    // 거래처 상세 정보 로드
    function loadPartnerDetail(partnerId) {
        if (currentPartnerId === partnerId) return;
        currentPartnerId = partnerId;

        // 활성화 상태 변경
        document.querySelectorAll('.partner-card').forEach(card => {
            card.classList.remove('active');
            if (parseInt(card.dataset.partnerId) === partnerId) {
                card.classList.add('active');
            }
        });

        // 로딩 표시
        document.getElementById('mainContent').innerHTML = `
            <div class="card">
                <div class="card-body text-center py-5">
                    <div class="spinner-border text-primary mb-3" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <div>데이터를 불러오는 중...</div>
                </div>
            </div>
        `;

        // AJAX 요청
        fetch('/partner/detail/' + partnerId)
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(data => {
                displayPartnerDetail(data);
            })
            .catch(error => {
                console.error('Error:', error);
                document.getElementById('mainContent').innerHTML = `
                        <div class="card">
                        <div class="card-body text-center py-5">
                            <i class="bx bx-error-circle display-1 text-danger mb-3"></i>
                            <h5 class="text-danger">데이터를 불러오는데 실패했습니다</h5>
                        </div>
                    </div>
                    `;
            });
    }

    // 거래처 상세 정보 표시
    function displayPartnerDetail(data) {
        const partner = data.partner;
        const fees = data.fees || [];
        const contracts = data.contracts || [];

        if (!partner) {
            document.getElementById('mainContent').innerHTML = `
                    <div class="card">
                    <div class="card-body text-center py-5">
                        <i class="bx bx-error-circle display-1 text-danger mb-3"></i>
                        <h5 class="text-danger">거래처 정보를 찾을 수 없습니다</h5>
                    </div>
                </div>
                `;
            return;
        }

        let html = '';

        // 헤더
        html += '<div class="card mb-4">';
        html += '<div class="card-header">';
        html += '<h5 class="mb-1">' + escapeHtml(partner.partnerName) + '</h5>';
        html += '<span class="text-muted">사업자번호: ' + escapeHtml(partner.businessNumber) + '</span>';
        html += '</div>';
        html += '</div>';

        // 기본 정보 섹션
        html += '<div class="card mb-4">';
        html += '<div class="card-header">';
        html += '<h5 class="mb-0"><i class="bx bx-info-circle me-2"></i>기본 정보</h5>';
        html += '</div>';
        html += '<div class="card-body">';
        html += '<div class="row g-3">';

        html += '<div class="col-md-6">';
        html += '<div class="border rounded p-3">';
        html += '<div class="text-muted small mb-1">거래처 ID</div>';
        html += '<div class="fw-bold">' + partner.partnerId + '</div>';
        html += '</div>';
        html += '</div>';

        html += '<div class="col-md-6">';
        html += '<div class="border rounded p-3">';
        html += '<div class="text-muted small mb-1">거래처명</div>';
        html += '<div class="fw-bold">' + escapeHtml(partner.partnerName) + '</div>';
        html += '</div>';
        html += '</div>';

        html += '<div class="col-md-6">';
        html += '<div class="border rounded p-3">';
        html += '<div class="text-muted small mb-1">사업자번호</div>';
        html += '<div class="fw-bold">' + escapeHtml(partner.businessNumber) + '</div>';
        html += '</div>';
        html += '</div>';

        html += '<div class="col-md-6">';
        html += '<div class="border rounded p-3">';
        html += '<div class="text-muted small mb-1">주소</div>';
        html += '<div class="fw-bold">' + (partner.address ? escapeHtml(partner.address) : '-') + '</div>';
        html += '</div>';
        html += '</div>';

        html += '<div class="col-md-6">';
        html += '<div class="border rounded p-3">';
        html += '<div class="text-muted small mb-1">등록일시</div>';
        html += '<div class="fw-bold">' + formatDateTime(partner.createdAt) + '</div>';
        html += '</div>';
        html += '</div>';

        html += '<div class="col-md-6">';
        html += '<div class="border rounded p-3">';
        html += '<div class="text-muted small mb-1">수정일시</div>';
        html += '<div class="fw-bold">' + formatDateTime(partner.updatedAt) + '</div>';
        html += '</div>';
        html += '</div>';

        html += '</div>';
        html += '</div>';
        html += '</div>';

        // 요금 정책 섹션
        html += '<div class="card mb-4">';
        html += '<div class="card-header">';
        html += '<h5 class="mb-0"><i class="bx bx-dollar-circle me-2"></i>요금 정책</h5>';
        html += '</div>';
        html += '<div class="card-body">';

        if (fees.length > 0) {
            html += '<div class="table-responsive">';
            html += '<table class="table table-hover">';
            html += '<thead><tr>';
            html += '<th>요금 ID</th>';
            html += '<th>요금 유형</th>';
            html += '<th>가격</th>';
            html += '<th>적용일</th>';
            html += '</tr></thead>';
            html += '<tbody>';

            fees.forEach(fee => {
                html += '<tr>';
                html += '<td>' + fee.feeId + '</td>';
                html += '<td>' + escapeHtml(fee.feeType) + '</td>';
                html += '<td>' + (fee.price ? formatNumber(fee.price) + '원' : '-') + '</td>';
                html += '<td>' + formatDateTime(fee.applyDate) + '</td>';
                html += '</tr>';
            });

            html += '</tbody></table>';
            html += '</div>';
        } else {
            html += '<div class="text-center py-4 text-muted">';
            html += '<i class="bx bx-dollar display-4 mb-3"></i>';
            html += '<div>등록된 요금 정책이 없습니다</div>';
            html += '</div>';
        }

        html += '</div>';
        html += '</div>';

        // 계약 정보 섹션
        html += '<div class="card">';
        html += '<div class="card-header">';
        html += '<h5 class="mb-0"><i class="bx bx-file me-2"></i>계약 정보</h5>';
        html += '</div>';
        html += '<div class="card-body">';

        if (contracts.length > 0) {
            html += '<div class="table-responsive">';
            html += '<table class="table table-hover">';
            html += '<thead><tr>';
            html += '<th>계약 ID</th>';
            html += '<th>계약 시작일</th>';
            html += '<th>계약 면적</th>';
            html += '<th>상태</th>';
            html += '</tr></thead>';
            html += '<tbody>';

            contracts.forEach(contract => {
                html += '<tr>';
                html += '<td>' + contract.contractId + '</td>';
                html += '<td>' + formatDate(contract.contractStart) + '</td>';
                html += '<td>' + (contract.contractArea ? formatNumber(contract.contractArea) + ' ㎡' : '-') + '</td>';
                html += '<td>' + getStatusBadge(contract.status) + '</td>';
                html += '</tr>';
            });

            html += '</tbody></table>';
            html += '</div>';
        } else {
            html += '<div class="text-center py-4 text-muted">';
            html += '<i class="bx bx-file-blank display-4 mb-3"></i>';
            html += '<div>등록된 계약 정보가 없습니다</div>';
            html += '</div>';
        }

        html += '</div>';
        html += '</div>';

        document.getElementById('mainContent').innerHTML = html;
    }

    // 상태 배지 생성
    function getStatusBadge(status) {
        if (!status) return '<span class="badge badge-inactive" style="color: #697a8d;">미정</span>';

        const statusUpper = status.toUpperCase();

        if (statusUpper === 'ACTIVE') {
            return '<span class="badge bg-success">활성</span>';
        } else if (statusUpper === 'PENDING') {
            return '<span class="badge bg-warning">대기</span>';
        } else if (statusUpper === 'COMPLETED') {
            return '<span class="badge bg-info">완료</span>';
        } else {
            return '<span class="badge bg-secondary">' + escapeHtml(status) + '</span>';
        }
    }

    // 날짜/시간 포맷
    function formatDateTime(dateTime) {
        if (!dateTime) return '-';

        // 배열 형식인 경우 (예: [2025, 11, 11, 17, 28, 26])
        if (Array.isArray(dateTime)) {
            const year = dateTime[0];
            const month = String(dateTime[1]).padStart(2, '0');
            const day = String(dateTime[2]).padStart(2, '0');
            const hours = String(dateTime[3] || 0).padStart(2, '0');
            const minutes = String(dateTime[4] || 0).padStart(2, '0');
            const seconds = String(dateTime[5] || 0).padStart(2, '0');

            return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
        }

        const date = new Date(dateTime);
        if (isNaN(date.getTime())) return '-';

        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');

        return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes;
    }

    // 날짜 포맷
    function formatDate(date) {
        if (!date) return '-';

        // 배열 형식인 경우 (예: [2025, 11, 11])
        if (Array.isArray(date)) {
            const year = date[0];
            const month = String(date[1]).padStart(2, '0');
            const day = String(date[2]).padStart(2, '0');

            return year + '-' + month + '-' + day;
        }

        // 이미 문자열 형태로 날짜가 오면 그대로 반환
        if (typeof date === 'string') {
            return date;
        }

        const d = new Date(date);
        if (isNaN(d.getTime())) return '-';

        const year = d.getFullYear();
        const month = String(d.getMonth() + 1).padStart(2, '0');
        const day = String(d.getDate()).padStart(2, '0');

        return year + '-' + month + '-' + day;
    }

    // 숫자 포맷 (천단위 구분)
    function formatNumber(num) {
        if (!num && num !== 0) return '-';
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    }

    // XSS 방지
    function escapeHtml(text) {
        if (!text) return '';

        const map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };

        return text.toString().replace(/[&<>"']/g, m => map[m]);
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


