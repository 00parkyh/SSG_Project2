package com.ssg.wms.product_stock.service;

import com.ssg.wms.product_stock.dto.DropdownDTO;
import com.ssg.wms.product_stock.dto.PageRequestDTO;
import com.ssg.wms.product_stock.dto.PageResponseDTO;
import com.ssg.wms.product_stock.dto.ProductListDTO;

import java.util.List;

//품목현황
public interface ProductListService {

    List<DropdownDTO> categoryDropDown();
    List<DropdownDTO> brandDropDown();
    List<DropdownDTO> warehouseDropDown();
    List<DropdownDTO> sectionDropDown();

    PageResponseDTO<ProductListDTO> getProductList(PageRequestDTO pageRequestDTO);


}
