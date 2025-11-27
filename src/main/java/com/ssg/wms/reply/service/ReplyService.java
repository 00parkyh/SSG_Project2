package com.ssg.wms.reply.service;

import com.ssg.wms.reply.dto.ReplyDTO;

import java.util.List;

public interface ReplyService {
    List<ReplyDTO> getReplies(Long inquiryId);
    ReplyDTO saveReply(Long inquiryId, ReplyDTO replyDTO);
    ReplyDTO getReplyDetail(Long inquiryId, Long replyId);
    void deleteReply(Long inquiryId, Long replyId);
}
