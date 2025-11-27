<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="dispatchFormContent">

  <script>
    console.log("dispatchForm loaded. contextPath =", contextPath);
  </script>

  <form id="dispatchForm">
    <input type="hidden" name="approvedOrderID" value="${dispatch.approvedOrderID}">

    <table class="table table-bordered text-center align-middle">
      <thead class="table-light">
      <tr>
        <th>출고지시서번호</th>
        <th>기사이름</th>
        <th>차량번호</th>
        <th>차량종류</th>
        <th>출고박스</th>
        <th>창고</th>
        <th>최대적재</th>
        <th>배차상태</th>
        <th>요청상태</th>
      </tr>
      </thead>

      <tbody>
      <tr>
        <td>${dispatch.approvedOrderID}</td>

        <td>
          <select id="driverSelect" name="driverName" class="form-select" required>
            <option value="">-- 기사 선택 --</option>
          </select>
        </td>

        <td><input type="text" name="vehicleNumber" class="form-control" readonly></td>
        <td><input type="text" name="vehicleType" class="form-control" readonly></td>

        <td><input type="number" name="boxCount" class="form-control" required></td>

        <td>
          <select id="warehouseSelect" name="warehouseId" class="form-select" required>
            <option value="">-- 창고 선택 --</option>
          </select>
        </td>

        <td><input type="number" name="vehicleCapacity" class="form-control" value="100" readonly></td>

        <td>
          <select name="dispatchStatus" class="form-select" required>
            <option value="대기">대기</option>
            <option value="완료">완료</option>
          </select>
        </td>

        <td>
          <select name="approvalStatus" class="form-select" required>
            <option value="approved">승인</option>
            <option value="반려">반려</option>
          </select>
        </td>
      </tr>
      </tbody>
    </table>

    <div class="text-end mt-3">
      <button type="button" class="btn btn-primary" id="submitDispatchBtn">등록</button>
      <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
    </div>
  </form>

  <script>
    $(document).ready(function () {

      var isExistingDispatch = ${dispatch.carId != null ? 'true' : 'false'};

      var approvedStatusValue = "${dispatch.approvedStatus}";
      var isApproved = (approvedStatusValue === "APPROVED" || approvedStatusValue === "승인");

      console.log("🔍 배차 정보:", {
        approvedOrderID: "${dispatch.approvedOrderID}",
        carId: "${dispatch.carId}",
        warehouseId: "${dispatch.warehouseId}",
        warehouseName: "${dispatch.warehouseName}",
        approvedStatus: approvedStatusValue,
        isApproved: isApproved,
        isExistingDispatch: isExistingDispatch
      });

      if (isApproved) {
        console.log("⚠️ 승인된 건이므로 수정 불가");
        $("#dispatchForm input, #dispatchForm select").prop("disabled", true);
        $("#submitDispatchBtn")
                .prop("disabled", true)
                .removeClass("btn-primary")
                .addClass("btn-secondary")
                .text("승인된 건은 수정할 수 없습니다");
      }
      var loadStatus = {
        drivers: false,
        warehouses: false
      };

      function checkAndSetValues() {
        if (loadStatus.drivers && loadStatus.warehouses && isExistingDispatch) {
          console.log("✅ 모든 데이터 로드 완료 - 기존 값 세팅 시작");
          setExistingValues();
        }
      }

      // ------------------------
      // 1) 기사 목록 불러오기 ⭐ 수정
      // ------------------------
      $.ajax({
        url: contextPath + "/admin/dispatches/drivers",
        type: "GET",
        dataType: "json",
        success: function (response) {
          console.log("✅ 기사 목록 조회 성공:", response);

          var select = $("#driverSelect");
          select.empty();
          select.append('<option value="">-- 기사 선택 --</option>');

          if (!response || response.length === 0) {
            console.warn("⚠️ 기사 데이터가 없습니다.");
            loadStatus.drivers = true;
            checkAndSetValues();
            return;
          }

          var seenCarIds = new Set();

          response.forEach(function (d) {
            if (!d.carId || seenCarIds.has(d.carId)) return;
            seenCarIds.add(d.carId);

            select.append(
                    $('<option></option>')
                            .val(d.driverName)
                            .attr('data-car', d.carId)
                            .attr('data-type', d.carType)
                            .text(d.driverName + ' (' + d.carId + ')')
            );
          });

          console.log("📋 기사 옵션 추가 완료:", select.find('option').length - 1 + "명");
          loadStatus.drivers = true;
          checkAndSetValues();
        },
        error: function(xhr, status, error) {
          console.error("❌ 기사 목록 조회 실패:", error);
          alert("기사 목록을 불러오는데 실패했습니다.");
        }
      });

      // ------------------------
      // 2) 창고 목록 불러오기
      // ------------------------
      $.ajax({
        url: contextPath + "/admin/outbound/dispatches/warehouses",
        type: "GET",
        dataType: "json",
        success: function(list) {
          console.log("✅ 창고 목록 조회 성공:", list);

          var select = $("#warehouseSelect");
          select.empty();
          select.append('<option value="">-- 창고 선택 --</option>');

          if (!list || list.length === 0) {
            console.warn("⚠️ 창고 데이터가 없습니다.");
            loadStatus.warehouses = true;
            checkAndSetValues();
            return;
          }

          list.forEach(function(w) {
            select.append(
                    $('<option></option>')
                            .val(w.id) // ✅ 수정: JSON의 'id' 필드 사용 (w.warehouseId -> w.id)
                            .text(w.name) // ✅ 수정: JSON에 없는 'warehouseType' 제거
            );
          });

          console.log("📋 창고 옵션 추가 완료:", select.find('option').length - 1 + "개");
        },
        error: function(xhr, status, error) {
          console.error("❌ 창고 목록 조회 실패:", error);
          console.error("응답:", xhr.responseText);
        }
      });

      // ------------------------
      // 기존 배차 값 세팅
      // ------------------------
      function setExistingValues() {
        console.log("📝 기존 배차 데이터 세팅 중...");
        console.log("warehouseId:", "${dispatch.warehouseId}");

        $("input[name='vehicleNumber']").val("${dispatch.carId}");
        $("input[name='vehicleType']").val("${dispatch.carType}");
        $("input[name='boxCount']").val("${dispatch.loadedBox}");
        $("select[name='dispatchStatus']").val("${dispatch.dispatchStatus}");
        $("select[name='approvalStatus']").val("${dispatch.approvedStatus}");
        $("#driverSelect").val("${dispatch.driverName}");

        // ✅ 창고 선택 - warehouseId가 있으면 설정
        var warehouseId = "${dispatch.warehouseId}";
        if (warehouseId && warehouseId !== "null" && warehouseId !== "") {
          $("#warehouseSelect").val(warehouseId);
          console.log("✅ 창고 설정됨:", warehouseId);
        } else {
          console.warn("⚠️ warehouseId가 없습니다:", warehouseId);
        }
      }
      // ------------------------
      // 기사 변경 → 차량 자동 입력 ⭐ 수정
      // ------------------------
      $("#driverSelect").on("change", function () {
        var option = $(this).find("option:selected");
        var carId = option.attr("data-car");
        var carType = option.attr("data-type");

        console.log("🚗 기사 선택:", $(this).val());
        console.log("차량번호:", carId);
        console.log("차량종류:", carType);

        $("input[name='vehicleNumber']").val(carId || '');
        $("input[name='vehicleType']").val(carType || '');
      });

      // ------------------------
      // 등록 버튼
      // ------------------------
      $("#submitDispatchBtn").on("click", function () {
        if (isApproved) {
          alert("승인된 건은 수정할 수 없습니다.");
          return;
        }

        var data = {
          approvedOrderID: Number("${dispatch.approvedOrderID}"),
          carId: $("input[name='vehicleNumber']").val(),
          carType: $("input[name='vehicleType']").val(),
          driverName: $("#driverSelect").val(),
          loadedBox: Number($("input[name='boxCount']").val()),
          warehouseId: Number($("#warehouseSelect").val()),
          maximumBOX: Number($("input[name='vehicleCapacity']").val()),
          dispatchStatus: $("select[name='dispatchStatus']").val(),
          approvedStatus: $("select[name='approvalStatus']").val()
        };

        console.log("📤 등록 데이터:", data);

        // 유효성 검사
        if (!data.driverName) {
          alert("기사를 선택해주세요.");
          return;
        }
        if (!data.warehouseId) {
          alert("창고를 선택해주세요.");
          return;
        }
        if (!data.loadedBox || data.loadedBox <= 0) {
          alert("출고박스 수를 입력해주세요.");
          return;
        }

        $.ajax({
          url: contextPath + "/admin/outbound/" + data.approvedOrderID + "/register",
          type: "POST",
          contentType: "application/json",
          data: JSON.stringify(data),
          success: function (response) {
            console.log("✅ 등록 성공:", response);
            alert("🚚 배차 등록 완료!");
            $("#dispatchModal").modal("hide");
            location.reload();
          },
          error: function (xhr, status, error) {
            console.error("❌ 등록 실패:", error);
            console.error("응답:", xhr.responseText);
            alert("등록 실패: " + (xhr.responseText || error));
          }
        });
      });

    });
  </script>

</div>