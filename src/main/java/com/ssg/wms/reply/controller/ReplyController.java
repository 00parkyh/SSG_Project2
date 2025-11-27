package com.ssg.wms.reply.controller;

import com.ssg.wms.reply.dto.ReplyDTO;
import com.ssg.wms.reply.service.ReplyService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@Log4j2
@RestController
@RequestMapping("/api/inquiries/{inquiryId}")
@RequiredArgsConstructor
public class ReplyController {
    private final ReplyService replyService;

    // 문의 답글 목록 조회
    @GetMapping("")
    public ResponseEntity<List<ReplyDTO>> getReplies(@PathVariable Long inquiryId) {
        log.info("getReplies inquiryId:" + inquiryId);
        return ResponseEntity.ok(replyService.getReplies(inquiryId));
    }

    // 문의 답글 작성
    @PostMapping("/reply")
    public ResponseEntity<ReplyDTO> saveReply(@PathVariable Long inquiryId,
                                              @Valid @RequestBody ReplyDTO replyDTO) {
        ReplyDTO saved = replyService.saveReply(inquiryId, replyDTO);
        log.info("saveReply inquiryId:" + inquiryId + " replyDTO:" + saved);
        return ResponseEntity.ok(saved);
    }

    // 문의 답글 상세 조회
    @GetMapping("/reply/{replyId}")
    public ResponseEntity<ReplyDTO> getReplyDetail(@PathVariable Long inquiryId,
                                                   @PathVariable Long replyId) {
        log.info("getReplyDetail inquiryId:" + inquiryId);
        return ResponseEntity.ok(replyService.getReplyDetail(inquiryId, replyId));
    }

    // 문의 답글 삭제 = 내용만 바꿈(삭제되었습니다)
    @PutMapping("/reply/{replyId}")
    public ResponseEntity<String> deleteReply(@PathVariable Long inquiryId,
                                              @PathVariable Long replyId) {
        replyService.deleteReply(inquiryId, replyId);
        log.info("deleteReply inquiryId:" + inquiryId);
        return ResponseEntity.ok("삭제 완료");
    }
}
