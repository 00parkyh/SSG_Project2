package com.ssg.wms.finance.dto;

import com.ssg.wms.finance.domain.ExpenseVO;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ExpenseResponseDTO { // 지출 목록 응답용
    private int page;
    private int size;
    private int total;
    private List<ExpenseVO> expenses;

    // Mybatis 에서 offset 계산을 위한 getter
    public int getOffset() {
        return (page - 1) * size;
    }
}
