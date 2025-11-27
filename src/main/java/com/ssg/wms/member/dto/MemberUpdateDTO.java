package com.ssg.wms.member.dto;

import lombok.Data;

@Data
public class MemberUpdateDTO {
    private Long memberId;
    private String memberEmail;
    private String memberPhone;
}
