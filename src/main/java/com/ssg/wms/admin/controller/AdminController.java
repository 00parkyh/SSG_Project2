package com.ssg.wms.admin.controller;

import com.ssg.wms.admin.domain.Staff;
import com.ssg.wms.member.domain.Member;
import com.ssg.wms.admin.dto.MemberCriteria;
import com.ssg.wms.admin.dto.MemberPageDTO;
import com.ssg.wms.manager.dto.StaffDTO;
import com.ssg.wms.admin.service.AdminService;
import com.ssg.wms.common.AccountStatus;
import com.ssg.wms.common.Role;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
@Log4j2
public class AdminController {

    private final AdminService adminService;

    @GetMapping("")
    public String getAdminMain() {
        // 메인 화면
        return "admin/dashboard";
    }

    @GetMapping("/login")
    public String getAdminLogin() {
        // 로그인 화면
        return "admin/login";
    }

    @PostMapping("/login")
    public String postAdminLogin(@RequestParam("loginId") String loginId,
                                 @RequestParam String password,
                                 HttpSession session,
                                 Model model) {
        Staff staff = adminService.loginCheck(loginId, password);
        if (staff == null) {
            model.addAttribute("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return "login";
        }

        // 세션에 저장
        session.setAttribute("loginStaff", staff);
        session.setAttribute("loginId", loginId);
        session.setAttribute("role", staff.getRole());

        return "redirect:/admin/dashboard";
    }

    @Transactional
    @GetMapping("/mypage")
    public String getUserInfo(HttpSession session, Model model) {
        // 마이페이지 조회
        String id = (String) session.getAttribute("loginId");
        if (id == null) {
            return "redirect:/login"; // 세션 없으면 로그인 페이지로
        }

        // 로그인 ID -> 고유 ID 구하고 직원 정보 얻음
        long staffId = adminService.findStaffIdByStaffLoginId(id);
        StaffDTO staffDTO = adminService.getStaffDetails(staffId);
        log.info("staffDTO: " + staffDTO);

        // 세션에 저장하고 모델로 넘김
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

        // 고객 목록 조회
        return "admin/members";
    }

    @GetMapping("/members/{memberId}")
    @ResponseBody
    public Member getMembersDetail(@PathVariable long memberId) {
        // 고객 상세 조회
        return adminService.getMemberDetails(memberId);
    }

    // 승인 처리
    @PostMapping("/members/{memberId}/approve")
    @ResponseBody
    public ResponseEntity<?> approveMember(@PathVariable long memberId) {
        try {
            log.info("승인 요청: memberId={}", memberId);
            adminService.changeMemberStatus(memberId, AccountStatus.ACTIVE);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            log.error("승인 처리 중 오류 발생: memberId={}", memberId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("승인 처리 실패: " + e.getMessage());
        }
    }

    // 거절 처리
    @PostMapping("/members/{memberId}/reject")
    @ResponseBody
    public ResponseEntity<?> rejectMember(@PathVariable long memberId) {
        // 거절 로직 처리
        log.info("Rejecting member " + memberId);
        adminService.changeMemberStatus(memberId, AccountStatus.REJECTED);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // 세션 무효화
        return "redirect:/login"; // 로그인 페이지로 리다이렉트
    }

}
