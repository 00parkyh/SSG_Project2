package com.ssg.wms.inbound.service;

import com.ssg.wms.inbound.dto.InboundDTO;
import com.ssg.wms.inbound.dto.InboundListDTO;
import com.ssg.wms.inbound.dto.InboundWarehouseDTO;
import com.ssg.wms.product_ehs.dto.ProductDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface InboundAdminService {

    // 입고 요청 목록 조회 (관리자용 - 브랜드, 상태 파라미터로 받아서 검색)
    List<InboundListDTO> getInboundListByPartner(Long memberId, String status);

    // 입고 요청 단건 조회
    InboundDTO getInboundById(int inboundId);

    // 입고 요청 승인
    @Transactional
    boolean approveInbound(Long inboundId, Long warehouseId);

    List<InboundWarehouseDTO> getWarehouseList();

    // 입고 요청 반려
    @Transactional
    void rejectInbound(Long inboundId, String reason);
}
