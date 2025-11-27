package com.ssg.wms.reply.mappers;

import com.ssg.wms.reply.dto.ReplyDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ReplyMapper {
    List<ReplyDTO> findRepliesByInquiryId(Long inquiryId);
    void insertReply(ReplyDTO replyDTO);
    ReplyDTO findByIdAndInquiryId(@Param(value = "replyId") Long replyId,
                                  @Param(value = "inquiryId") Long inquiryId);
    void deleteReply(@Param(value = "replyId") Long replyId,
                     @Param(value = "inquiryId") Long inquiryId);
}
