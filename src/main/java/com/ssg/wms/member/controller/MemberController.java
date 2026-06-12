package com.ssg.wms.member.controller;

import com.ssg.wms.admin.domain.Staff;
import com.ssg.wms.admin.service.AdminService;
import com.ssg.wms.common.Role;
import com.ssg.wms.member.dto.MemberDTO;
import com.ssg.wms.member.dto.MemberUpdateDTO;
import com.ssg.wms.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.Map;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
@Log4j2
public class MemberController {

    private static final String NO_PERMISSION_MESSAGE = "로그인 권한이 없습니다.";
    private static final String INVALID_CREDENTIALS_MESSAGE = "아이디 혹은 비밀번호가 틀렸습니다.";

    private final MemberService memberService;
    private final AdminService adminService;

    @GetMapping("")
    public String getMemberMain() {
        return "member/connect";
    }

    @GetMapping("/login")
    public String getMemberLogin() {
        return "member/login";
    }

    @PostMapping("/login")
    public String postMemberLogin(@RequestParam("loginId") String loginId,
                                  @RequestParam String password,
                                  HttpServletRequest request,
                                  Model model) {
        MemberDTO member = memberService.loginCheck(loginId, password);

        if (member != null) {
            String partnerName = memberService.getPartnerName(member.getPartnerId());

            HttpSession session = request.getSession(true);
            session.setAttribute("loginMember", member);
            log.info("세션 로그: " + member);
            session.setAttribute("partnerName", partnerName);
            log.info("세션 로그: " + partnerName);
            session.setAttribute("loginId", loginId);
            log.info("세션 로그: " + loginId);
            session.setAttribute("role", member.getRole());
            log.info("(중요) 세션 로그: " + session.getAttribute("role"));

            log.info("Login Member: " + member);
            return "redirect:/member";
        }

        prepareLoginFailure(loginId, password, model);
        return "member/login";

    }

    @GetMapping("/register")
    public String getMemberRegister() {
        return "member/register";
    }

    @PostMapping("/register")
    public String registerMember(@Valid @ModelAttribute MemberDTO memberDTO,
                                 BindingResult bindingResult,
                                 Model model) {
        log.info("memberDTO: " + memberDTO);

        if (bindingResult.hasErrors()) {
            log.info("Member Registration Error");
            model.addAttribute("errorMessage", "입력값을 다시 확인해주세요.");
            return "member/register";
        }
        try {
            memberDTO.setPartnerId(memberService.getPartnerIdByBusinessNumber(memberDTO.getBusinessNumber()));
            log.info("PartnerId-inserted memberDTO: " + memberDTO);
        } catch (Exception e) {
            log.info("PartnerId-insertion error: " + e);
            model.addAttribute("errorMessage", "등록되지 않은 사업자등록번호입니다.");
            return "member/register";
        }
        memberService.insertMember(memberDTO);
        log.info("Member Registration Success");

        return "member/success";
    }

    @Transactional
    @GetMapping("/mypage")
    public String getUserInfo(HttpSession session, Model model) {
        String id = (String) session.getAttribute("loginId");
        if (id == null) {
            return "redirect:/login";
        }

        long memberId = memberService.findMemberIdByMemberLoginId(id);
        MemberDTO memberDTO = memberService.getMemberDetails(memberId);
        log.info("memberDTO: " + memberDTO);

        session.setAttribute("loginMember", memberDTO);
        model.addAttribute("loginMember", memberDTO);
        return "member/mypage";
    }

    @PostMapping("/update")
    @ResponseBody
    public ResponseEntity<?> updateMember(@RequestBody MemberUpdateDTO memberUpdateDTO,
                                          HttpSession session) {
        try {
            MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");

            if (loginMember == null) {
                log.info("Member Login Error: UNAUTHORIZED");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(Map.of("message", "로그인이 필요합니다."));
            }
            log.info("Member Login: " + loginMember);
            memberService.updateMember(loginMember.getMemberId(), memberUpdateDTO);

            MemberDTO updatedMember = memberService.getMemberDetails(loginMember.getMemberId());
            session.setAttribute("loginMember", updatedMember);

            return ResponseEntity.ok()
                    .body(Map.of("message", "회원 정보가 수정되었습니다."));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "정보 수정 중 에러가 발생했습니다."));
        }
    }

    private void prepareLoginFailure(String loginId, String password, Model model) {
        Staff staff = adminService.loginCheck(loginId, password);
        model.addAttribute("loginId", loginId);

        if (staff != null) {
            model.addAttribute("alertMessage", NO_PERMISSION_MESSAGE);
            model.addAttribute("redirectUrl", resolveRedirectUrlByRole(staff.getRole()));
            return;
        }

        model.addAttribute("alertMessage", INVALID_CREDENTIALS_MESSAGE);
    }

    private String resolveRedirectUrlByRole(Role role) {
        if (role == null) {
            return "/login";
        }

        switch (role) {
            case ADMIN:
                return "/admin/login";
            case MEMBER:
                return "/member/login";
            case MANAGER:
                return "/warehousemanager/login";
            default:
                return "/login";
        }
    }
}
