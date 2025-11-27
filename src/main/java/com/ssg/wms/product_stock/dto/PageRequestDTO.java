package com.ssg.wms.product_stock.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.lang.Nullable;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.Positive;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
public class PageRequestDTO {

    /** 페이지는 1부터 시작 */
    @Builder.Default
    @Min(1)
    private int page = 1;

    /** 페이지당 건수(범위 10~100) */
    @Builder.Default
    @Min(10)
    @Max(100)
    @Positive
    private int size = 10;

    /** 리스트 페이지 유지용 링크 쿼리 */
    private String link;

    /** 검색 타입들: "t"(title), "w"(writer) */
    private List<String> types;

    /** 검색어 */
    private String keyword;

    /** 완료 여부 필터 */
    private boolean finished;

    /** 기간 검색 */
    private LocalDate from;
    private LocalDate to;

    @Nullable
    private String productId;
    @Nullable
    private Long categoryCd;
    @Nullable
    private Long partnerId;
    @Nullable
    private Long warehouseId;
    @Nullable
    private Long sectionId;

    /** LIMIT offset */
    public int getSkip() {
        // page가 1 미만이거나 size가 1 미만인 경우를 방어
        int safePage = Math.max(1, page);
        int safeSize = Math.max(1, size);
        return (safePage - 1) * safeSize;
    }

    /** 키워드 존재 여부 */
    public boolean hasKeyword() {
        return keyword != null && !keyword.isBlank();
    }

    /** 컨트롤러/서비스 진입 초기에 한 번 호출해서 값 정리하면 안전 */
    public void normalize() {
        if (page < 1) page = 1;
        if (size < 1) size = 10;
        if (size > 100) size = 100;

        // types 정리: null 방지 + 공백/널 원소 제거
        if (types == null) {
            types = Collections.emptyList();
        } else {
            types.removeIf(t -> t == null || t.isBlank());
        }
    }

    /** 현재 검색 파라미터를 쿼리스트링으로 */
    public String getLink() {
        StringBuilder builder = new StringBuilder();
        builder.append("page=").append(Math.max(1, page));
        builder.append("&size=").append(Math.max(1, size));

        if (categoryCd != null) builder.append("&categoryCd=").append(categoryCd);
        if (partnerId != null) builder.append("&partnerId=").append(partnerId);
        if (warehouseId != null) builder.append("&warehouseId=").append(warehouseId);
        if (sectionId != null) builder.append("&sectionId=").append(sectionId);

        return builder.toString();
    }
}
