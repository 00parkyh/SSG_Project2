package com.ssg.wms.inbound.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class InboundDTO {
    private int inboundId;
    private int warehouseId;
    private String warehouseName;
    private Long memberId;
    private Long partnerId;
    private String partnerName;
    private String memberName;
    private int staffId;
    private String staffName;
    private String inboundStatus; // request, cancelled, approved, rejected
    private String inboundRejectReason;

    // ISO 8601 문자열로 내려가기
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss", timezone = "Asia/Seoul")
    private LocalDateTime inboundRequestedAt;

    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss", timezone = "Asia/Seoul")
    private LocalDateTime inboundUpdatedAt;

    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss", timezone = "Asia/Seoul")
    private LocalDateTime inboundAt;

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

    private List<InboundItemDTO> inboundItems = new ArrayList<>();
}

@Data
@AllArgsConstructor
@NoArgsConstructor
class InboundItemDTO {
    private int inboundItemId;
    private int inboundId;
    private String productId;
    private String productName;
    private int quantity;
    private int categoryCd;
    private String categoryName; // JS에서 사용 중
}
