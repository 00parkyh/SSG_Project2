package com.ssg.wms.config;

import com.ssg.wms.common.Role;
import lombok.extern.log4j.Log4j2;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Arrays;
import java.util.List;

@Log4j2
public class RoleCheckInterceptor implements HandlerInterceptor {
    private final List<String> allowedRoles;

    public RoleCheckInterceptor(String... roles) {
        log.info("RoleCheckInterceptor: " + Arrays.toString(roles));
        this.allowedRoles = Arrays.asList(roles);
    }

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        if (isPublicRequest(request)) {
            return true;
        }

        HttpSession session = request.getSession(false);
        log.info("preHandle: {}", session);

        if (session == null || session.getAttribute("role") == null) {
            log.info("No authenticated session. Redirecting to /login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        Role role = resolveRole(session.getAttribute("role"));
        if (role == null) {
            log.info("Invalid role in session. Redirecting to /login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        String uri = request.getRequestURI();
        log.info("Request URI: {}, role: {}", uri, role);

        if (!isAllowedRole(request, role)) {
            log.info("Access denied: {}", role);
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
            return false;
        }

        return true;
    }

    private boolean isPublicRequest(HttpServletRequest request) {
        String path = getRequestPath(request);
        String method = request.getMethod();

        return path.equals("/")
                || path.equals("/login")
                || path.equals("/logout")
                || path.equals("/admin/login")
                || path.equals("/warehousemanager/login")
                || (path.equals("/warehousemanager") && "POST".equalsIgnoreCase(method))
                || path.equals("/member/login")
                || path.equals("/member/register")
                || path.startsWith("/resources/")
                || path.startsWith("/static/")
                || path.startsWith("/error/")
                || path.equals("/favicon.ico");
    }

    private Role resolveRole(Object roleValue) {
        if (roleValue instanceof Role) {
            return (Role) roleValue;
        }

        if (roleValue instanceof String) {
            try {
                return Role.valueOf((String) roleValue);
            } catch (IllegalArgumentException ignored) {
                return null;
            }
        }

        return null;
    }

    private boolean isAllowedRole(HttpServletRequest request, Role role) {
        String path = getRequestPath(request);

        if (path.startsWith("/admin")
                || path.startsWith("/dashboard")
                || path.startsWith("/sales")
                || path.startsWith("/expense")
                || path.startsWith("/inbound/admin")
                || path.startsWith("/admin/outbound")
                || path.startsWith("/admin/waybills")
                || path.startsWith("/admin/dispatches")
                || path.startsWith("/partner")){
            return role == Role.ADMIN;
        }

        if (path.startsWith("/warehousemanager") || path.startsWith("/mgr")) {
            return role == Role.MANAGER;
        }

        if (path.startsWith("/member")) {
            return role == Role.MEMBER;
        }

        if (path.startsWith("/stock") || path.startsWith("/physical-inventory") || path.startsWith("/productList")) {
            return role == Role.ADMIN || role == Role.MANAGER;
        }

        if (path.startsWith("/inbound/member") || path.startsWith("/member/outbound")) {
            return role == Role.MEMBER;
        }
        if (path.startsWith("/announcements")
                || path.startsWith("/inquiries")
                || path.startsWith("/api/inquiries")) {
            return role == Role.ADMIN || role == Role.MANAGER || role == Role.MEMBER;
        }

        return false ;
    }

    private String getRequestPath(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        return contextPath != null && !contextPath.isEmpty() && uri.startsWith(contextPath)
                ? uri.substring(contextPath.length())
                : uri;
    }
}
