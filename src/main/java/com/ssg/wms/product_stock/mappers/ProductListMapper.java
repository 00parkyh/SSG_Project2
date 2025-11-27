package com.ssg.wms.product_stock.mappers;

import com.ssg.wms.product_stock.dto.*;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

//품목현황
@Mapper
public interface ProductListMapper {
    //품목 조회
    List<ProductListDTO> findProductList(PageRequestDTO pageRequestDTO);
    //페이징 위한 카운트
    int countProductList(PageRequestDTO pageRequestDTO);

}
