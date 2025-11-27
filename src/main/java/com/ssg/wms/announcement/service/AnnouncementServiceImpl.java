package com.ssg.wms.announcement.service;

import com.ssg.wms.announcement.dto.AnnouncementDTO;
import com.ssg.wms.announcement.dto.AnnouncementSearch;
import com.ssg.wms.announcement.dto.AnnouncementPageDTO;
import com.ssg.wms.announcement.mappers.AnnouncementMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import java.util.List;

@Service
@Log4j2
@RequiredArgsConstructor
public class AnnouncementServiceImpl implements AnnouncementService {
    private final AnnouncementMapper announcementMapper;

    public void getAnnouncements(AnnouncementSearch search, Model model) {
        List<AnnouncementDTO> list = announcementMapper.selectAnnouncements(search);
        log.info("조회된 공지사항 개수: {}", list.size());
        int totalCount = announcementMapper.countAnnouncements(search);
        log.info("전체 공지사항 개수: {}", totalCount);

        AnnouncementPageDTO pageDTO = new AnnouncementPageDTO(
                search.getPage(),
                search.getSize(),
                totalCount
        );

        model.addAttribute("announcements", list);
        model.addAttribute("currentPage", pageDTO.getPageNum());
        model.addAttribute("totalPages", pageDTO.getTotalPages());
        model.addAttribute("startPage", pageDTO.getStartPage());
        model.addAttribute("endPage", pageDTO.getEndPage());
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("keyword", search.getKeyword() != null ? search.getKeyword() : "");

    }

    public AnnouncementDTO getAnnouncement(Long id) {
        return announcementMapper.selectAnnouncementById(id);
    }

    public Long saveAnnouncement(AnnouncementDTO dto) {
        announcementMapper.insertAnnouncement(dto);
        return dto.getAnnouncementId(); // MyBatis의 useGeneratedKeys 사용 가정
    }

    public void updateAnnouncement(AnnouncementDTO dto) {
        announcementMapper.updateAnnouncement(dto);
        log.info("Service - updateAnnouncement 실행 완료");
    }

    public void deleteAnnouncement(Long id) {
        announcementMapper.deleteAnnouncement(id);
    }
}
