package com.ssg.wms.partner.controller;

import com.ssg.wms.partner.dto.PartnerContractDTO;
import com.ssg.wms.partner.dto.PartnerDTO;
import com.ssg.wms.partner.dto.PartnerFeeDTO;
import com.ssg.wms.partner.service.PartnerService;
import lombok.Builder;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/partner")
@RequiredArgsConstructor
@Log4j2
public class PartnerController {
    private final PartnerService partnerService;

    @Builder
    @Data
    public static class PartnerDetailResponse {
        private PartnerDTO partner;
        private List<PartnerFeeDTO> fees;
        private List<PartnerContractDTO> contracts;
    }

    @GetMapping
    public String partnerMain(Model model) {
        // 초기 로딩 시 전체 데이터 조회
        List<PartnerDTO> partners = partnerService.selectPartners(new PartnerDTO());
        model.addAttribute("partners", partners);
        return "partners/partnerMain";
    }

    @GetMapping("/detail/{partnerId}")
    @ResponseBody
    public PartnerDetailResponse getPartnerDetail(@PathVariable int partnerId) {
        log.info("getPartnerDetail inquiryId:" + partnerId);

        try {
            PartnerDTO partnerDTO = new PartnerDTO();
            partnerDTO.setPartnerId(partnerId);

            PartnerFeeDTO partnerFeeDTO = new PartnerFeeDTO();
            partnerFeeDTO.setPartnerId(partnerId);

            PartnerContractDTO partnerContractDTO = new PartnerContractDTO();
            partnerContractDTO.setPartnerId(partnerId);

            List<PartnerDTO> partners = partnerService.selectPartners(partnerDTO);
            log.info("Partners found: {}", partners.size());
            List<PartnerFeeDTO> fees = partnerService.selectPartnerFees(partnerFeeDTO);
            log.info("Fees found: {}", fees.size());
            List<PartnerContractDTO> contracts = partnerService.selectPartnerContracts(partnerContractDTO);
            log.info("Contracts found: {}", contracts.size());

            return PartnerDetailResponse.builder()
                    .partner(partners.isEmpty() ? null : partners.get(0))
                    .fees(fees)
                    .contracts(contracts)
                    .build();
        } catch (Exception e) {
            log.error("Error occurred: ", e);
            throw e;
        }
    }

    @GetMapping("/api/partners")
    @ResponseBody
    public List<PartnerDTO> getPartners(@RequestBody(required = false) PartnerDTO partnerDTO) {
        if (partnerDTO == null) {
            partnerDTO = new PartnerDTO();
        }
        return partnerService.selectPartners(partnerDTO);
    }

    @GetMapping("/api/fees")
    @ResponseBody
    public List<PartnerFeeDTO> getPartnerFees(@RequestBody(required = false) PartnerFeeDTO partnerFeeDTO) {
        if (partnerFeeDTO == null) {
            partnerFeeDTO = new PartnerFeeDTO();
        }
        return partnerService.selectPartnerFees(partnerFeeDTO);
    }

    @GetMapping("/api/contracts")
    @ResponseBody
    public List<PartnerContractDTO> getPartnerContracts(@RequestBody(required = false) PartnerContractDTO partnerContractDTO) {
        if (partnerContractDTO == null) {
            partnerContractDTO = new PartnerContractDTO();
        }
        return partnerService.selectPartnerContracts(partnerContractDTO);
    }


}
