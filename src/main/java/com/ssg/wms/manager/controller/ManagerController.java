package com.ssg.wms.manager.controller;

import com.ssg.wms.common.Role;
import com.ssg.wms.manager.dto.StaffDTO;
import com.ssg.wms.manager.service.ManagerService;
import com.ssg.wms.member.dto.MemberDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

@Controller
@RequestMapping("/warehousemanager")
@RequiredArgsConstructor
@Log4j2
public class ManagerController {

    private final ManagerService managerService;

    @GetMapping("")
    public String getManagerMain() {
        // 메인 화면
        return "warehousemanager/connect";
    }

    @GetMapping("/login")
    public String getManagerLogin() {
        // 로그인 화면
        return "warehousemanager/login";
    }

    @PostMapping("")
    public String postManagerLogin(@RequestParam("loginId") String loginId,
                                   @RequestParam String password,
                                   HttpSession session,
                                   Model model) {

        StaffDTO manager = managerService.loginCheck(loginId, password);
        if (manager == null) {
            model.addAttribute("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return "warehousemanager/login"; // 로그인 페이지로 다시 이동
        }

        // 세션에 저장
        session.setAttribute("loginManager", manager);
        session.setAttribute("loginId", loginId);
        session.setAttribute("role", manager.getRole());
        return "redirect:/warehousemanager";
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
        long staffId = managerService.findManagerIdByManagerLoginId(id);
        StaffDTO staffDTO = managerService.getManagerDetails(staffId);

        // 세션에 저장하고 모델로 넘김
        session.setAttribute("loginManager", staffDTO);
        model.addAttribute("loginManager", staffDTO);
        return "warehousemanager/mypage";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // 세션 무효화
        return "redirect:/login"; // 로그인 페이지로 리다이렉트
    }

}
