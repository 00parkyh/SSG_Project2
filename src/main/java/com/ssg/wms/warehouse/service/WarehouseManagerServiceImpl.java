package com.ssg.wms.warehouse.service;

import com.ssg.wms.warehouse.dto.SectionDTO;
import com.ssg.wms.warehouse.dto.WarehouseSaveDTO;
import com.ssg.wms.warehouse.dto.WarehouseUpdateDTO;
// AdminMapper를 사용해도 되지만, 관리의 용이성을 위해 ManagerMapper를 별도로 만들거나
// 기존 AdminMapper의 이름을 수정하여 사용하는 것이 좋습니다.
// 여기서는 제공된 코드 구조를 유지하며, 동일한 매퍼를 사용한다고 가정합니다.
import com.ssg.wms.warehouse.mappers.WarehouseAdminMapper;
import com.ssg.wms.warehouse.util.KakaoApiUtil;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Log4j2
@Service
@Transactional
public class WarehouseManagerServiceImpl implements WarehouseManagerService {

    private final WarehouseAdminMapper adminManagerMapper;
    private final KakaoApiUtil kakaoApiUtil;

    @Autowired
    public WarehouseManagerServiceImpl(
            WarehouseAdminMapper adminManagerMapper,
            KakaoApiUtil kakaoApiUtil) {
        this.adminManagerMapper = adminManagerMapper;
        this.kakaoApiUtil = kakaoApiUtil;
//        log.info("WarehouseManagerServiceImpl 초기화 완료.");
    }

    /// 창고 이름 중복 확인 구현
    @Override
    public boolean checkNameDuplication(String name) {
        log.debug("창고 이름 중복 확인 시작 (Manager): {}", name);
        return adminManagerMapper.countWarehouseName(name) > 0;
    }

    ///창고 등록 구현 (Manager)
    @Override
    @Transactional // 창고와 구역 등록이 모두 성공해야 커밋됩니다.
    public Long saveWarehouse(WarehouseSaveDTO saveDTO) throws Exception {

        // 1. 이름 중복 확인
        if (checkNameDuplication(saveDTO.getName())) {
            log.warn("등록 실패 (Manager): 이미 존재하는 창고 이름입니다. (이름: {})", saveDTO.getName());
            throw new IllegalArgumentException("이미 존재하는 창고 이름입니다.");
        }

        // 2. Geocoding (카카오 API 호출)
        Double[] coords;
        try {
            log.info("Geocoding 시작 (Manager). 주소: {}", saveDTO.getAddress());
            coords = kakaoApiUtil.getCoordinates(saveDTO.getAddress());
            // 카카오 API 응답 순서: [경도, 위도]
            log.info("Geocoding 성공 (Manager). 위도: {}, 경도: {}", coords[1], coords[0]);
        } catch (Exception e) {
            log.error("Geocoding API 호출 오류 발생 (Manager): {}", e.getMessage());
            throw new Exception("주소 변환(Geocoding)에 실패했습니다. 주소를 확인해 주세요.");
        }

        // 3. DTO에 위도(Latitude)와 경도(Longitude) 설정
        saveDTO.setLongitude(coords[0]);
        saveDTO.setLatitude(coords[1]);

        // 4. 창고 (WAREHOUSE) DB에 저장
        int insertedRows = adminManagerMapper.insertWarehouse(saveDTO);

        if (insertedRows != 1) {
            log.error("WAREHOUSE INSERT 실패 (Manager) (영향 받은 행 수: {}). 트랜잭션 롤백.", insertedRows);
            throw new RuntimeException("창고 등록에 실패했습니다.");
        }

        ///  warehouseId는 insertWarehouse 실행 후 데이터에 담김
        Long warehouseId = saveDTO.getWarehouseId();

        // 5. 구역 (SECTION) 정보 등록 추가
        if (saveDTO.getSections() != null && !saveDTO.getSections().isEmpty()) {
            log.info("구역 정보 등록 시작 (Manager). 구역 수: {}", saveDTO.getSections().size());

            for (SectionDTO section : saveDTO.getSections()) {
                // FK(warehouse_id) 설정
                section.setSectionId(warehouseId);

                // Mapper를 호출하여 SECTION 테이블에 삽입
                int sectionInsertedRows = adminManagerMapper.insertSection(section);

                if (sectionInsertedRows != 1) {
                    log.error("SECTION INSERT 실패 (Manager). 트랜잭션 롤백.");
                    throw new RuntimeException("구역 등록 중 오류가 발생했습니다.");
                }
            }
            log.info("구역 정보 등록 성공 (Manager).");
        }

        log.info("최종 창고 등록 성공 (Manager). ID: {}", warehouseId);
        return warehouseId;
    }

    /// 창고 수정 구현
    @Override
    @Transactional
    public void updateWarehouse(Long id, WarehouseUpdateDTO updateDTO) throws Exception {
        updateDTO.setWarehouseId(id);

        log.debug("창고 수정 시작 (Manager). ID: {}", id);

        int updatedRows = adminManagerMapper.updateWarehouse(updateDTO);

        if (updatedRows != 1) {
            log.warn("수정 실패 (Manager): 창고 ID({})가 존재하지 않거나 수정된 행이 없습니다.", id);
            throw new IllegalArgumentException("수정하려는 창고를 찾을 수 없거나 수정에 실패했습니다.");
        }
        log.info("창고 수정 성공 (Manager). ID: {}", id);
    }

    /// 창고 삭제 구현
    @Override
    @Transactional
    public void deleteWarehouse(Long id) {
        log.debug("창고 삭제 시작 (Manager). ID: {}", id);

        int deletedRows = adminManagerMapper.deleteWarehouse(id);

        if (deletedRows != 1) {
            log.warn("삭제 실패 (Manager): 창고 ID({})가 존재하지 않거나 삭제된 행이 없습니다.", id);
            throw new IllegalArgumentException("삭제하려는 창고를 찾을 수 없거나 삭제에 실패했습니다.");
        }
        log.info("창고 삭제 성공 (Manager). ID: {}", id);
    }

    /// 창고 상태 업데이트 구현
//    @Override
//    @Transactional
//    public void updateWarehouseStatus(Long id, Byte newStatus) {
//        log.debug("창고 상태 업데이트 시작 (Manager). ID: {}, New Status: {}", id, newStatus);
//        int updatedRows = adminManagerMapper.updateWarehouseStatus(id, newStatus);
//
//        if (updatedRows != 1) {
//            log.warn("상태 업데이트 실패 (Manager): 창고 ID({})가 존재하지 않습니다.", id);
//            throw new IllegalArgumentException("상태를 변경하려는 창고를 찾을 수 없습니다.");
//        }
//        log.info("창고 상태 업데이트 성공 (Manager). ID: {}", id);
//    }
}