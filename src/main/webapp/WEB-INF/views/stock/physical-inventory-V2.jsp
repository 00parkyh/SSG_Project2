<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<div class="card mt-4">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">실사 리스트</h5>
    </div>
    <div class="card-body">
        <p class="text-muted">* 실사 등록 1회는 하나의 실사 건으로 묶여 표시되며, 클릭하면 등록된 물품 상세 목록을 확인할 수 있습니다.</p>
        <div class="row g-3 mb-4">
            <div class="col-12 table-responsive">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>대표 실사 번호</th>
                        <th>실사 일자</th>
                        <th>실사 상태</th>
                        <th>창고명</th>
                        <th>섹션명</th>
                        <th>조정 여부</th>
                        <th>담당자</th>
                    </tr>
                    </thead>
                    <tbody id="pi-tbody">
                    <tr>
                        <td colspan="7" class="text-center">실사 정보를 불러오는 중입니다...</td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="card-footer">
        <div class="float-end">
            <ul class="pagination flex-wrap" id="pi-pagination-ul"></ul>
        </div>
    </div>
</div>
