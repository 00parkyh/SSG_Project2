package com.ssg.wms.warehouse.service;

import com.ssg.wms.warehouse.dto.WarehouseSaveDTO;
import com.ssg.wms.warehouse.dto.WarehouseUpdateDTO;

// public 접근자 없이 선언
public interface WarehouseManagerService {


    Long saveWarehouse(WarehouseSaveDTO saveDTO) throws Exception;


    boolean checkNameDuplication(String name);


    void updateWarehouse(Long id, WarehouseUpdateDTO updateDTO) throws Exception;


    void deleteWarehouse(Long id);


//    void updateWarehouseStatus(Long id, Byte newStatus);
}