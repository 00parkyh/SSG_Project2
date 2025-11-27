package com.ssg.wms.product_ehs.dto;

import lombok.Data;

@Data
public class ProductDTO {
    private String productId;
    private int categoryCd;
    private String productName;
    private Long productPrice;
    private String productOrigin;
}
