package com.ssg.wms.outbound.mappers;

import com.ssg.wms.outbound.domain.dto.OutboundItemDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface OutboundItemMapper {

    //출고품목 추가
    void insertOutboundItem(OutboundItemDTO outboundItemDTO);
    //특정 출고요청에 대한 품목 목록 조회
    List<OutboundItemDTO> selectOutboundItemsByRequestId(@Param("outboundRequestID") Long outboundRequestID);
    //출고품목 수정 (수량 등)
    int updateOutboundItem(@Param("outboundItemDTO") OutboundItemDTO outboundItemDTO,
                           @Param("outboundRequestID") Long outboundRequestID);

    // 특정 출고품목 삭제
    int deleteOutboundItem(@Param("outboundItemId") Long outboundItemId);

    //특정 출고요청의 품목 전체 삭제 (출고요청 삭제 시 사용)
    int deleteOutboundItemsByRequestId(@Param("outboundRequestID") Long outboundRequestID);
}



