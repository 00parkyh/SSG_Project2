package com.ssg.wms.outbound.domain;


import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum OutboundStatus {
    APPROVED("승인"),
    PENDING("승인대기"),
    COMPANION("반려");

    private final String korean;

    public static OutboundStatus fromKorean(String korean) {
        for (OutboundStatus s : values()) {
            if (s.korean.equals(korean)) return s;
        }
        return null;
    }
}
