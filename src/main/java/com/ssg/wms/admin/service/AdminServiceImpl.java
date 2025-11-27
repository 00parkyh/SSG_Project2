package com.ssg.wms.admin.service;

import com.ssg.wms.admin.domain.Staff;
import com.ssg.wms.member.domain.Member;
import com.ssg.wms.admin.dto.MemberCriteria;
import com.ssg.wms.manager.dto.StaffDTO;
import com.ssg.wms.admin.mappers.AdminMapper;
import com.ssg.wms.common.AccountStatus;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Log4j2
@Transactional(readOnly = true)
public class AdminServiceImpl implements AdminService {

    private final AdminMapper adminMapper;

    @Override
    public StaffDTO getStaffDetails(long staffId) {
        return adminMapper.getStaffDetails(staffId);
    }

    @Override
    public List<Member> getMembersByCriteria(MemberCriteria criteria) {
        return adminMapper.getMembersByCriteria(criteria);
    }

    @Override
    public Member getMemberDetails(long memberId) {
        return adminMapper.getMemberDetails(memberId);
    }

    @Override
    public long findStaffIdByStaffLoginId(String staffLoginId) {
        return adminMapper.findStaffIdByStaffLoginId(staffLoginId);
    }

    @Override
    public int getMemberTotalCount(MemberCriteria cri) {
        return adminMapper.getMemberTotalCount(cri);
    }

    @Transactional
    @Override
    public void changeMemberStatus(long memberId, AccountStatus status) {
        log.info("Changing member status " + memberId + " to " + status);
        adminMapper.updateMemberStatus(memberId, status.name());
        log.info("Member " + memberId + " has been changed to " + status);
    }

    @Override
    public Staff loginCheck(String loginId, String password) {
        Staff staff = adminMapper.findByLoginIdAndPw(loginId, password);

        return staff;
    }

}
