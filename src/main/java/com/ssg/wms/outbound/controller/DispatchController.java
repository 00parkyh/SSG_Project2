package com.ssg.wms.outbound.controller;

import com.ssg.wms.common.Role;
import com.ssg.wms.outbound.domain.Criteria;
import com.ssg.wms.outbound.domain.dto.DispatchDTO;
import com.ssg.wms.outbound.service.DispatchService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@RestController
@RequestMapping("/admin/dispatches")
@RequiredArgsConstructor
@Log4j2
public class DispatchController {

    private final DispatchService dispatchService;

    /** 로그인 여부 체크 */
    private boolean isLoggedIn(HttpSession session) {

        return session.getAttribute("loginId") != null;
    }

    /** ADMIN 권한 체크 */
    private boolean isAdmin(HttpSession session) {
        Object role = session.getAttribute("role");
        return role != null && role.equals(Role.ADMIN);
    }

    /** 공통 권한 체크 */
    private ResponseEntity<?> validateAdmin(HttpSession session) {
        if (!isLoggedIn(session)) {
            return ResponseEntity.status(401).body("로그인이 필요합니다.");
        }
        if (!isAdmin(session)) {
            return ResponseEntity.status(403).body("접근 권한이 없습니다.");
        }
        return null; // 통과
    }


    // ================================================
    // 🔵 1. 배차 목록 조회
    // ================================================
    @GetMapping
    public ResponseEntity<?> getDispatchList(
            HttpSession session,
            Criteria criteria,
            @RequestParam(required = false) String driverName) {

        ResponseEntity<?> accessCheck = validateAdmin(session);
        if (accessCheck != null) return accessCheck;

        log.info("배차 목록 조회 요청 - driverName={}", driverName);

        List<DispatchDTO> dispatchList = dispatchService.getDispatchList(criteria, driverName);
        return ResponseEntity.ok(dispatchList);
    }


    // ================================================
    // 🔵 2. 배차 상세 조회
    // ================================================
    @GetMapping("/{dispatchId}")
    public ResponseEntity<?> getDispatchDetail(
            @PathVariable Long dispatchId,
            HttpSession session) {

        ResponseEntity<?> accessCheck = validateAdmin(session);
        if (accessCheck != null) return accessCheck;

        log.info("배차 상세 조회 요청 - Dispatch ID: {}", dispatchId);

        DispatchDTO detail = dispatchService.getDispatchDetailById(dispatchId);

        if (detail == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(detail);
    }


    // ================================================
    // 🔵 3. 배차 수정
    // ================================================
    @PutMapping("/{dispatchId}")
    public ResponseEntity<?> updateDispatch(
            @PathVariable Long dispatchId,
            @RequestBody DispatchDTO dispatchDTO,
            HttpSession session) {

        ResponseEntity<?> accessCheck = validateAdmin(session);
        if (accessCheck != null) return accessCheck;

        log.info("배차 수정 요청 - ID: {}", dispatchId);

        dispatchDTO.setDispatchId(dispatchId);
        dispatchService.updateDispatchInformation(dispatchDTO);

        return ResponseEntity.ok().build();
    }


    // ================================================
    // 🔵 4. 기사 목록 조회 (ADMIN 전용)
    // ================================================
    @GetMapping("/drivers")
    public ResponseEntity<?> getDrivers(HttpSession session) {

        ResponseEntity<?> accessCheck = validateAdmin(session);
        if (accessCheck != null) return accessCheck;

        List<DispatchDTO> drivers = dispatchService.getDistinctDrivers();
        return ResponseEntity.ok(drivers);
    }
}
