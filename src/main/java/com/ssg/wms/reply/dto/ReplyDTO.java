package com.ssg.wms.reply.dto;

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
public class ReplyDTO {
    private Long replyId;
    private Long inquiryId;
    private String content;
    private String writer;
    private LocalDateTime createdAt;
}
