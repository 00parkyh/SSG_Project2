package com.ssg.wms.outbound.service;


import com.ssg.wms.outbound.domain.Criteria;
import com.ssg.wms.outbound.domain.dto.DispatchDTO;
import com.ssg.wms.outbound.domain.dto.OutboundOrderDTO;
import com.ssg.wms.outbound.mappers.DispatchMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Log4j2
public class DispatchServiceImpl implements DispatchService {

    private final DispatchMapper dispatchMapper;



    // 기사 이름으로 배차 목록 조회
    @Override
    public List<DispatchDTO> getDispatchList(Criteria criteria, String driverName) {
        List<DispatchDTO> dispatchDTO = dispatchMapper.getDispatchNameList(criteria, driverName);
        return dispatchDTO;
    }


    //배차 ID로 배차 상세 조회
    @Override
    public DispatchDTO getDispatchDetailById(Long dispatchId) {
        DispatchDTO dispatchDTO = dispatchMapper.getDispatchDetailById(dispatchId);
        return dispatchDTO;
    }

    //배차 정보 등록
    @Transactional
    @Override
    public void insertDispatchInformation(OutboundOrderDTO outboundOrderDTO) {
        log.info("배차 정보 등록 요청: 지시서 ID={}", outboundOrderDTO.getApprovedOrderID());



        int loadedBox = outboundOrderDTO.getLoadedBox();
        int maximumBox = outboundOrderDTO.getMaximumBOX();

        if(loadedBox > maximumBox) {
            log.warn("배차 등록 실패: 적재량이 최대 적재량을 초과했습니다. 적재량={}, 최대={}", loadedBox, maximumBox);


            // 비즈니스 예외 발생
            throw new IllegalArgumentException("적재 박스 개수(" + loadedBox +
                    "개)가 차량의 최대 적재량(" + maximumBox + "개)을 초과하여 등록할 수 없습니다.");
        }
        dispatchMapper.insertDispatchInformation(outboundOrderDTO);
    }


    // 배차 정보 수정
    @Transactional
    @Override
    public void updateDispatchInformation(DispatchDTO dispatchDTO) {
        log.info("배차 정보 수정 요청: 지시서 ID={}", dispatchDTO.getDispatchId());
        dispatchMapper.updateDispatchInformation(dispatchDTO);
    }



    // 운송장 번호 등록
    @Override
    @Transactional
    public void insertMinimalWaybill(OutboundOrderDTO outboundOrderDTO) {
        log.info("운송장 번호 등록 요청: 지시서 ID={}", outboundOrderDTO.getApprovedOrderID());

        // 1. DTO에서 dispatchId를 안전하게 획득
        // 🚨 int 대신 Long 타입으로 변경합니다.
        Long dispatchId = outboundOrderDTO.getDispatchId();

        if (dispatchId == null || dispatchId <= 0) { // null 체크 포함
            throw new IllegalStateException("dispatchId가 유효하지 않습니다. 배차 정보 등록이 선행되어야 합니다.");
        }

        // 2. 운송장 번호 자동 생성 (Service Layer의 역할)
        String waybillNumber = generateUniqueWaybillNumber();

        // 3. 최소 운송장 정보 등록
        // DAO 파라미터에 맞게 dispatchId와 waybillNumber를 전달합니다.
        dispatchMapper.insertMinimalWaybill(dispatchId, waybillNumber);

        log.info("운송장 번호 {}가 dispatchId {}에 등록 완료되었습니다.", waybillNumber, dispatchId);
    }



    @Override
    public List<DispatchDTO> getDistinctDrivers() {
        log.info("🚚 기사/차량 정보 중복 없이 조회 실행");
        return dispatchMapper.getAllDrivers();
    }


    /**
     * 고유한 운송장 번호 생성 (예시)
     */
    private String generateUniqueWaybillNumber() {
        return "WB-" + LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmmss"))
                + "-" + UUID.randomUUID().toString().substring(0, 4);
    }
}
