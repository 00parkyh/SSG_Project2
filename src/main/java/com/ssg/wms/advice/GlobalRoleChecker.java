package com.ssg.wms.advice;

import com.ssg.wms.common.Role;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@ControllerAdvice
public class GlobalRoleChecker {
    @ModelAttribute
    public void checkAdminAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String uri = request.getRequestURI();
        HttpSession session = request.getSession(false);

        if (uri.equals("/admin/login")) return;

        // /admin 경로에 접근하는데 ADMIN이 아닌 경우 차단
        if (uri.contains("/admin") || uri.contains("/dashboard")) {
            Role role = (Role) session.getAttribute("role");

            if (session == null || session.getAttribute("role") == null) {
                response.sendRedirect("/login");
            } else if (role != Role.ADMIN) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "관리자만 접근 가능합니다.");
            }
        }

    }

    @ModelAttribute
    public void checkManagerAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String uri = request.getRequestURI();
        HttpSession session = request.getSession(false);

        if (uri.equals("/warehousemanager/login")) return;

        if (uri.startsWith("/warehousemanager")) {
            Role role = (Role) session.getAttribute("role");

            if (session == null || session.getAttribute("role") == null) {
                response.sendRedirect("/login");
            } else if (role != Role.MANAGER) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "창고관리자 전용 페이지입니다.");
            }
        }
    }

    @ModelAttribute
    public void checkMemberAccess(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String uri = request.getRequestURI();
        HttpSession session = request.getSession(false);

        if ((uri.equals("/member/login")) || (uri.equals("/member/register"))) return;

        if (uri.startsWith("/member")) {
            Role role = (Role) session.getAttribute("role");

            if (session == null || session.getAttribute("role") == null) {
                response.sendRedirect("/login");
            } else if (role != Role.MEMBER) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "회원 전용 페이지입니다.");
            }
        }
    }
}
