package com.ssg.wms.outbound.service;


import com.ssg.wms.outbound.domain.Criteria;
import com.ssg.wms.outbound.domain.dto.OutboundOrderDTO;
import com.ssg.wms.outbound.domain.dto.WaybillDTO;
import com.ssg.wms.outbound.mappers.DispatchMapper;
import com.ssg.wms.outbound.mappers.WaybillMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Log4j2
public class WaybillServiceImpl implements WaybillService {


    private final WaybillMapper waybillMapper;
    private final DispatchMapper dispatchMapper;

    // 운송장 ID로 운송장 단건 조회
    @Override
    public WaybillDTO getWaybillById(String waybillNumber) {
        WaybillDTO waybillDTO = waybillMapper.getWaybillById(waybillNumber);
        return waybillDTO;
    }

    // 운송장 리스트 조회 (검색, 페이징 포함)
    @Override
    public List<WaybillDTO> getWaybillList(Criteria criteria, String search) {
        List<WaybillDTO> waybillDTOList = waybillMapper.getWaybills(criteria, search);
        return waybillDTOList;
    }

    //  운송장 정보입력
    @Override
    public OutboundOrderDTO createWaybill(OutboundOrderDTO outboundOrderDTO) {
        waybillMapper.insertWaybill(outboundOrderDTO);
        return outboundOrderDTO;
    }


    @Override
    public void updateWaybill(WaybillDTO dto) {
        // 1. Waybill 정보 업데이트 (주소, 이름 등)
        waybillMapper.updateWaybill(dto);

        // 2. Dispatch 정보 업데이트 (loadedBOX)
        if (dto.getLoadedBox() != null && dto.getDispatchId() != null) {
            // DispatchMapper에 정의된 새로운 메서드를 호출합니다.
            dispatchMapper.updateLoadedBox(dto.getDispatchId(), dto.getLoadedBox());
        }
    }

    //QR코드용 조회
    @Override
    public WaybillDTO getWaybillByNumber(String waybillNumber) {
        return null;
    }
}
