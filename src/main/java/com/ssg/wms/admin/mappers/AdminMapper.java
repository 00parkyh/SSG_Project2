package com.ssg.wms.admin.mappers;

import com.ssg.wms.admin.domain.Staff;
import com.ssg.wms.member.domain.Member;
import com.ssg.wms.admin.dto.MemberCriteria;
import com.ssg.wms.manager.dto.StaffDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AdminMapper {
    Staff findByLoginIdAndPw(@Param(value = "loginId") String loginId, @Param(value = "password") String password);
    StaffDTO getStaffDetails(long staffId);
    long findStaffIdByStaffLoginId(String staffLoginId);
    List<Member> getMembersByCriteria(MemberCriteria criteria);
    Member getMemberDetails(long memberId);
    int getMemberTotalCount(MemberCriteria criteria);
    void updateMemberStatus(@Param("memberId") long memberId, @Param("status") String status);

}
