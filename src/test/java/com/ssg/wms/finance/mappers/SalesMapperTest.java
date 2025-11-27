package com.ssg.wms.finance.mappers;

import com.ssg.wms.finance.domain.SalesVO;
import com.ssg.wms.finance.dto.SalesRequestDTO;
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
public class SalesMapperTest {

    @Autowired(required = false)
    private SalesMapper salesMapper;

    @Test
    @DisplayName("매출 등록(save) 및 조회(findById) 테스트")
    public void testSaveAndFindById() {
        SalesVO salesVO = SalesVO.builder()
                .warehouseName("테스트 창고")
                .salesDate(LocalDate.now())
                .category("테스트 카테고리")
                .clientName("테스트 거래처명")
                .amount(12345L)
                .description("SalesMapper 테스트")
                .build();

        salesMapper.save(salesVO);

        Assertions.assertNotNull(salesVO.getId());

        Optional<SalesVO> optionalVO = salesMapper.findById(salesVO.getId());

        Assertions.assertTrue(optionalVO.isPresent());

        SalesVO findVO = optionalVO.get();
        Assertions.assertEquals(12345L, findVO.getAmount());
        Assertions.assertEquals("테스트 카테고리", findVO.getCategory());
    }

    @Test
    @DisplayName("매출 수정(update) 테스트")
    public void testUpdate() {
        SalesVO salesVO = SalesVO.builder()
                .warehouseName("테스트 창고")
                .salesDate(LocalDate.now())
                .category("테스트 카테고리")
                .clientName("테스트 거래처명")
                .amount(12345L)
                .description("Update 테스트")
                .build();

        salesMapper.save(salesVO);

        SalesVO updateVO = salesVO.toBuilder()
                .category("수정된 카테고리")
                .clientName("수정된 거래처명")
                .amount(1000L)
                .description("수정 완료")
                .build();

        salesMapper.update(updateVO);

        Optional<SalesVO> findOptional = salesMapper.findById(salesVO.getId());
        Assertions.assertTrue(findOptional.isPresent());

        SalesVO findVO = findOptional.get();
        Assertions.assertEquals(1000L, findVO.getAmount());
        Assertions.assertEquals("수정된 카테고리", findVO.getCategory());
        Assertions.assertEquals("수정된 거래처명", findVO.getClientName());
        Assertions.assertEquals("수정 완료", findVO.getDescription());
    }

    @Test
    @DisplayName("매출 삭제(delete) 테스트")
    public void testDelete() {
        SalesVO salesVO = SalesVO.builder()
                .warehouseName("삭제용 창고")
                .salesDate(LocalDate.now())
                .category("삭제용 카테고리")
                .clientName("삭제용 거래처명")
                .amount(1L)
                .description("삭제용 데이터 테스트")
                .build();

        salesMapper.save(salesVO);
        Long saveId = salesVO.getId();

        salesMapper.delete(saveId);

        Optional<SalesVO> findOptional = salesMapper.findById(saveId);
        Assertions.assertFalse(findOptional.isPresent());
    }

    @Test
    @DisplayName("매출 목록 조회(findAll) 및 페이징 테스트")
    void testFindAllWithPaging() {
        // 데이터 20개 생성
        for (int i = 0; i < 20; i++) {
            salesMapper.save(SalesVO.builder()
                    .warehouseName("테스트 창고")
                    .clientName("테스트 거래처")
                    .category("페이징")
                    .amount(10L + i)
                    .salesDate(LocalDate.now())
                    .description("페이징 테스트 데이터 " + i)
                    .build());
        }

        SalesRequestDTO dto1 = SalesRequestDTO.builder().page(1).size(10).build();
        SalesRequestDTO dto2 = SalesRequestDTO.builder().page(2).size(10).build();

        List<SalesVO> list1 = salesMapper.findAll(dto1);
        List<SalesVO> list2 = salesMapper.findAll(dto2);
        int total = salesMapper.count(dto1);

        Assertions.assertEquals(10, list1.size());
        Assertions.assertEquals(10, list2.size());
        Assertions.assertTrue(total >= 20);
    }
}
