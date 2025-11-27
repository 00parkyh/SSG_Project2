package com.ssg.wms.warehouse.service;

import com.ssg.wms.warehouse.dto.WarehouseListDTO;
import com.ssg.wms.warehouse.dto.WarehouseSaveDTO;
import com.ssg.wms.warehouse.dto.WarehouseSearchDTO;
import com.ssg.wms.warehouse.dto.WarehouseUpdateDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface WarehouseAdminService {

    /// 창고 이름 중복 확인
    boolean checkNameDuplication(String name);

    /// 창고 등록 (Geocoding 구역 등록 포함)
    Long saveWarehouse(WarehouseSaveDTO saveDTO) throws Exception;

    /// 창고 수정
    void updateWarehouse(Long id, WarehouseUpdateDTO updateDTO) throws Exception;

    /// 창고 삭제
    void deleteWarehouse(Long id);




    //// 창고 상태 업데이트
//    void updateWarehouseStatus(Long id, Byte newStatus);

    List<WarehouseListDTO> findWarehouses(WarehouseSearchDTO searchForm);
}