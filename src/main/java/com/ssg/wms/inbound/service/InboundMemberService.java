package com.ssg.wms.inbound.service;

import com.ssg.wms.inbound.dto.InboundDTO;
import com.ssg.wms.inbound.dto.InboundDetailDTO;
import com.ssg.wms.inbound.dto.InboundListDTO;
import com.ssg.wms.inbound.dto.InboundRequestDTO;
import com.ssg.wms.product_ehs.dto.ProductDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface InboundMemberService {

    @Transactional
    InboundRequestDTO createInbound(InboundRequestDTO inboundRequestDTO);
    
    List<ProductDTO> getProductsByPartnerAndCategory(int partnerId, int categoryCd);

    InboundDetailDTO getInboundById(int inboundId);

    List<InboundListDTO> getInboundListByPartner(Long memberId, String inboundStatus);

    @Transactional
    InboundDTO updateInbound(InboundRequestDTO inboundRequestDTO);

    @Transactional
    boolean cancelInbound(int inboundId);
}
