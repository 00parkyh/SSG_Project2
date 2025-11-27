package com.ssg.wms.outbound.mappers;


import com.ssg.wms.outbound.domain.Criteria;
import com.ssg.wms.outbound.domain.dto.OutboundOrderDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface OutboundOrderMapper {

    //  출고지시서 전체 조회
    List<OutboundOrderDTO> getAllOrders(@Param("criteria") Criteria criteria,
                                        @Param("search") String search);

    // 출고지시서 조건 조회(상태, 승인자별)
    List<OutboundOrderDTO> getFilteredOrders(@Param("criteria") Criteria criteria,
                                             @Param("filterType") String filterType,
                                             @Param("searchValue") String searchValue); // ★ 이 파라미터를 추가해야 합니다.
    // 출고지시서 상세조회
    OutboundOrderDTO getOrderDetailById(@Param("approvedOrderId") Long approvedOrderId);


    // 출고지시서 상태 변경 (승인/반려/취소 등)
    int updateOrderStatus(OutboundOrderDTO outboundOrderDTO);


    // ✅ 출고요청 상태 업데이트 (새로 추가)
    int updateOutboundRequestStatus(@Param("approvedOrderId") Long approvedOrderId,
                                    @Param("approvedStatus") String approvedStatus,
                                    @Param("warehouseId") Long warehouseId);


}
