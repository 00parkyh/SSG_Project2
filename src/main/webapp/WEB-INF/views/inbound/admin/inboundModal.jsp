<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<!-- 입고 상세 모달 -->
<div class="modal fade" id="inboundModal" tabindex="-1" aria-labelledby="inboundModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header bg-light">
                <h5 class="modal-title fw-bold" id="inboundModalLabel">
                    <i class="bi bi-box-seam me-2"></i>입고 상세 정보
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body">
                <!-- 입고 기본 정보 -->
                <div class="card mb-3">
                    <div class="card-header bg-primary text-white"><strong>기본 정보</strong></div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label class="form-label fw-bold">입고 번호</label>
                                <input type="text" id="inboundId" name="inboundId" class="form-control" readonly>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold">입고 상태</label>
                                <input type="text" id="inboundStatus" class="form-control" readonly>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold">입고 창고 <span class="text-danger">*</span></label>
                                <select id="warehouseId" name="warehouseId" class="form-select">
                                    <option value="">창고를 선택하세요</option>
                                    <c:forEach var="warehouse" items="${warehouseList}">
                                        <option value="${warehouse.warehouseId}">${warehouse.warehouseName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">거래처명</label>
                                <input type="text" id="partnerName" class="form-control" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">요청자</label>
                                <input type="text" id="memberName" class="form-control" readonly>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">입고 요청일</label>
                                <input type="text" id="inboundRequestedAt" class="form-control" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">실제 입고일</label>
                                <input type="text" id="inboundAt" class="form-control" readonly>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">입고 승인자</label>
                                <input type="text" id="staffName" class="form-control" readonly>
                            </div>
                            <div class="col-md-6" id="rejectReasonSection">
                                <label class="form-label fw-bold text-danger">반려 사유</label>
                                <textarea id="inboundRejectReason" class="form-control" rows="2" placeholder="반려시 사유를 작성해주세요."></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 상품 리스트 -->
                <div class="card">
                    <div class="card-header bg-success text-white"><strong>입고 상품 내역</strong></div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover table-bordered mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th width="10%">상품 ID</th>
                                    <th width="20%">카테고리</th>
                                    <th width="40%">상품명</th>
                                    <th width="15%" class="text-end">수량</th>
                                </tr>
                                </thead>
                                <tbody id="inboundItemsBody">
                                <tr>
                                    <td colspan="4" class="text-center text-muted py-4">
                                        상품 정보를 불러오는 중...
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 모달 푸터 : 승인/반려 버튼 추가 -->
            <div class="modal-footer">
                <form id="approveForm" action="<%=contextPath%>/inbound/admin/approve" method="post" class="d-inline">
                    <input type="hidden" id="approveInboundId" name="inboundId">
                    <input type="hidden" id="approveWarehouseId" name="warehouseId">
                    <button type="button" class="btn btn-primary" onclick="submitApprove()">
                        <i class="bi bi-check-circle me-1"></i>승인
                    </button>
                </form>

                <form id="rejectForm" action="<%=contextPath%>/inbound/admin/reject" method="post" class="d-inline">
                    <!-- hidden input으로 실제 전송 -->
                    <input type="hidden" id="rejectInboundId" name="inboundId">
                    <input type="hidden" id="rejectReasonInput" name="reason">

                    <button type="button" class="btn btn-danger" onclick="submitReject()">
                        <i class="bi bi-x-circle me-1"></i>반려
                    </button>
                </form>

                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x-circle me-1"></i>닫기
                </button>
            </div>
        </div>
    </div>
</div>
