package com.ssg.wms.product_stock.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

//품목현황dto
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductListDTO {
    private String productId;
    private String productName;
    private String brandName;
    private String warehouseName;
    private String sectionName;
    private int quantity;
    private String productState;
    private String availableOutbound;
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss", timezone = "Asia/Seoul")
    private LocalDateTime inboundDate;
}