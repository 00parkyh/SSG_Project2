package com.ssg.wms.announcement.mappers;

import com.ssg.wms.announcement.dto.AnnouncementDTO;
import com.ssg.wms.announcement.dto.AnnouncementSearch;

import java.util.List;

public interface AnnouncementMapper {
    List<AnnouncementDTO> selectAnnouncements(AnnouncementSearch search);

    int countAnnouncements(AnnouncementSearch search);

    AnnouncementDTO selectAnnouncementById(Long id);

    void insertAnnouncement(AnnouncementDTO dto);

    void updateAnnouncement(AnnouncementDTO dto);

    void deleteAnnouncement(Long id);
}
