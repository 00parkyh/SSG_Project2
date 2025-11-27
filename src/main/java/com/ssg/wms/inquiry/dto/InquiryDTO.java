package com.ssg.wms.inquiry.dto;

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
public class InquiryDTO {
    private Long inquiryId;
    private String title;
    private String content;
    private String writer;
    private boolean isImportant;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private BoardStatus status;
    private String password;
}
