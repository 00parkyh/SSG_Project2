package com.ssg.wms.outbound.controller;

import com.ssg.wms.common.Role;
import com.ssg.wms.outbound.domain.Criteria;
import com.ssg.wms.outbound.domain.dto.WaybillDTO;
import com.ssg.wms.outbound.service.WaybillService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@RestController
@RequestMapping("/admin/waybills")
@RequiredArgsConstructor
@Log4j2
public class WaybillController {

    private final WaybillService waybillService;

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
        return null; // 정상 접근
    }


    // ================================================
    // 🔵 1. 운송장 리스트 조회
    // ================================================
    @GetMapping
    public ResponseEntity<?> getWaybillList(
            HttpSession session,
            Criteria criteria,
            @RequestParam(required = false) String search) {

        // 관리자 체크
        ResponseEntity<?> accessCheck = validateAdmin(session);
        if (accessCheck != null) return accessCheck;

        log.info("운송장 리스트 조회: search={}", search);

        List<WaybillDTO> list = waybillService.getWaybillList(criteria, search);
        return ResponseEntity.ok(list);
    }


    // ================================================
    // 🔵 2. 운송장 수정
    // ================================================
    @PutMapping("/{waybillId}")
    public ResponseEntity<?> updateWaybill(
            @PathVariable Long waybillId,
            @RequestBody WaybillDTO dto,
            HttpSession session) {

        ResponseEntity<?> accessCheck = validateAdmin(session);
        if (accessCheck != null) return accessCheck;

        log.info("운송장 정보 수정 요청 - ID: {}", waybillId);

        dto.setWaybillId(waybillId);
        waybillService.updateWaybill(dto);

        return ResponseEntity.ok().build();
    }


    // ================================================
    // 🔵 3. 운송장 상세 조회
    // ================================================
    @GetMapping("/{waybillNumber}")
    public ResponseEntity<?> getWaybillDetail(
            @PathVariable String waybillNumber,
            HttpSession session) {

        ResponseEntity<?> accessCheck = validateAdmin(session);
        if (accessCheck != null) return accessCheck;

        log.info("운송장 상세 조회 요청: Waybill Number={}", waybillNumber);

        WaybillDTO dto = waybillService.getWaybillByNumber(waybillNumber);

        if (dto == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(dto);
    }
}
