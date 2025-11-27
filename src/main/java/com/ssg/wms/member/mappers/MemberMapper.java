package com.ssg.wms.member.mappers;

import com.ssg.wms.member.dto.MemberDTO;
import com.ssg.wms.member.dto.MemberUpdateDTO;
import org.apache.ibatis.annotations.Param;

public interface MemberMapper {
    MemberDTO findByLoginIdAndPw(@Param(value = "loginId") String loginId, @Param(value = "password") String password);
    MemberDTO getMemberDetails(long memberId);
    long findMemberIdByMemberLoginId(String memberLoginId);
    void insertMember(MemberDTO memberDTO);
    void updateMember(MemberUpdateDTO memberUpdateDTO);
    String getPartnerName(int partnerId);
    int getPartnerIdByBusinessNumber(String businessNumber);
}
