package com.ssg.wms.common;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("")
@RequiredArgsConstructor
@Log4j2
public class CommonController {

    /**
     * [신규 추가 또는 수정]
     * 루트 URL ("/") 접근 시 /login (권한 선택) 페이지로 리다이렉트
     */
    @GetMapping("/")
    public String root() {
        log.info("Root URL (/) accessed. Redirecting to /login...");
        return "redirect:/login"; // 👈 사용자님이 요청하신 /login으로 수정
    }

    /**
     * (기존 코드)
     * /login URL은 권한별 로그인 선택 페이지로 이동
     */
    @GetMapping("/login")
    public String getMemberLogin() {
        // 로그인 화면(권한별로 분기 시작)
        return "/login"; // views/login.jsp
    }
}