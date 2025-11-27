package com.ssg.wms.announcement.dto;

import com.ssg.wms.common.BoardStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AnnouncementDTO {
    private Long announcementId;
    private String title;
    private String content;
    private String writer;
    private boolean isImportant;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private BoardStatus status;
}
