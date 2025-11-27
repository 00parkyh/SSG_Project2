package com.ssg.wms.warehouse.mappers;

import com.ssg.wms.warehouse.dto.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface WarehousesManagerMapper { // MANAGER 전용 Mapper (WarehousesManagerController에서 사용)
    ///창고 등록 Warehouse ID
    int insertWarehouse(WarehouseSaveDTO saveDTO);

    /// 구역 등록
    int insertSection(SectionDTO section);

    ///위치 등록

    int insertLocation(LocationDTO location);

    /// 창고 이름 중복 확인
    int countWarehouseName(@Param("name") String name);


    /// 창고 수정
    int updateWarehouse(WarehouseUpdateDTO updateDTO);

    /// 창고 삭제
    int deleteWarehouse(Long id);

//    /// 창고 상태 업데이트
//    int updateWarehouseStatus(@Param("id") Long id, @Param("newStatus") Byte newStatus);

    ///창고 목록 조회
    List<WarehouseListDTO> selectWarehouses(WarehouseSearchDTO searchForm);

    /// 창고 상세 조회
    WarehouseDetailDTO selectWarehouseDetailById(Long id);
}