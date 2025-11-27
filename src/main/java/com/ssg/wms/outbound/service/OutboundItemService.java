package com.ssg.wms.outbound.service;

import com.ssg.wms.outbound.domain.dto.DispatchDTO;
import com.ssg.wms.outbound.domain.dto.OutboundItemDTO;

import java.util.List;

public interface OutboundItemService {
    void insertOutboundItem(OutboundItemDTO outboundItemDTO);
    List<OutboundItemDTO> selectOutboundItemsByRequestId(Long outboundRequestID);
    int updateOutboundItem(OutboundItemDTO outboundItemDTO, Long outboundRequestID);
    int deleteOutboundItem(Long outboundItemId);
    int deleteOutboundItemsByRequestId(Long outboundRequestID);

}
