package com.ssg.wms.warehouse.service;

import com.ssg.wms.warehouse.dto.WarehouseDetailDTO;
import com.ssg.wms.warehouse.dto.WarehouseListDTO;
import com.ssg.wms.warehouse.dto.WarehouseSearchDTO;

import java.util.List;

public interface WarehouseMemberService {

    ///창고 목록 조회 (창고 목록 조회 및 창고 위치 조회 메뉴에 사용)MEMBER, ADMIN, MANAGER 모두 접근 가능

    List<WarehouseListDTO> findWarehouses(WarehouseSearchDTO warehouseSearch);

    ///창고 상세 조회
    ///  MEMBER는 단순 데이터 조회 목적으로만  (수정/삭제 권한 없음)

    WarehouseDetailDTO findWarehouseDetailById(Long id);
}
