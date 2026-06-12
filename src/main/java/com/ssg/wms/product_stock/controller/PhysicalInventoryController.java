package com.ssg.wms.product_stock.controller;

import com.ssg.wms.admin.domain.Staff;
import com.ssg.wms.common.AdjustmentStatus;
import com.ssg.wms.manager.dto.StaffDTO;
import com.ssg.wms.product_stock.dto.DropdownDTO;
import com.ssg.wms.product_stock.dto.PageRequestDTO;
import com.ssg.wms.product_stock.dto.PageResponseDTO;
import com.ssg.wms.product_stock.dto.PhysicalInventoryBatchUpdateDTO;
import com.ssg.wms.product_stock.dto.PhysicalInventoryDTO;
import com.ssg.wms.product_stock.dto.PhysicalInventoryRequest;
import com.ssg.wms.product_stock.dto.PhysicalInventoryUpdateDTO;
import com.ssg.wms.product_stock.mappers.dropDownMapper;
import com.ssg.wms.product_stock.service.PhysicalInventoryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/physical-inventory")
@RequiredArgsConstructor
@Log4j2
public class PhysicalInventoryController {

    private final PhysicalInventoryService physicalInventoryService;
    private final dropDownMapper dropDownMapper;

    @GetMapping
    public String physicalInventoryPage(Model model, HttpSession session) {
        populateCurrentStaff(model, session);

        List<DropdownDTO> warehouseList = dropDownMapper.warehouseDropDown();
        List<DropdownDTO> sectionList = Collections.emptyList();
        model.addAttribute("warehouseList", warehouseList);
        model.addAttribute("sectionList", sectionList);
        model.addAttribute("adjustmentStatuses", AdjustmentStatus.selectableValues());
        model.addAttribute("defaultAdjustmentStatus", AdjustmentStatus.defaultStatus().getDbValue());

        return "stock/physical-inventory";
    }

    private void populateCurrentStaff(Model model, HttpSession session) {
        StaffDTO loginManager = (StaffDTO) session.getAttribute("loginManager");
        StaffDTO loginAdmin = (StaffDTO) session.getAttribute("loginAdmin");
        Staff loginStaff = (Staff) session.getAttribute("loginStaff");

        if (loginManager != null) {
            model.addAttribute("currentStaffId", loginManager.getStaffId());
            model.addAttribute("currentStaffName", loginManager.getStaffName());
            return;
        }

        if (loginAdmin != null) {
            model.addAttribute("currentStaffId", loginAdmin.getStaffId());
            model.addAttribute("currentStaffName", loginAdmin.getStaffName());
            return;
        }

        if (loginStaff != null) {
            model.addAttribute("currentStaffId", loginStaff.getStaffId());
            model.addAttribute("currentStaffName", loginStaff.getStaffName());
        }
    }

    @GetMapping("/list")
    @ResponseBody
    public PageResponseDTO<PhysicalInventoryDTO> getPhysicalInventoryData(PageRequestDTO pageRequestDTO) {
        return physicalInventoryService.getPhysicalInventoryList(pageRequestDTO);
    }

    @GetMapping("/search")
    @ResponseBody
    public PageResponseDTO<PhysicalInventoryDTO> searchList(PageRequestDTO pageRequestDTO) {
        return physicalInventoryService.getPhysicalInventoryList(pageRequestDTO);
    }

    @GetMapping("/detail")
    @ResponseBody
    public List<PhysicalInventoryDTO> getPhysicalInventoryDetail(@RequestParam String inventoryBatchId) {
        return physicalInventoryService.getPhysicalInventoryDetailList(inventoryBatchId);
    }

    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> registerPhysicalInventory(@RequestBody PhysicalInventoryRequest request) {
        try {
            int registeredCount = physicalInventoryService.registerPhysicalInventory(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(Map.of(
                    "message", "등록 성공",
                    "count", registeredCount
            ));
        } catch (IllegalArgumentException e) {
            log.error("Physical inventory registration failed: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }

    @PostMapping("/update")
    public ResponseEntity<Map<String, String>> updatePhysicalInventory(@RequestBody PhysicalInventoryUpdateDTO updateDTO) {
        try {
            physicalInventoryService.updatePhysicalInventory(updateDTO);
            AdjustmentStatus adjustmentStatus = updateDTO.getUpdateState() == null
                    ? null
                    : AdjustmentStatus.fromDbValue(updateDTO.getUpdateState());
            String action = adjustmentStatus == AdjustmentStatus.COMPLETED ? "재고 조정 및 완료" : "저장";
            return ResponseEntity.ok(Map.of("message", action + " 처리 성공"));
        } catch (Exception e) {
            log.error("Physical inventory update failed", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "처리 실패: " + e.getMessage()));
        }
    }

    @PostMapping("/update-batch")
    public ResponseEntity<Map<String, String>> updatePhysicalInventoryBatch(@RequestBody PhysicalInventoryBatchUpdateDTO updateDTO) {
        try {
            physicalInventoryService.updatePhysicalInventoryBatch(updateDTO);
            String action = "완료".equals(updateDTO.getPiState()) ? "실사 상세 및 상태" : "실사 상태";
            return ResponseEntity.ok(Map.of("message", action + " 저장 성공"));
        } catch (Exception e) {
            log.error("Physical inventory batch update failed", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "처리 실패: " + e.getMessage()));
        }
    }
}
