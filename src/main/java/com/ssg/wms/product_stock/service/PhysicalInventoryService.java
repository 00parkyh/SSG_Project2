package com.ssg.wms.product_stock.service;

import com.ssg.wms.product_stock.dto.*;

import java.util.List;

//재고 실사 서비스
public interface PhysicalInventoryService {

    // 실사 등록 (PI 레코드 생성 및 스냅샷 저장)
    int registerPhysicalInventory(PhysicalInventoryRequest request);

    // 실사 리스트 및 페이지네이션 정보 조회
    PageResponseDTO<PhysicalInventoryDTO> getPhysicalInventoryList(PageRequestDTO pageRequestDTO);

    // 실사 결과 업데이트 및 재고 조정
    void updatePhysicalInventory(PhysicalInventoryUpdateDTO updateDTO);
}