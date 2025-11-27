package com.ssg.wms.announcement.controller;

import com.ssg.wms.announcement.dto.AnnouncementDTO;
import com.ssg.wms.announcement.dto.AnnouncementSearch;
import com.ssg.wms.announcement.service.AnnouncementService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.List;

@Controller
@Log4j2
@RequestMapping("/announcements")
@RequiredArgsConstructor
public class AnnouncementController {

    private final AnnouncementService announcementService;

    // 공지 목록 조회
    @GetMapping
    public String getAnnouncements(@ModelAttribute AnnouncementSearch announcementSearch,
                                   Model model) {
        log.info("=== 공지사항 목록 조회 요청 ===");
        log.info("검색 조건: {}", announcementSearch);
        announcementService.getAnnouncements(announcementSearch, model);
        log.info("Model attributes: {}", model.asMap().keySet());
        return "announcements/list"; // JSP 경로
    }

    // 공지 상세조회
    @GetMapping("/{id}")
    public String getAnnouncement(@PathVariable("id") Long id,
                                  Model model) {
        AnnouncementDTO dto = announcementService.getAnnouncement(id);
        model.addAttribute("announcement", dto);
        return "announcements/detail";
    }

    // 공지 작성 폼
    @GetMapping("/save")
    public String getSaveForm(Model model, HttpSession session) {
        model.addAttribute("announcement", new AnnouncementDTO());
        log.info("세션 로그: {}", session.getAttribute("role"));
        return "announcements/save";
    }

    // 공지 작성 처리
    @PostMapping("/save")
    public String postSaveForm(@Valid @ModelAttribute("announcement") AnnouncementDTO announcementDTO,
                               BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            return "announcements/save";
        }

        Long savedId = announcementService.saveAnnouncement(announcementDTO);
        return "redirect:/announcements/" + savedId;
    }

    // 공지 수정 폼
    @GetMapping("/{id}/edit")
    public String getUpdateForm(@PathVariable("id") Long id,
                                Model model) {
        AnnouncementDTO dto = announcementService.getAnnouncement(id);
        model.addAttribute("announcement", dto);
        return "announcements/edit";
    }

    // 공지 수정 처리
    @PostMapping("/{id}/edit")
    public String postUpdateForm(@Valid @ModelAttribute("announcement") AnnouncementDTO announcementDTO,
                                 BindingResult bindingResult,
                                 @PathVariable("id") Long id) {

        if (bindingResult.hasErrors()) {
            log.info("Binding Error: 수정 오류");
            return "announcements/edit";
        }

        announcementService.updateAnnouncement(announcementDTO);
        log.info("수정 완료: {}", announcementDTO);
        return "redirect:/announcements/" + id;
    }

    // 공지 삭제
    @PostMapping("/{id}/delete")
    public String postDelete(@PathVariable("id") Long id) {
        announcementService.deleteAnnouncement(id);
        return "redirect:/announcements";
    }
}

