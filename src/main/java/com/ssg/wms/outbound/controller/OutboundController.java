package com.ssg.wms.outbound.controller;

import com.ssg.wms.member.dto.MemberDTO;
import com.ssg.wms.outbound.domain.Criteria;
import com.ssg.wms.outbound.domain.dto.OutboundDTO;
import com.ssg.wms.outbound.service.OutboundService;
import com.ssg.wms.product_ehs.dto.ProductDTO;
import com.ssg.wms.product_ehs.service.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/member/outbound")
@RequiredArgsConstructor
@Log4j2
public class OutboundController {

    private final OutboundService outboundService;
    private final ProductService productService;


    //  기본 경로 → 리스트 페이지로 리다이렉트
    @GetMapping
    public String redirectToList(HttpSession session) {


        MemberDTO memberDTO = (MemberDTO) session.getAttribute("loginMember");
        Long memberId = memberDTO.getMemberId();

        if (memberId == null) {
            return "redirect:/login";
        }

        return "redirect:/member/outbound/list"; // jsp경로
    }


    // ======================================================
    // 🔵 1. 출고 요청 목록 조회
    // ======================================================
    @GetMapping("/list")  // url경로 /member/outbound/list
    public String getOutboundList(HttpSession session,
                                  @RequestParam(required = false) String status,
                                  Model model) {

        MemberDTO memberDTO = (MemberDTO) session.getAttribute("loginMember");
        Long memberId = memberDTO.getMemberId();
        if (memberId == null) {
            return "redirect:/login";
        }

        log.info("출고 요청 목록 조회 - memberId: {}, status: {}", memberId, status);

        List<OutboundDTO> outboundList = outboundService.getRequestsByUserId(memberId, status);

        model.addAttribute("outboundList", outboundList);
        model.addAttribute("memberId", memberId);

        return "outbound/member/outboundList";  // jsp경로
    }


    // ======================================================
    // 🔵 2. 출고 요청 작성 페이지
    // ======================================================
    @GetMapping("/request/form") // /member/outbound/request/form
    public String getOutboundRequestForm(HttpSession session, Model model) {

        MemberDTO memberDTO = (MemberDTO) session.getAttribute("loginMember");
        Long memberId = memberDTO.getMemberId();
        if (memberId == null) {
            return "redirect:/login";
        }

        model.addAttribute("categories", productService.getCategory());
        model.addAttribute("memberId", memberId);

        return "outbound/member/request";
    }


    // ======================================================
    // 🔵 3. 출고 요청 등록
    // ======================================================
    @PostMapping("/request")
    public String createOutboundRequest(HttpSession session,
                                        @ModelAttribute OutboundDTO outboundDTO) {

        MemberDTO memberDTO = (MemberDTO) session.getAttribute("loginMember");
        Long memberId = memberDTO.getMemberId();
        if (memberId == null) return "redirect:/login";

        outboundDTO.setMemberId(memberId);

        log.info("출고 요청 등록 - memberId={}, 품목수={}",
                memberId,
                (outboundDTO.getOutboundRequestItems() != null
                        ? outboundDTO.getOutboundRequestItems().size() : 0)
        );

        outboundService.createOutboundRequest(outboundDTO, memberId);

        return "redirect:/member/outbound/list";
    }


    // ======================================================
    // 🔵 4. 출고 요청 상세 조회 (JSON)
    // ======================================================
    @GetMapping("/request/{outboundRequestId}")
    @ResponseBody
    public ResponseEntity<OutboundDTO> getOutboundRequestDetail(
            @PathVariable Long outboundRequestId,
            HttpSession session) {

        MemberDTO memberDTO = (MemberDTO) session.getAttribute("loginMember");
        Long memberId = memberDTO.getMemberId();
        if (memberId == null) return ResponseEntity.status(401).build();

        log.info("출고 요청 상세 조회 - outboundRequestId: {}", outboundRequestId);

        OutboundDTO dto = outboundService.getRequestDetailById(outboundRequestId, memberId);
        return ResponseEntity.ok(dto);
    }


    // ======================================================
    // 🔵 5. 출고 요청 수정
    // ======================================================
    @PutMapping("/request/{outboundRequestId}")
    @ResponseBody
    public ResponseEntity<Void> updateOutboundRequest(
            @PathVariable Long outboundRequestId,
            HttpSession session,
            @RequestBody OutboundDTO dto) {

        MemberDTO memberDTO = (MemberDTO) session.getAttribute("loginMember");
        Long memberId = memberDTO.getMemberId();
        if (memberId == null) return ResponseEntity.status(401).build();

        log.info("출고 요청 수정 - outboundRequestId={}, memberId={}",
                outboundRequestId, memberId);

        outboundService.updateRequest(outboundRequestId, memberId, dto);

        return ResponseEntity.ok().build();
    }


    // ======================================================
    // 🔵 6. 출고 요청 삭제
    // ======================================================
    @DeleteMapping("/request/{outboundRequestId}")
    @ResponseBody
    public ResponseEntity<String> deleteOutboundRequest(
            @PathVariable Long outboundRequestId,
            HttpSession session) {

        MemberDTO memberDTO = (MemberDTO) session.getAttribute("loginMember");
        Long memberId = memberDTO.getMemberId();
        if (memberId == null) return ResponseEntity.status(401).build();

        log.info("출고 요청 삭제 - outboundRequestId={}, memberId={}",
                outboundRequestId, memberId);

        try {
            outboundService.deleteRequest(outboundRequestId, memberId);
            return ResponseEntity.ok("삭제 완료");
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (Exception e) {
            log.error("❌ 삭제 오류", e);
            return ResponseEntity.status(500).body("삭제 중 오류 발생");
        }
    }


    // ======================================================
    // 🔵 7. 카테고리별 상품 조회
    // ======================================================
    @GetMapping("/products/byCategory")
    @ResponseBody
    public ResponseEntity<?> getProductsByPartner(
            @RequestParam Integer categoryCd,
            HttpSession session) {

        MemberDTO memberDTO = (MemberDTO) session.getAttribute("loginMember");
        if (memberDTO == null) {
            return ResponseEntity.status(401).body("로그인이 필요합니다.");
        }

        Integer partnerId = memberDTO.getPartnerId(); // 로그인한 회원의 파트너 ID

        List<ProductDTO> products =
                productService.getProductsByPartnerAndCategory(partnerId, categoryCd);

        return ResponseEntity.ok(products);
    }

}
