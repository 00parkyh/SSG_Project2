package com.ssg.wms.finance.controller;

import com.ssg.wms.finance.domain.SalesVO;
import com.ssg.wms.finance.dto.SalesPartnerDTO;
import com.ssg.wms.finance.dto.SalesRequestDTO;
import com.ssg.wms.finance.dto.SalesResponseDTO;
import com.ssg.wms.finance.dto.SalesSaveDTO;
import com.ssg.wms.finance.service.SalesService;
import com.ssg.wms.inbound.dto.InboundWarehouseDTO;
import com.ssg.wms.inbound.service.InboundAdminService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/sales")
@RequiredArgsConstructor
@Log4j2
public class SalesController {

    private final SalesService salesService;

    private final InboundAdminService inboundAdminService;

    // JSP 렌더링
    @GetMapping("/list")
    public String list(Model model, @ModelAttribute SalesRequestDTO dto) {
        SalesResponseDTO response = salesService.getSales(dto);
        model.addAttribute("response", response);

        // --- ▼ 3. 창고 목록과 거래처 목록을 조회해서 모델에 추가합니다. ---
        List<InboundWarehouseDTO> warehouseList = inboundAdminService.getWarehouseList();
        model.addAttribute("warehouseList", warehouseList);

        List<SalesPartnerDTO> partnerList = salesService.getPartnerList();
        model.addAttribute("partnerList", partnerList);
        // --- ▲ 3. ---

        return "sales/list";
    }

    // 1. 매출 내역 조회
    // REST API (모달용)
    @GetMapping("/api/list")
    @ResponseBody
    public ResponseEntity<SalesResponseDTO> getSalesListApi(@ModelAttribute SalesRequestDTO dto) {
        SalesResponseDTO response = salesService.getSales(dto);
        return ResponseEntity.ok(response);
    }
    /*@GetMapping
    public ResponseEntity<SalesResponseDTO> getSalesList(@ModelAttribute SalesRequestDTO dto) {
        SalesResponseDTO response = salesService.getSales(dto);
        return ResponseEntity.ok(response);
    }*/


    // 2. 매출 단일 조회
    @GetMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<SalesVO> getSaleApi(@PathVariable("id") Long id) {
        SalesVO salesVO = salesService.getSale(id);
        return ResponseEntity.ok(salesVO);
    }
    /*@GetMapping("/{id}")
    public ResponseEntity<SalesVO> getSale(@PathVariable("id") Long id) {
        SalesVO salesVO = salesService.getSale(id);
        return ResponseEntity.ok(salesVO);
    }*/


    // 3. 매출내역 등록
    @PostMapping("/api")
    @ResponseBody
    public ResponseEntity<Long> saveSalesApi(@RequestBody SalesSaveDTO dto) {
        Long newSalesId = salesService.saveSales(dto);
        return new ResponseEntity<>(newSalesId, HttpStatus.CREATED);
    }
    /*@PostMapping
    public ResponseEntity<Long> saveSales(@RequestBody SalesSaveDTO dto) {
        Long newSalesId = salesService.saveSales(dto);
        return new ResponseEntity<>(newSalesId, HttpStatus.CREATED);
    }*/


    // 4. 매출내역 수정
    @PutMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<String> updateSalesApi(@PathVariable("id") Long id, @RequestBody SalesSaveDTO dto) {
        salesService.updateSales(id, dto);
        return ResponseEntity.ok("success");
    }
    /*@PutMapping("/{id}")
    public ResponseEntity<String> updateSale(@PathVariable("id") Long id, @RequestBody SalesSaveDTO dto) {
        salesService.updateSales(id, dto);
        return ResponseEntity.ok("success");
    }*/

    // 5. 지출내역 삭제
    @DeleteMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<String> deleteSalesApi(@PathVariable("id") Long id) {
        salesService.deleteSales(id);
        return ResponseEntity.ok("success");
    }
    /*@DeleteMapping("/{id}")
    public ResponseEntity<String> deleteSale(@PathVariable("id") Long id) {
        salesService.deleteSales(id);
        return ResponseEntity.ok("success");
    }*/
}