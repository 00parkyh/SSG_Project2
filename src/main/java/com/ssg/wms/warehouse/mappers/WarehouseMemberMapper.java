package com.ssg.wms.warehouse.mappers;

import com.ssg.wms.warehouse.dto.WarehouseDetailDTO;
import com.ssg.wms.warehouse.dto.WarehouseListDTO;
import com.ssg.wms.warehouse.dto.WarehouseSearchDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;


/// member(사용자) mappper입니다.


/// 창고 위치 조회를 메인페이지로 쓰자고 했음
/// member 메뉴에는 창고 위치 조회 , 창고 목록 조회만 보여주게끔 하기로 함.
@Mapper
public interface WarehouseMemberMapper {


    ///  창고 상세 조회가 보여주게끔
    WarehouseDetailDTO selectWarehouseDetailById(Long id);

    List<WarehouseListDTO> selectWarehouses(WarehouseSearchDTO warehouseSearch);
}