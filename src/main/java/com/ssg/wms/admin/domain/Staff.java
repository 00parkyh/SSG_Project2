package com.ssg.wms.admin.domain;


import com.ssg.wms.common.AccountStatus;
import com.ssg.wms.common.Role;
import lombok.*;

import java.time.LocalDateTime;

@Data
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Staff {
    private Long staffId;
    private String staffLoginId;
    private String staffName;
    private String staffPw;
    private String staffPhone;
    private String staffEmail;
    private Role role;
    private AccountStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;


}
