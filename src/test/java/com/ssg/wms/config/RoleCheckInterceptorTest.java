package com.ssg.wms.config;

import com.ssg.wms.common.Role;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.mock.web.MockHttpSession;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class RoleCheckInterceptorTest {

    private final RoleCheckInterceptor interceptor = new RoleCheckInterceptor("ADMIN", "MANAGER", "MEMBER");

    @Test
    void redirectsToLoginWhenSessionExpired() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/mgr/warehouses/location");
        MockHttpServletResponse response = new MockHttpServletResponse();

        boolean result = interceptor.preHandle(request, response, new Object());

        assertFalse(result);
        assertEquals("/login", response.getRedirectedUrl());
    }

    @Test
    void allowsLoginPageWithoutSession() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/login");
        MockHttpServletResponse response = new MockHttpServletResponse();

        boolean result = interceptor.preHandle(request, response, new Object());

        assertTrue(result);
    }

    @Test
    void allowsLogoutWithoutSession() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/logout");
        MockHttpServletResponse response = new MockHttpServletResponse();

        boolean result = interceptor.preHandle(request, response, new Object());

        assertTrue(result);
    }

    @Test
    void allowsManagerLoginPostWithoutSession() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest("POST", "/warehousemanager");
        MockHttpServletResponse response = new MockHttpServletResponse();

        boolean result = interceptor.preHandle(request, response, new Object());

        assertTrue(result);
    }

    @Test
    void allowsAuthenticatedRequest() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/mgr/warehouses/location");
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("role", Role.MANAGER);
        request.setSession(session);
        MockHttpServletResponse response = new MockHttpServletResponse();

        boolean result = interceptor.preHandle(request, response, new Object());

        assertTrue(result);
    }

    @Test
    void deniesMemberAccessToAdminPath() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/admin/dashboard");
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("role", Role.MEMBER);
        request.setSession(session);
        MockHttpServletResponse response = new MockHttpServletResponse();

        boolean result = interceptor.preHandle(request, response, new Object());

        assertFalse(result);
        assertEquals(403, response.getStatus());
    }

    @Test
    void deniesAdminAccessToManagerPath() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/mgr/warehouses");
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("role", Role.ADMIN);
        request.setSession(session);
        MockHttpServletResponse response = new MockHttpServletResponse();

        boolean result = interceptor.preHandle(request, response, new Object());

        assertFalse(result);
        assertEquals(403, response.getStatus());
    }

    @Test
    void allowsAdminAndManagerAccessToStockPath() throws Exception {
        MockHttpServletRequest adminRequest = new MockHttpServletRequest("GET", "/physical-inventory");
        MockHttpSession adminSession = new MockHttpSession();
        adminSession.setAttribute("role", Role.ADMIN);
        adminRequest.setSession(adminSession);

        MockHttpServletRequest managerRequest = new MockHttpServletRequest("GET", "/physical-inventory");
        MockHttpSession managerSession = new MockHttpSession();
        managerSession.setAttribute("role", Role.MANAGER);
        managerRequest.setSession(managerSession);

        assertTrue(interceptor.preHandle(adminRequest, new MockHttpServletResponse(), new Object()));
        assertTrue(interceptor.preHandle(managerRequest, new MockHttpServletResponse(), new Object()));
    }

    @Test
    void allowsAdminAndManagerAccessToProductListPath() throws Exception {
        assertAllowed("/productList/plist", Role.ADMIN);
        assertAllowed("/productList/plist", Role.MANAGER);
    }

    @Test
    void deniesMemberAccessToProductListPath() throws Exception {
        assertForbidden("/productList/plist", Role.MEMBER);
    }

    @Test
    void allowsOnlyAdminAccessToPartnerPath() throws Exception {
        assertAllowed("/partner", Role.ADMIN);
        assertForbidden("/partner", Role.MANAGER);
        assertForbidden("/partner", Role.MEMBER);
    }

    @Test
    void allowsEveryAuthenticatedRoleToCommonBoardPaths() throws Exception {
        assertAllowed("/announcements", Role.ADMIN);
        assertAllowed("/announcements", Role.MANAGER);
        assertAllowed("/announcements", Role.MEMBER);

        assertAllowed("/inquiries", Role.ADMIN);
        assertAllowed("/inquiries", Role.MANAGER);
        assertAllowed("/inquiries", Role.MEMBER);

        assertAllowed("/api/inquiries/1/replies", Role.ADMIN);
        assertAllowed("/api/inquiries/1/replies", Role.MANAGER);
        assertAllowed("/api/inquiries/1/replies", Role.MEMBER);
    }

    @Test
    void deniesUnmappedAuthenticatedPathByDefault() throws Exception {
        assertForbidden("/unmapped/path", Role.ADMIN);
        assertForbidden("/unmapped/path", Role.MANAGER);
        assertForbidden("/unmapped/path", Role.MEMBER);
    }

    @Test
    void resolvesStringRoleFromSession() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/productList/plist");
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("role", "MANAGER");
        request.setSession(session);
        MockHttpServletResponse response = new MockHttpServletResponse();

        boolean result = interceptor.preHandle(request, response, new Object());

        assertTrue(result);
    }

    private void assertAllowed(String path, Role role) throws Exception {
        MockHttpServletRequest request = authenticatedRequest(path, role);
        MockHttpServletResponse response = new MockHttpServletResponse();

        boolean result = interceptor.preHandle(request, response, new Object());

        assertTrue(result);
    }

    private void assertForbidden(String path, Role role) throws Exception {
        MockHttpServletRequest request = authenticatedRequest(path, role);
        MockHttpServletResponse response = new MockHttpServletResponse();

        boolean result = interceptor.preHandle(request, response, new Object());

        assertFalse(result);
        assertEquals(403, response.getStatus());
    }

    private MockHttpServletRequest authenticatedRequest(String path, Role role) {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", path);
        MockHttpSession session = new MockHttpSession();
        session.setAttribute("role", role);
        request.setSession(session);
        return request;
    }
}
