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
        // 준비
        ExpenseVO expenseVO = ExpenseVO.builder()
                .warehouseName("테스트 창고")
                .expenseDate(LocalDate.now())
                .category("테스트 카테고리")
                .amount(12345L)
                .description("Mapper 테스트")
                .build();

        // 실행 - 저장
        expenseMapper.save(expenseVO);
        // 검증. ID가 생성되었는지 - 저장
        Assertions.assertNotNull(expenseVO.getId());
        // 실행 - 조회
        Optional<ExpenseVO> optionalVO = expenseMapper.findById(expenseVO.getId());
        // 검증 - 조회
        Assertions.assertTrue(optionalVO.isPresent()); // 조회가 되었는지 검증

        ExpenseVO findVO = optionalVO.get();
        Assertions.assertEquals(12345L, findVO.getAmount()); // 저장된 값이 맞는지 검증
        Assertions.assertEquals("테스트 카테고리", findVO.getCategory());
    }

    @Test
    @DisplayName("지출 수정(update) 테스트")
    public void testUpdate() {
        // Given (먼저 저장)
        ExpenseVO vo = ExpenseVO.builder()
                .warehouseName("원본창고")
                .expenseDate(LocalDate.now())
                .category("원본카테고리")
                .amount(100L)
                .description("원본 데이터")
                .build();
        expenseMapper.save(vo);

        ExpenseVO updateVO = vo.toBuilder()
                .category("수정된카테고리")
                .amount(999L)
                .description("수정 완료") //
                .build();

        // When
        expenseMapper.update(updateVO);

        // Then
        Optional<ExpenseVO> findOptional = expenseMapper.findById(vo.getId());
        Assertions.assertTrue(findOptional.isPresent());

        ExpenseVO findVO = findOptional.get();
        Assertions.assertEquals(999L, findVO.getAmount());
        Assertions.assertEquals("수정된카테고리", findVO.getCategory());
        Assertions.assertEquals("수정 완료", findVO.getDescription());
    }

    @Test
    @DisplayName("지출 삭제(delete) 테스트")
    public void testDelete() {
        ExpenseVO vo = ExpenseVO.builder()
                .warehouseName("삭제할 창고")
                .category("삭제될데이터")
                .amount(1L)
                .expenseDate(LocalDate.now())
                .description("삭제용 데이터")
                .build();
        expenseMapper.save(vo);
        Long savedId = vo.getId();

        expenseMapper.delete(savedId);

        Optional<ExpenseVO> findOptional = expenseMapper.findById(savedId);
        Assertions.assertFalse(findOptional.isPresent());
    }

    @Test
    @DisplayName("지출 목록 조회(findAll) 및 페이징 테스트")
    void testFindAllWithPaging() {
        // 데이터 20개 생성
        for (int i = 0; i < 20; i++) {
            expenseMapper.save(ExpenseVO.builder()
                    .warehouseName("테스트 창고")
                    .category("페이징")
                    .amount(10L + i)
                    .expenseDate(LocalDate.now())
                    .description("페이징 테스트 데이터 " + i)
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
