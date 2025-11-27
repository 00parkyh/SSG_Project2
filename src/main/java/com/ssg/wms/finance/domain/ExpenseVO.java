package com.ssg.wms.finance.domain;

import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Builder(toBuilder = true)
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class ExpenseVO {
    private Long id;          // 지출 ID (PK)
    private String expenseCode; // 지출 관리번호
    private String status;
    private String warehouseName;    // 창고명
    private LocalDate expenseDate;   // 지출일자
    private String category;         // 지출 분류
    private Long amount;             // 지출액수
    private String description;      // 지출 설명
    private LocalDateTime regDate;   // 등록일자
    private LocalDateTime modDate;   // 수정일자
}
