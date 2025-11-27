<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String contextPath = request.getContextPath(); %>
<%@ include file="../../member/member-header.jsp" %>

<div class="container mt-4">
    <h4 class="fw-bold mb-3">입고 요청 목록</h4>

    <!-- 입고 요청 리스트 테이블 -->
    <table class="table table-bordered" id="inboundTable">
        <thead>
        <tr>
            <th>입고 번호</th>
            <th>브랜드</th>
            <th>요청자</th>
            <th>요청일시</th>
            <th>
                상태
                <!-- 상태 필터 드롭다운 -->
                <select id="statusFilter" class="form-select w-auto d-inline mb-3">
                    <option value="">전체</option>
                    <option value="request" ${param.status == 'request' ? 'selected' : ''}>처리 대기</option>
                    <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>요청 취소</option>
                    <option value="approved" ${param.status == 'approved' ? 'selected' : ''}>승인 완료</option>
                    <option value="rejected" ${param.status == 'rejected' ? 'selected' : ''}>반려</option>
                </select>
            </th>
        </tr>
        </thead>
        <tbody id="inboundTableBody">
        <c:forEach var="item" items="${list}">
            <tr style="cursor:pointer" data-inbound-id="${item.inboundId}">
                <td>${item.inboundId}</td>
                <td>${item.partnerName}</td>
                <td>${item.memberName}</td>
                <td>${item.inboundRequestedDate}</td>
                <td>${item.inboundStatusKor}</td>
            </tr>
        </c:forEach>
        <c:if test="${empty list}">
            <tr>
                <td colspan="4" class="text-center">조회된 데이터가 없습니다.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

<form id="inboundForm" method="post" style="display:none;">
    <input type="hidden" name="inboundId" id="formInboundId" value="">
</form>

<!-- 모달 JSP 인클루드 -->
<%@ include file="inboundModal.jsp" %>

