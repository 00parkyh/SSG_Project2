package com.ssg.wms.partner.service;

import com.ssg.wms.partner.dto.PartnerContractDTO;
import com.ssg.wms.partner.dto.PartnerDTO;
import com.ssg.wms.partner.dto.PartnerFeeDTO;

import java.util.List;

public interface PartnerService {
    List<PartnerFeeDTO> selectPartnerFees(PartnerFeeDTO partnerFeeDTO);
    List<PartnerDTO> selectPartners(PartnerDTO partnerDTO);
    List<PartnerContractDTO> selectPartnerContracts(PartnerContractDTO partnerContractDTO);
}
