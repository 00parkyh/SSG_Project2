package com.ssg.wms.product_stock.service;

import com.ssg.wms.product_stock.dto.DropdownDTO;
import com.ssg.wms.product_stock.dto.PageRequestDTO;
import com.ssg.wms.product_stock.dto.PageResponseDTO;
import com.ssg.wms.product_stock.dto.ProductListDTO;
import com.ssg.wms.product_stock.mappers.ProductListMapper;
import com.ssg.wms.product_stock.mappers.dropDownMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Log4j2
public class ProductListServiceImpl implements ProductListService {

    private final dropDownMapper dropDownMapper;
    private final ProductListMapper productListMapper;
    @Override
    public List<DropdownDTO> categoryDropDown() {
        return dropDownMapper.categoryDropDown();
    }

    @Override
    public List<DropdownDTO> brandDropDown() {
        return dropDownMapper.brandDropDown();
    }

    @Override
    public List<DropdownDTO> warehouseDropDown() {
        return dropDownMapper.warehouseDropDown();
    }

    @Override
    public List<DropdownDTO> sectionDropDown() {
        return dropDownMapper.sectionDropDown();
    }

    @Override
    public PageResponseDTO<ProductListDTO> getProductList(PageRequestDTO pageRequestDTO) {

        pageRequestDTO.normalize();
        int totalCount = productListMapper.countProductList(pageRequestDTO);
        List<ProductListDTO> dtoList = productListMapper.findProductList(pageRequestDTO);

        // 💡 디버그 로그 추가: DTO 매핑 후 inboundDate 값 확인
        log.info("DEBUG: ProductListMapper 호출 후 DTO inboundDate 값 확인");
        if (dtoList != null) {
            dtoList.stream()
                    .limit(5) // 상위 5개만 로그 출력
                    .forEach(dto -> {
                        log.info("  상품 ID: {}, Raw inboundDate: {}", dto.getProductId(), dto.getInboundDate());
                    });
        }

        return PageResponseDTO.<ProductListDTO>withAll()
                .pageRequestDTO(pageRequestDTO)
                .dtoList(dtoList)
                .total(totalCount)
                .build();
    }
}
