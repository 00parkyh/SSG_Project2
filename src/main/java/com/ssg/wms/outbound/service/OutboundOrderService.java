package com.ssg.wms.outbound.service;


//출고리스트 전체 조회
//출고지시리스트 / 출고리스트
//출고 요청 상세
//출고 요청 상태 수정 (approve/fail 기능을 통합 및 PATCH로 변경)


import com.ssg.wms.outbound.domain.Criteria;
import com.ssg.wms.outbound.domain.dto.OutboundOrderDTO;

import java.util.List;

public interface OutboundOrderService {
    List<OutboundOrderDTO> getAllRequests(Criteria criteria, String search);
    List<OutboundOrderDTO> getFilteredOrders(Criteria criteria, String filterType, String searchValue);
    OutboundOrderDTO getRequestDetailById(Long approvedOrderId);
    void updateOrderStatus(OutboundOrderDTO outboundOrderDTO);

}
