package com.ssg.wms.finance.service;

import com.ssg.wms.finance.domain.ExpenseVO;
import com.ssg.wms.finance.dto.CategorySummaryDTO;
import com.ssg.wms.finance.dto.ExpenseRequestDTO;
import com.ssg.wms.finance.dto.ExpenseResponseDTO;
import com.ssg.wms.finance.dto.ExpenseSaveDTO;
import com.ssg.wms.finance.mappers.ExpenseMapper;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
@Transactional
public class ExpenseServiceImpl implements ExpenseService {

    private final ExpenseMapper expenseMapper;
    private final ModelMapper modelMapper;

    @Override
    public ExpenseResponseDTO getExpenses(ExpenseRequestDTO dto) {
        List<ExpenseVO> expenses = expenseMapper.findAll(dto);
        int total = expenseMapper.count(dto);

        ExpenseResponseDTO response = new ExpenseResponseDTO();
        response.setExpenses(expenses);
        response.setTotal(total);
        response.setPage(dto.getPage());
        response.setSize(dto.getSize());
        return response;
    }

    @Override
    public ExpenseVO getExpense(Long id) {
        return expenseMapper.findById(id).orElseThrow(() ->
                new NoSuchElementException("ID " + id + "에 해당하는 Expense 를 찾을 수 없습니다.")
        );
    }

    @Override
    public Long saveExpense(ExpenseSaveDTO dto) {
        // 1. DTO를 VO로 변환
        ExpenseVO expenseVO = modelMapper.map(dto, ExpenseVO.class);

        // 2. 먼저 DB에 저장 (ID를 받아오기 위해)
        expenseMapper.save(expenseVO);

        // 3. MyBatis가 <insert>의 useGeneratedKeys 덕분에 VO에 채워준 ID를 가져옴
        Long newId = expenseVO.getId();

        // 4. 고유 식별 번호 생성 (예: EXP-251111-00027)
        // 날짜 포맷 (2025-11-11 -> 251111)
        String datePart = dto.getExpenseDate().toString().replace("-", "").substring(2);
        // ID 포맷 (27 -> 00027)
        String idPart = String.format("%05d", newId); // ID를 5자리로 패딩

        String expenseCode = "EXP-" + datePart + "-" + idPart;

        // 5. 생성된 관리번호(expenseCode)를 DB에 다시 UPDATE
        expenseMapper.updateCode(newId, expenseCode);

        return newId; // 컨트롤러에는 기존처럼 ID만 반환
    }

    @Override
    public void updateExpense(Long id, ExpenseSaveDTO dto) {
        ExpenseVO expenseVO = modelMapper.map(dto, ExpenseVO.class);
        ExpenseVO finalVO = expenseVO.toBuilder()
                .id(id)
                .build();
        expenseMapper.update(finalVO);
    }

    @Override
    public void deleteExpense(Long id) {
        expenseMapper.delete(id);
    }
}