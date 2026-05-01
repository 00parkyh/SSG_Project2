<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageActive" value="physical_inventory" scope="request"/>
<c:choose>
    <c:when test="${sessionScope.role == 'MANAGER'}">
        <jsp:include page="/WEB-INF/views/warehousemanager/manager-header.jsp" />
    </c:when>
    <c:otherwise>
        <jsp:include page="/WEB-INF/views/admin/admin-header.jsp" />
    </c:otherwise>
</c:choose>

<div class="container-xxl flex-grow-1 container-p-y">
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">실사 등록</h5>
        </div>
        <div class="card-body">
            <form id="physicalInventoryForm" onsubmit="return false">

                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">실사일자</label>
                        <input type="date" id="piDate" name="piDate" class="form-control" required>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">실사 상태</label>
                        <select id="piState" name="piState" class="form-select" required>
                            <option value="예정">예정</option>
                            <option value="진행중">시작</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">담당자</label>
                        <%-- 담당자 이름 표시 (읽기 전용) --%>
                        <input type="text"
                               id="managerNameDisplay"
                               class="form-control"
                               value="${not empty loginAdmin ? loginAdmin.staffName : '담당자 정보 없음'}"
                               readonly>

                        <%-- 실제 폼 전송을 위한 Hidden 필드 (Staff ID) --%>
                        <input type="hidden"
                               id="managerId"
                               name="managerId"
                               value="${not empty loginAdmin ? loginAdmin.staffId : ''}"
                               required></div>

                    <div class="row g-3 mt-3">
                        <div class="col-md-3">
                            <label class="form-label">창고 이름</label>
                            <select id="warehouseName" name="warehouseId" class="form-select">
                                <option value="">선택</option>
                                <c:forEach var="item" items="${warehouseList}">
                                    <option value="${item.id}">${item.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label">섹션 이름</label>
                            <select id="sectionName" name="sectionId" class="form-select">
                                <option value="">선택</option>
                                <c:forEach var="item" items="${sectionList}">
                                    <option value="${item.id}">${item.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-25" onclick="searchPhysicalInventoryList(1)">
                                등록
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="card2">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">실사 리스트</h5>
        </div>
        <div class="card-body">
            <p class="text-muted">* 실사는 섹션 별로 이루어지며, 실제 수량 입력 후 '조정'이 가능합니다.</p>
            <div class="row g-3 mb-4">
                <div class="col-12 table-responsive">

                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>실사 ID</th>
                            <th>실사 일자</th>
                            <th>상품 ID</th>
                            <th>실사 상태</th>
                            <th>전산 수량</th>
                            <th>실제 수량</th>
                            <th>차이 수량</th>
                            <th>창고 이름</th>
                            <th>실사 섹션 이름</th>
                            <th>조정 여부</th>
                        </tr>
                        </thead>
                        <tbody id="pi-tbody">

                        <tr>
                            <td colspan="11" class="text-center">실사 정보를 불러오는 중입니다...</td>
                        </tr>

                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="card-footer">
            <div class="float-end">
                <ul class="pagination flex-wrap" id="pi-pagination-ul">
                </ul>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="physicalInventoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">실사 ID: <span id="modalPiIdDisplay"></span></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="physicalInventoryUpdateForm" onsubmit="return false">
                    <input type="hidden" id="modalPiId" name="piId">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">상품 ID</label>
                            <input type="text" id="modalProductId" class="form-control" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">실사 일자</label>
                            <input type="text" id="modalPiDate" class="form-control" readonly>
                        </div>
                    </div>
                    <div class="row g-3 mt-3">
                        <div class="col-md-4">
                            <label class="form-label">창고 이름</label>
                            <input type="text" id="modalWarehouseName" class="form-control" readonly>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">섹션 이름</label>
                            <input type="text" id="modalSectionName" class="form-control" readonly>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">실사 상태</label>
                            <input type="text" id="modalPiState" class="form-control" readonly>
                        </div>
                    </div>
                    <div class="row g-3 mt-3">
                        <div class="col-md-4">
                            <label class="form-label">전산 수량 (스냅샷)</label>
                            <input type="number" id="modalCalculatedQuantity" class="form-control" readonly>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">실제 수량 (입력)</label>
                            <input type="number" id="modalRealQuantity" name="realQuantity" class="form-control" min="0"
                                   required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">조정 여부</label>
                            <select id="modalUpdateState" name="updateState" class="form-select" required>
                                <option value="조정 예정">조정 예정</option>
                                <option value="조정 중">조정 중</option>
                                <option value="조정 완료">조정 완료</option>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" onclick="updatePhysicalInventory()">수정 및 저장</button>
            </div>
        </div>
    </div>
</div>

<%-- FOOTER 포함 --%>
<c:choose>
    <c:when test="${sessionScope.role == 'MANAGER'}">
        <jsp:include page="/WEB-INF/views/warehousemanager/manager-footer.jsp" />
    </c:when>
    <c:otherwise>
        <jsp:include page="/WEB-INF/views/admin/admin-footer.jsp" />
    </c:otherwise>
</c:choose>

<script>
    let physicalInventoryDataList = [];

    function getPhysicalInventorySearchParams(page) {
        const warehouseId = document.querySelector('#warehouseName').value;
        const sectionId = document.querySelector('#sectionName').value;
        const params = {
            page: page || 1,
            size: 10,
            warehouseId: warehouseId,
            sectionId: sectionId
        };
        const urlParams = new URLSearchParams();
        Object.keys(params).forEach(key => {
            if (params[key] !== '') urlParams.append(key, params[key]);
        });
        return urlParams.toString();
    }

    function searchPhysicalInventoryList(_page) {
        document.getElementById('pi-tbody').innerHTML = '<tr><td colspan="10" class="text-center">실사 목록 검색 중...</td></tr>';
        const queryString = getPhysicalInventorySearchParams(_page);
        const apiUrl = '/physical-inventory/search?' + queryString; // 실제 목록 API 경로로 변경

        fetch(apiUrl)
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .then(responseDTO => {
                console.log("실사 목록 검색 성공, 데이터:", responseDTO);
                physicalInventoryDataList = responseDTO.dtoList;
                setTimeout(() => {
                    updatePhysicalInventoryTable(responseDTO.dtoList);
                    updatePagination(responseDTO);
                    console.log("지연 후 실사 목록 화면 갱신 완료");
                }, 100);
            })
            .catch(error => {
                console.error("AJAX 통신 실패:", error);
                document.getElementById('pi-tbody').innerHTML = '<tr><td colspan="10" class="text-center text-danger">실사 목록 조회 실패. 콘솔을 확인하세요.</td></tr>';
                document.getElementById('pi-pagination-ul').innerHTML = ''; // 페이지네이션 초기화
                alert("실사 목록 조회 요청 처리 실패. 콘솔을 확인하세요.");
            });
    }

    function updatePhysicalInventoryTable(piList) {
        const tbody = document.getElementById('pi-tbody');
        if (!tbody) {
            console.error("DOM Error: 'pi-tbody' 요소를 찾을 수 없습니다.");
            return;
        }
        let html = '';

        if (piList && piList.length > 0) {
            piList.forEach((pi, index) => {
                let differenceDisplay = '-';
                let realQuantityDisplay = pi.realQuantity || '-';

                if (pi.realQuantity !== null && pi.realQuantity !== undefined) {
                    const calculatedQuantity = pi.calculatedQuantity || 0;
                    const realQuantity = pi.realQuantity;

                    const rawDifference = calculatedQuantity - realQuantity;
                    differenceDisplay = rawDifference;
                }
                html += '<tr>';
                html += '<td><a href="javascript:void(0)" class="text-primary" onclick="openUpdateModal(' + index + ')">' + pi.piId + '</a></td>';
                html += '<td>' + pi.piDate + '</td>';
                html += '<td><a href="/stock/detail?productId=' + pi.productId + '" class="text-primary">' + pi.productId + '</a></td>';
                html += '<td>' + pi.piState + '</td>';
                html += '<td>' + (pi.calculatedQuantity || 0) + '</td>';
                html += '<td>' + realQuantityDisplay + '</td>';
                html += '<td>' + differenceDisplay + '</td>';
                html += '<td>' + pi.warehouseName + '</td>';
                html += '<td>' + pi.sectionName + '</td>';
                html += '<td>' + (pi.adjustmentStatus || '*') + '</td>';
                html += '</tr>';
            });
        } else {
            html = `<tr><td colspan="10" class="text-center">조회된 실사 정보가 없습니다.</td></tr>`;
        }

        tbody.innerHTML = html;
    }

    function updatePagination(responseDTO) {
        const paginationUl = document.getElementById('pi-pagination-ul');
        if (!paginationUl) {
            console.error("pi-pagination-ul 요소를 찾을 수 없습니다.");
            return;
        }

        const page = parseInt(responseDTO.page) || 1;
        const start = parseInt(responseDTO.start) || 1;
        const end = parseInt(responseDTO.end) || 1;
        const total = parseInt(responseDTO.total) || 0;

        const prev = responseDTO.prev;
        const next = responseDTO.next;

        if (total === 0 || isNaN(page)) {
            paginationUl.innerHTML = '';
            return;
        }
        let html = '';

        if (prev) {
            const prevPage = start - 1;
            html += '<li class="page-item prev">';
            html += '<a class="page-link" onclick="searchPhysicalInventoryList(' + prevPage + ')">';
            html += '<i class="tf-icon bx bx-chevrons-left"></i>';
            html += '</a>';
            html += '</li>';
        }

        for (let i = Number(start); i <= Number(end); i++) {
            const activeClass = (i === page) ? ' active' : '';
            html += '<li class="page-item' + activeClass + '">';
            html += '<a class="page-link" onclick="searchPhysicalInventoryList(' + i + ')">' + i + '</a>';
            html += '</li>';
        }

        if (next) {
            const nextPage = end + 1;
            html += '<li class="page-item next">';
            html += '<a class="page-link" onclick="searchPhysicalInventoryList(' + nextPage + ')">';
            html += '<i class="tf-icon bx bx-chevrons-right"></i>';
            html += '</a>';
            html += '</li>';
        }

        paginationUl.innerHTML = html;
    }

    function registerPhysicalInventory() {
        const form = document.getElementById('physicalInventoryForm');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }
        const piDateElement = document.getElementById('piDate');
        const piStateElement = document.getElementById('piState');
        const managerIdElement = document.getElementById('managerId'); // 👈 Hidden 필드의 ID
        const warehouseElement = document.getElementById('warehouseName');
        const sectionElement = document.getElementById('sectionName');

        if (!piDateElement || !piStateElement || !managerIdElement || !warehouseElement || !sectionElement) {
            console.error(" 등록 폼 요소 누락: registerPhysicalInventory 함수가 HTML 요소를 찾지 못했습니다.");
            alert("등록에 필요한 일부 폼 요소(ID)를 찾을 수 없습니다. 콘솔을 확인하세요.");
            return;
        }

        const formData = {
            piDate: piDateElement.value,
            piState: piStateElement.value,
            managerId: managerIdElement.value,
            warehouseId: warehouseElement.value,
            sectionId: sectionElement.value
        };

        console.log("실사 등록 요청 데이터:", formData);
        // AJAX 요청
        fetch('/physical-inventory/register', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData)
        })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(errorData => {
                        throw new Error(errorData.message || '등록 처리 중 알 수 없는 오류 발생');
                    });
                }
                return response.json();
            })
            .then(response => {
                alert(response.message + " (" + response.count + "건 처리됨)");
                searchPhysicalInventoryList(1);
            })
            .catch(error => {
                console.error("실사 등록 실패:", error);
                alert("실사 등록 실패: " + error.message);
            });
    }

    function openUpdateModal(index) {
        const pi = physicalInventoryDataList[index];

        if (!pi) {
            console.error("선택된 실사 데이터가 없습니다. Index:", index);
            alert("선택된 실사 데이터를 불러올 수 없습니다.");
            return;
        }
        document.getElementById('modalPiIdDisplay').textContent = pi.piId;
        document.getElementById('modalPiId').value = pi.piId;
        document.getElementById('modalProductId').value = pi.productId;
        document.getElementById('modalPiDate').value = pi.piDate;
        document.getElementById('modalWarehouseName').value = pi.warehouseName;
        document.getElementById('modalSectionName').value = pi.sectionName;
        document.getElementById('modalPiState').value = pi.piState;
        document.getElementById('modalCalculatedQuantity').value = pi.calculatedQuantity || 0;

        document.getElementById('modalRealQuantity').value = pi.realQuantity || '';

        const updateStateSelect = document.getElementById('modalUpdateState');
        const currentStatus = pi.adjustmentStatus === '*' ? '조정 예정' : pi.adjustmentStatus || '조정 예정';

        let statusFound = false;
        for (let i = 0; i < updateStateSelect.options.length; i++) {
            if (updateStateSelect.options[i].value === currentStatus) {
                updateStateSelect.selectedIndex = i;
                statusFound = true;
                break;
            }
        }
        if (!statusFound) {
            updateStateSelect.value = '조정 예정';
        }
        const modalElement = document.getElementById('physicalInventoryModal');
        const modal = new bootstrap.Modal(modalElement);
        modal.show();
    }
    function updatePhysicalInventory() {
        const form = document.getElementById('physicalInventoryUpdateForm');
        const piId = document.getElementById('modalPiId').value;
        const realQuantity = document.getElementById('modalRealQuantity').value;
        const updateState = document.getElementById('modalUpdateState').value;

        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const updateData = {
            piId: parseInt(piId),
            realQuantity: parseInt(realQuantity),
            updateState: updateState
        };

        console.log("실사 수정 요청 데이터:", updateData);

        fetch('/physical-inventory/update', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(updateData)
        })
            .then(response => {
                const modalElement = document.getElementById('physicalInventoryModal');
                const modal = bootstrap.Modal.getInstance(modalElement);
                if (modal) {
                    modal.hide();
                }

                if (!response.ok) {
                    return response.json().then(errorData => {
                        throw new Error(errorData.message || '실사 수정 처리 중 알 수 없는 오류 발생');
                    });
                }
                return response.json();
            })
            .then(response => {
                alert(response.message);
                searchPhysicalInventoryList(1);
            })
            .catch(error => {
                console.error("실사 수정 실패:", error);
                alert("실사 수정 실패: " + error.message);
            });
    }

    document.addEventListener('DOMContentLoaded', function () {
        console.log("페이지 로드 완료 이벤트 발생, 초기 실사 목록 검색 시작.");

        // 재고 실사 등록 버튼의 onclick을 등록 함수로 변경합니다.
        const registerButton = document.querySelector('#physicalInventoryForm button[type="submit"]');
        if (registerButton) {
            registerButton.onclick = registerPhysicalInventory;
        }

        searchPhysicalInventoryList(1);

        const piDateInput = document.getElementById('piDate');
        if (piDateInput) {
            piDateInput.valueAsDate = new Date();
        }
    });
</script>
