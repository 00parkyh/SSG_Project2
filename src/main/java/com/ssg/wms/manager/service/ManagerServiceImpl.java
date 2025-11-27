package com.ssg.wms.manager.service;

import com.ssg.wms.admin.dto.MemberCriteria;
import com.ssg.wms.admin.mappers.AdminMapper;
import com.ssg.wms.admin.service.AdminService;
import com.ssg.wms.common.AccountStatus;
import com.ssg.wms.manager.dto.StaffDTO;
import com.ssg.wms.manager.mappers.ManagerMapper;
import com.ssg.wms.member.domain.Member;
import com.ssg.wms.member.dto.MemberDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ManagerServiceImpl implements ManagerService {

    private final ManagerMapper managerMapper;


    @Override
    public StaffDTO getManagerDetails(long staffId) {
        return managerMapper.getManagerDetails(staffId);
    }

    @Override
    public long findManagerIdByManagerLoginId(String staffLoginId) {
        return managerMapper.findStaffIdByStaffLoginId(staffLoginId);
    }

    @Override
    public void updateManager(StaffDTO staffDTO) {
        managerMapper.updateManager(staffDTO);
    }

    @Override
    public StaffDTO loginCheck(String loginId, String password) {
        StaffDTO manager = managerMapper.findByLoginIdAndPw(loginId, password);

        return manager;
    }
}
