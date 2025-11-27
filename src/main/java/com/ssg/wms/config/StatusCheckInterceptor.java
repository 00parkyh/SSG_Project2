package com.ssg.wms.config;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Arrays;
import java.util.List;

@Component
public class StatusCheckInterceptor implements HandlerInterceptor {
    private final List<String> disallowedStatus;

    // 생성자로 허용할 역할 목록을 주입
    public StatusCheckInterceptor(String... status) {
        this.disallowedStatus = Arrays.asList(status);
    }

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("/login");
            return false;
        }

        String status = (String) session.getAttribute("status");

        // 비허용된 권한에 포함되는지 검사
        if (disallowedStatus.contains(status)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "비활성화된 계정입니다.");
            return false;
        }

        return true;
    }
}
