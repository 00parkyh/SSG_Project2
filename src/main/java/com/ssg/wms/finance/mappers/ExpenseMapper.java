package com.ssg.wms.finance.mappers;

import com.ssg.wms.finance.domain.ExpenseVO;
import com.ssg.wms.finance.dto.CategorySummaryDTO;
import com.ssg.wms.finance.dto.DashboardSummaryDTO;
import com.ssg.wms.finance.dto.ExpenseRequestDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Optional;

@Mapper
public interface ExpenseMapper {
    List<ExpenseVO> findAll(ExpenseRequestDTO dto);
    int count(ExpenseRequestDTO dto);
    Optional<ExpenseVO> findById(Long id);
    void save(ExpenseVO expenseVO);
    void update(ExpenseVO expenseVO);
    void delete(Long id);
    List<DashboardSummaryDTO> findMonthlySummary(int year);

    // 생성된 관리번호(expense_code)를 업데이트하기 위한 메서드
    void updateCode(@Param("id") Long id, @Param("expenseCode") String expenseCode);

    long findTotalExpenseByMonth(@Param("year") int year, @Param("month") int month);
}