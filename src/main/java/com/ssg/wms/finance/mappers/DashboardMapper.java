package com.ssg.wms.finance.mappers;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface DashboardMapper {

    // 입고량 조회
    int countMonthlyInbound(@Param("year") int year, @Param("month") int month);

    // 출고량 조회
    int countMonthlyOutbound(@Param("year") int year, @Param("month") int month);
}
