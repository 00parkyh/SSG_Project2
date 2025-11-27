package com.ssg.wms.manager.mappers;

import com.ssg.wms.admin.dto.MemberCriteria;
import com.ssg.wms.manager.dto.StaffDTO;
import com.ssg.wms.member.domain.Member;
import com.ssg.wms.member.dto.MemberDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ManagerMapper {
    StaffDTO findByLoginIdAndPw(@Param(value = "loginId") String loginId, @Param(value = "password") String password);
    StaffDTO getManagerDetails(long staffId);
    long findStaffIdByStaffLoginId(String staffLoginId);
    void updateManager(StaffDTO staffDTO);
}
