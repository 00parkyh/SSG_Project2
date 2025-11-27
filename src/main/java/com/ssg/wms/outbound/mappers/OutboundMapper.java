package com.ssg.wms.outbound.mappers;


import com.ssg.wms.outbound.domain.Criteria;
import com.ssg.wms.outbound.domain.dto.OutboundDTO;
import com.ssg.wms.outbound.domain.dto.OutboundItemDTO;
import com.ssg.wms.outbound.domain.dto.OutboundOrderDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface OutboundMapper {

    void insertOutboundRequest(OutboundDTO outboundDTO);



    // 출고 요청 리스트 전체조회 (서비스 allShipments와 연결)
    List<OutboundDTO> selectAllShipment(       @Param("memberId") Long memberId,
                                                @Param("status") String status);


    // 출고 요청 목록 조회 (서비스 getRequestByUserId와 연결)

    List<OutboundDTO> selectOutboundRequestByUserId(@Param("memberId") Long memberId,
                                                    @Param("status") String status);


    // 출고 요청 상세 조회 (서비스 getRequestDetailById와 연결)
    List<OutboundDTO> getRequestDetailByUser(@Param("outboundRequestId") Long outboundRequestId,
                                             @Param("memberId") Long memberId);

    

    // 3-1. 출고요청 메인정보 수정 (서비스 updateRequest의 메인 UPDATE)
    int updateOutboundRequestMain(@Param("outboundRequestId") Long outboundRequestId,
                                  @Param("memberId") Long memberId,
                                  @Param("dto") OutboundDTO dto);


    // 3-2. 출고 품목 개별 수정 (서비스 updateRequest의 반복문 내 UPDATE)
    int updateOutboundItem(@Param("item") OutboundItemDTO item,
                           @Param("outboundRequestId") Long outboundRequestId);


    // 출고지시서 상태 조회 (승인 여부 확인용)
    String getOutboundOrderStatusByRequestId(Long outboundRequestId);


    // 1️⃣ 출고 지시서 삭제 (자식 테이블)
    int deleteShipmentOrder(@Param("outboundRequestId") Long outboundRequestId);

    // 2️⃣ 출고 품목 삭제 (자식 테이블)
    int deleteOutboundItemsByRequestId(@Param("outboundRequestId") Long outboundRequestId);

    // 3️⃣ 출고 요청 삭제 (부모 테이블)
    int deleteRequest(@Param("outboundRequestId") Long outboundRequestId,
                      @Param("memberId") Long memberId);

    int deleteWaybillByRequestId(@Param("outboundRequestId")Long outboundRequestId);
    int deleteDispatchByRequestId(@Param("outboundRequestId") Long outboundRequestId);



    // ✅ 출고요청 후 출고지시서 자동 생성
    void insertOutboundOrderAfterRequest(OutboundOrderDTO order);


    List<OutboundItemDTO> getOutboundRequestItems(@Param("outboundRequestId") Long outboundRequestId);
}
