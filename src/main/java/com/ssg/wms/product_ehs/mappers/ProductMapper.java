package com.ssg.wms.product_ehs.mappers;

import com.ssg.wms.product_ehs.dto.CategoryDTO;
import com.ssg.wms.product_ehs.dto.ProductDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ProductMapper {
    List<ProductDTO> selectProductsByPartnerAndCategory(@Param("partnerId")int partnerId,
                                                        @Param("categoryCd")int categoryCd);
    List<CategoryDTO> selectCategory();
}
