package com.ssg.wms.product_stock.mappers;

import com.ssg.wms.product_stock.dto.DropdownDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

//드롭 다운 메뉴
@Mapper
public interface dropDownMapper {
    List<DropdownDTO> categoryDropDown();
    List<DropdownDTO> brandDropDown();
    List<DropdownDTO> warehouseDropDown();
    List<DropdownDTO> sectionDropDown();
}

