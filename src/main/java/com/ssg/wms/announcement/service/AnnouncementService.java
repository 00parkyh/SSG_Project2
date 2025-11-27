package com.ssg.wms.announcement.service;

import com.ssg.wms.announcement.dto.AnnouncementDTO;
import com.ssg.wms.announcement.dto.AnnouncementSearch;
import org.springframework.ui.Model;

import java.util.List;

public interface AnnouncementService {
    void getAnnouncements(AnnouncementSearch search, Model model);
    AnnouncementDTO getAnnouncement(Long id);
    Long saveAnnouncement(AnnouncementDTO dto);
    void updateAnnouncement(AnnouncementDTO dto);
    void deleteAnnouncement(Long id);
}
