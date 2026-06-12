package com.ssg.wms.product_stock.controller;

import com.ssg.wms.product_stock.dto.DropdownDTO;
import com.ssg.wms.product_stock.dto.PageRequestDTO;
import com.ssg.wms.product_stock.dto.PageResponseDTO;
import com.ssg.wms.product_stock.dto.ProductListDTO;
import com.ssg.wms.product_stock.service.ProductListService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Collections;
import java.util.List;

@Controller
@RequestMapping("/productList")
@RequiredArgsConstructor
@Log4j2
public class ProductListController {
    private final ProductListService productListService;

    @GetMapping("/plist")
     public String plist(PageRequestDTO pageRequestDTO, Model model) {
        List<DropdownDTO> categoryList = productListService.categoryDropDown();
        List<DropdownDTO> brandList = productListService.brandDropDown();
        List<DropdownDTO> warehouseList = productListService.warehouseDropDown();
        List<DropdownDTO> sectionList = Collections.emptyList();

        model.addAttribute("categoryList", categoryList);
        model.addAttribute("brandList", brandList);
        model.addAttribute("warehouseList", warehouseList);
        model.addAttribute("sectionList", sectionList);

        PageResponseDTO<ProductListDTO> responseDTO = productListService.getProductList(pageRequestDTO);
        model.addAttribute("responseDTO", responseDTO);

        return "stock/product";
    }

    @GetMapping("/api/plist")
    @ResponseBody // 💡 추가: JSON 데이터를 반환하도록 설정
    public PageResponseDTO<ProductListDTO> getProductListApi(PageRequestDTO pageRequestDTO) {
        log.info("Request DTO for API: {}", pageRequestDTO);

        // Service 로직을 호출하여 PageResponseDTO 객체를 JSON으로 변환하여 반환
        return productListService.getProductList(pageRequestDTO);
    }

}
