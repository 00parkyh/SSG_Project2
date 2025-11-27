package com.ssg.wms.inquiry.mappers;

import com.ssg.wms.inquiry.dto.InquiryDTO;
import com.ssg.wms.inquiry.dto.InquirySearch;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface InquiryMapper {
    List<InquiryDTO> selectInquiries(InquirySearch search);

    int countInquiries(InquirySearch search);

    InquiryDTO selectInquiryById(Long inquiryId);

    void insertInquiry(InquiryDTO dto);

    void updateInquiry(InquiryDTO dto);

    void deleteInquiry(@Param(value = "inquiryId") Long inquiryId,
                       @Param(value = "password") String password);
}
