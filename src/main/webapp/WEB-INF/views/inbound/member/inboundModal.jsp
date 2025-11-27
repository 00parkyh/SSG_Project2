<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

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
                                <label class="form-label fw-bold">입고 창고</label>
                                <input type="text" id="warehouseName" class="form-control" readonly>
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
                            <div class="col-md-6" id="rejectReasonSection" style="display:none;">
                                <label class="form-label fw-bold text-danger">반려 사유</label>
                                <textarea id="inboundRejectReason" class="form-control" rows="2" readonly></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 상품 리스트 -->
                <div class="card">
                    <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                        <strong>입고 상품 내역</strong>
                        <button type="button" class="btn btn-sm btn-light" id="addInboundItemBtn">
                            <i class="bi bi-plus-circle"></i> 상품 추가
                        </button>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover table-bordered mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th>카테고리</th>
                                    <th>상품명</th>
                                    <th class="text-end">수량</th>
                                    <th>삭제</th>
                                </tr>
                                </thead>
                                <tbody id="inboundItemsBody">
                                <tr>
                                    <td colspan="4" class="text-center text-muted py-3">상품 정보를 불러오는 중...</td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="updateInboundBtn">
                    수정
                </button>
                <button type="button" class="btn btn-primary" id="cancelInboundBtn">
                    입고 취소
                </button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x-circle me-1"></i>닫기
                </button>
            </div>
        </div>
    </div>
</div>
