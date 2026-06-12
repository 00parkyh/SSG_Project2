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
                        <label class="form-label">실사 일자</label>
                        <input type="date" id="piDate" name="piDate" class="form-control" required>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">실사 상태</label>
                        <select id="piState" name="piState" class="form-select" required>
                            <option value="예정">예정</option>
                            <option value="진행중">진행중</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">담당자</label>
                        <input type="text"
                               id="staffNameDisplay"
                               class="form-control"
                               value="${not empty currentStaffName ? currentStaffName : '담당자 정보 없음'}"
                               readonly>
                        <input type="hidden"
                               id="staffId"
                               name="staffId"
                               value="${not empty currentStaffId ? currentStaffId : ''}"
                               required>
                    </div>
                </div>

                <div class="row g-3 mt-3">
                    <div class="col-md-3">
                        <label class="form-label">창고 이름</label>
                        <select id="warehouseName" name="warehouseId" class="form-select" required>
                            <option value="">선택</option>
                            <c:forEach var="item" items="${warehouseList}">
                                <option value="${item.id}">${item.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">섹션 이름</label>
                        <select id="sectionName" name="sectionId" class="form-select" disabled required>
                            <option value="">선택</option>
                            <c:forEach var="item" items="${sectionList}">
                                <option value="${item.id}">${item.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-6 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-25">등록</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/stock/physical-inventory-V2.jsp" />
</div>

<div class="modal fade" id="physicalInventoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">실사 상세 목록</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="modalInventoryBatchId">

                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">대표 실사 번호</label>
                        <input type="text" id="modalPiIdDisplay" class="form-control" readonly>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">실사 일자</label>
                        <input type="text" id="modalPiDate" class="form-control" readonly>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">창고명</label>
                        <input type="text" id="modalWarehouseName" class="form-control" readonly>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">섹션명</label>
                        <input type="text" id="modalSectionName" class="form-control" readonly>
                    </div>
                </div>

                <div class="row g-3 mt-2">
                    <div class="col-md-4">
                        <label class="form-label">실사 상태</label>
                        <select id="modalPiState" class="form-select">
                            <option value="예정">예정</option>
                            <option value="진행중">진행중</option>
                            <option value="완료">완료</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">담당자</label>
                        <input type="text" id="modalStaffName" class="form-control" readonly>
                    </div>
                </div>

                <div class="table-responsive mt-4">
                    <table class="table table-hover align-middle">
                        <thead>
                        <tr>
                            <th>상품 ID</th>
                            <th>계산 수량</th>
                            <th>실제 수량</th>
                            <th>차이 수량</th>
                            <th>조정 여부</th>
                        </tr>
                        </thead>
                        <tbody id="modalPiDetailTbody">
                        <tr>
                            <td colspan="5" class="text-center">실사 상세 정보를 불러오는 중입니다...</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" onclick="updatePhysicalInventoryBatch()">저장</button>
            </div>
        </div>
    </div>
</div>

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
    let physicalInventoryDetailList = [];
    const currentStaffName = "${not empty currentStaffName ? currentStaffName : ''}";
    const adjustmentStatuses = [
        <c:forEach var="status" items="${adjustmentStatuses}" varStatus="loop">
        { value: "${status.dbValue}", label: "${status.label}" }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];
    const defaultAdjustmentStatus = "${defaultAdjustmentStatus}";

    function initializeAdjustmentStatusOptions() {
        const updateStateCells = document.querySelectorAll('.modal-update-state');
        updateStateCells.forEach(function (select) {
            select.innerHTML = '';
            adjustmentStatuses.forEach(function (status) {
                const option = document.createElement('option');
                option.value = status.value;
                option.textContent = status.label;
                select.appendChild(option);
            });
        });
    }

    function getLocalDateString() {
        const today = new Date();
        const year = today.getFullYear();
        const month = String(today.getMonth() + 1).padStart(2, '0');
        const day = String(today.getDate()).padStart(2, '0');
        return year + '-' + month + '-' + day;
    }

    function resetSectionOptions(placeholder) {
        const sectionSelect = document.getElementById('sectionName');
        sectionSelect.innerHTML = '<option value="">' + placeholder + '</option>';
        sectionSelect.disabled = true;
    }

    function populateSectionOptions(sectionList) {
        const sectionSelect = document.getElementById('sectionName');
        sectionSelect.innerHTML = '<option value="">선택</option>';

        sectionList.forEach(function (item) {
            const option = document.createElement('option');
            option.value = item.id;
            option.textContent = item.name;
            sectionSelect.appendChild(option);
        });

        sectionSelect.disabled = false;
    }

    function loadSectionsByWarehouse(warehouseId) {
        if (!warehouseId) {
            resetSectionOptions('창고를 먼저 선택해주세요');
            return Promise.resolve();
        }

        resetSectionOptions('섹션 정보를 불러오는 중입니다...');

        return fetch('/stock/sections?warehouseId=' + encodeURIComponent(warehouseId))
            .then(function (response) {
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }

                return response.json();
            })
            .then(function (sectionList) {
                if (!sectionList || sectionList.length === 0) {
                    resetSectionOptions('선택 가능한 섹션이 없습니다');
                    return;
                }

                populateSectionOptions(sectionList);
            })
            .catch(function (error) {
                console.error('섹션 목록 조회 실패:', error);
                resetSectionOptions('섹션 목록 조회 실패');
            });
    }

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

        Object.keys(params).forEach(function (key) {
            if (params[key] !== '') {
                urlParams.append(key, params[key]);
            }
        });

        return urlParams.toString();
    }

    function searchPhysicalInventoryList(page) {
        document.getElementById('pi-tbody').innerHTML =
            '<tr><td colspan="7" class="text-center">실사 목록 검색 중...</td></tr>';

        fetch('/physical-inventory/search?' + getPhysicalInventorySearchParams(page))
            .then(function (response) {
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(function (responseDTO) {
                physicalInventoryDataList = responseDTO.dtoList || [];
                updatePhysicalInventoryTable(physicalInventoryDataList);
                updatePagination(responseDTO);
            })
            .catch(function (error) {
                console.error('실사 목록 조회 실패:', error);
                document.getElementById('pi-tbody').innerHTML =
                    '<tr><td colspan="7" class="text-center text-danger">실사 목록 조회 실패. 콘솔을 확인하세요.</td></tr>';
                document.getElementById('pi-pagination-ul').innerHTML = '';
            });
    }

    function updatePhysicalInventoryTable(piList) {
        const tbody = document.getElementById('pi-tbody');
        let html = '';

        if (piList && piList.length > 0) {
            piList.forEach(function (pi, index) {
                const adjustmentStatus = pi.adjustmentStatus && pi.adjustmentStatus !== '*'
                    ? pi.adjustmentStatus
                    : defaultAdjustmentStatus;

                html += '<tr style="cursor:pointer;" onclick="openBatchDetailModal(' + index + ')">';
                html += '<td>' + pi.piId + '</td>';
                html += '<td>' + pi.piDate + '</td>';
                html += '<td>' + pi.piState + '</td>';
                html += '<td>' + pi.warehouseName + '</td>';
                html += '<td>' + pi.sectionName + '</td>';
                html += '<td>' + adjustmentStatus + '</td>';
                html += '<td>' + (currentStaffName || '-') + '</td>';
                html += '</tr>';
            });
        } else {
            html = '<tr><td colspan="7" class="text-center">조회된 실사 정보가 없습니다.</td></tr>';
        }

        tbody.innerHTML = html;
    }

    function updatePagination(responseDTO) {
        const paginationUl = document.getElementById('pi-pagination-ul');
        const page = parseInt(responseDTO.page, 10) || 1;
        const start = parseInt(responseDTO.start, 10) || 1;
        const end = parseInt(responseDTO.end, 10) || 1;
        const total = parseInt(responseDTO.total, 10) || 0;

        if (total === 0 || isNaN(page)) {
            paginationUl.innerHTML = '';
            return;
        }

        let html = '';

        if (responseDTO.prev) {
            html += '<li class="page-item prev">';
            html += '<a class="page-link" onclick="searchPhysicalInventoryList(' + (start - 1) + ')">';
            html += '<i class="tf-icon bx bx-chevrons-left"></i>';
            html += '</a>';
            html += '</li>';
        }

        for (let i = start; i <= end; i++) {
            const activeClass = i === page ? ' active' : '';
            html += '<li class="page-item' + activeClass + '">';
            html += '<a class="page-link" onclick="searchPhysicalInventoryList(' + i + ')">' + i + '</a>';
            html += '</li>';
        }

        if (responseDTO.next) {
            html += '<li class="page-item next">';
            html += '<a class="page-link" onclick="searchPhysicalInventoryList(' + (end + 1) + ')">';
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

        const formData = {
            piDate: document.getElementById('piDate').value,
            piState: document.getElementById('piState').value,
            staffId: document.getElementById('staffId').value,
            warehouseId: document.getElementById('warehouseName').value,
            sectionId: document.getElementById('sectionName').value
        };

        fetch('/physical-inventory/register', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData)
        })
            .then(function (response) {
                if (!response.ok) {
                    return response.json().then(function (errorData) {
                        throw new Error(errorData.message || '등록 처리 중 오류가 발생했습니다.');
                    });
                }
                return response.json();
            })
            .then(function (response) {
                alert(response.message + ' (' + response.count + '건 처리)');
                searchPhysicalInventoryList(1);
            })
            .catch(function (error) {
                console.error('실사 등록 실패:', error);
                alert('실사 등록 실패: ' + error.message);
            });
    }

    function createAdjustmentSelect(selectedValue, rowIndex) {
        const select = document.createElement('select');
        select.className = 'form-select form-select-sm modal-update-state';
        select.dataset.rowIndex = String(rowIndex);

        adjustmentStatuses.forEach(function (status) {
            const option = document.createElement('option');
            option.value = status.value;
            option.textContent = status.label;
            if (status.value === selectedValue) {
                option.selected = true;
            }
            select.appendChild(option);
        });

        return select;
    }

    function updateDetailEditingState(piState) {
        const isCompleted = piState === '완료';
        document.querySelectorAll('.modal-real-quantity').forEach(function (input) {
            input.disabled = !isCompleted;
        });
        document.querySelectorAll('.modal-update-state').forEach(function (select) {
            select.disabled = !isCompleted;
        });
    }

    function renderBatchDetailRows(detailList) {
        const tbody = document.getElementById('modalPiDetailTbody');
        let html = '';

        if (!detailList || detailList.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="text-center">등록된 상세 품목이 없습니다.</td></tr>';
            return;
        }

        detailList.forEach(function (item, index) {
            const difference = item.realQuantity === null || item.realQuantity === undefined
                ? '-'
                : item.realQuantity - item.calculatedQuantity;
            html += '<tr>';
            html += '<td>' + item.productId + '</td>';
            html += '<td>' + item.calculatedQuantity + '</td>';
            html += '<td><input type="number" class="form-control form-control-sm modal-real-quantity" min="0" data-row-index="' + index + '" value="' + (item.realQuantity ?? '') + '"></td>';
            html += '<td>' + difference + '</td>';
            html += '<td id="adjustment-cell-' + index + '"></td>';
            html += '</tr>';
        });

        tbody.innerHTML = html;

        detailList.forEach(function (item, index) {
            const cell = document.getElementById('adjustment-cell-' + index);
            const currentStatus = item.adjustmentStatus && item.adjustmentStatus !== '*'
                ? item.adjustmentStatus
                : defaultAdjustmentStatus;
            cell.appendChild(createAdjustmentSelect(currentStatus, index));
        });

        updateDetailEditingState(document.getElementById('modalPiState').value);
    }

    function openBatchDetailModal(index) {
        const pi = physicalInventoryDataList[index];
        if (!pi) {
            alert('선택한 실사 데이터를 찾을 수 없습니다.');
            return;
        }

        document.getElementById('modalInventoryBatchId').value = pi.inventoryBatchId;
        document.getElementById('modalPiIdDisplay').value = pi.piId;
        document.getElementById('modalPiDate').value = pi.piDate;
        document.getElementById('modalWarehouseName').value = pi.warehouseName;
        document.getElementById('modalSectionName').value = pi.sectionName;
        document.getElementById('modalPiState').value = pi.piState;
        document.getElementById('modalStaffName').value = currentStaffName || '-';
        document.getElementById('modalPiDetailTbody').innerHTML =
            '<tr><td colspan="5" class="text-center">실사 상세 정보를 불러오는 중입니다...</td></tr>';

        fetch('/physical-inventory/detail?inventoryBatchId=' + encodeURIComponent(pi.inventoryBatchId))
            .then(function (response) {
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(function (detailList) {
                physicalInventoryDetailList = detailList || [];
                renderBatchDetailRows(physicalInventoryDetailList);
                updateDetailEditingState(document.getElementById('modalPiState').value);
                const modal = new bootstrap.Modal(document.getElementById('physicalInventoryModal'));
                modal.show();
            })
            .catch(function (error) {
                console.error('실사 상세 조회 실패:', error);
                alert('실사 상세 조회 실패: ' + error.message);
            });
    }

    function updatePhysicalInventoryBatch() {
        const piState = document.getElementById('modalPiState').value;
        const updateData = {
            inventoryBatchId: document.getElementById('modalInventoryBatchId').value,
            piState: piState,
            items: physicalInventoryDetailList.map(function (item, index) {
                const realQuantityInput = document.querySelector('.modal-real-quantity[data-row-index="' + index + '"]');
                const updateStateSelect = document.querySelector('.modal-update-state[data-row-index="' + index + '"]');
                return {
                    piId: item.piId,
                    realQuantity: piState === '완료' ? parseInt(realQuantityInput.value, 10) : null,
                    updateState: piState === '완료' ? updateStateSelect.value : null
                };
            })
        };

        if (piState === '완료') {
            const invalidItem = updateData.items.find(function (item) {
                return Number.isNaN(item.realQuantity) || item.updateState === null || item.updateState === '';
            });
            if (invalidItem) {
                alert('완료 상태에서는 모든 품목의 실제 수량과 조정 여부를 입력해야 합니다.');
                return;
            }
        }

        fetch('/physical-inventory/update-batch', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(updateData)
        })
            .then(function (response) {
                if (!response.ok) {
                    return response.json().then(function (errorData) {
                        throw new Error(errorData.message || '실사 상세 저장 중 오류가 발생했습니다.');
                    });
                }
                return response.json();
            })
            .then(function (response) {
                alert(response.message);
                const modalElement = document.getElementById('physicalInventoryModal');
                const modal = bootstrap.Modal.getInstance(modalElement);
                if (modal) {
                    modal.hide();
                }
                searchPhysicalInventoryList(1);
            })
            .catch(function (error) {
                console.error('실사 상세 저장 실패:', error);
                alert('실사 상세 저장 실패: ' + error.message);
            });
    }

    document.addEventListener('DOMContentLoaded', function () {
        initializeAdjustmentStatusOptions();

        const warehouseSelect = document.getElementById('warehouseName');
        warehouseSelect.addEventListener('change', function () {
            loadSectionsByWarehouse(this.value);
        });

        const modalPiStateSelect = document.getElementById('modalPiState');
        modalPiStateSelect.addEventListener('change', function () {
            updateDetailEditingState(this.value);
        });

        const registerButton = document.querySelector('#physicalInventoryForm button[type="submit"]');
        if (registerButton) {
            registerButton.onclick = registerPhysicalInventory;
        }

        document.getElementById('piDate').value = getLocalDateString();
        searchPhysicalInventoryList(1);
    });
</script>
