package com.ssg.wms.outbound.service;


import com.ssg.wms.outbound.domain.Criteria;
import com.ssg.wms.outbound.domain.dto.DispatchDTO;
import com.ssg.wms.outbound.domain.dto.OutboundOrderDTO;
import com.ssg.wms.outbound.mappers.DispatchMapper;
import com.ssg.wms.outbound.mappers.OutboundOrderMapper;
import com.ssg.wms.outbound.mappers.WaybillMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Log4j2
public class OutboundOrderServiceImpl implements OutboundOrderService {


    private final OutboundOrderMapper outboundOrderMapper;
    private final DispatchMapper dispatchMapper;
    private final WaybillMapper waybillMapper;


    @Override
    public List<OutboundOrderDTO> getAllRequests(Criteria criteria, String search) {
        log.info("출고지시서 전체 조회 요청: {}", search);
        return outboundOrderMapper.getAllOrders(criteria, search);
    }

    @Override
    public List<OutboundOrderDTO> getFilteredOrders(Criteria criteria, String filterType, String searchValue) {
        log.info("출고지시서 조건 조회: 필터 타입={}, 값={}", filterType, searchValue);
        return outboundOrderMapper.getFilteredOrders(criteria, filterType, searchValue);
    }

    @Override
    public OutboundOrderDTO getRequestDetailById(Long approvedOrderId) {
        log.info("출고지시서 상세 조회 요청: approvedOrderId={}", approvedOrderId);
        OutboundOrderDTO outboundOrderDTO = outboundOrderMapper.getOrderDetailById(approvedOrderId);

        if (outboundOrderDTO == null) {
            throw new RuntimeException("출고지시서 ID를 찾을 수 없습니다: " + approvedOrderId);
        }
        return outboundOrderDTO;
    }

    @Override
    @Transactional
    public void updateOrderStatus(OutboundOrderDTO outboundOrderDTO) {
        log.info("✅ 출고지시서 상태 변경 시작");
        log.info("✅ 데이터: {}", outboundOrderDTO);

            // ✅ 1. 출고지시서 상태 업데이트
            int updatedOrder = outboundOrderMapper.updateOrderStatus(outboundOrderDTO);
            log.info("✅ 출고지시서 업데이트 완료: {} rows", updatedOrder);

            // ✅ 2. 출고요청 상태 업데이트
            int updatedRequest = outboundOrderMapper.updateOutboundRequestStatus(
                    outboundOrderDTO.getApprovedOrderID(),
                    outboundOrderDTO.getApprovedStatus(),
                    outboundOrderDTO.getWarehouseId()
            );
            log.info("✅ 출고요청 상태 업데이트 완료: {} rows", updatedRequest);

            // ✅ 3. 승인된 경우에만 배차 및 운송장 처리
            if ("승인".equals(outboundOrderDTO.getApprovedStatus())) {

                Long dispatchId = dispatchMapper.getDispatchIdByApprovedOrderId(
                        outboundOrderDTO.getApprovedOrderID()
                );
                log.info("✅ 기존 배차 조회 결과: dispatchId={}", dispatchId);

                if (dispatchId == null) {
                    // 🚀 Dispatch 신규 생성
                    log.info("✅ 배차 정보 신규 생성 시작");
                    log.info("   - approvedOrderID: {}", outboundOrderDTO.getApprovedOrderID());
                    log.info("   - warehouseId: {}", outboundOrderDTO.getWarehouseId());
                    log.info("   - carId: {}", outboundOrderDTO.getCarId());
                    log.info("   - carType: {}", outboundOrderDTO.getCarType());
                    log.info("   - driverName: {}", outboundOrderDTO.getDriverName());

                    dispatchMapper.insertDispatchInformation(outboundOrderDTO);
                    dispatchId = outboundOrderDTO.getDispatchId();
                    log.info("✅ 배차 정보 생성 완료: dispatchId={}", dispatchId);
                } else {
                    // 🚀 Dispatch 수정
                    log.info("✅ 배차 정보 수정 시작: dispatchId={}", dispatchId);
                    DispatchDTO dispatchDTO = DispatchDTO.builder()
                            .dispatchId(dispatchId)
                            .approvedOrderID(outboundOrderDTO.getApprovedOrderID())
                            .carId(outboundOrderDTO.getCarId())
                            .carType(outboundOrderDTO.getCarType())
                            .driverName(outboundOrderDTO.getDriverName())
                            .dispatchStatus(outboundOrderDTO.getDispatchStatus())
                            .loadedBox(outboundOrderDTO.getLoadedBox())
                            .maximumBox(outboundOrderDTO.getMaximumBOX())
                            .warehouseId(outboundOrderDTO.getWarehouseId())
                            .build();

                    dispatchMapper.updateDispatchInformation(dispatchDTO);
                    log.info("✅ 배차 정보 수정 완료");
                }

                // 🚚 운송장 생성
                log.info("✅ 운송장 생성 시작");
                outboundOrderDTO.setDispatchId(dispatchId);
                String newWaybillNumber = generateUniqueWaybillNumber();
                outboundOrderDTO.setWaybillNumber(newWaybillNumber);

                log.info("   - dispatchId: {}", dispatchId);
                log.info("   - waybillNumber: {}", newWaybillNumber);

                waybillMapper.insertWaybill(outboundOrderDTO);
                log.info("✅ 운송장 생성 완료: {}", newWaybillNumber);
            }

            log.info("✅✅✅ 전체 프로세스 정상 완료 ✅✅✅");

        }



    private String generateUniqueWaybillNumber() {
        return "WB-" + System.currentTimeMillis();
    }
}