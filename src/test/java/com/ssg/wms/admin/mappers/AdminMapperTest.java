package com.ssg.wms.admin.mappers;

import com.ssg.wms.member.domain.Member;
import com.ssg.wms.admin.dto.MemberCriteria;
import com.ssg.wms.manager.dto.StaffDTO;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.util.List;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = "file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class AdminMapperTest {

    @Autowired(required = false)
    private AdminMapper adminMapper;

    @Test
    void testGetStaffDetails() {
        long staffId = 1L; // 테스트용 데이터 존재해야 함

        StaffDTO staffDTO = adminMapper.getStaffDetails(staffId);

        System.out.println("조회 결과: " + staffDTO);
    }

    @Test
    void testGetMembersByCriteria() {
        MemberCriteria criteria = new MemberCriteria();
        criteria.setKeyword("홍"); // LIKE 검색용

        List<Member> list = adminMapper.getMembersByCriteria(criteria);


        list.forEach(System.out::println);
    }

    @Test
    void testGetMemberDetails() {
        long memberId = 1L; // 테스트 DB에 존재해야 함

        Member member = adminMapper.getMemberDetails(memberId);

        System.out.println("조회 결과: " + member);
    }

}
