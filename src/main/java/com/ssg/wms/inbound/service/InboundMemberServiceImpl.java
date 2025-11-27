package com.ssg.wms.inbound.service;

import com.ssg.wms.inbound.domain.InboundItemVO;
import com.ssg.wms.inbound.domain.InboundVO;
import com.ssg.wms.inbound.dto.*;
import com.ssg.wms.inbound.mappers.InboundMemberMapper;
import com.ssg.wms.product_ehs.dto.ProductDTO;
import com.ssg.wms.product_ehs.mappers.ProductMapper;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Primary
@Log4j2
public class InboundMemberServiceImpl implements InboundMemberService {

    @Autowired
    private InboundMemberMapper inboundMemberMapper;

    @Autowired
    private ProductMapper productMapper;

    @Transactional
    @Override
    public InboundRequestDTO createInbound(InboundRequestDTO inboundRequestDTO) {

        log.info("=== Service 진입 ===");
        log.info("받은 DTO memberId: {}", inboundRequestDTO.getMemberId());

        // InboundVO 생성 시 memberId 포함
        InboundVO inboundVO = InboundVO.builder()
                .memberId(inboundRequestDTO.getMemberId())
                .inboundStatus("request")
                .build();

        log.info("생성한 VO memberId: {}", inboundVO.getMemberId());

        // inbound 테이블에 INSERT (inboundId가 자동 생성됨)
        inboundMemberMapper.insertInbound(inboundVO);
        int inboundId = inboundVO.getInboundId();

        log.info("생성된 inboundId: {}", inboundId);

        // inbound_item 테이블에 INSERT
        if (inboundRequestDTO.getInboundRequestItems() != null &&
                !inboundRequestDTO.getInboundRequestItems().isEmpty()) {

            for (InboundRequestItemDTO inboundItemDTO : inboundRequestDTO.getInboundRequestItems()) {
                InboundItemVO inboundItemVO = InboundItemVO.builder()
                        .inboundId(inboundId)
                        .productId(inboundItemDTO.getProductId())
                        .quantity(inboundItemDTO.getQuantity())
                        .build();

                inboundMemberMapper.insertInboundItem(inboundItemVO);
                log.info("품목 추가: productId={}, quantity={}",
                        inboundItemDTO.getProductId(),
                        inboundItemDTO.getQuantity());
            }
        }

        log.info("입고 요청 생성 완료!");
        return inboundRequestDTO;
    }

    @Override
    public List<ProductDTO> getProductsByPartnerAndCategory(int partnerId, int categoryCd) {
        return productMapper.selectProductsByPartnerAndCategory(partnerId, categoryCd);
    }


    @Override
    public InboundDetailDTO getInboundById(int inboundId) {
        // 1. 입고 상세 + 아이템 조회
        InboundDetailDTO detail = inboundMemberMapper.selectInboundWithItemsDetail(inboundId);

        if (detail == null) {
            return null; // 존재하지 않는 경우
        }

        // 2. 전체 카테고리 리스트 조회
        detail.setCategories(productMapper.selectCategory());

        // 3. 전체 거래처 기준 상품 리스트 조회
        // partnerId가 필요하므로 InboundDetailDTO에 partnerId가 있어야 함
        // 각 아이템마다 products를 넣는 것이 아니라, 모달 전체에서 사용
        List<ProductDTO> allProducts = productMapper.selectProductsByPartnerAndCategory(
                detail.getPartnerId(), 0 // categoryCd 0 또는 null이면 전체 상품 조회용
        );
        detail.setProducts(allProducts);

        return detail;
    }

    @Override
    public List<InboundListDTO> getInboundListByPartner(Long memberId, String status){
        return inboundMemberMapper.selectInboundListByPartner(memberId, status);
    }

    @Transactional
    @Override
    public InboundDTO updateInbound(InboundRequestDTO inboundRequestDTO) {

        log.info("Update inbound - ID: {}", inboundRequestDTO.getInboundId());
        log.info("Items count: {}", inboundRequestDTO.getInboundRequestItems().size());

        // 1 기본 정보 업데이트
        inboundMemberMapper.updateInbound(inboundRequestDTO);

        // 2 기존 상품 삭제
        inboundMemberMapper.deleteInboundItems(inboundRequestDTO.getInboundId());

        // 3 새로운 상품 목록 등록
        if (inboundRequestDTO.getInboundRequestItems() != null &&
                !inboundRequestDTO.getInboundRequestItems().isEmpty()) {
            for (InboundRequestItemDTO item : inboundRequestDTO.getInboundRequestItems()) {
                item.setInboundId(inboundRequestDTO.getInboundId());
                log.info("Item - inboundId: {}, productId: {}, quantity: {}",
                        item.getInboundId(), item.getProductId(), item.getQuantity());
            }

            log.info("Calling insertInboundItemsBatch with {} items",
                    inboundRequestDTO.getInboundRequestItems().size());
            inboundMemberMapper.insertInboundItemsBatch(inboundRequestDTO.getInboundRequestItems());
            log.info("insertInboundItemsBatch completed");

        }

        // 4 최신 데이터 조회 후 출력용 DTO 반환
        return inboundMemberMapper.selectInboundWithItems(inboundRequestDTO.getInboundId());
    }

    @Transactional
    @Override
    public boolean cancelInbound(int inboundId) {
        inboundMemberMapper.cancelInboundItems(inboundId);
        int result = inboundMemberMapper.cancelInbound(inboundId);
        return result > 0;
    }

}