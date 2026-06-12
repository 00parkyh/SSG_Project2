package com.ssg.wms.common;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("")
@RequiredArgsConstructor
@Log4j2
public class CommonController {

    @GetMapping("/")
    public String root() {
        log.info("Root URL (/) accessed. Redirecting to /login...");
        return "redirect:/login"; // 👈 사용자님이 요청하신 /login으로 수정
    }

    @GetMapping("/login")
    public String getMemberLogin() {
        // 로그인 화면(권한별로 분기 시작)
        return "/login"; // views/login.jsp
    }
    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session != null) {
            session.invalidate();
        }

        return "redirect:/login";
    }
}
