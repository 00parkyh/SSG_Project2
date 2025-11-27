package com.ssg.wms.partner.mappers;

import com.ssg.wms.partner.dto.PartnerContractDTO;
import com.ssg.wms.partner.dto.PartnerDTO;
import com.ssg.wms.partner.dto.PartnerFeeDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface PartnerMapper {
    List<PartnerFeeDTO> selectPartnerFees(PartnerFeeDTO partnerFeeDTO);
    List<PartnerDTO> selectPartners(PartnerDTO partnerDTO);
    List<PartnerContractDTO> selectPartnerContracts(PartnerContractDTO partnerContractDTO);
}
