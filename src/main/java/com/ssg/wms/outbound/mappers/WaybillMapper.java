package com.ssg.wms.outbound.mappers;


import com.ssg.wms.outbound.domain.Criteria;
import com.ssg.wms.outbound.domain.dto.OutboundOrderDTO;
import com.ssg.wms.outbound.domain.dto.WaybillDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface WaybillMapper {

    // 운송장 번호로 운송장 단건 조회
    WaybillDTO getWaybillById(@Param("waybillNumber") String waybillNumber);

    // 운송장 목록 조회 (검색, 페이징 포함)
    List<WaybillDTO> getWaybills(@Param("criteria") Criteria criteria, @Param("search") String search);

    //  운송장 정보입력
    void insertWaybill(OutboundOrderDTO outboundOrderDTO);

    // UPDATE 쿼리 호출을 위한 메서드 추가
    void updateWaybill(WaybillDTO dto);

    //QR코드용 조회
    WaybillDTO getWaybillByNumber(@Param("waybillNumber") String waybillNumber);
}
