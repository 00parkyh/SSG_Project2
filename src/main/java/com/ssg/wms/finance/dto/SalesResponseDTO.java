package com.ssg.wms.finance.dto;

import com.ssg.wms.finance.domain.SalesVO;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class SalesResponseDTO { // 매출 목록 응답용
    private int page;
    private int size;
    private int total;
    private List<SalesVO> sales;
}
