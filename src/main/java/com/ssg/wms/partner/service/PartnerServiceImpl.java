package com.ssg.wms.partner.service;

import com.ssg.wms.partner.dto.PartnerContractDTO;
import com.ssg.wms.partner.dto.PartnerDTO;
import com.ssg.wms.partner.dto.PartnerFeeDTO;
import com.ssg.wms.partner.mappers.PartnerMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Log4j2
public class PartnerServiceImpl implements PartnerService {
    private final PartnerMapper partnerMapper;

    @Override
    public List<PartnerFeeDTO> selectPartnerFees(PartnerFeeDTO partnerFeeDTO) {
        return partnerMapper.selectPartnerFees(partnerFeeDTO);
    }

    @Override
    public List<PartnerDTO> selectPartners(PartnerDTO partnerDTO) {
        return partnerMapper.selectPartners(partnerDTO);
    }

    @Override
    public List<PartnerContractDTO> selectPartnerContracts(PartnerContractDTO partnerContractDTO) {
        return partnerMapper.selectPartnerContracts(partnerContractDTO);
    }
}
