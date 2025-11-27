package com.ssg.wms.finance.mappers;

import com.ssg.wms.finance.domain.SalesVO;
import com.ssg.wms.finance.dto.DashboardSummaryDTO;
import com.ssg.wms.finance.dto.SalesPartnerDTO;
import com.ssg.wms.finance.dto.SalesRequestDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Optional;

@Mapper
public interface SalesMapper {
    List<SalesVO> findAll(SalesRequestDTO dto);

    int count(SalesRequestDTO dto);

    Optional<SalesVO> findById(Long id);

    void save(SalesVO salesVO);

    void update(SalesVO salesVO);

    void delete(Long id);

    List<DashboardSummaryDTO> findMonthlySummary(int year);

    void updateCode(@Param("id") Long id, @Param("salesCode") String salesCode);

    List<SalesPartnerDTO> selectPartnerList();

    long findTotalSalesByMonth(@Param("year") int year, @Param("month") int month);
}