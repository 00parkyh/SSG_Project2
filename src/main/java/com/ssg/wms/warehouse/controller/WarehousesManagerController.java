package com.ssg.wms.warehouse.controller;

import com.ssg.wms.warehouse.dto.*;
import com.ssg.wms.warehouse.service.WarehouseManagerService;
import com.ssg.wms.warehouse.service.WarehouseMemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.ui.Model;


import javax.validation.Valid;
import java.util.List;
import com.fasterxml.jackson.databind.ObjectMapper; // ObjectMapper 추가 (필요시 사용)
import lombok.extern.log4j.Log4j2; // 로그 추가


//세션
import com.ssg.wms.common.Role;
import javax.servlet.http.HttpSession; // HttpSession import

@Log4j2 // 로그 사용을 위해 추가
@Controller
// Tomcat Manager 충돌 방지를 위해 경로를 /mgr/warehouses로 변경
@RequestMapping("/mgr/warehouses")
public class WarehousesManagerController {

    private final WarehouseManagerService warehouseManagerService;
    private final WarehouseMemberService memberService;
    private final ObjectMapper objectMapper = new ObjectMapper(); // ObjectMapper 추가 (로그인 List용)


    @Autowired
    public WarehousesManagerController(
            WarehouseManagerService warehouseManagerService,
            @Qualifier("warehousesMemberServiceImpl")
            WarehouseMemberService memberService) {
        this.warehouseManagerService = warehouseManagerService;
        this.memberService = memberService;
        // ObjectMapper는 생성자에서 초기화하지 않고 필드에서 바로 초기화하거나, 빈으로 주입받을 수 있으나, 여기서는 필드에서 초기화했습니다.
    }

    //1. View Controller

    @GetMapping({"", "/location"})
    public String managerListIndex(
            @ModelAttribute("searchForm") WarehouseSearchDTO searchForm,
            Model model,
            HttpSession session) { // 세션 추가

        // **[세션/권한 적용]**: 매니저 권한 확인
        String auth = validateManagerAccess(session);
        if (auth != null) return auth;

        List<WarehouseListDTO> list = memberService.findWarehouses(searchForm);
        model.addAttribute("warehouseList", list);
        model.addAttribute("userRole", "MANAGER");

        try {
            String jsonList = objectMapper.writeValueAsString(list);
            model.addAttribute("jsWarehouseData", jsonList);
        } catch (Exception e) {
            log.error("WarehouseListDTO JSON 변환 오류: {}", e.getMessage());
            model.addAttribute("jsWarehouseData", "[]");
        }

        return "warehouse/list";
    }

    @GetMapping("/register")
    public String getWarehouseRegisterView(Model model, HttpSession session) { // 세션 추가

        // 매니저 권한 확인
        String auth = validateManagerAccess(session);
        if (auth != null) return auth;

        // DTO 객체가 이미 Flash Attribute로 넘어왔다면 재사용
        if (!model.containsAttribute("saveDTO")) {
            model.addAttribute("saveDTO", new WarehouseSaveDTO());
        }
        return "warehouse/register";
    }

    @PostMapping("/register")
    public String registerNewWarehouse(
            @Valid @ModelAttribute("saveDTO") WarehouseSaveDTO saveDTO,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            HttpSession session) { // HttpSession 유지

        log.info("창고 등록 요청 시작 (매니저). 주소: {}", saveDTO.getAddress());

        // **[세션/권한 적용]**
        String auth = validateManagerAccess(session);
        if (auth != null) return auth;


        // 1. DTO 유효성 검사 (세션 검증 후 수행)
        if (bindingResult.hasErrors()) {
            // BindingResult와 입력 데이터를 Flash Attribute로 전달
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.saveDTO", bindingResult);
            redirectAttributes.addFlashAttribute("saveDTO", saveDTO);
            log.warn("창고 등록 유효성 검사 실패: {}", bindingResult.getFieldError().getDefaultMessage());
            return "redirect:/mgr/warehouses/register"; // 리다이렉트로 수정
        }

        try {
            // Long managerId = managerService.findStaffIdByStaffLoginId(loginId);
            // saveDTO.setManagerId(managerId);

            Long newWarehouseId = warehouseManagerService.saveWarehouse(saveDTO);
            log.info("창고 등록 성공. ID: {}", newWarehouseId);

            // 2. 성공: 창고 리스트 페이지로 리다이렉트
            redirectAttributes.addFlashAttribute("message", " V" + newWarehouseId + "번 창고 등록이 완료되었습니다.");
            return "redirect:/mgr/warehouses";

        } catch (IllegalArgumentException e) {

            log.error("창고 등록 비즈니스 오류 발생: {}", e.getMessage());
            bindingResult.rejectValue("name", "name.duplicate", e.getMessage()); // 오류를 특정 필드(name)에 연결

            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.saveDTO", bindingResult);
            redirectAttributes.addFlashAttribute("saveDTO", saveDTO);
            redirectAttributes.addFlashAttribute("error", "등록 오류: " + e.getMessage());
            return "redirect:/mgr/warehouses/register"; // 리다이렉트로 수정

        } catch (Exception e) {


            log.error("창고 등록 중 시스템 오류 발생: {}", e.getMessage(), e);
            bindingResult.reject("globalError", e.getMessage()); // 서비스에서 던진 상세 메시지를 Global Error로 사용

            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.saveDTO", bindingResult);
            redirectAttributes.addFlashAttribute("saveDTO", saveDTO);
            redirectAttributes.addFlashAttribute("error", "시스템 오류: 등록 중 예상치 못한 오류 발생. (원인: " + e.getMessage() + ")");

            return "redirect:/mgr/warehouses/register"; // 리다이렉트로 수정
        }
    }

