package com.ssg.wms.inbound.mappers;

import com.ssg.wms.inbound.domain.InboundItemVO;
import com.ssg.wms.inbound.domain.InboundVO;
import com.ssg.wms.inbound.dto.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface InboundMemberMapper {

    // 입고 요청
    int insertInbound(InboundVO inboundVO);
    void insertInboundItem(InboundItemVO item);

    // 입고 요청 목록 조회 (사용자용 - 브랜드, 상태 파라미터로 받아서 검색)
    List<InboundListDTO> selectInboundListByPartner(@Param("memberId") Long memberId, @Param("inboundStatus") String status);

    // 입고 요청 단건 조회
    InboundDTO selectInboundWithItems(int inboundId);

    // 입고 수정시 출력해줄 입고 상세DTO
    InboundDetailDTO selectInboundWithItemsDetail(int inboundId);

    // 입고 요청 수정
    // 입고 기본 정보 수정
    void updateInbound(InboundRequestDTO dto);
    // 기존 상품 삭제
    void deleteInboundItems(int inboundId);
    // 상품 목록 batch insert
    void insertInboundItemsBatch(List<InboundRequestItemDTO> items);

    // 입고 요청 취소
    int cancelInbound(int inboundId);
    // 입고 요청 취소시 FK제약조건으로 인하여 재고테이블에 해당 입고품목 아이템이 있다면 삭제
    int cancelInboundItems(int inboundId);

}
