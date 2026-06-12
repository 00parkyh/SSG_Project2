package com.ssg.wms.manager.controller;

import com.ssg.wms.common.Role;
import com.ssg.wms.admin.domain.Staff;
import com.ssg.wms.admin.service.AdminService;
import com.ssg.wms.manager.dto.StaffDTO;
import com.ssg.wms.manager.service.ManagerService;
import com.ssg.wms.member.dto.MemberDTO;
import com.ssg.wms.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/warehousemanager")
@RequiredArgsConstructor
@Log4j2
public class ManagerController {

    private static final String NO_PERMISSION_MESSAGE = "로그인 권한이 없습니다.";
    private static final String INVALID_CREDENTIALS_MESSAGE = "아이디 혹은 비밀번호가 틀렸습니다.";

    private final ManagerService managerService;
    private final AdminService adminService;
    private final MemberService memberService;

    @GetMapping("")
    public String getManagerMain() {
        return "warehousemanager/connect";
    }

    @GetMapping("/login")
    public String getManagerLogin() {
        return "warehousemanager/login";
    }

    @PostMapping("")
    public String postManagerLogin(@RequestParam("loginId") String loginId,
                                   @RequestParam String password,
                                   HttpServletRequest request,
                                   Model model) {

        StaffDTO manager = managerService.loginCheck(loginId, password);
        if (manager != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("loginManager", manager);
            session.setAttribute("loginId", loginId);
            session.setAttribute("role", manager.getRole());
            return "redirect:/warehousemanager";
        }

        prepareLoginFailure(loginId, password, model);
        return "warehousemanager/login";
    }

    @Transactional
    @GetMapping("/mypage")
    public String getUserInfo(HttpSession session, Model model) {
        String id = (String) session.getAttribute("loginId");
        if (id == null) {
            return "redirect:/login";
        }

        long staffId = managerService.findManagerIdByManagerLoginId(id);
        StaffDTO staffDTO = managerService.getManagerDetails(staffId);

        session.setAttribute("loginManager", staffDTO);
        model.addAttribute("loginManager", staffDTO);
        return "warehousemanager/mypage";
    }

    private void prepareLoginFailure(String loginId, String password, Model model) {
        Staff staff = adminService.loginCheck(loginId, password);
        MemberDTO member = memberService.loginCheck(loginId, password);
        model.addAttribute("loginId", loginId);

        if (staff != null && staff.getRole() != Role.MANAGER) {
            model.addAttribute("alertMessage", NO_PERMISSION_MESSAGE);
            model.addAttribute("redirectUrl", resolveRedirectUrlByRole(staff.getRole()));
            return;
        }

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
