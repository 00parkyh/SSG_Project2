package com.ssg.wms.announcement.domain;

import com.ssg.wms.common.BoardStatus;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Announcement {
    private Long announcementId;
    private String title;
    private String content;
    private String writer;
    private boolean isImportant;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private BoardStatus status;
}
