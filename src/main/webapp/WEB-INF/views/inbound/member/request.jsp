<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String contextPath = request.getContextPath(); %>
<%@ include file="../../member/member-header.jsp" %>

<div class="container mt-5">
    <h3>입고 요청</h3>

    <form id="inboundRequestForm" method="post" action="/inbound/member/request">
        <input type="hidden" name="memberId" value="${memberId}"/>

        <h5>입고 품목</h5>
        <table class="table table-bordered" id="inboundItemsTable">
            <thead>
            <tr>
                <th>카테고리</th>
                <th>상품명</th>
                <th>수량</th>
                <th>삭제</th>
            </tr>
            </thead>
            <tbody>
            <!-- 첫 번째 행은 서버에서 렌더링하여 깜빡임 방지 -->
            <tr class="inboundItemRow">
                <td>
                    <select name="inboundRequestItems[0].categoryCd" class="form-select categorySelect" required>
                        <option value="" disabled selected>카테고리</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.categoryCd}">${category.categoryName}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>
                    <select name="inboundRequestItems[0].productId" class="form-select productSelect" required>
                        <option value="" disabled selected>상품 선택</option>
                    </select>
                </td>
                <td>
                    <input type="number" name="inboundRequestItems[0].quantity" class="form-control quantityInput" min="1" value="1" required>
                </td>
                <td>
                    <button type="button" class="btn btn-danger btn-sm removeItemBtn">삭제</button>
                </td>
            </tr>
            </tbody>
        </table>

        <button type="button" id="addItemBtn" class="btn btn-secondary btn-sm mb-3">품목 추가</button>
        <br/>
        <button type="submit" class="btn btn-primary">입고 요청</button>
    </form>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // AJAX 요청 추적용 (경쟁 상태 방지)
    let ajaxRequests = {};

    // 카테고리 옵션 템플릿
    const categoryOptions = (() => {
        const opts = [];
        opts.push($('<option>').val('').prop('disabled', true).prop('selected', true).text('카테고리'));
        <c:forEach var="category" items="${categories}">
        opts.push($('<option>').val('${category.categoryCd}').text('${category.categoryName}'));
        </c:forEach>
        return opts;
    })();

    // 새 행 생성 함수
    function createNewRow() {
        const currentIndex = $('#inboundItemsTable tbody tr').length;
        let newRow = $('<tr>').addClass('inboundItemRow');

        // 카테고리 셀
        let categoryCell = $('<td>');
        let categorySelect = $('<select>')
            .addClass('form-select categorySelect')
            .attr('name', 'inboundRequestItems[' + currentIndex + '].categoryCd')
            .attr('required', true);
        categoryOptions.forEach(opt => categorySelect.append(opt.clone()));
        categoryCell.append(categorySelect);
        newRow.append(categoryCell);

        // 상품 셀
        let productCell = $('<td>');
        let productSelect = $('<select>')
            .addClass('form-select productSelect')
            .attr('name', 'inboundRequestItems[' + currentIndex + '].productId')
            .attr('required', true)
            .append($('<option>').val('').prop('disabled', true).prop('selected', true).text('상품 선택'));
        productCell.append(productSelect);
        newRow.append(productCell);

        // 수량 셀
        let quantityCell = $('<td>');
        quantityCell.append(
            $('<input>')
                .attr('type', 'number')
                .addClass('form-control quantityInput')
                .attr('name', 'inboundRequestItems[' + currentIndex + '].quantity')
                .attr('min', 1)
                .val(1)
                .prop('required', true)
        );
        newRow.append(quantityCell);

        // 삭제 버튼 셀
        let removeCell = $('<td>');
        removeCell.append(
            $('<button>')
                .attr('type', 'button')
                .addClass('btn btn-danger btn-sm removeItemBtn')
                .text('삭제')
        );
        newRow.append(removeCell);

        return newRow;
    }

    // 인덱스 재정렬 함수
    function updateIndices() {
        $('#inboundItemsTable tbody tr').each(function(index) {
            $(this).find('select.categorySelect').attr('name', 'inboundRequestItems[' + index + '].categoryCd');
            $(this).find('select.productSelect').attr('name', 'inboundRequestItems[' + index + '].productId');
            $(this).find('input.quantityInput').attr('name', 'inboundRequestItems[' + index + '].quantity');
        });
    }

    // 품목 추가
    $('#addItemBtn').click(function() {
        const newRow = createNewRow();
        $('#inboundItemsTable tbody').append(newRow);
    });

    // 품목 삭제
    $(document).on('click', '.removeItemBtn', function() {
        if ($('#inboundItemsTable tbody tr').length <= 1) {
            alert('최소 1개의 품목은 있어야 합니다.');
            return;
        }
        $(this).closest('tr').remove();
        updateIndices(); // 삭제 후 재정렬
    });

    // 카테고리 선택 시 상품 목록 로드
    $(document).on('change', '.categorySelect', function() {
        let categoryCd = $(this).val();
        let $row = $(this).closest('tr');
        let $productSelect = $row.find('.productSelect');
        let rowId = $row.index(); // 행 식별자

        // 이전 AJAX 요청 취소 (경쟁 상태 방지)
        if (ajaxRequests[rowId]) {
            ajaxRequests[rowId].abort();
        }

        // 상품 선택 초기화 및 비활성화
        $productSelect.empty();
        $productSelect.append(
            $('<option>').val('').prop('disabled', true).prop('selected', true).text('로딩 중...')
        );
        $productSelect.prop('disabled', true);

        // AJAX 요청
        ajaxRequests[rowId] = $.ajax({
            url: '/inbound/member/products/byCategory',
            type: 'GET',
            data: { categoryCd },
            success: function(products) {
                $productSelect.empty();
                $productSelect.append(
                    $('<option>').val('').prop('disabled', true).prop('selected', true).text('상품 선택')
                );

                if (products && products.length > 0) {
                    products.forEach(p => {
                        $productSelect.append($('<option>').val(p.productId).text(p.productName));
                    });
                    $productSelect.prop('disabled', false);
                } else {
                    $productSelect.append(
                        $('<option>').val('').prop('disabled', true).text('상품이 없습니다')
                    );
                }

                delete ajaxRequests[rowId];
            },
            error: function(xhr, status, error) {
                // 요청이 취소된 경우는 무시
                if (status === 'abort') return;

                console.error('상품 로딩 실패:', error);
                $productSelect.empty();
                $productSelect.append(
                    $('<option>').val('').prop('disabled', true).prop('selected', true).text('상품 로딩 실패')
                );
                $productSelect.prop('disabled', false);
                alert('상품을 불러오지 못했습니다.');
                delete ajaxRequests[rowId];
            }
        });
    });

    // 폼 제출 전 검증
    $('#inboundRequestForm').submit(function(e) {
        // 최소 1개 품목 확인
        const itemCount = $('#inboundItemsTable tbody tr').length;
        if (itemCount === 0) {
            alert('최소 1개의 품목을 추가해주세요.');
            e.preventDefault();
            return false;
        }

        // 모든 상품이 선택되었는지 확인
        let allProductsSelected = true;
        $('.productSelect').each(function() {
            if (!$(this).val()) {
                allProductsSelected = false;
                return false;
            }
        });

        if (!allProductsSelected) {
            alert('모든 품목의 상품을 선택해주세요.');
            e.preventDefault();
            return false;
        }

        // 디버깅: 전송될 데이터 확인
        console.log('=== 전송 데이터 확인 ===');
        $(this).serializeArray().forEach(item => {
            console.log(item.name, ':', item.value);
        });

        return true;
    });

    // 페이지 로드 시 첫 번째 행의 카테고리가 선택되어 있으면 상품 로드
    $(document).ready(function() {
        $('.categorySelect').each(function() {
            if ($(this).val()) {
                $(this).trigger('change');
            }
        });
    });
</script>

<%@ include file="../../member/member-footer.jsp" %>