package com.ssg.wms.warehouse.service;

import com.ssg.wms.warehouse.dto.*;
import com.ssg.wms.warehouse.mappers.WarehouseAdminMapper;
import com.ssg.wms.warehouse.util.KakaoApiUtil;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Log4j2
@Service
@Transactional
public class WarehouseAdminServiceImpl implements WarehouseAdminService {

    private final WarehouseAdminMapper warehouseAdminMapper;
    private final KakaoApiUtil kakaoApiUtil;

    // 생성자 주입
    @Autowired
    public WarehouseAdminServiceImpl(
            WarehouseAdminMapper warehouseAdminMapper,
            KakaoApiUtil kakaoApiUtil) {
        this.warehouseAdminMapper = warehouseAdminMapper;
        this.kakaoApiUtil = kakaoApiUtil;
    }

    /// 창고 이름 중복 확인 구현
    @Override
    public boolean checkNameDuplication(String warehouseName) {
        log.debug("창고 이름 중복 확인 시작 (Admin): {}", warehouseName);
        return warehouseAdminMapper.countWarehouseName(warehouseName) > 0;
    }

    /// 창고 등록 구현 (Admin)  Geocoding 연동 및 구역 등록
    @Override
    @Transactional
    public Long saveWarehouse(WarehouseSaveDTO saveDTO) throws Exception {

        /// 1. 이름 중복 확인
        if (checkNameDuplication(saveDTO.getWarehouseName())) {
            log.warn("등록 실패 (Admin): 이미 존재하는 창고 이름입니다. (이름: {})", saveDTO.getWarehouseName());
            throw new IllegalArgumentException("이미 존재하는 창고 이름입니다.");
        }

        /// 2. Geocoding (카카오 API 호출) - 예외 처리 로직 개선
        Double[] coords;
        try {
            log.info("Geocoding 시작 (Admin). 주소: {}", saveDTO.getAddress());
            coords = kakaoApiUtil.getCoordinates(saveDTO.getAddress());
            log.info("Geocoding 성공 (Admin). 위도: {}, 경도: {}", coords[1], coords[0]);
        } catch (Exception e) {
            log.error("Geocoding API 호출 중 오류 발생 (Admin). 주소: {}. 상세 오류:", saveDTO.getAddress(), e);
            throw new Exception("주소 변환(Geocoding)에 실패했습니다. (원인: 주소 변환(Geocoding)에 실패했습니다. 주소를 확인해 주세요.)", e);
        }

        /// 3. DTO에 위도(Latitude)와 경도(Longitude) 설정 (카카오 API 응답 순서: [경도, 위도])
        saveDTO.setLongitude(coords[0]);
        saveDTO.setLatitude(coords[1]);


        log.info(" DTO 데이터 받기 성공. 받은 창고 이름: {}", saveDTO.getWarehouseName());

        /// 4. 창고 (WAREHOUSE) DB에 저장 (PK가 saveDTO.warehouseId에 채워짐)
        int insertedRows = warehouseAdminMapper.insertWarehouse(saveDTO);

        if (insertedRows != 1) {
            log.error("WAREHOUSE INSERT 실패 (Admin) (영향 받은 행 수: {}). 트랜잭션 롤백.", insertedRows);
            throw new RuntimeException("창고 등록에 실패했습니다.");
        }

        Long warehouseId = saveDTO.getWarehouseId();

        log.info("WAREHOUSE 삽입 성공. ID: {}", warehouseId);

        /// 5. 구역 (SECTION) 및 위치 (LOCATION) 정보 등록 핵심 로직
        if (saveDTO.getSections() != null && !saveDTO.getSections().isEmpty()) {
            log.info("구역 정보 등록 시작 (Admin). 구역 수: {}", saveDTO.getSections().size());

            for (SectionDTO section : saveDTO.getSections()) {

                // 5-1. 층수 유효성 검사 (최대 2층)
                if (section.getLocations() != null) {
                    for (LocationDTO location : section.getLocations()) {
                        // 참고: 층수 3 초과 시 WARN 로그 및 예외 발생
                        if (location.getFloorNum() > 2) {
                            log.warn("등록 실패 (Admin): 층수({})가 최대 2층을 초과합니다.", location.getFloorNum());
                            throw new IllegalArgumentException("위치 정보의 층수는 최대 2층까지 등록 가능합니다.");
                        }
                    }
                }

                // 5-2. Section 기본 정보 설정 및 저장 (section.sectionId에 PK가 채워져야 함)
                section.setWarehouseId(warehouseId);


                log.info("SECTION 삽입 시작: {}", section.getSectionName());

                int sectionInsertedRows = warehouseAdminMapper.insertSection(section);

                if (sectionInsertedRows != 1) {
                    log.error("SECTION INSERT 실패 (Admin). 트랜잭션 롤백.");
                    throw new RuntimeException("구역 등록 중 오류가 발생했습니다.");
                }


                Long sectionId = section.getSectionId();
                log.debug("Section ID 획득 성공: {}", sectionId);

                /// 5-3. 위치 (LOCATION) 정보 등록 추가
                if (section.getLocations() != null && !section.getLocations().isEmpty()) {

                    for (LocationDTO location : section.getLocations()) {

                        // 🟢 [필수 추가]: Section ID 설정
                        location.setSectionId(sectionId);
                        // warehouse_id 설정
                        location.setWarehouseId(warehouseId);

                        // locationTypeCode 기본값 설정
                        if (location.getLocationTypeCode() == null || location.getLocationTypeCode().isEmpty()) {
                            location.setLocationTypeCode("A구역");
                            log.warn("locationTypeCode이 누락되어 'A구역'으로 기본값을 설정합니다.");
                        }

                        // Mapper를 호출하여 LOCATION 테이블에 삽입
                        int locationInsertedRows = warehouseAdminMapper.insertLocation(location);

                        if (locationInsertedRows != 1) {
                            log.error("LOCATION INSERT 실패 (Admin). 트랜잭션 롤백.");
                            throw new RuntimeException("위치 정보 등록 중 오류가 발생했습니다.");
                        }
                    }
                }
            }
            log.info("구역 및 위치 정보 등록 성공 (Admin).");
        }

        log.info("최종 창고 등록 성공 (Admin). ID: {}", warehouseId);
        return warehouseId;
    }