    @GetMapping("/{whid}")
    public String getManagerDetailView(
            @PathVariable("whid") Long warehouseId,
            Model model,
            RedirectAttributes redirectAttributes,
            HttpSession session) { // 세션 추가

        // **[세션/권한 적용]**: 매니저 권한 확인
        String auth = validateManagerAccess(session);
        if (auth != null) return auth;

        try {
            WarehouseDetailDTO detail = memberService.findWarehouseDetailById(warehouseId);
            model.addAttribute("detail", detail);
            model.addAttribute("userRole", "MANAGER");
            return "warehouse/detail";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", "조회하려는 창고 정보를 찾을 수 없습니다.");
            return "redirect:/mgr/warehouses";
        }
    }

    @GetMapping("/{whid}/modify")
    public String getModifyForm(
            @PathVariable("whid") Long warehouseId,
            Model model,
            RedirectAttributes redirectAttributes,
            HttpSession session) { // 세션 추가

        // **[세션/권한 적용]**: 매니저 권한 확인
        String auth = validateManagerAccess(session);
        if (auth != null) return auth;

        try {
            WarehouseDetailDTO detailDTO = memberService.findWarehouseDetailById(warehouseId);
            model.addAttribute("detailDTO", detailDTO);

            if (!model.containsAttribute("updateDTO")) { model.addAttribute("updateDTO", new WarehouseUpdateDTO()); }

            model.addAttribute("userRole", "MANAGER");
            return "warehouse/modify";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", "수정하려는 창고 정보를 찾을 수 없습니다.");
            return "redirect:/mgr/warehouses";
        }
    }

    @PostMapping("/{whid}")
    public String updateWarehouse(
            @PathVariable("whid") Long warehouseId,
            @Valid @ModelAttribute("updateDTO") WarehouseUpdateDTO updateDTO,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            HttpSession session) { // HttpSession 유지

        // **[세션/권한 적용]**: 매니저 권한 확인
        String auth = validateManagerAccess(session);
        if (auth != null) return auth;

        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.updateDTO", bindingResult);
            redirectAttributes.addFlashAttribute("updateDTO", updateDTO);
            return "redirect:/mgr/warehouses/" + warehouseId + "/modify";
        }


        try {
            // Long managerId = managerService.findStaffIdByStaffLoginId(loginId);
            // updateDTO.setManagerId(managerId);

            warehouseManagerService.updateWarehouse(warehouseId, updateDTO);
            log.info("창고 수정 성공. ID: {}", warehouseId);

            redirectAttributes.addFlashAttribute("message", warehouseId + "번 창고 수정이 완료되었습니다.");
            return "redirect:/mgr/warehouses/" + warehouseId;
        } catch (Exception e) {
            // 수정 로직에서 발생하는 오류도 명확히 처리
            log.error("창고 수정 중 오류 발생 (ID: {}): {}", warehouseId, e.getMessage());
            redirectAttributes.addFlashAttribute("error", "수정 실패: " + e.getMessage());
            return "redirect:/mgr/warehouses/" + warehouseId;
        }
    }

    @PostMapping("/{whid}/delete")
    public String deleteWarehouse(
            @PathVariable("whid") Long warehouseId,
            RedirectAttributes redirectAttributes,
            HttpSession session) { // 세션 추가

        // **[세션/권한 적용]**: 매니저 권한 확인
        String auth = validateManagerAccess(session);
        if (auth != null) return auth;

        try {
            warehouseManagerService.deleteWarehouse(warehouseId);
            log.info("창고 삭제 성공. ID: {}", warehouseId);
            redirectAttributes.addFlashAttribute("message", "창고(" + warehouseId + ")가 삭제되었습니다.");
            return "redirect:/mgr/warehouses";
        } catch (Exception e) {
            // 삭제 로직에서 발생하는 오류도 명확히 처리
            log.error("창고 삭제 중 오류 발생 (ID: {}): {}", warehouseId, e.getMessage());
            redirectAttributes.addFlashAttribute("error", "삭제 실패: " + e.getMessage());
            return "redirect:/mgr/warehouses/" + warehouseId;
        }
    }

    @GetMapping("/api/check/name")
    @ResponseBody
    public Boolean checkNameDuplication(@RequestParam String name) {
        return warehouseManagerService.checkNameDuplication(name);
    }

    //2. 매니저 접근 권한 검사 헬퍼 메서드


    private String validateManagerAccess(HttpSession session) {
        if (!isLoggedIn(session)) {
            // 로그인 안 됨 → /login
            return "redirect:/login";
        }
        if (!isManager(session)) {
            // 로그인됨 + MANAGER 아님 → /error/403
            return "redirect:/error/403";
        }
        return null; // 통과
    }


    private boolean isManager(HttpSession session) {
        Object role = session.getAttribute("role");
        return role != null && role.equals(Role.MANAGER);
    }



    private boolean isLoggedIn(HttpSession session) {
        return session.getAttribute("loginId") != null;
    }
}