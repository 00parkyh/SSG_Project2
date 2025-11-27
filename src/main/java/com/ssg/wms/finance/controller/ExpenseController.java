package com.ssg.wms.finance.controller;

// ... (기존 import) ...
import com.ssg.wms.finance.domain.ExpenseVO;
import com.ssg.wms.finance.dto.ExpenseRequestDTO;
import com.ssg.wms.finance.dto.ExpenseResponseDTO;
import com.ssg.wms.finance.dto.ExpenseSaveDTO;
import com.ssg.wms.finance.service.ExpenseService;

// --- ▼ 1. 필요한 서비스와 DTO를 import 합니다. ---
import com.ssg.wms.inbound.dto.InboundWarehouseDTO;
import com.ssg.wms.inbound.service.InboundAdminService;
// --- ▲ 1. ---

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List; // java.util.List import

@Log4j2
@RequestMapping("/admin/expense")
@Controller
@RequiredArgsConstructor
public class ExpenseController {

    private final ExpenseService expenseService;

    // --- ▼ 2. InboundAdminService를 주입받습니다. ---
    private final InboundAdminService inboundAdminService;
    // --- ▲ 2. ---

    /**
     * 지출 목록 페이지 (JSP 렌더링) - 화면 요청
     * URL: GET /expense/list
     */
    @GetMapping("/list")
    public String list(Model model, @ModelAttribute ExpenseRequestDTO dto) {
        log.info("Expense list page request: {}", dto);

        // 기존 로직: 지출 목록 조회
        ExpenseResponseDTO responseDTO = expenseService.getExpenses(dto);
        model.addAttribute("response", responseDTO);

        // --- ▼ 3. 창고 목록을 조회해서 모델에 추가합니다. ---
        List<InboundWarehouseDTO> warehouseList = inboundAdminService.getWarehouseList();
        model.addAttribute("warehouseList", warehouseList);
        // --- ▲ 3. ---

        return "expense/list";
    }

    // 1. 지출 목록 조회
    @GetMapping("/api/list")
    @ResponseBody
    public ResponseEntity<ExpenseResponseDTO> getExpenseListApi(@ModelAttribute ExpenseRequestDTO dto) {
        // ... (기존 코드 그대로)
        log.info("API: Get expense list: {}", dto);
        ExpenseResponseDTO response = expenseService.getExpenses(dto);
        return ResponseEntity.ok(response);
    }


    // 2. 지출 단일 조회
    @GetMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<ExpenseVO> getExpenseApi(@PathVariable("id") Long id) {
        // ... (기존 코드 그대로)
        log.info("API: Get expense by id: {}", id);
        ExpenseVO expenseVO = expenseService.getExpense(id);
        return ResponseEntity.ok(expenseVO);
    }


    // 3. 지출내역 등록
    @PostMapping("/api")
    @ResponseBody
    public ResponseEntity<Long> saveExpenseApi(@RequestBody ExpenseSaveDTO dto) {
        // ... (기존 코드 그대로)
        log.info("API: Save expense: {}", dto);
        Long newExpenseId = expenseService.saveExpense(dto);
        return new ResponseEntity<>(newExpenseId, HttpStatus.CREATED);
    }


    // 4. 지출내역 수정
    @PutMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<String> updateExpenseApi(@PathVariable("id") Long id, @RequestBody ExpenseSaveDTO dto) {
        // ... (기존 코드 그대로)
        log.info("API: Update expense id {}: {}", id, dto);
        expenseService.updateExpense(id, dto);
        return ResponseEntity.ok("success");
    }


    // 5. 지출내역 삭제
    @DeleteMapping("/api/{id}")
    @ResponseBody
    public ResponseEntity<String> deleteExpenseApi(@PathVariable("id") Long id) {
        // ... (기존 코드 그대로)
        log.info("API: Delete expense id: {}", id);
        expenseService.deleteExpense(id);
        return ResponseEntity.ok("success");
    }
}