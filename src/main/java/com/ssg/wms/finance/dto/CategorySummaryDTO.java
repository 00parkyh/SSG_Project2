package com.ssg.wms.finance.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Builder
@Data
@AllArgsConstructor
public class CategorySummaryDTO {
    private String category;
    private Long totalAmount;
}
