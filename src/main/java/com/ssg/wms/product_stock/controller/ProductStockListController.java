package com.ssg.wms.product_stock.controller;

import com.ssg.wms.product_stock.dto.*;
import com.ssg.wms.product_stock.service.ProductStockService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.*;

@Controller
@RequestMapping("/stock")
@RequiredArgsConstructor
@Log4j2
public class ProductStockListController {

    private final ProductStockService productStockService;

    @GetMapping("/list")
    public String drop_down_list(PageRequestDTO pageRequestDTO, Model model){
        List<DropdownDTO> categoryList = productStockService.categoryDropDown();
        List<DropdownDTO> brandList = productStockService.brandDropDown();
        List<DropdownDTO> warehouseList = productStockService.warehouseDropDown();
        List<DropdownDTO> sectionList = productStockService.sectionDropDown();

        model.addAttribute("categoryList", categoryList);
        model.addAttribute("brandList", brandList);
        model.addAttribute("warehouseList", warehouseList);
        model.addAttribute("sectionList", sectionList);

        PageResponseDTO<StockInfoDTO> responseDTO = productStockService.getStockList(pageRequestDTO);
        model.addAttribute("responseDTO", responseDTO);

        return "stock/stock-list";
    }

    @GetMapping("/search") // 💡 새로운 엔드포인트
    @ResponseBody // 💡 응답 데이터를 JSON으로 변환하여 본문에 직접 작성하도록 지시
    public PageResponseDTO<StockInfoDTO> searchStockList(
            @RequestParam(required = false) String categoryCd,
            @RequestParam(required = false) String partnerId,
            @RequestParam(required = false) String warehouseId,
            @RequestParam(required = false) String sectionId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {

        PageRequestDTO pageRequestDTO = PageRequestDTO.builder()
                .page(page)
                .size(size)
                .categoryCd(parseLongOrNull(categoryCd))
                .partnerId(parseLongOrNull(partnerId))
                .warehouseId(parseLongOrNull(warehouseId))
                .sectionId(parseLongOrNull(sectionId))
                .build();

        return productStockService.getStockList(pageRequestDTO);
    }

    private Long parseLongOrNull(String str) {
        if (str == null || str.isBlank()) return null;
        try { return Long.valueOf(str); }
        catch (NumberFormatException e) { return null; }
    }

    @GetMapping("/detail")
    public String productDetail(@RequestParam("productId") String productId, Model model) {
        StockSummaryDTO summary = productStockService.getProductSummary(productId);
        List<StockLogDTO> logList = productStockService.getStockMovementLogs(productId);

        model.addAttribute("summary", summary);
        model.addAttribute("logList", logList);

        return "stock/stock-detail";
    }

    @GetMapping("/stock/detail/{productId}")
    public String getStockDetail(@PathVariable String productId, Model model) {
        // 상품 요약 정보
        model.addAttribute("summary", productStockService.getProductSummary(productId));

        // 이동 로그
        List<StockLogDTO> logs = productStockService.getStockMovementLogs(productId);

        // LocalDateTime → 문자열 변환 포맷 지정
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

        List<Map<String, Object>> formattedLogs = new ArrayList<>();

        for (StockLogDTO log : logs) {
            Map<String, Object> map = new HashMap<>();
            if (log.getEventTime() != null) {
                map.put("eventTime", log.getEventTime().format(formatter));
            } else {
                map.put("eventTime", "");
            }
            map.put("eventType", log.getEventType());
            map.put("moveQuantity", log.getMoveQuantity());
            map.put("destination", log.getDestination());
            map.put("productStatus", log.getProductStatus());
            map.put("sectionName", log.getSectionName());
            formattedLogs.add(map);
        }

        model.addAttribute("logs", formattedLogs);

        return "product_stock/detail"; // JSP 경로에 맞게 조정
    }

}