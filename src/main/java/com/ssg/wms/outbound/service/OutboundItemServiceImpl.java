package com.ssg.wms.outbound.service;

import com.ssg.wms.outbound.domain.dto.OutboundItemDTO;
import com.ssg.wms.outbound.mappers.OutboundItemMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Log4j2
public class OutboundItemServiceImpl implements OutboundItemService {

    private final OutboundItemMapper outboundItemMapper;


    @Override
    public void insertOutboundItem(OutboundItemDTO outboundItemDTO) {
        outboundItemMapper.insertOutboundItem(outboundItemDTO);
    }

    @Override
    public List<OutboundItemDTO> selectOutboundItemsByRequestId(Long outboundRequestID) {
       return outboundItemMapper.selectOutboundItemsByRequestId(outboundRequestID);
    }

    @Override
    public int updateOutboundItem(OutboundItemDTO outboundItemDTO, Long outboundRequestID) {
        return outboundItemMapper.updateOutboundItem(outboundItemDTO, outboundRequestID);
    }

    @Override
    public int deleteOutboundItem(Long outboundItemId) {
        return outboundItemMapper.deleteOutboundItem(outboundItemId);
    }

    @Override
    public int deleteOutboundItemsByRequestId(Long outboundRequestID) {
        return outboundItemMapper.deleteOutboundItemsByRequestId(outboundRequestID);
    }
}
