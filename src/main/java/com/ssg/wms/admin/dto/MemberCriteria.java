package com.ssg.wms.admin.dto;

import com.ssg.wms.common.AccountStatus;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;

@Data
public class MemberCriteria {

  private String keyword;        // 이름/아이디 검색
  private AccountStatus status;  // 상태 (ACTIVE, INACTIVE 등)

  @DateTimeFormat(pattern = "yyyy-MM-dd")
  private LocalDate startDate;   // 생성일 시작
  @DateTimeFormat(pattern = "yyyy-MM-dd")
  private LocalDate endDate;     // 생성일 종료
  // 페이징 추가
  private int pageNum = 1;
  private int amount = 10;

  public int getSkip() {
    return (pageNum - 1) * amount;
  }

}
