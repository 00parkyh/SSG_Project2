package com.ssg.wms.inbound.controller;

import com.ssg.wms.inbound.dto.InboundDTO;
import com.ssg.wms.inbound.dto.InboundListDTO;
import com.ssg.wms.inbound.dto.InboundRequestItemDTO;
import com.ssg.wms.inbound.dto.InboundWarehouseDTO;
import com.ssg.wms.inbound.service.InboundAdminService;
import com.ssg.wms.inbound.service.InboundMemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/inbound/admin")
@Log4j2
public class InboundAdminController {

    private final InboundAdminService inboundAdminService;

    // 입고 요청 목록 조회
    @GetMapping("/list")
    public String inboundList(
//            HttpSession session,
                              Model model,
                              @RequestParam(value = "partnerId", required = false) Long partnerId,
                              @RequestParam(value = "status", required = false) String status) {

        List<InboundListDTO> list = inboundAdminService.getInboundListByPartner(partnerId, status);
        model.addAttribute("list", list);

        List<InboundWarehouseDTO> warehouseList = inboundAdminService.getWarehouseList();
        model.addAttribute("warehouseList", warehouseList);

        return "inbound/admin/list";
    }

    // 입고 요청 단건 조회
    @GetMapping("/{inboundId}")
    public ResponseEntity<InboundDTO> getInbound(@PathVariable int inboundId,
                                                 HttpSession session) {
        InboundDTO inboundDTO = inboundAdminService.getInboundById(inboundId);

        if(inboundDTO == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(inboundDTO);
    }

    // 입고 요청 승인
    // form에서 form submit으로 입력받기 위해
    @PostMapping("/approve")
    public String approveInbound(
            @RequestParam("inboundId") Long inboundId,
            @RequestParam("warehouseId") Long warehouseId,
            RedirectAttributes redirectAttributes) {

        try {
            // 실제 승인 처리
            boolean result = inboundAdminService.approveInbound(inboundId, warehouseId);

            if (result) {
                redirectAttributes.addFlashAttribute("message", "입고가 승인되었습니다.");
                redirectAttributes.addFlashAttribute("messageType", "success");
            } else {
                redirectAttributes.addFlashAttribute("message", "입고 승인에 실패했습니다.");
                redirectAttributes.addFlashAttribute("messageType", "error");
            }

        } catch (Exception e) {
            log.error("입고 승인 중 오류 발생 - inboundId: {}, warehouseId: {}", inboundId, warehouseId, e);
            redirectAttributes.addFlashAttribute("message", "입고 승인 중 오류가 발생했습니다.");
            redirectAttributes.addFlashAttribute("messageType", "error");
        }

        return "redirect:/inbound/admin/list";
    }

    // 입고 요청 반려
    @PostMapping("/reject")
    public String rejectInbound(
            @RequestParam("inboundId") Long inboundId,
            @RequestParam("reason") String reason,
            RedirectAttributes redirectAttributes) {

        inboundAdminService.rejectInbound(inboundId, reason);
        redirectAttributes.addFlashAttribute("message", "입고가 반려되었습니다.");
        return "redirect:/inbound/admin/list";
    }


}
