package com.ssg.wms.common;

import java.util.Arrays;
import java.util.List;

public enum AdjustmentStatus {
    NOT_ADJUSTED("조정 미필요"),
    WAITING("조정 대기"),
    IN_PROGRESS("조정 진행중"),
    COMPLETED("조정 완료");

    private final String dbValue;

    AdjustmentStatus(String dbValue) {
        this.dbValue = dbValue;
    }

    public String getDbValue() {
        return dbValue;
    }

    public String getLabel() {
        return dbValue;
    }

    public static List<AdjustmentStatus> selectableValues() {
        return Arrays.asList(values());
    }

    public static AdjustmentStatus fromDbValue(String dbValue) {
        return Arrays.stream(values())
                .filter(status -> status.dbValue.equals(dbValue))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Unknown adjustment status: " + dbValue));
    }

    public static AdjustmentStatus defaultStatus() {
        return NOT_ADJUSTED;
    }
}
