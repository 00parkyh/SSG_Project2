package com.ssg.wms.member.domain;

import com.ssg.wms.common.AccountStatus;
import com.ssg.wms.common.Role;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Member {
    private Long memberId;
    private String memberLoginId;
    private String memberName;
    private String memberPw;
    private String memberPhone;
    private String memberEmail;
    private Role role;
    private AccountStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String businessNumber;
    private int partnerId;
}
