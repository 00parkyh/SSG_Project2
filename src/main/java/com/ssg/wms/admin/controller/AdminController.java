package com.ssg.wms.admin.controller;

import com.ssg.wms.admin.domain.Staff;
import com.ssg.wms.admin.dto.MemberCriteria;
import com.ssg.wms.admin.dto.MemberPageDTO;
import com.ssg.wms.admin.service.AdminService;
import com.ssg.wms.common.AccountStatus;
import com.ssg.wms.common.Role;
import com.ssg.wms.manager.dto.StaffDTO;
import com.ssg.wms.member.domain.Member;
import com.ssg.wms.member.dto.MemberDTO;
import com.ssg.wms.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
@Log4j2
public class AdminController {

    private static final String NO_PERMISSION_MESSAGE = "로그인 권한이 없습니다.";
    private static final String INVALID_CREDENTIALS_MESSAGE = "아이디 혹은 비밀번호가 틀렸습니다.";

    private final AdminService adminService;
    private final MemberService memberService;

    @GetMapping("")
    public String getAdminMain() {
        return "admin/dashboard";
    }

    @GetMapping("/login")
    public String getAdminLogin() {
        return "admin/login";
    }

    @PostMapping("/login")
    public String postAdminLogin(@RequestParam("loginId") String loginId,
                                 @RequestParam String password,
                                 HttpSession session,
                                 Model model) {
        Staff staff = adminService.loginCheck(loginId, password);
        if (staff != null) {
            if (staff.getRole() != Role.ADMIN) {
                model.addAttribute("loginId", loginId);
                model.addAttribute("alertMessage", NO_PERMISSION_MESSAGE);
                model.addAttribute("redirectUrl", resolveRedirectUrlByRole(staff.getRole()));
                return "admin/login";
            }

            session.setAttribute("loginStaff", staff);
            session.setAttribute("loginId", loginId);
            session.setAttribute("role", staff.getRole());

            return "redirect:/admin/dashboard";
        }

        prepareLoginFailure(loginId, password, model);
        return "admin/login";
    }

    @Transactional
    @GetMapping("/mypage")
    public String getUserInfo(HttpSession session, Model model) {
        String id = (String) session.getAttribute("loginId");
        if (id == null) {
            return "redirect:/login";
        }

        long staffId = adminService.findStaffIdByStaffLoginId(id);
        StaffDTO staffDTO = adminService.getStaffDetails(staffId);
        log.info("staffDTO: " + staffDTO);

        session.setAttribute("loginAdmin", staffDTO);
        model.addAttribute("loginAdmin", staffDTO);
        log.info("(중요) 세션 로그: " + session.getAttribute("role"));

        return "admin/mypage";
    }

    @GetMapping("/members")
    public String getMembers(@ModelAttribute MemberCriteria criteria,
                             Model model) {
        List<Member> members = adminService.getMembersByCriteria(criteria);
        int total = adminService.getMemberTotalCount(criteria);

        MemberPageDTO pageDTO = new MemberPageDTO(criteria.getPageNum(),
                criteria.getAmount(), total);

        model.addAttribute("members", members);
        model.addAttribute("pageDTO", pageDTO);
        model.addAttribute("totalCount", total);
        model.addAttribute("criteria", criteria);

        return "admin/members";
    }

    @GetMapping("/members/{memberId}")
    @ResponseBody
    public Member getMembersDetail(@PathVariable long memberId) {
        return adminService.getMemberDetails(memberId);
    }

    @PostMapping("/members/{memberId}/approve")
    @ResponseBody
    public ResponseEntity<?> approveMember(@PathVariable long memberId) {
        try {
            log.info("승인 요청: memberId={}", memberId);
            adminService.changeMemberStatus(memberId, AccountStatus.ACTIVE);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            log.error("승인 처리 중 에러 발생: memberId={}", memberId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("승인 처리 실패: " + e.getMessage());
        }
    }

    @PostMapping("/members/{memberId}/reject")
    @ResponseBody
    public ResponseEntity<?> rejectMember(@PathVariable long memberId) {
        log.info("Rejecting member " + memberId);
        adminService.changeMemberStatus(memberId, AccountStatus.REJECTED);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    private void prepareLoginFailure(String loginId, String password, Model model) {
        MemberDTO member = memberService.loginCheck(loginId, password);
        model.addAttribute("loginId", loginId);

        if (member != null) {
            model.addAttribute("alertMessage", NO_PERMISSION_MESSAGE);
            model.addAttribute("redirectUrl", resolveRedirectUrlByRole(member.getRole()));
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
