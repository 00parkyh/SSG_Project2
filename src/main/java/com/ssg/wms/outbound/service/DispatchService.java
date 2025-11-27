package com.ssg.wms.outbound.service;



import com.ssg.wms.outbound.domain.Criteria;
import com.ssg.wms.outbound.domain.dto.DispatchDTO;
import com.ssg.wms.outbound.domain.dto.OutboundOrderDTO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface DispatchService {


    //운전사 이름으로 필터링해서 배차 리스트 보고 싶을 떄 파라미터로 String driverName 넣어줌
    List<DispatchDTO> getDispatchList(Criteria criteria, String driverName);

    // 배차 상세조회
    DispatchDTO getDispatchDetailById(Long dispatchId);

    // 배차 정보 등록
    void insertDispatchInformation(OutboundOrderDTO outboundOrderDTO);
    // 배차 수정
    void updateDispatchInformation(DispatchDTO dispatchDTO);

    // 운송장 번호 등록
    void insertMinimalWaybill(OutboundOrderDTO outboundOrderDTO);

    List<DispatchDTO> getDistinctDrivers();
}
