package com.ssg.wms.inbound.controller;

import com.ssg.wms.inbound.dto.InboundDTO;
import com.ssg.wms.inbound.dto.InboundDetailDTO;
import com.ssg.wms.inbound.dto.InboundListDTO;
import com.ssg.wms.inbound.dto.InboundRequestDTO;
import com.ssg.wms.member.dto.MemberDTO;
import com.ssg.wms.product_ehs.dto.CategoryDTO;
import com.ssg.wms.product_ehs.dto.ProductDTO;
import com.ssg.wms.inbound.service.InboundMemberService;
import com.ssg.wms.product_ehs.service.ProductService;
import com.ssg.wms.product_ehs.service.ProductServiceImpl;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Controller
@RequiredArgsConstructor
@Log4j2
@RequestMapping("/inbound/member")
public class InboundMemberController {

    private final InboundMemberService inboundMemberService;
    private final ProductService productService;

    // 입고 요청 화면 이동
    @GetMapping("/request")
    public String getInboundRequestForm(
            HttpSession session,
            Model model) {
        // 로그인한 사용자의 user_id를 자동으로 가져오도록
        MemberDTO memberDTO = (MemberDTO) session.getAttribute("loginMember");
        Long memberId = memberDTO.getMemberId();
        String memberName = memberDTO.getMemberName();
        model.addAttribute("memberId", memberId);
        model.addAttribute("memberName", memberName);

        // 로그인한 사용자가 속한 거래처를 자동으로 가져오도록
        int partnerId = memberDTO.getPartnerId();
        String partnerName = (String) session.getAttribute("partnerName");
        model.addAttribute("partnerId", partnerId);
        model.addAttribute("partnerName", partnerName);

        // 카테고리 데이터 로드
        List<CategoryDTO> categories = productService.getCategory();
        model.addAttribute("categories", categories);
        log.info(categories);

        return "inbound/member/request";
    }

    @GetMapping("/products/byCategory")
    @ResponseBody
    public ResponseEntity<List<ProductDTO>> getProductsByPartner(
            @RequestParam Integer categoryCd,
            HttpSession session) {

        // 세션에서 partnerId 가져오기
        MemberDTO memberDTO = (MemberDTO) session.getAttribute("loginMember");
        int partnerId = memberDTO.getPartnerId();

        try {
            List<ProductDTO> products = productService.getProductsByPartnerAndCategory(partnerId, categoryCd);

            if (products == null || products.isEmpty()) {
                return ResponseEntity.ok(Collections.emptyList());
            }

            return ResponseEntity.ok(products);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // 입고 요청
    @PostMapping("/request")
    public String inboundRequest(HttpSession session,
                                 @Valid @ModelAttribute InboundRequestDTO inboundRequestDTO) {

        // 로그인한 사용자의 memberId 가져오기
        MemberDTO memberDTO = (MemberDTO) session.getAttribute("loginMember");
        Long memberId = memberDTO.getMemberId();
        inboundRequestDTO.setMemberId(memberId);

        log.info("=== 입고 요청 디버깅 ===");
        log.info("memberId: {}", memberId);
        log.info("DTO: {}", inboundRequestDTO);

        // 서비스 호출하여 DB 저장
        inboundMemberService.createInbound(inboundRequestDTO);

        // 요청 완료 후 이동할 페이지
        return "redirect:/inbound/member/list";
    }

    // 입고 요청 목록 조회 (관리자용 - 브랜드, 상태 파라미터로 받아서 검색)
    @GetMapping("/list")
    public String inboundList(
            HttpSession session,
            Model model,
            @RequestParam(value = "status", required = false) String status) {

        MemberDTO memberDTO = (MemberDTO) session.getAttribute("loginMember");
        Long memberId = memberDTO.getMemberId();
        int partnerId = memberDTO.getPartnerId();

        // 입고 요청 목록 조회
        List<InboundListDTO> list = inboundMemberService.getInboundListByPartner(memberId, status);

        model.addAttribute("list", list);
        model.addAttribute("partnerId", partnerId);

        return "inbound/member/list";
    }

    // 입고 요청 단건 조회
    @GetMapping("/{inboundId}")
    public ResponseEntity<InboundDetailDTO> getInboundById(@PathVariable int inboundId) {
        InboundDetailDTO inboundDetailDTO = inboundMemberService.getInboundById(inboundId);

        if(inboundDetailDTO == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(inboundDetailDTO);
    }

    // 입고 요청 수정
    @PutMapping("/{inboundId}")
    public ResponseEntity<InboundDTO> editInboundRequest(
            HttpSession session,
            @PathVariable int inboundId,
            @RequestBody InboundRequestDTO inboundRequestDTO) {

        MemberDTO memberDTO = (MemberDTO) session.getAttribute("loginMember");
        Long memberId = memberDTO.getMemberId();

        inboundRequestDTO.setMemberId(memberId);
        inboundRequestDTO.setInboundId(inboundId);

        // 서비스에서 수정 후 최신 데이터 반환
        InboundDTO updatedDto = inboundMemberService.updateInbound(inboundRequestDTO);

        System.out.println("InboundRequestDTO: " + inboundRequestDTO);

        return ResponseEntity.ok(updatedDto);
    }

    // 입고 요청 취소
    @PostMapping("/cancel")
    public String cancelInbound(HttpSession session,
                                @RequestParam("inboundId") int inboundId,
                                RedirectAttributes redirectAttributes) {

        try {
            boolean result = inboundMemberService.cancelInbound(inboundId);

            if (result) {
                redirectAttributes.addFlashAttribute("message", "입고 요청이 취소되었습니다.");
                redirectAttributes.addFlashAttribute("messageType", "success");
            } else {
                redirectAttributes.addFlashAttribute("message", "입고 요청 취소에 실패했습니다.");
                redirectAttributes.addFlashAttribute("messageType", "error");
            }

        } catch (Exception e) {
            log.error("입고 취소 중 오류 발생 - inboundId: {}", inboundId, e);
            redirectAttributes.addFlashAttribute("message", "입고 취소 중 오류가 발생했습니다.");
            redirectAttributes.addFlashAttribute("messageType", "error");
        }

        return "redirect:/inbound/member/list";
    }

}