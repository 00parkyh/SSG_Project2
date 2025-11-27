package com.ssg.wms.product_ehs.service;

import com.ssg.wms.product_ehs.dto.CategoryDTO;
import com.ssg.wms.product_ehs.dto.ProductDTO;
import com.ssg.wms.product_ehs.mappers.ProductMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductMapper productMapper;

    @Override
    public List<ProductDTO> getProductsByPartnerAndCategory(int partnerId, int categoryCd) {
        return productMapper.selectProductsByPartnerAndCategory(partnerId, categoryCd);
    }

    @Override
    public List<CategoryDTO> getCategory(){
        return productMapper.selectCategory();
    }

}
