package com.ssg.wms.outbound.service;


import com.ssg.wms.outbound.domain.Criteria;
import com.ssg.wms.outbound.domain.OutboundStatus;
import com.ssg.wms.outbound.domain.dto.OutboundDTO;
import com.ssg.wms.outbound.domain.dto.OutboundItemDTO;
import com.ssg.wms.outbound.domain.dto.OutboundOrderDTO;
import com.ssg.wms.outbound.mappers.OutboundItemMapper;
import com.ssg.wms.outbound.mappers.OutboundMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
@Log4j2
public class OutboundServiceImpl implements OutboundService {

    private final OutboundMapper outboundMapper;
    private final OutboundItemMapper outboundItemMapper;

    /**
     * 출고요청 생성
     */
    @Override
    @Transactional
    public OutboundDTO createOutboundRequest(OutboundDTO dto, Long memberId) {
        dto.setMemberId(memberId);
        dto.setOutboundDate(LocalDate.now());
        dto.setApprovedStatus("승인대기");
        dto.setWarehouseId(dto.getWarehouseId());

        // ✅ 2. 출고요청 등록 (outboundRequest)
        outboundMapper.insertOutboundRequest(dto);
        log.info("✅ 출고요청 등록 완료 - outboundRequestId={}", dto.getOutboundRequestId());

        // ✅ 3. 품목 등록 (outboundItem)
        if (dto.getOutboundRequestItems() != null && !dto.getOutboundRequestItems().isEmpty()) {
            for (OutboundItemDTO item : dto.getOutboundRequestItems()) {
                item.setOutboundRequestId(dto.getOutboundRequestId());
                outboundItemMapper.insertOutboundItem(item);
            }
            log.info("✅ 출고요청 품목 {}개 등록 완료", dto.getOutboundRequestItems().size());
        }

        // ✅ 4. 출고지시서 자동 생성 (outboundOrder)
        OutboundOrderDTO order = new OutboundOrderDTO();
        order.setOutboundRequestID(dto.getOutboundRequestId()); // FK 설정
        outboundMapper.insertOutboundOrderAfterRequest(order);
        log.info("🚚 출고지시서 자동 생성 완료 (approvedOrder 생성) ID={}", order.getApprovedOrderID());

        return dto;
    }
    /**
     * 특정 사용자 출고 요청 목록 조회
     */
    @Override
    public List<OutboundDTO> getRequestsByUserId(Long memberId, String status) {
        // 한글 → 영어 변환
        if (status != null && !status.isEmpty()) {
            OutboundStatus enumStatus = OutboundStatus.fromKorean(status);
            if (enumStatus != null) {
                status = enumStatus.name(); // "승인" → "APPROVED"
            }
        }
        return outboundMapper.selectOutboundRequestByUserId(memberId, status);
    }

    /**
     * 전체 출고 요청 목록 조회
     */
    @Override
    public List<OutboundDTO> allOutboundRequests(Long memberId, String status) {
        log.info("🔍 Service - memberId: {}, status: {}", memberId, status);

        // 한글 → 영어 변환
        if (status != null && !status.isEmpty()) {
            OutboundStatus enumStatus = OutboundStatus.fromKorean(status);
            if (enumStatus != null) {
                status = enumStatus.name(); // "승인" → "APPROVED"
            }
        }

        List<OutboundDTO> list = outboundMapper.selectAllShipment(memberId, status);

        log.info("🔍 Mapper에서 반환된 데이터 개수: {}", list.size());

        if (!list.isEmpty()) {
            OutboundDTO first = list.get(0);
            log.info("🔍 첫 번째 데이터 - ID: {}, 브랜드: {}, 요청자: {}",
                    first.getOutboundRequestId(),
                    first.getBrandName(),
                    first.getRequestUserName());
        }

        return list;
    }

    /**
     * 출고 요청 상세 조회
     */
    @Override
    public OutboundDTO getRequestDetailById(Long outboundRequestId, Long memberId) {
        // ✅ 1. 메인 정보 조회 (단건 → 다건으로 변경)
        List<OutboundDTO> resultList = outboundMapper.getRequestDetailByUser(outboundRequestId, memberId);

        if (resultList == null || resultList.isEmpty()) {
            log.warn("⚠️ 출고요청 데이터 없음 - requestId={}, memberId={}", outboundRequestId, memberId);
            return null;
        }

        // ✅ 동일 출고요청에 여러 운송장이나 배차 데이터가 있을 수 있으므로 첫 번째만 사용
        OutboundDTO outbound = resultList.get(0);

        // ✅ 2. 품목 리스트 조회
        List<OutboundItemDTO> items = outboundMapper.getOutboundRequestItems(outboundRequestId);
        if (items == null || items.isEmpty()) {
            log.info("ℹ️ 품목 데이터 없음 - requestId={}", outboundRequestId);
        }

        outbound.setOutboundRequestItems(items);
        return outbound;
    }

    /**
     * 출고 요청 수정
     */
    @Override
    @Transactional
    public void updateRequest(Long outboundRequestId, Long memberId, OutboundDTO dto) {
        String approveStatus = outboundMapper.getOutboundOrderStatusByRequestId(outboundRequestId);

        if ("APPROVED".equalsIgnoreCase(approveStatus)) {
            throw new IllegalStateException("이미 승인된 출고요청은 수정할 수 없습니다.");
        }

        outboundMapper.updateOutboundRequestMain(outboundRequestId, memberId, dto);

        if (dto.getOutboundRequestItems() != null) {
            for (OutboundItemDTO item : dto.getOutboundRequestItems()) {
                outboundMapper.updateOutboundItem(item, outboundRequestId);
            }
        }
    }

    /**
     * 출고 요청 삭제
     */
    @Override
    @Transactional
    public boolean deleteRequest(Long outboundRequestId, Long memberId) {
        log.info("출고 요청 삭제 시작 - outboundRequestId: {}, memberId: {}", outboundRequestId, memberId);

        // 현재 승인 상태 조회
        String approvedStatus = outboundMapper.getOutboundOrderStatusByRequestId(outboundRequestId);

        // ✅ 승인된 요청은 삭제 금지
        if ("APPROVED".equalsIgnoreCase(approvedStatus)) {
            log.warn("승인된 출고요청은 삭제할 수 없습니다. (outboundRequestId={})", outboundRequestId);
            throw new IllegalStateException("승인된 출고요청은 삭제할 수 없습니다.");
        }

        // 1️⃣ 운송장 → 배차 → 출고지시서 → 품목 → 요청 순으로 삭제
        outboundMapper.deleteWaybillByRequestId(outboundRequestId);
        outboundMapper.deleteDispatchByRequestId(outboundRequestId);
        outboundMapper.deleteShipmentOrder(outboundRequestId);
        outboundMapper.deleteOutboundItemsByRequestId(outboundRequestId);
        int deleted = outboundMapper.deleteRequest(outboundRequestId, memberId);

        if (deleted == 0) {
            log.warn("❌ 삭제 실패: 해당 출고요청이 존재하지 않음");
            return false;
        }

        log.info("✅ 출고 요청 삭제 완료");
        return true;
    }

}