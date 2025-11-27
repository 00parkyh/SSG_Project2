package com.ssg.wms.product_stock.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DropdownDTO {
    //드롭 다운 메뉴
    private Long id;
    private String name;
}
