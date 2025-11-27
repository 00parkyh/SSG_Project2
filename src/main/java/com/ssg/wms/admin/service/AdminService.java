package com.ssg.wms.admin.service;

import com.ssg.wms.admin.domain.Staff;
import com.ssg.wms.member.domain.Member;
import com.ssg.wms.admin.dto.MemberCriteria;
import com.ssg.wms.manager.dto.StaffDTO;
import com.ssg.wms.common.AccountStatus;
import com.ssg.wms.member.dto.MemberDTO;

import java.util.List;

public interface AdminService {
    StaffDTO getStaffDetails(long staffId);
    List<Member> getMembersByCriteria(MemberCriteria criteria);
    Member getMemberDetails(long memberId);
    long findStaffIdByStaffLoginId(String staffLoginId);
    int getMemberTotalCount(MemberCriteria cri);
    void changeMemberStatus(long memberId, AccountStatus status);
    Staff loginCheck(String loginId, String password);

}
