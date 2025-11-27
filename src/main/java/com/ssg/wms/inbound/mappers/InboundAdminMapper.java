package com.ssg.wms.inbound.mappers;

import com.ssg.wms.inbound.dto.InboundDTO;
import com.ssg.wms.inbound.dto.InboundListDTO;
import com.ssg.wms.inbound.dto.InboundRequestDTO;
import com.ssg.wms.inbound.dto.InboundWarehouseDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface InboundAdminMapper {

    // 리스트 조회
    List<InboundListDTO> selectInboundListByPartner(@Param("partnerId") Long partnerId, @Param("inboundStatus") String status);

    // 단건 조회
    InboundDTO selectInboundWithItems(int inboundId);

    // 입고 요청 승인
    int approveInboundStatus(@Param("inboundId") Long inboundId,
                             @Param("warehouseId") Long warehouseId);

    // 입고 승인에 쓰일 창고 리스트 조회
    List<InboundWarehouseDTO> selectWarehouseName();

    // 입고 요청 리젝
    int updateInboundStatusRejected(
            @Param("inboundId") Long inboundId,
            @Param("reason") String reason
    );



}
