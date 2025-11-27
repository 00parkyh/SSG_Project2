package com.ssg.wms.inbound.mappers;

import com.ssg.wms.inbound.domain.InboundItemVO;
import com.ssg.wms.inbound.domain.InboundVO;
import com.ssg.wms.inbound.dto.InboundListDTO;
import com.ssg.wms.product_ehs.mappers.ProductMapper;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = "file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class InboundMapperTests {

    @Autowired(required = false)
    private InboundMemberMapper inboundMemberMapper;

    @Autowired(required = false)
    private InboundAdminMapper inboundAdminMapper;

    @Autowired(required = false)
    private ProductMapper productMapper;

    @Test
    public void testRequestInbound() {

        List<InboundItemVO> inboundItems = new ArrayList<>();
        inboundItems.add(
                InboundItemVO.builder()
                        .productId("P001")
                        .quantity(10)
                        .build()
        );

        inboundItems.add(
                InboundItemVO.builder()
                        .productId("P001")
                        .quantity(5)
                        .build()
        );
        InboundVO inboundVO = InboundVO.builder()
                .memberId(1L)
//                .inboundStatus("request")
                .inboundItems(inboundItems)
//                .inboundRequestedAt(LocalDateTime.now())
//                .inboundUpdatedAt(LocalDateTime.now())
                .build();

        int result = inboundMemberMapper.insertInbound(inboundVO);

        for (InboundItemVO item : inboundItems) {
            item.setInboundId(inboundVO.getInboundId()); // 부모 inboundId 세팅
            inboundMemberMapper.insertInboundItem(item);
        }

        assertEquals(1, result); // insert 성공 시 반환값이 1이라고 가정
        System.out.println("입고 요청 테스트 완료, inboundId = " + inboundVO.getInboundId());


    }

    @Test
    public void testInboundList() {

        List<InboundListDTO> result = inboundMemberMapper.selectInboundListByPartner(1L, "");
        System.out.println("조회 건수: " + result.size());

        for (InboundListDTO dto : result) {
            System.out.println("ID: " + dto.getInboundId() +
                    ", 요청일시: " + dto.getInboundRequestedAt() +
                    ", 회원명: " + dto.getMemberName() +
                    ", 상태: " + dto.getInboundStatus());
        }
    }


}
