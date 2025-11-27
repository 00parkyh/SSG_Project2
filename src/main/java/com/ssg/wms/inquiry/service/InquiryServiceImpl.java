package com.ssg.wms.inquiry.service;

import com.ssg.wms.inquiry.dto.InquiryDTO;
import com.ssg.wms.inquiry.dto.InquiryPageDTO;
import com.ssg.wms.inquiry.dto.InquirySearch;
import com.ssg.wms.inquiry.mappers.InquiryMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import java.util.List;

@Service
@Log4j2
@RequiredArgsConstructor
public class InquiryServiceImpl implements InquiryService {
    private final InquiryMapper inquiryMapper;

    @Override
    public void getInquiries(InquirySearch search, Model model) {
        List<InquiryDTO> list = inquiryMapper.selectInquiries(search);

        int totalCount = inquiryMapper.countInquiries(search);

        InquiryPageDTO pageDTO = new InquiryPageDTO(
                search.getPage(),
                search.getSize(),
                totalCount
        );

        model.addAttribute("inquiries", list);
        model.addAttribute("currentPage", pageDTO.getPageNum());
        model.addAttribute("totalPages", pageDTO.getTotal());
        model.addAttribute("startPage", pageDTO.getStartPage());
        model.addAttribute("endPage", pageDTO.getEndPage());
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("keyword", search.getKeyword() != null ? search.getKeyword() : "");
    }

    @Override
    public InquiryDTO getInquiry(Long id) {
        return inquiryMapper.selectInquiryById(id);
    }

    @Override
    public Long saveInquiry(InquiryDTO dto) {
        inquiryMapper.insertInquiry(dto);
        return dto.getInquiryId();
    }

    @Override
    public void updateInquiry(InquiryDTO dto) {
        inquiryMapper.updateInquiry(dto);
    }

    @Override
    public void deleteInquiry(Long inquiryId, String password) {
        inquiryMapper.deleteInquiry(inquiryId, password);
    }
}
