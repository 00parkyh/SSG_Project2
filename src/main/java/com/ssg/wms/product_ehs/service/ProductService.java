package com.ssg.wms.product_ehs.service;

import com.ssg.wms.product_ehs.dto.CategoryDTO;
import com.ssg.wms.product_ehs.dto.ProductDTO;

import java.util.List;

public interface ProductService {

    List<ProductDTO> getProductsByPartnerAndCategory(int partnerId, int categoryCd);

    List<CategoryDTO> getCategory();

}
