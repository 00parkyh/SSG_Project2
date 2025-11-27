package com.ssg.wms.outbound.domain.dto;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class OutboundItemDTO {
    private Long outboundItemId;        // 출고품목 고유번호 (DB용)
    private Long outboundRequestId;     // 출고요청 ID (DB용)
    private String productId;             // JSON에서는 productId
    private Integer outboundQuantity;   // JSON에서는 outboundQuantity
    private String productName;
    private String categoryCd;          // ✅ 추가 필요 (JSP에서 전송)
    private String categoryName;
}
