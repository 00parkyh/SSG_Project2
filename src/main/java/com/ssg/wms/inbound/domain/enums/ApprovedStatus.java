package com.ssg.wms.inbound.domain.enums;

public enum ApprovedStatus {
    APPROVED("승인"),
    PENDING("승인대기"),
    COMPANION("반려"),
    COMPLETED("출고완료");

    private final String description;

    ApprovedStatus(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }

    // 한글 -> 영문 변환
    public static ApprovedStatus fromDescription(String description) {
        for (ApprovedStatus status : values()) {
            if (status.description.equals(description)) {
                return status;
            }
        }
        return null;
    }

    // 영문 -> 한글 변환
    public static String toDescription(String name) {
        try {
            return ApprovedStatus.valueOf(name).getDescription();
        } catch (IllegalArgumentException e) {
            return name; // 변환 실패 시 원본 반환
        }
    }
}
