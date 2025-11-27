<%-- /WEB-INF/views/outbound/member/request.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/member/member-header.jsp" />

<div class="container mt-5">
    <h3>출고 요청</h3>

    <form id="outboundRequestForm" method="post" action="/member/outbound/request">
        <input type="hidden" name="memberId" value="${memberId}"/>

        <!-- ✅ 출고 주소 -->
        <div class="mb-3">
            <label for="outboundAddress" class="form-label">도착지 주소</label>
            <input type="text" class="form-control" id="outboundAddress" name="outboundAddress"
                   placeholder="예: 서울시 강남구 테헤란로 123" required>
        </div>

        <!-- ✅ 출고 희망일 -->
        <div class="mb-3">
            <label for="requestedDeliveryDate" class="form-label">출고 희망일</label>
            <input type="date" class="form-control" id="requestedDeliveryDate" name="requestedDeliveryDate" required>
        </div>

        <h5>출고 품목</h5>
        <table class="table table-bordered" id="outboundItemsTable">
            <thead>
            <tr>
                <th>카테고리</th>
                <th>상품명</th>
                <th>수량</th>
                <th>삭제</th>
            </tr>
            </thead>
            <tbody>
            <tr class="outboundItemRow">
                <td>
                    <select name="outboundRequestItems[0].categoryCd" class="form-select categorySelect" required>
                        <option value="" disabled selected>카테고리</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.categoryCd}">${category.categoryName}</option>
                        </c:forEach>
                    </select>
                </td>
                <td>
                    <select name="outboundRequestItems[0].productId" class="form-select productSelect" required>
                        <option value="" disabled selected>상품 선택</option>
                    </select>
                </td>
                <td>
                    <input type="number" name="outboundRequestItems[0].outboundQuantity" class="form-control quantityInput" min="1" value="1" required>
                </td>
                <td>
                    <button type="button" class="btn btn-danger btn-sm removeItemBtn">삭제</button>
                </td>
            </tr>
            </tbody>
        </table>

        <button type="button" id="addItemBtn" class="btn btn-secondary btn-sm mb-3">품목 추가</button>
        <br/>
        <button type="submit" class="btn btn-primary">출고 요청</button>
    </form>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
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

    // 새 행 생성
    function createNewRow() {
        const currentIndex = $('#outboundItemsTable tbody tr').length;
        let newRow = $('<tr>').addClass('outboundItemRow');

        let categoryCell = $('<td>');
        let categorySelect = $('<select>')
            .addClass('form-select categorySelect')
            .attr('name', 'outboundRequestItems[' + currentIndex + '].categoryCd')
            .attr('required', true);
        categoryOptions.forEach(opt => categorySelect.append(opt.clone()));
        categoryCell.append(categorySelect);
        newRow.append(categoryCell);

        let productCell = $('<td>');
        let productSelect = $('<select>')
            .addClass('form-select productSelect')
            .attr('name', 'outboundRequestItems[' + currentIndex + '].productId')
            .attr('required', true)
            .append($('<option>').val('').prop('disabled', true).prop('selected', true).text('상품 선택'));
        productCell.append(productSelect);
        newRow.append(productCell);

        let quantityCell = $('<td>');
        quantityCell.append(
            $('<input>')
                .attr('type', 'number')
                .addClass('form-control quantityInput')
                .attr('name', 'outboundRequestItems[' + currentIndex + '].outboundQuantity')
                .attr('min', 1)
                .val(1)
                .prop('required', true)
        );
        newRow.append(quantityCell);

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

    // 인덱스 재정렬
    function updateIndices() {
        $('#outboundItemsTable tbody tr').each(function(index) {
            $(this).find('select.categorySelect').attr('name', 'outboundRequestItems[' + index + '].categoryCd');
            $(this).find('select.productSelect').attr('name', 'outboundRequestItems[' + index + '].productId');
            $(this).find('input.quantityInput').attr('name', 'outboundRequestItems[' + index + '].outboundQuantity');
        });
    }

    // 품목 추가
    $('#addItemBtn').click(function() {
        const newRow = createNewRow();
        $('#outboundItemsTable tbody').append(newRow);
    });

    // 품목 삭제
    $(document).on('click', '.removeItemBtn', function() {
        if ($('#outboundItemsTable tbody tr').length <= 1) {
            alert('최소 1개의 품목은 있어야 합니다.');
            return;
        }
        $(this).closest('tr').remove();
        updateIndices();
    });

    // 카테고리 선택 시 상품 목록 로드
    $(document).on('change', '.categorySelect', function() {
        let categoryCd = $(this).val();
        let $row = $(this).closest('tr');
        let $productSelect = $row.find('.productSelect');
        let rowId = $row.index();

        if (ajaxRequests[rowId]) {
            ajaxRequests[rowId].abort();
        }

        $productSelect.empty().append(
            $('<option>').val('').prop('disabled', true).prop('selected', true).text('로딩 중...')
        ).prop('disabled', true);

        ajaxRequests[rowId] = $.ajax({
            url: '/member/outbound/products/byCategory',
            type: 'GET',
            data: { categoryCd },
            success: function(products) {
                $productSelect.empty().append(
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
                if (status === 'abort') return;
                console.error('상품 로딩 실패:', error);
                alert('상품을 불러오지 못했습니다.');
                $productSelect.empty().append(
                    $('<option>').val('').prop('disabled', true).prop('selected', true).text('상품 로딩 실패')
                ).prop('disabled', false);
                delete ajaxRequests[rowId];
            }
        });
    });

    // 폼 검증
    $('#outboundRequestForm').submit(function(e) {
        const itemCount = $('#outboundItemsTable tbody tr').length;
        if (itemCount === 0) {
            alert('최소 1개의 품목을 추가해주세요.');
            e.preventDefault();
            return false;
        }

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

        console.log('=== 전송 데이터 ===');
        $(this).serializeArray().forEach(item => console.log(item.name, ':', item.value));
        return true;
    });
</script>

<%@ include file="../../member/member-footer.jsp" %>
