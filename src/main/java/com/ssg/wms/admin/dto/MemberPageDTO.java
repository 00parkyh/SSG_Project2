package com.ssg.wms.admin.dto;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class MemberPageDTO {

  private int startPage; //시작
  private int endPage; //화면에서 마지막 번호
  private boolean prev, next;

  private int total;

  private int pageNum;
  private int amount;

  public MemberPageDTO(int pageNum, int amount, int total) {

    this.pageNum = pageNum;
    this.amount = amount;
    this.total = total;

    this.endPage = (int) (Math.ceil(pageNum / 10.0)) * 10;
    this.startPage = this.endPage - 9;

    int realEnd = (int) Math.ceil((total * 1.0) / amount);

    if(realEnd < endPage) {
      endPage = realEnd;
    }

    this.prev = startPage > 1;
    this.next = endPage < realEnd;
  }
  
}

