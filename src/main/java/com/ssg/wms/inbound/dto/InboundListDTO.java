package com.ssg.wms.inbound.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class InboundListDTO {
    private Long inboundId;
    private LocalDateTime inboundRequestedAt;
    private String memberName;
    private String inboundStatus;
    private String partnerName; // 관리자용에서만 사용

    public String getInboundRequestedDate() {
        if (inboundRequestedAt == null) return "";
        return inboundRequestedAt.toLocalDate().toString();
        // 또는 DateTimeFormatter 사용 가능
        // return inboundRequestedAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }

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
