package com.ssg.wms.warehouse.controller;

import com.ssg.wms.warehouse.dto.WarehouseSearchDTO;
import com.ssg.wms.warehouse.service.WarehouseMemberService;

import com.ssg.wms.warehouse.dto.WarehouseListDTO;
import com.ssg.wms.warehouse.dto.WarehouseDetailDTO;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.JsonProcessingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.extern.log4j.Log4j2; // 로그 추가


import javax.servlet.http.HttpSession;
import java.util.List;

@Log4j2 // 로그 사용을 위해 추가
@Controller
@RequestMapping("/member/warehouses")
public class WarehouseMemberController {

    private final WarehouseMemberService memberService;
    private final ObjectMapper objectMapper;

    @Autowired
    public WarehouseMemberController(
            @Qualifier("warehousesMemberServiceImpl")
            WarehouseMemberService memberService,
            ObjectMapper objectMapper) {
        this.memberService = memberService;
        this.objectMapper = objectMapper;
    }


    // 1. View Controller
    // 창고 위치 조회
    @GetMapping({"/location", ""})
    public String getWarehouseListView(
            @ModelAttribute WarehouseSearchDTO searchForm,
            Model model,
            RedirectAttributes redirectAttributes,
            HttpSession session) {

        // **[세션 적용]**: 로그인 여부 확인
        String auth = validateMemberAccess(session);
        if (auth != null) return auth;

        try {
            List<WarehouseListDTO> list = memberService.findWarehouses(searchForm);

            model.addAttribute("tableWarehouseList", list);


            String jsonList = objectMapper.writeValueAsString(list);

            model.addAttribute("jsWarehouseData", jsonList);

        } catch (JsonProcessingException e) {
            log.error("JSON 처리 중 오류 발생: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", "데이터 처리 중 오류가 발생했습니다.");
            return "redirect:/error";
        } catch (Exception e) {
            log.error("창고 목록 조회 중 오류 발생: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", "창고 목록을 불러오는 데 실패했습니다.");
            return "redirect:/error";
        }

        return "warehouse/list";
    }


    // 창고 상세 화면 로드 (MEMBER는 조회만 가능)
    @GetMapping("/{whid}")
    public String getWarehouseDetailView(
            @PathVariable("whid") Long warehouseId,
            Model model,
            RedirectAttributes redirectAttributes,
            HttpSession session) {

        // **[세션 적용]**: 로그인 여부 확인
        String auth = validateMemberAccess(session);
        if (auth != null) return auth;

        try {
            WarehouseDetailDTO detail = memberService.findWarehouseDetailById(warehouseId);
            model.addAttribute("detail", detail);
            model.addAttribute("userRole", "MEMBER");
        } catch (IllegalArgumentException e) {
            log.warn("요청된 창고 ID({})를 찾을 수 없음: {}", warehouseId, e.getMessage());
            // 창고 ID를 찾지 못했을 때
            redirectAttributes.addFlashAttribute("error", "요청하신 창고 정보를 찾을 수 없습니다.");

            return "redirect:/member/warehouses"; // 매핑 경로에 맞게 /member/warehouses로 수정
        }


        return "warehouse/detail";
    }

    // 창고 목록 데이터 조회 (API)
    @GetMapping("/api/warehouses")
    @ResponseBody
    public List<WarehouseListDTO> getWarehouseList(
            @ModelAttribute WarehouseSearchDTO searchForm,
            HttpSession session) {


        if (!isLoggedIn(session)) {
            // 미인증 상태일 경우 빈 리스트 반환 또는 예외 throw (여기서는 빈 리스트 반환)
            log.warn("미인증 사용자가 API /api/warehouses에 접근 시도");
            // throw new AccessDeniedException("로그인이 필요합니다."); // 예외 처리 방식도 가능
            return List.of();
        }

        return memberService.findWarehouses(searchForm);
    }


    // 창고 상세 데이터 조회 (API)
    @GetMapping("/api/warehouses/{whid}")
    @ResponseBody
    public WarehouseDetailDTO getWarehouseDetail(
            @PathVariable("whid") Long warehouseId,
            HttpSession session) {

        // **[세션 적용]**: 로그인 여부 확인 (API 접근 시)
        if (!isLoggedIn(session)) {
            log.warn("미인증 사용자가 API /api/warehouses/{}에 접근 시도", warehouseId);
            // 미인증 상태일 경우 null 반환 또는 예외 throw
            return null;
        }

        return memberService.findWarehouseDetailById(warehouseId);
    }

    private String validateMemberAccess(HttpSession session) {
        if (!isLoggedIn(session)) {
            // 로그인 안 됨 → /login
            log.info("미인증 사용자가 접근 시도. 로그인 페이지로 리다이렉트.");
            return "redirect:/login";
        }
        return null; // 통과
    }

    
    private boolean isLoggedIn(HttpSession session) {
        // "loginId" 속성이 존재하면 로그인된 것으로 간주
        return session.getAttribute("loginId") != null;
    }
}