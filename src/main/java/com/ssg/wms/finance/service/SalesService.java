package com.ssg.wms.finance.service;

import com.ssg.wms.finance.domain.SalesVO;
import com.ssg.wms.finance.dto.SalesPartnerDTO;
import com.ssg.wms.finance.dto.SalesRequestDTO;
import com.ssg.wms.finance.dto.SalesResponseDTO;
import com.ssg.wms.finance.dto.SalesSaveDTO;

import java.util.List;

public interface SalesService {
    SalesResponseDTO getSales(SalesRequestDTO dto);

    SalesVO getSale(Long id);

    Long saveSales(SalesSaveDTO dto);

    void updateSales(Long id, SalesSaveDTO dto);

    void deleteSales(Long id);

    List<SalesPartnerDTO> getPartnerList();
}
