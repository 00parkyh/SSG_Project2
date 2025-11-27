package com.ssg.wms.finance.domain;

import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Builder(toBuilder = true)
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class SalesVO {
    private Long id;            // 매출 ID (PK)
    private String salesCode; // 매출 관리번호
    private String status;
    private String warehouseName;    // 창고명
    private LocalDate salesDate;     // 매출일자
    private String category;         // 매출 분류
    private String clientName;       // 고객사명
    private Long amount;             // 매출액수
    private String description;      // 매출 설명
    private LocalDateTime regDate;   // 등록일자
    private LocalDateTime modDate;   // 수정일자
}
