package com.ssg.wms.inbound.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ssg.wms.product_ehs.dto.CategoryDTO;
import com.ssg.wms.product_ehs.dto.ProductDTO;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDateTime;
import java.util.List;

@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class InboundDetailDTO {
    private Long inboundId;
    private Long warehouseId;
    private String warehouseName;
    private Integer partnerId;
    private String partnerName;
    private Long memberId;
    private String memberName;
    private int staffId;
    private String staffName;
    private String inboundStatus;
    private String inboundRejectReason;
    private String inboundStatusKor;
    private List<InboundItemDTO> inboundItems;

    // ISO 8601 문자열로 내려가기
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss", timezone = "Asia/Seoul")
    private LocalDateTime inboundRequestedAt;

    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss", timezone = "Asia/Seoul")
    private LocalDateTime inboundUpdatedAt;

    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss", timezone = "Asia/Seoul")
    private LocalDateTime inboundAt;

    // 추가
    private List<CategoryDTO> categories; // 전체 카테고리 리스트
    private List<ProductDTO> products;   // 전체 상품 리스트 (사용자 거래처 필터)

    public String getInboundStatusKor() {
        if(inboundStatus == null) {
            return "";
        }
        switch (inboundStatus) {
            case "request":
                return "처리 대기";
            case "cancelled":
                return "요청 취소";
            case "approved":
                return "승인 완료";
            case "rejected":
                return "반려";
            default:
                return inboundStatus;
        }
    }
}
