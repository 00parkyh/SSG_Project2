package com.ssg.wms.manager.mappers;

import com.ssg.wms.manager.dto.StaffDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ManagerMapper {
    StaffDTO findByLoginIdAndPw(@Param(value = "loginId") String loginId, @Param(value = "password") String password);
    StaffDTO findByLoginId(@Param(value = "loginId") String loginId);
    StaffDTO getManagerDetails(long staffId);
    long findStaffIdByStaffLoginId(String staffLoginId);
    void updateManager(StaffDTO staffDTO);
}