<!-- axios, bootstrap, jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const contextPath = '<%=request.getContextPath()%>';
    const currentPartnerId = '${partnerId}';


    $(document).ready(function() {

        const inboundModalElement = document.getElementById('inboundModal');
        const inboundModal = new bootstrap.Modal(inboundModalElement);

        function formatDate(dateInput) {
            if (!dateInput) return '';
            if (typeof dateInput === 'string') return dateInput.length >= 16 ? dateInput.substring(0,16).replace('T',' ') : dateInput;
            if (dateInput instanceof Date) return dateInput.toISOString().substring(0,16).replace('T',' ');
            return String(dateInput);
        }


        // 상태 필터 변경 시 리스트 새로고침
        // 서버사이드(vs 클라이언트사이드) 방식으로 대량의 데이터 처리하기가 좀더 용이함
        // 서버에서 필터링되지만 새로고침이 필요해서 해당 방식은 채용하지 않는것으로
        // 클라이언트사이드 방식은 가장빠르지만 모든 데이터를 처음에 로드 -> 대량 데이터 부적합
        // 페이징 구현도 거의 어려움
/*        $('#statusFilter').on('change', function() {
            const selectedStatus = $(this).val();
            const currentUrl = new URL(window.location.href);

            if (selectedStatus) {
                currentUrl.searchParams.set('status', selectedStatus);
            } else {
                currentUrl.searchParams.delete('status');
            }

            // 페이지 새로고침하여 필터링된 결과 가져오기
            window.location.href = currentUrl.toString();
        });*/


        // 추후 페이징 리팩토링까지 고려하여 새로고침 없이도
        // 대량의 데이터를 서버에서 필터링 가능한 AJAX방식으로 채택
        // URL도 유지됨
        $("#statusFilter").change(function() {
            const status = $(this).val();
            $.ajax({
                url: "<%=contextPath%>/inbound/member/list",
                type: "get",
                data: {
                    status: status,
                },
                success: function(data) {
                    const newBody = $(data).find("#inboundTableBody").html();
                    $("#inboundTableBody").html(newBody);
                },
                error: function() {
                    console.error("AJAX Error:", error);
                    alert("리스트 조회 중 오류가 발생했습니다.");
                }
            });
        });



        // 전역 변수 선언
        let categories = [];
        let products = [];



        // 상품 렌더링 함수
        function renderInboundItems(items, categories) {
            const tbody = document.getElementById('inboundItemsBody');
            tbody.innerHTML = '';

            if (!items || items.length === 0) {
                tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted py-3">입고 상품이 없습니다.</td></tr>';
                return;
            }

            items.forEach(function(item) {
                // 카테고리 select
                let categoryOptions = '';
                categories.forEach(function(c) {
                    const selected = c.categoryCd === item.categoryCd ? 'selected' : '';
                    categoryOptions += '<option value="' + c.categoryCd + '" ' + selected + '>' + c.categoryName + '</option>';
                });

                // 초기 상품 select
                const initialProductOption = '<option value="' + item.productId + '" data-category="' + item.categoryCd + '" selected>' + item.productName + '</option>';

                const row =
                    '<tr>' +
                        '<td>' +
                            '<select class="form-select categorySelect" data-original-category="' + item.categoryCd + '">' +
                                categoryOptions +
                            '</select>' +
                        '</td>' +
                        '<td>' +
                            '<select class="form-select productSelect" data-original-product="' + item.productId + '">' +
                                initialProductOption +
                            '</select>' +
                        '</td>' +
                        '<td class="text-end">' +
                            '<input type="number" class="form-control quantity" value="' + item.quantity + '" min="1"/>' +
                        '</td>' +
                        '<td>' +
                            '<button type="button" class="btn btn-sm btn-danger removeItemBtn">삭제</button>' +
                        '</td>' +
                    '</tr>';

                tbody.insertAdjacentHTML('beforeend', row);

                // 초기 상품 데이터 저장
                $(tbody).find('tr:last').data('products', [item]);
            });
        }


        // 카테고리 변경 시 상품 목록 API 호출
        $(document).on('change', '.categorySelect', function() {
            const $categorySelect = $(this);
            const $row = $categorySelect.closest('tr');
            const $productSelect = $row.find('.productSelect');
            const partnerId = $('#inboundModal').data('partnerId');
            const selectedCategory = $categorySelect.val();

            if (!selectedCategory) {
                $productSelect.html('<option value="">카테고리를 먼저 선택하세요</option>').prop('disabled', true);
                return;
            }

            if (!partnerId) {
                alert('거래처 정보를 찾을 수 없습니다.');
                $productSelect.html('<option value="">거래처 정보 없음</option>').prop('disabled', true);
                return;
            }

            $productSelect.html('<option>로딩 중...</option>').prop('disabled', true);

            axios.get('<%=contextPath%>/inbound/member/products/byCategory', {
                params: {
                    categoryCd: selectedCategory,
                    partnerId: partnerId
                }
            })
                .then(function(response) {
                    const products = response.data || [];
                    $productSelect.empty().prop('disabled', false);

                    if (products.length === 0) {
                        $productSelect.append('<option value="">해당 카테고리의 상품이 없습니다</option>');
                        $row.data('products', []);
                        return;
                    }

                    $productSelect.append('<option value="">상품을 선택하세요</option>');

                    products.forEach(function(p) {
                        $productSelect.append(
                            '<option value="' + p.productId + '" data-category="' + p.categoryCd + '">' + p.productName + '</option>'
                        );
                    });

                    // 선택한 행에 products 데이터 저장
                    $row.data('products', products);
                })
                .catch(function(err) {
                    console.error('상품 목록 조회 오류:', err);
                    $productSelect.html('<option value="">조회 실패</option>').prop('disabled', false);
                    alert('상품 목록을 불러오는데 실패했습니다.');
                });
        });

        // 상품 선택 시 해당 데이터 적용
        $(document).on('change', '.productSelect', function() {
            const $productSelect = $(this);
            const $row = $productSelect.closest('tr');
            const selectedProductId = $productSelect.val();

            if (!selectedProductId) {
                alert('상품을 선택하세요');
                return;
            }

            const rowProducts = $row.data('products') || [];
            const productData = rowProducts.find(function(p) {
                return String(p.productId) === String(selectedProductId);
            });

            if (!productData) {
                alert('상품 데이터를 불러올 수 없습니다.');
                return;
            }

            // 예시: 수량 초기화 및 category 자동 변경
            $row.find('.quantity').val(productData.defaultQuantity || 1);
            // $row.find('.categorySelect').val(productData.categoryCd);
        });



        // 상품 삭제
        $(document).on('click', '.removeItemBtn', function() {
            $(this).closest('tr').remove();
        });




        // 상품 추가
        $('#addInboundItemBtn').click(function() {
            const tbody = $('#inboundItemsBody');
            const categories = $('#inboundModal').data('categories') || [];
            let categoryOptions = '<option value="">카테고리 선택</option>';
            categories.forEach(function(c) {
                categoryOptions += '<option value="' + c.categoryCd + '">' + c.categoryName + '</option>';
            });

            const row = '<tr>' +
                '<td><select class="form-select categorySelect">' + categoryOptions + '</select></td>' +
                '<td><select class="form-select productSelect" disabled><option value="">카테고리를 먼저 선택하세요</option></select></td>' +
                '<td class="text-end"><input type="number" class="form-control quantity" value="1" min="1"/></td>' +
                '<td><button type="button" class="btn btn-sm btn-danger removeItemBtn">삭제</button></td>' +
                '</tr>';

            tbody.append(row);
            $(tbody).find('tr:last').data('products', []);
        });



        // 모달 열기
        function openInboundModal(inboundId) {
            // 모달 root 먼저 가져오기
            const modalEl = document.getElementById('inboundModal');
            if (!modalEl) {
                console.error('inboundModal NOT found in current document.');
                return;
            }
            const inboundModal = new bootstrap.Modal(modalEl);

            // 데이터 조회
            axios.get('<%=contextPath%>/inbound/member/' + inboundId)
                .then(function(response) {
                    const data = response.data;
                    if (!data) {
                        alert('데이터를 불러올 수 없습니다.');
                        return;
                    }

                    // 모달 내부에서 요소들을 안전하게 가져오기
                    const inboundInput          = modalEl.querySelector('#inboundId');
                    const inboundStatusEl       = modalEl.querySelector('#inboundStatus');
                    const warehouseIdEl         = modalEl.querySelector('#warehouseId');
                    const warehouseNameEl       = modalEl.querySelector('#warehouseName');
                    const partnerNameEl         = modalEl.querySelector('#partnerName');
                    const memberIdEl            = modalEl.querySelector('#memberId');
                    const memberNameEl          = modalEl.querySelector('#memberName');
                    const staffIdEl             = modalEl.querySelector('#staffId');
                    const staffNameEl           = modalEl.querySelector('#staffName');
                    const inboundRequestedAtEl  = modalEl.querySelector('#inboundRequestedAt');
                    const inboundAtEl           = modalEl.querySelector('#inboundAt');
                    const rejectSection         = modalEl.querySelector('#rejectReasonSection');
                    const inboundRejectReasonEl = modalEl.querySelector('#inboundRejectReason');

                    // 버튼 속성 제어용 변수 선언
                    const updateBtn = modalEl.querySelector('#updateInboundBtn');
                    const cancelBtn = modalEl.querySelector('#cancelInboundBtn');

                    if (!inboundInput) {
                        console.error('inboundId input not found INSIDE modal. modalEl.innerHTML snapshot:', modalEl.innerHTML.slice(0,500));
                        return;
                    }

                    // 데이터 채우기
                    inboundInput.value = data.inboundId || '';
                    if (inboundStatusEl) {
                        inboundStatusEl.value = data.inboundStatusKor || '';

                        // 기존 Bootstrap 클래스 제거
                        inboundStatusEl.classList.remove('bg-success', 'bg-primary', 'bg-danger', 'text-white');

                        // 상태에 따라 Bootstrap 클래스 추가
                        switch(data.inboundStatus) {
                            case 'approved':
                                inboundStatusEl.classList.add('bg-success', 'text-white');
                                break;
                            case 'request':
                                inboundStatusEl.classList.add('bg-primary', 'text-white');
                                break;
                            case 'rejected':
                            case 'cancelled':
                                inboundStatusEl.classList.add('bg-danger', 'text-white');
                                break;
                        }
                    }




                    if (warehouseIdEl) warehouseIdEl.value = data.warehouseId || '';
                    if (warehouseNameEl) warehouseNameEl.value = data.warehouseName || '미지정';
                    if (partnerNameEl) partnerNameEl.value = data.partnerName || '';
                    if (memberIdEl) memberIdEl.value = data.memberId || '';
                    if (memberNameEl) memberNameEl.value = data.memberName || '';
                    if (staffIdEl) staffIdEl.value = data.staffId || '';
                    if (staffNameEl) staffNameEl.value = data.staffName || '미지정';
                    if (inboundRequestedAtEl) inboundRequestedAtEl.value = formatDate(data.inboundRequestedAt);
                    if (inboundAtEl) inboundAtEl.value = formatDate(data.inboundAt) || '미지정';

                    // 반려 사유 표시
                    if (data.inboundStatus === 'rejected' && data.inboundRejectReason) {
                        if (inboundRejectReasonEl) inboundRejectReasonEl.value = data.inboundRejectReason;
                        if (rejectSection) rejectSection.style.display = 'block';
                    } else {
                        if (rejectSection) rejectSection.style.display = 'none';
                    }

                    // 버튼 상태 제어: 취소, 승인, 반려 시 수정/취소 버튼 숨김
                    if (['cancelled', 'approved', 'rejected'].includes(data.inboundStatus)) {
                        if (updateBtn) updateBtn.style.display = 'none';
                        if (cancelBtn) cancelBtn.style.display = 'none';
                    } else {
                        if (updateBtn) updateBtn.style.display = 'inline-block';
                        if (cancelBtn) cancelBtn.style.display = 'inline-block';
                    }



                    // 상품 렌더링
                    renderInboundItems(data.inboundItems, data.categories || []);



                    // 버튼 상태 제어: 취소, 승인, 반려 시 수정/취소 버튼 숨김
                    if (['cancelled', 'approved', 'rejected'].includes(data.inboundStatus)) {
                        if (updateBtn) updateBtn.style.display = 'none';
                        if (cancelBtn) cancelBtn.style.display = 'none';
                    } else {
                        if (updateBtn) updateBtn.style.display = 'inline-block';
                        if (cancelBtn) cancelBtn.style.display = 'inline-block';
                    }

                    // 상품 추가/삭제 버튼 비활성화/활성화
                    const addItemBtn = modalEl.querySelector('#addInboundItemBtn');
                    const deleteBtns = modalEl.querySelectorAll('#inboundItemsBody .removeItemBtn');

                    if (data.inboundStatus === 'request') {
                        if (addItemBtn) addItemBtn.disabled = false;
                        deleteBtns.forEach(btn => btn.disabled = false);
                    } else {
                        if (addItemBtn) addItemBtn.disabled = true;
                        deleteBtns.forEach(btn => btn.disabled = true);
                    }



                    // 모달 열기
                    inboundModal.show();

                    // 모달에 데이터 저장 (전역 사용 가능)
                    $(modalEl).data('inbound-id', inboundId);
                    $(modalEl).data('partnerId', data.partnerId);
                    $(modalEl).data('categories', data.categories || []);
                })
                .catch(function(err) {
                    console.error('입고 상세 조회 오류:', err);
                    alert('입고 상세 조회 중 오류가 발생했습니다.');
                });
        }


        // 테이블 행 클릭
        $(document).on('click', '#inboundTableBody tr', function() {
            const inboundId = $(this).find('td:first').text().trim();
            if (inboundId) openInboundModal(inboundId);
        });



        // 수정 버튼 클릭 이벤트
        // 수정 버튼 클릭 이벤트
        $(document).on('click', '#updateInboundBtn', function() {
            const inboundId = $('#inboundModal').data('inbound-id');
            if (!inboundId) {
                alert('입고 요청 정보를 찾을 수 없습니다.');
                return;
            }

            // 수정할 데이터 수집
            const updatedItems = [];
            $('#inboundItemsBody tr').each(function() {
                const $row = $(this);
                const item = {
                    inboundId: inboundId,  // ✅ inboundId 추가
                    productId: $row.find('.productSelect').val(),
                    categoryCd: Number($row.find('.categorySelect').val()),
                    quantity: Number($row.find('.quantity').val())
                };
                updatedItems.push(item);
            });

            const requestData = {
                inboundId: inboundId,
                warehouseId: Number($('#warehouseId').val()),
                staffId: Number($('#staffId').val()),
                memberId: Number($('#memberId').val()),
                inboundStatus: $('#inboundStatus').val() || 'request',
                inboundRejectReason: $('#inboundRejectReason').val() || null,
                inboundRequestItems: updatedItems  // ✅ inboundItems → inboundRequestItems
            };

            console.log("수정 요청 데이터:", requestData);

            axios.put(contextPath + '/inbound/member/' + inboundId, requestData)
                .then(response => {
                    alert('입고 요청이 성공적으로 수정되었습니다.');
                    $('#inboundModal').modal('hide');
                    location.reload();
                })
                .catch(error => {
                    console.error('수정 오류:', error);
                    alert('수정 중 오류가 발생했습니다.');
                });
        });

        // 입고 취소 버튼
        document.getElementById("cancelInboundBtn").addEventListener("click", function() {
            const form = document.getElementById("inboundForm");
            form.action = "/inbound/member/cancel";
            form.formInboundId.value = document.getElementById("inboundId").value;
            form.submit();
        });





        // 전역 노출
        /*현재 스코프에 있는 openInboundModal 함수를 전역 객체 window의 openInboundModal 속성으로 등록.
            이렇게 하면 어디서든 window.openInboundModal() 혹은 단순히 openInboundModal()로 호출 가능.*/
        window.openInboundModal = openInboundModal;
    });
</script>




<%@ include file="../../member/member-footer.jsp" %>
