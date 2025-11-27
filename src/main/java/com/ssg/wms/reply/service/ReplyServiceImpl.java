package com.ssg.wms.reply.service;

import com.ssg.wms.reply.dto.ReplyDTO;
import com.ssg.wms.reply.mappers.ReplyMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import java.util.List;

@Log4j2
@Service
@RequiredArgsConstructor
public class ReplyServiceImpl implements ReplyService {
    private final ReplyMapper replyMapper;

    @Override
    public List<ReplyDTO> getReplies(Long inquiryId) {
        log.info("getReplies inquiryId:" + inquiryId);
        return replyMapper.findRepliesByInquiryId(inquiryId);
    }

    @Override
    public ReplyDTO saveReply(Long inquiryId, ReplyDTO replyDTO) {
        replyDTO.setInquiryId(inquiryId);
        replyMapper.insertReply(replyDTO);
        log.info("saveReply inquiryId:" + inquiryId);
        return replyDTO;
    }

    @Override
    public ReplyDTO getReplyDetail(Long inquiryId, Long replyId) {
        log.info("getReplyDetail inquiryId:" + inquiryId);
        return replyMapper.findByIdAndInquiryId(replyId, inquiryId);
    }

    @Override
    public void deleteReply(Long inquiryId, Long replyId) {
        replyMapper.deleteReply(replyId, inquiryId);
    }
}
