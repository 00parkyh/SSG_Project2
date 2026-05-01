package com.ssg.wms.manager.service;

import com.ssg.wms.manager.dto.StaffDTO;

public interface ManagerService {
    StaffDTO getManagerDetails(long staffId);
    long findManagerIdByManagerLoginId(String staffLoginId);
    void updateManager(StaffDTO staffDTO);
    StaffDTO loginCheck(String loginId, String password);
    StaffDTO findByLoginId(String loginId);
}
