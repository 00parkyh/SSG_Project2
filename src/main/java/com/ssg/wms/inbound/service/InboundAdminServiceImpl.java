package com.ssg.wms.inbound.service;

import com.ssg.wms.inbound.dto.InboundDTO;
import com.ssg.wms.inbound.dto.InboundListDTO;
import com.ssg.wms.inbound.dto.InboundWarehouseDTO;
import com.ssg.wms.inbound.mappers.InboundAdminMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Primary
public class InboundAdminServiceImpl implements InboundAdminService {

    @Autowired
    private InboundAdminMapper inboundAdminMapper;

     // 입고 요청 목록 조회 (관리자용 - 브랜드, 상태 파라미터로 받아서 검색)
     @Override
     public List<InboundListDTO> getInboundListByPartner(Long partnerId, String status){
         return inboundAdminMapper.selectInboundListByPartner(partnerId, status);
     }

    // 입고 요청 단건 조회
    @Override
    public InboundDTO getInboundById(int inboundId) {
        return inboundAdminMapper.selectInboundWithItems(inboundId);
    }

    // 입고 요청 승인
    @Transactional
    @Override
    public boolean approveInbound(Long inboundId, Long warehouseId) {
        int result = inboundAdminMapper.approveInboundStatus(inboundId, warehouseId);
        return result > 0;
    }

    // 요청 승인에 쓰일 창고 리스트
    @Override
    public List<InboundWarehouseDTO> getWarehouseList() {
        return inboundAdminMapper.selectWarehouseName();
    }

    // 입고 요청 반려
    @Transactional
    @Override
    public void rejectInbound(Long inboundId, String reason) {
        inboundAdminMapper.updateInboundStatusRejected(inboundId, reason);
    }


}
