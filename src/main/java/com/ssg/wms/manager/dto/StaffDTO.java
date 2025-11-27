package com.ssg.wms.manager.dto;

import com.ssg.wms.common.AccountStatus;
import com.ssg.wms.common.Role;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StaffDTO {
    private Long staffId;
    private String staffLoginId;
    private String staffName;
    private String staffPhone;
    private String staffEmail;
    private Role role;
    private AccountStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
