package com.ssg.wms.manager.service;

import com.ssg.wms.manager.dto.StaffDTO;
import com.ssg.wms.manager.mappers.ManagerMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

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
        return managerMapper.findByLoginIdAndPw(loginId, password);
    }

    @Override
    public StaffDTO findByLoginId(String loginId) {
        return managerMapper.findByLoginId(loginId);
    }
}
