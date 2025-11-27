package com.ssg.wms.inquiry.controller;

import com.ssg.wms.inquiry.dto.InquiryDTO;
import com.ssg.wms.inquiry.dto.InquirySearch;
import com.ssg.wms.inquiry.service.InquiryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

@Controller
@Log4j2
@RequestMapping("/inquiries")
@RequiredArgsConstructor
public class InquiryController {

    private final InquiryService inquiryService;

    // 문의 목록 조회
    @GetMapping
    public String getInquiries(@ModelAttribute InquirySearch inquirySearch,
                                   HttpSession session,
                                   Model model) {
        log.info("=== 문의사항 목록 조회 요청 ===");
        log.info("검색 조건: {}", inquirySearch);
        inquiryService.getInquiries(inquirySearch, model);
        log.info("Model attributes: {}", model.asMap().keySet());

        model.addAttribute("role", session.getAttribute("role"));

        return "inquiries/list"; // JSP 경로
    }

    // 문의 상세조회
    @GetMapping("/{id}")
    public String getInquiry(@PathVariable("id") Long id,
                                  Model model) {
        InquiryDTO dto = inquiryService.getInquiry(id);
        model.addAttribute("inquiry", dto);
        return "inquiries/detail";
    }

    // 문의 작성 폼
    @GetMapping("/save")
    public String getSaveForm(Model model) {
        model.addAttribute("inquiry", new InquiryDTO());
        return "inquiries/save";
    }

    // 문의 작성 처리
    @PostMapping("/save")
    public String postSaveForm(@Valid @ModelAttribute("inquiry") InquiryDTO inquiryDTO,
                               BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            return "inquiries/save";
        }

        Long savedId = inquiryService.saveInquiry(inquiryDTO);
        return "redirect:/inquiries/" + savedId;
    }

    // 문의 수정 폼
    @GetMapping("/{id}/edit")
    public String getUpdateForm(@PathVariable("id") Long id,
                                Model model) {
        InquiryDTO dto = inquiryService.getInquiry(id);
        model.addAttribute("inquiry", dto);
        return "inquiries/edit";
    }

    // 문의 수정 처리
    @PostMapping("/{id}/edit")
    public String postUpdateForm(@Valid @ModelAttribute("inquiry") InquiryDTO inquiryDTO,
                                 BindingResult bindingResult,
                                 @PathVariable("id") Long id) {
        if (bindingResult.hasErrors()) {
            return "inquiries/edit";
        }

        inquiryService.updateInquiry(inquiryDTO);
        return "redirect:/inquiries/" + id;
    }

    // 문의 삭제
    @PostMapping("/{id}/delete")
    public String postDelete(@PathVariable("id") Long id,
                             @RequestParam String password) {
        inquiryService.deleteInquiry(id, password);
        return "redirect:/inquiries";
    }
}

