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
                .salesCategory("테스트 카테고리")
                .clientName("테스트 거래처명")
                .salesAmount(12345L)
                .salesDescription("SalesMapper 테스트")
                .build();

        salesMapper.save(salesVO);

        Assertions.assertNotNull(salesVO.getSalesID());

        Optional<SalesVO> optionalVO = salesMapper.findById(salesVO.getSalesID());

        Assertions.assertTrue(optionalVO.isPresent());

        SalesVO findVO = optionalVO.get();
        Assertions.assertEquals(12345L, findVO.getSalesAmount());
        Assertions.assertEquals("테스트 카테고리", findVO.getSalesCategory());
    }

    @Test
    @DisplayName("매출 수정(update) 테스트")
    public void testUpdate() {
        SalesVO salesVO = SalesVO.builder()
                .warehouseName("테스트 창고")
                .salesDate(LocalDate.now())
                .salesCategory("테스트 카테고리")
                .clientName("테스트 거래처명")
                .salesAmount(12345L)
                .salesDescription("Update 테스트")
                .build();

        salesMapper.save(salesVO);

        SalesVO updateVO = salesVO.toBuilder()
                .salesCategory("수정된 카테고리")
                .clientName("수정된 거래처명")
                .salesAmount(1000L)
                .salesDescription("수정 완료")
                .build();

        salesMapper.update(updateVO);

        Optional<SalesVO> findOptional = salesMapper.findById(salesVO.getSalesID());
        Assertions.assertTrue(findOptional.isPresent());

        SalesVO findVO = findOptional.get();
        Assertions.assertEquals(1000L, findVO.getSalesAmount());
        Assertions.assertEquals("수정된 카테고리", findVO.getSalesCategory());
        Assertions.assertEquals("수정된 거래처명", findVO.getClientName());
        Assertions.assertEquals("수정 완료", findVO.getSalesDescription());
    }

    @Test
    @DisplayName("매출 삭제(delete) 테스트")
    public void testDelete() {
        SalesVO salesVO = SalesVO.builder()
                .warehouseName("삭제용 창고")
                .salesDate(LocalDate.now())
                .salesCategory("삭제용 카테고리")
                .clientName("삭제용 거래처명")
                .salesAmount(1L)
                .salesDescription("삭제용 데이터")
                .build();

        salesMapper.save(salesVO);
        Long saveId = salesVO.getSalesID();

        salesMapper.delete(saveId);

        Optional<SalesVO> findOptional = salesMapper.findById(saveId);
        Assertions.assertFalse(findOptional.isPresent());
    }

    @Test
    @DisplayName("매출 목록 조회(findAll) 및 페이징 테스트")
    void testFindAllWithPaging() {
        for (int i = 0; i < 20; i++) {
            salesMapper.save(SalesVO.builder()
                    .warehouseName("테스트 창고")
                    .clientName("테스트 거래처")
                    .salesCategory("페이징")
                    .salesAmount(10L + i)
                    .salesDate(LocalDate.now())
                    .salesDescription("페이징 테스트 데이터" + i)
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
