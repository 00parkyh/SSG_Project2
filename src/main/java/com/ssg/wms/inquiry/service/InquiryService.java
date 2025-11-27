package com.ssg.wms.inquiry.service;

import com.ssg.wms.inquiry.dto.InquiryDTO;
import com.ssg.wms.inquiry.dto.InquirySearch;
import org.springframework.ui.Model;

public interface InquiryService {
    void getInquiries(InquirySearch search, Model model);
    InquiryDTO getInquiry(Long id);
    Long saveInquiry(InquiryDTO dto);
    void updateInquiry(InquiryDTO dto);
    void deleteInquiry(Long inquiryId, String password);
}
