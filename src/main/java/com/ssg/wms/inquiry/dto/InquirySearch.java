package com.ssg.wms.inquiry.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InquirySearch {
    private String keyword;

    // 페이징
    private int page = 1;     // 현재 페이지
    private int size = 10;    // 페이지당 게시글 수

    public int getOffset() {
        return (page - 1) * size;
    }
}