    /// 창고 수정 구현
    @Override
    @Transactional
    public void updateWarehouse(Long id, WarehouseUpdateDTO updateDTO) throws Exception {
        updateDTO.setWarehouseId(id);

        log.debug("창고 수정 시작 (Admin). ID: {}", id);
        int updatedRows = warehouseAdminMapper.updateWarehouse(updateDTO);

        if (updatedRows != 1) {
            log.warn("수정 실패 (Admin): 창고 ID({})가 존재하지 않거나 수정된 행이 없습니다.", id);
            throw new IllegalArgumentException("수정하려는 창고를 찾을 수 없거나 수정에 실패했습니다.");
        }
        log.info("창고 수정 성공 (Admin). ID: {}", id);
    }

    /// 창고 삭제 구현
    @Override
    @Transactional
    public void deleteWarehouse(Long id) {
        log.debug("창고 삭제 시작 (Admin). ID: {}", id);
        int deletedRows = warehouseAdminMapper.deleteWarehouse(id);

        if (deletedRows != 1) {
            log.warn("삭제 실패 (Admin): 창고 ID({})가 존재하지 않거나 삭제된 행이 없습니다.", id);
            throw new IllegalArgumentException("삭제하려는 창고를 찾을 수 없거나 삭제에 실패했습니다.");
        }
        log.info("창고 삭제 성공 (Admin). ID: {}", id);
    }

    /// 창고 상태 업데이트 구현
//    @Transactional
//    @Override
//    public void updateWarehouseStatus(Long id, Byte newStatus) {
//        log.debug("창고 상태 업데이트 시작 (Admin). ID: {}, New Status: {}", id, newStatus);
//
//        int updatedRows = warehouseAdminMapper.updateWarehouseStatus(id, newStatus);
//
//        if (updatedRows != 1) {
//            log.warn("상태 업데이트 실패 (Admin): 창고 ID({})가 존재하지 않습니다.", id);
//            throw new IllegalArgumentException("상태를 변경하려는 창고를 찾을 수 없습니다.");
//        }
//        log.info("창고 상태 업데이트 성공 (Admin). ID: {}", id);
//    }

    @Override
    public List<WarehouseListDTO> findWarehouses(WarehouseSearchDTO searchForm) {
        return warehouseAdminMapper.selectWarehouses(searchForm);
    }
}
