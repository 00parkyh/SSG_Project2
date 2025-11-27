package com.ssg.wms.inquiry.domain;

import com.ssg.wms.common.BoardStatus;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Inquiry {
    private Long inquiryId;
    private String title;
    private String content;
    private String writer;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private BoardStatus status;
}
