package com.ssg.wms.config;

import com.ssg.wms.common.Role;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Arrays;
import java.util.List;

@Log4j2
public class RoleCheckInterceptor implements HandlerInterceptor {
    private final List<String> allowedRoles;

    // 생성자로 허용할 역할 목록을 주입
    public RoleCheckInterceptor(String... roles) {
        log.info("RoleCheckInterceptor: " + Arrays.toString(roles));
        this.allowedRoles = Arrays.asList(roles);
    }

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        HttpSession session = request.getSession(false);
        log.info("preHandle: " + session);

        if (session == null || session.getAttribute("role") == null) {
            log.info("session == null, /login redirected");
            response.sendRedirect("/login");
            return false;
        }

        Role role = (Role) session.getAttribute("role");
        String uri = request.getRequestURI();
        log.info("요청 URI: {}, 사용자 권한: {}", uri, role);

        if (!allowedRoles.contains(role.name())) {
            log.info("권한 없음: {}", role);
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
            return false;
        }

        return true;
    }
}
