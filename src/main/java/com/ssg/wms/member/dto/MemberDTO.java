package com.ssg.wms.member.dto;

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
public class MemberDTO {
    private Long memberId;
    private String memberLoginId;
    private String memberPw;
    private String memberName;
    private String memberPhone;
    private String memberEmail;
    private Role role;
    private AccountStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String businessNumber;
    private int partnerId;
}
