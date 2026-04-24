package com.ssg.wms.finance.mappers;

import com.ssg.wms.finance.domain.ExpenseVO;
import com.ssg.wms.finance.dto.ExpenseRequestDTO;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = "file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Transactional
public class ExpenseMapperTest {

    @Autowired(required = false)
    private ExpenseMapper expenseMapper;

    @Test
    @DisplayName("지출 등록(save) 및 조회(findById) 테스트")
    public void testSaveAndFindById() {
        ExpenseVO expenseVO = ExpenseVO.builder()
                .warehouseName("테스트 창고")
                .expenseDate(LocalDate.now())
                .expenseCategory("테스트 카테고리")
                .expenseAmount(12345L)
                .expenseDescription("Mapper 테스트")
                .build();

        expenseMapper.save(expenseVO);

        Assertions.assertNotNull(expenseVO.getExpenseID());

        Optional<ExpenseVO> optionalVO = expenseMapper.findById(expenseVO.getExpenseID());
        Assertions.assertTrue(optionalVO.isPresent());

        ExpenseVO findVO = optionalVO.get();
        Assertions.assertEquals(12345L, findVO.getExpenseAmount());
        Assertions.assertEquals("테스트 카테고리", findVO.getExpenseCategory());
    }

    @Test
    @DisplayName("지출 수정(update) 테스트")
    public void testUpdate() {
        ExpenseVO vo = ExpenseVO.builder()
                .warehouseName("원본창고")
                .expenseDate(LocalDate.now())
                .expenseCategory("원본카테고리")
                .expenseAmount(100L)
                .expenseDescription("원본 데이터")
                .build();
        expenseMapper.save(vo);

        ExpenseVO updateVO = vo.toBuilder()
                .expenseCategory("수정된카테고리")
                .expenseAmount(999L)
                .expenseDescription("수정 완료")
                .build();

        expenseMapper.update(updateVO);

        Optional<ExpenseVO> findOptional = expenseMapper.findById(vo.getExpenseID());
        Assertions.assertTrue(findOptional.isPresent());

        ExpenseVO findVO = findOptional.get();
        Assertions.assertEquals(999L, findVO.getExpenseAmount());
        Assertions.assertEquals("수정된카테고리", findVO.getExpenseCategory());
        Assertions.assertEquals("수정 완료", findVO.getExpenseDescription());
    }

    @Test
    @DisplayName("지출 삭제(delete) 테스트")
    public void testDelete() {
        ExpenseVO vo = ExpenseVO.builder()
                .warehouseName("삭제용 창고")
                .expenseCategory("삭제될데이터")
                .expenseAmount(1L)
                .expenseDate(LocalDate.now())
                .expenseDescription("삭제용 데이터")
                .build();
        expenseMapper.save(vo);
        Long savedId = vo.getExpenseID();

        expenseMapper.delete(savedId);

        Optional<ExpenseVO> findOptional = expenseMapper.findById(savedId);
        Assertions.assertFalse(findOptional.isPresent());
    }

    @Test
    @DisplayName("지출 목록 조회(findAll) 및 페이징 테스트")
    void testFindAllWithPaging() {
        for (int i = 0; i < 20; i++) {
            expenseMapper.save(ExpenseVO.builder()
                    .warehouseName("테스트 창고")
                    .expenseCategory("페이징")
                    .expenseAmount(10L + i)
                    .expenseDate(LocalDate.now())
                    .expenseDescription("페이징 테스트 데이터" + i)
                    .build());
        }

        ExpenseRequestDTO dto1 = ExpenseRequestDTO.builder().page(1).size(10).build();
        ExpenseRequestDTO dto2 = ExpenseRequestDTO.builder().page(2).size(10).build();

        List<ExpenseVO> list1 = expenseMapper.findAll(dto1);
        List<ExpenseVO> list2 = expenseMapper.findAll(dto2);
        int total = expenseMapper.count(dto1);

        Assertions.assertEquals(10, list1.size());
        Assertions.assertEquals(10, list2.size());
        Assertions.assertTrue(total >= 20);
    }
}
