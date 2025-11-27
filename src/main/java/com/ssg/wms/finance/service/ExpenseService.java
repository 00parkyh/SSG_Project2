package com.ssg.wms.finance.service;

import com.ssg.wms.finance.domain.ExpenseVO;
import com.ssg.wms.finance.dto.CategorySummaryDTO;
import com.ssg.wms.finance.dto.ExpenseRequestDTO;
import com.ssg.wms.finance.dto.ExpenseResponseDTO;
import com.ssg.wms.finance.dto.ExpenseSaveDTO;

import java.util.List;

public interface ExpenseService {
    ExpenseResponseDTO getExpenses(ExpenseRequestDTO dto);
    ExpenseVO getExpense(Long id);
    Long saveExpense(ExpenseSaveDTO dto);
    void updateExpense(Long id, ExpenseSaveDTO dto);
    void deleteExpense(Long id);

}