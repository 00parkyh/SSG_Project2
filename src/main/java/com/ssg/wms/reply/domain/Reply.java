package com.ssg.wms.reply.domain;

import com.ssg.wms.common.BoardStatus;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Reply {
    private Long replyId;
    private Long inquiryId;
    private String title;
    private String content;
    private String writer;
    private LocalDateTime createdAt;
}

