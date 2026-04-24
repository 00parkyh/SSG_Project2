-- 의류 WMS 더미 데이터
-- 빈 스키마에 DDLV4.1.sql 적용 후 실행

START TRANSACTION;

-- ===========================
-- 1. Partner
-- ===========================
INSERT INTO Partner (partner_id, partner_name, business_number, address, created_at, updated_at)
VALUES
    (1, '나이키', '110-81-10001', '서울특별시 강남구 테헤란로 101', '2026-01-02 09:00:00', '2026-01-02 09:00:00'),
    (2, '아디다스', '110-81-10002', '경기도 성남시 분당구 판교역로 220', '2026-01-02 09:10:00', '2026-01-02 09:10:00'),
    (3, '푸마', '110-81-10003', '부산광역시 해운대구 센텀서로 30', '2026-01-02 09:20:00', '2026-01-02 09:20:00'),
    (4, '뉴발란스', '110-81-10004', '대구광역시 수성구 동대구로 88', '2026-01-02 09:30:00', '2026-01-02 09:30:00'),
    (5, '언더아머', '110-81-10005', '인천광역시 연수구 센트럴로 55', '2026-01-02 09:40:00', '2026-01-02 09:40:00');

-- ===========================
-- 2. Category
-- ===========================
INSERT INTO Category (category_cd, category_name)
VALUES
    (1, '반팔'),
    (2, '긴팔'),
    (3, '후드'),
    (4, '재킷'),
    (5, '팬츠');

-- ===========================
-- 3. Staff
-- ===========================
INSERT INTO Staff (
    staff_id,
    staff_login_id,
    staff_pw,
    staff_name,
    staff_phone,
    staff_email,
    created_at,
    updated_at,
    status,
    role
)
VALUES
    (1, 'admin01', 'pw_admin01', '김창고', '010-3000-0001', 'admin01@wms.local', '2026-01-02 08:00:00', '2026-01-02 08:00:00', 'ACTIVE', 'MANAGER'),
    (2, 'admin02', 'pw_admin02', '이물류', '010-3000-0002', 'admin02@wms.local', '2026-01-02 08:05:00', '2026-01-02 08:05:00', 'ACTIVE', 'MANAGER'),
    (3, 'admin03', 'pw_admin03', '박재고', '010-3000-0003', 'admin03@wms.local', '2026-01-02 08:10:00', '2026-01-02 08:10:00', 'ACTIVE', 'MANAGER'),
    (4, 'staff04', 'pw_staff04', '최준호', '010-3000-0004', 'staff04@wms.local', '2026-01-02 08:15:00', '2026-01-02 08:15:00', 'ACTIVE', 'MANAGER'),
    (5, 'staff05', 'pw_staff05', '정서윤', '010-3000-0005', 'staff05@wms.local', '2026-01-02 08:20:00', '2026-01-02 08:20:00', 'ACTIVE', 'MANAGER'),
    (6, 'staff06', 'pw_staff06', '한도윤', '010-3000-0006', 'staff06@wms.local', '2026-01-02 08:25:00', '2026-01-02 08:25:00', 'ACTIVE', 'MANAGER'),
    (7, 'staff07', 'pw_staff07', '오민재', '010-3000-0007', 'staff07@wms.local', '2026-01-02 08:30:00', '2026-01-02 08:30:00', 'ACTIVE', 'MANAGER'),
    (8, 'staff08', 'pw_staff08', '유지훈', '010-3000-0008', 'staff08@wms.local', '2026-01-02 08:35:00', '2026-01-02 08:35:00', 'ACTIVE', 'MANAGER');

-- ===========================
-- 4. Warehouse
-- ===========================
INSERT INTO Warehouse (
    warehouse_id,
    admin_id,
    warehouse_name,
    warehouse_type,
    warehouse_capacity,
    warehouse_status,
    registration_date,
    latest_update_date,
    address,
    latitude,
    longitude
)
VALUES
    (1, 1, '수도권 통합 의류센터', 'APPAREL', 120000, 1, '2026-01-05', '2026-04-01 09:00:00', '경기도 광주시 곤지암읍 물류단지로 11', 37.3571000, 127.2335000),
    (2, 2, '영남 스포츠웨어센터', 'APPAREL', 90000, 1, '2026-01-08', '2026-04-01 09:10:00', '대구광역시 달성군 테크노중앙대로 66', 35.6939000, 128.4692000),
    (3, 3, '서부 이커머스센터', 'APPAREL', 70000, 1, '2026-01-10', '2026-04-01 09:20:00', '인천광역시 서구 봉수대로 500', 37.5451000, 126.6753000);

-- ===========================
-- 5. Section
-- ===========================
INSERT INTO Section (section_id, warehouse_id, section_name, section_type, section_purpose, allocated_area)
VALUES
    (1, 1, 'A-상의 구역', 'TOP', '반팔 및 긴팔 보관 구역', 18000),
    (2, 1, 'B-아우터 구역', 'OUTER', '후드 및 재킷 보관 구역', 22000),
    (3, 1, 'C-하의 구역', 'BOTTOM', '팬츠 및 접이 의류 보관 구역', 16000),
    (4, 2, 'A-상의 구역', 'TOP', '반팔 및 긴팔 보관 구역', 14000),
    (5, 2, 'B-아우터 구역', 'OUTER', '후드 및 재킷 보관 구역', 17000),
    (6, 2, 'C-하의 구역', 'BOTTOM', '팬츠 및 접이 의류 보관 구역', 13000),
    (7, 3, 'A-상의 구역', 'TOP', '반팔 및 긴팔 보관 구역', 11000),
    (8, 3, 'B-아우터 구역', 'OUTER', '후드 및 재킷 보관 구역', 15000),
    (9, 3, 'C-하의 구역', 'BOTTOM', '팬츠 및 접이 의류 보관 구역', 12000);

-- ===========================
-- 6. Location
-- ===========================
INSERT INTO Location (location_id, warehouse_id, location_code, floor_num, location_type_code, max_volume)
VALUES
    (1, 1, 'W1-A-01', 1, 'RACK', 950.000),
    (2, 1, 'W1-A-02', 1, 'RACK', 950.000),
    (3, 1, 'W1-B-01', 1, 'RACK', 1100.000),
    (4, 1, 'W1-C-01', 1, 'RACK', 1000.000),
    (5, 2, 'W2-A-01', 1, 'RACK', 900.000),
    (6, 2, 'W2-A-02', 1, 'RACK', 900.000),
    (7, 2, 'W2-B-01', 1, 'RACK', 1000.000),
    (8, 2, 'W2-C-01', 1, 'RACK', 980.000),
    (9, 3, 'W3-A-01', 1, 'RACK', 850.000),
    (10, 3, 'W3-A-02', 1, 'RACK', 850.000),
    (11, 3, 'W3-B-01', 1, 'RACK', 920.000),
    (12, 3, 'W3-C-01', 1, 'RACK', 900.000);

-- ===========================
-- 7. Member
-- ===========================
INSERT INTO Member (
    member_id,
    member_login_id,
    member_pw,
    member_name,
    member_phone,
    member_email,
    business_number,
    created_at,
    updated_at,
    status,
    role,
    partner_id
)
VALUES
    (1, 'nike_md_01', 'pw_nike_01', '김나이키', '010-4000-0001', 'nike_md_01@partner.local', '210-81-20001', '2026-01-03 09:00:00', '2026-01-03 09:00:00', 'ACTIVE', 'MEMBER', 1),
    (2, 'nike_md_02', 'pw_nike_02', '이나이키', '010-4000-0002', 'nike_md_02@partner.local', '210-81-20002', '2026-01-03 09:05:00', '2026-01-03 09:05:00', 'ACTIVE', 'MEMBER', 1),
    (3, 'adidas_md_01', 'pw_adidas_01', '김아디다스', '010-4000-0003', 'adidas_md_01@partner.local', '210-81-20003', '2026-01-03 09:10:00', '2026-01-03 09:10:00', 'ACTIVE', 'MEMBER', 2),
    (4, 'adidas_md_02', 'pw_adidas_02', '이아디다스', '010-4000-0004', 'adidas_md_02@partner.local', '210-81-20004', '2026-01-03 09:15:00', '2026-01-03 09:15:00', 'ACTIVE', 'MEMBER', 2),
    (5, 'puma_md_01', 'pw_puma_01', '김푸마', '010-4000-0005', 'puma_md_01@partner.local', '210-81-20005', '2026-01-03 09:20:00', '2026-01-03 09:20:00', 'ACTIVE', 'MEMBER', 3),
    (6, 'puma_md_02', 'pw_puma_02', '이푸마', '010-4000-0006', 'puma_md_02@partner.local', '210-81-20006', '2026-01-03 09:25:00', '2026-01-03 09:25:00', 'ACTIVE', 'MEMBER', 3),
    (7, 'nb_md_01', 'pw_nb_01', '김뉴발', '010-4000-0007', 'nb_md_01@partner.local', '210-81-20007', '2026-01-03 09:30:00', '2026-01-03 09:30:00', 'ACTIVE', 'MEMBER', 4),
    (8, 'nb_md_02', 'pw_nb_02', '이뉴발', '010-4000-0008', 'nb_md_02@partner.local', '210-81-20008', '2026-01-03 09:35:00', '2026-01-03 09:35:00', 'ACTIVE', 'MEMBER', 4),
    (9, 'ua_md_01', 'pw_ua_01', '김언더', '010-4000-0009', 'ua_md_01@partner.local', '210-81-20009', '2026-01-03 09:40:00', '2026-01-03 09:40:00', 'ACTIVE', 'MEMBER', 5),
    (10, 'ua_md_02', 'pw_ua_02', '이언더', '010-4000-0010', 'ua_md_02@partner.local', '210-81-20010', '2026-01-03 09:45:00', '2026-01-03 09:45:00', 'ACTIVE', 'MEMBER', 5);

-- ===========================
-- 8. PartnerFee
-- ===========================
INSERT INTO PartnerFee (fee_id, partner_id, fee_type, price, apply_date)
VALUES
    (1, 1, 'STORAGE', 1800, '2026-01-15'),
    (2, 1, 'INBOUND', 700, '2026-01-15'),
    (3, 1, 'OUTBOUND', 900, '2026-01-15'),
    (4, 2, 'STORAGE', 1750, '2026-01-15'),
    (5, 2, 'INBOUND', 680, '2026-01-15'),
    (6, 2, 'OUTBOUND', 880, '2026-01-15'),
    (7, 3, 'STORAGE', 1650, '2026-01-15'),
    (8, 3, 'INBOUND', 650, '2026-01-15'),
    (9, 3, 'OUTBOUND', 850, '2026-01-15'),
    (10, 4, 'STORAGE', 1720, '2026-01-15'),
    (11, 4, 'INBOUND', 690, '2026-01-15'),
    (12, 4, 'OUTBOUND', 890, '2026-01-15'),
    (13, 5, 'STORAGE', 1780, '2026-01-15'),
    (14, 5, 'INBOUND', 710, '2026-01-15'),
    (15, 5, 'OUTBOUND', 920, '2026-01-15');

-- ===========================
-- 9. PartnerContract
-- ===========================
INSERT INTO PartnerContract (CONTRACT_ID, partner_id, CONTRACT_START, CONTRACT_AREA, CONTRACT_STATUS)
VALUES
    (1, 1, '2026-01-20', 4200, 'AVAILABLE'),
    (2, 2, '2026-01-20', 3800, 'AVAILABLE'),
    (3, 3, '2026-01-20', 3000, 'AVAILABLE'),
    (4, 4, '2026-01-20', 3500, 'AVAILABLE'),
    (5, 5, '2026-01-20', 3300, 'AVAILABLE');

CREATE TEMPORARY TABLE tmp_variant (
    variant_no INT PRIMARY KEY
);

INSERT INTO tmp_variant (variant_no)
VALUES (1), (2), (3), (4);

-- ===========================
-- 10. Product
-- 5개 브랜드 x 5개 카테고리 x 4개 옵션 = 100개 상품
-- 카테고리별 총 20개 상품
-- ===========================
INSERT INTO Product (
    product_id,
    category_cd,
    partner_id,
    product_name,
    product_price,
    product_origin
)
SELECT
    CONCAT(
        CASE p.partner_id
            WHEN 1 THEN 'NK'
            WHEN 2 THEN 'AD'
            WHEN 3 THEN 'PM'
            WHEN 4 THEN 'NB'
            WHEN 5 THEN 'UA'
        END,
        '-',
        CASE c.category_cd
            WHEN 1 THEN 'SS'
            WHEN 2 THEN 'LS'
            WHEN 3 THEN 'HD'
            WHEN 4 THEN 'JK'
            WHEN 5 THEN 'PT'
        END,
        '-',
        LPAD(v.variant_no, 2, '0')
    ) AS product_id,
    c.category_cd,
    p.partner_id,
    CASE c.category_cd
        WHEN 1 THEN CONCAT(p.partner_name, ' 퍼포먼스 반팔 ', LPAD(v.variant_no, 2, '0'))
        WHEN 2 THEN CONCAT(p.partner_name, ' 쿨링 긴팔 ', LPAD(v.variant_no, 2, '0'))
        WHEN 3 THEN CONCAT(p.partner_name, ' 에센셜 후드 ', LPAD(v.variant_no, 2, '0'))
        WHEN 4 THEN CONCAT(p.partner_name, ' 트레이닝 재킷 ', LPAD(v.variant_no, 2, '0'))
        WHEN 5 THEN CONCAT(p.partner_name, ' 액티브 팬츠 ', LPAD(v.variant_no, 2, '0'))
    END AS product_name,
    CASE c.category_cd
        WHEN 1 THEN 39000
        WHEN 2 THEN 49000
        WHEN 3 THEN 89000
        WHEN 4 THEN 109000
        WHEN 5 THEN 79000
    END + (p.partner_id * 2500) + (v.variant_no * 1500) AS product_price,
    CASE p.partner_id
        WHEN 1 THEN '베트남'
        WHEN 2 THEN '인도네시아'
        WHEN 3 THEN '중국'
        WHEN 4 THEN '대한민국'
        WHEN 5 THEN '요르단'
    END AS product_origin
FROM Partner p
CROSS JOIN Category c
CROSS JOIN tmp_variant v
WHERE p.partner_id BETWEEN 1 AND 5
  AND c.category_cd BETWEEN 1 AND 5
ORDER BY p.partner_id, c.category_cd, v.variant_no;

-- ===========================
-- 11. Inbound
-- ===========================
INSERT INTO Inbound (
    inbound_id,
    warehouse_id,
    staff_id,
    member_id,
    inbound_status,
    inbound_reject_reason,
    inbound_requested_at,
    inbound_updated_at,
    inbound_at
)
VALUES
    (1, 1, 4, 1, 'approved', NULL, '2026-02-01 09:00:00', '2026-02-02 11:00:00', '2026-02-02 11:00:00'),
    (2, 1, 4, 3, 'approved', NULL, '2026-02-03 09:30:00', '2026-02-04 13:00:00', '2026-02-04 13:00:00'),
    (3, 2, 5, 5, 'approved', NULL, '2026-02-05 10:00:00', '2026-02-06 15:00:00', '2026-02-06 15:00:00'),
    (4, 2, 5, 7, 'approved', NULL, '2026-02-07 10:20:00', '2026-02-08 15:30:00', '2026-02-08 15:30:00'),
    (5, 3, 6, 9, 'approved', NULL, '2026-02-09 11:00:00', '2026-02-10 16:00:00', '2026-02-10 16:00:00');

-- ===========================
-- 12. InboundItem
-- 100개 상품 전체 입고
-- ===========================
INSERT INTO InboundItem (product_id, inbound_id, quantity)
SELECT
    p.product_id,
    CASE p.partner_id
        WHEN 1 THEN 1
        WHEN 2 THEN 2
        WHEN 3 THEN 3
        WHEN 4 THEN 4
        WHEN 5 THEN 5
    END AS inbound_id,
    CASE p.category_cd
        WHEN 1 THEN 120
        WHEN 2 THEN 110
        WHEN 3 THEN 80
        WHEN 4 THEN 70
        WHEN 5 THEN 95
    END + (p.partner_id * 4) + (CAST(RIGHT(p.product_id, 2) AS UNSIGNED) * 3) AS quantity
FROM Product p
ORDER BY p.partner_id, p.category_cd, p.product_id;

-- ===========================
-- 13. OutboundRequest
-- ===========================
INSERT INTO OutboundRequest (
    outbound_request_id,
    outbound_date,
    approved_status,
    outbound_address,
    member_id,
    warehouse_id,
    staff_id,
    requested_delivery_date
)
VALUES
    (1, '2026-03-03 10:00:00', 'APPROVED', '서울 강남 물류거점', 1, 1, 4, '2026-03-05 09:00:00'),
    (2, '2026-03-06 10:20:00', 'APPROVED', '경기 성남 매장', 3, 1, 4, '2026-03-08 09:00:00'),
    (3, '2026-03-09 11:00:00', 'APPROVED', '부산 센텀몰', 5, 2, 5, '2026-03-11 10:00:00'),
    (4, '2026-03-12 11:30:00', 'APPROVED', '대구 수성점', 7, 2, 5, '2026-03-14 10:00:00'),
    (5, '2026-03-15 13:00:00', 'PENDING', '인천 송도점', 9, 3, 6, '2026-03-18 11:00:00'),
    (6, '2026-03-17 15:00:00', 'COMPANION', '대전 둔산점', 10, 3, 6, '2026-03-20 11:00:00');

CREATE TEMPORARY TABLE tmp_outbound_plan (
    outbound_item_id INT PRIMARY KEY,
    outbound_request_id INT NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    outbound_quantity INT NOT NULL
);

INSERT INTO tmp_outbound_plan (outbound_item_id, outbound_request_id, product_id, outbound_quantity)
VALUES
    (1, 1, 'NK-SS-01', 18),
    (2, 1, 'NK-HD-02', 10),
    (3, 2, 'AD-LS-03', 12),
    (4, 2, 'AD-PT-01', 14),
    (5, 3, 'PM-SS-02', 16),
    (6, 3, 'PM-JK-04', 8),
    (7, 4, 'NB-HD-01', 9),
    (8, 4, 'NB-PT-03', 11),
    (9, 5, 'UA-SS-04', 20),
    (10, 5, 'UA-JK-02', 6),
    (11, 6, 'UA-LS-02', 10),
    (12, 6, 'UA-PT-04', 7);

-- ===========================
-- 14. OutboundItem
-- ===========================
INSERT INTO OutboundItem (outbound_item_id, outbound_request_id, product_id, outbound_quantity)
SELECT outbound_item_id, outbound_request_id, product_id, outbound_quantity
FROM tmp_outbound_plan
ORDER BY outbound_item_id;

-- ===========================
-- 15. OutboundOrder
-- ===========================
INSERT INTO OutboundOrder (
    approved_order_id,
    outbound_request_id,
    approved_date,
    instruction_no,
    order_status
)
VALUES
    (1, 1, '2026-03-03 13:00:00', 'ORD-0001', 'APPROVED'),
    (2, 2, '2026-03-06 14:00:00', 'ORD-0002', 'APPROVED'),
    (3, 3, '2026-03-09 15:00:00', 'ORD-0003', 'APPROVED'),
    (4, 4, '2026-03-12 16:00:00', 'ORD-0004', 'APPROVED'),
    (5, 5, NULL, 'ORD-0005', 'PENDING'),
    (6, 6, NULL, 'ORD-0006', 'COMPANION');

-- ===========================
-- 16. Driver
-- ===========================
INSERT INTO Driver (driver_id, driver_name, car_id, car_number, car_type)
VALUES
    (1, '박준수', 201, '84바1234', '1톤밴'),
    (2, '이도현', 202, '92사5678', '1톤밴'),
    (3, '정민호', 203, '33하8421', '2.5톤'),
    (4, '최성민', 204, '11가9001', '2.5톤'),
    (5, '김태윤', 205, '72너2200', '1톤밴');

-- ===========================
-- 17. Dispatch
-- ===========================
INSERT INTO Dispatch (
    dispatch_id,
    approved_order_id,
    car_id,
    car_type,
    driver_name,
    assigned_date,
    dispatch_status,
    loaded_box,
    maximum_box,
    driver_id
)
VALUES
    (1, 1, 201, '1톤밴', '박준수', '2026-03-04 08:00:00', '배차완료', 42, 100, 1),
    (2, 2, 202, '1톤밴', '이도현', '2026-03-07 08:30:00', '배송중', 38, 100, 2),
    (3, 3, 203, '2.5톤', '정민호', '2026-03-10 07:50:00', '배차완료', 51, 120, 3),
    (4, 4, 204, '2.5톤', '최성민', '2026-03-13 08:10:00', '배송중', 47, 120, 4);

-- ===========================
-- 18. Waybill
-- ===========================
INSERT INTO Waybill (
    waybill_id,
    waybill_number,
    waybill_date,
    waybill_status,
    dispatch_id,
    departure_address,
    arrival_address,
    sender_name,
    receiver_name
)
VALUES
    (1, 'WB-20260304-001', '2026-03-04 09:00:00', '등록완료', 1, '수도권 통합 의류센터', '서울 강남 물류거점', '김창고', '강남점'),
    (2, 'WB-20260307-002', '2026-03-07 09:10:00', '배송중', 2, '수도권 통합 의류센터', '경기 성남 매장', '김창고', '성남점'),
    (3, 'WB-20260310-003', '2026-03-10 09:20:00', '등록완료', 3, '영남 스포츠웨어센터', '부산 센텀몰', '이물류', '센텀몰'),
    (4, 'WB-20260313-004', '2026-03-13 09:30:00', '배송중', 4, '영남 스포츠웨어센터', '대구 수성점', '이물류', '수성점');

-- ===========================
-- 19. Qr
-- ===========================
INSERT INTO Qr (qr_id, created_at, waybill_id)
VALUES
    (1, '2026-03-04 09:05:00', 1),
    (2, '2026-03-07 09:15:00', 2),
    (3, '2026-03-10 09:25:00', 3),
    (4, '2026-03-13 09:35:00', 4);

-- ===========================
-- 20. ProductStock
-- 승인된 출고 요청만 현재 재고에 반영
-- ===========================
INSERT INTO ProductStock (
    warehouse_id,
    section_id,
    inbound_item_id,
    outbound_item_id,
    quantity,
    product_status,
    last_update_date
)
SELECT
    i.warehouse_id,
    CASE i.warehouse_id
        WHEN 1 THEN
            CASE
                WHEN p.category_cd IN (1, 2) THEN 1
                WHEN p.category_cd IN (3, 4) THEN 2
                ELSE 3
            END
        WHEN 2 THEN
            CASE
                WHEN p.category_cd IN (1, 2) THEN 4
                WHEN p.category_cd IN (3, 4) THEN 5
                ELSE 6
            END
        WHEN 3 THEN
            CASE
                WHEN p.category_cd IN (1, 2) THEN 7
                WHEN p.category_cd IN (3, 4) THEN 8
                ELSE 9
            END
    END AS section_id,
    ii.inbound_item_id,
    CASE
        WHEN orq.outbound_request_id IS NOT NULL THEN top.outbound_item_id
        ELSE NULL
    END AS outbound_item_id,
    ii.quantity - COALESCE(
        CASE
            WHEN orq.outbound_request_id IS NOT NULL THEN top.outbound_quantity
            ELSE 0
        END,
        0
    ) AS quantity,
    CASE
        WHEN orq.outbound_request_id IS NOT NULL THEN 'OUT_PROGRESS'
        ELSE 'IN_STOCK'
    END AS product_status,
    CASE
        WHEN orq.outbound_request_id IS NOT NULL THEN DATE_ADD(orq.outbound_date, INTERVAL 2 HOUR)
        ELSE i.inbound_at
    END AS last_update_date
FROM InboundItem ii
JOIN Inbound i
    ON ii.inbound_id = i.inbound_id
JOIN Product p
    ON ii.product_id = p.product_id
LEFT JOIN tmp_outbound_plan top
    ON ii.product_id = top.product_id
LEFT JOIN OutboundRequest orq
    ON top.outbound_request_id = orq.outbound_request_id
   AND orq.approved_status = 'APPROVED'
ORDER BY ii.inbound_item_id;

CREATE TEMPORARY TABLE tmp_pi_plan (
    product_id VARCHAR(20) PRIMARY KEY,
    pi_date TIMESTAMP NOT NULL,
    pi_state VARCHAR(30) NOT NULL,
    real_delta INT NOT NULL,
    update_state VARCHAR(30) NOT NULL
);

INSERT INTO tmp_pi_plan (product_id, pi_date, pi_state, real_delta, update_state)
VALUES
    ('NK-SS-01', '2026-03-20 09:00:00', '완료', 0, '정상'),
    ('NK-JK-03', '2026-03-20 09:10:00', '완료', -2, '조정완료'),
    ('AD-LS-03', '2026-03-21 09:00:00', '완료', 0, '정상'),
    ('AD-PT-02', '2026-03-21 09:10:00', '완료', 1, '조정완료'),
    ('PM-SS-02', '2026-03-22 09:00:00', '완료', 0, '정상'),
    ('PM-HD-04', '2026-03-22 09:10:00', '완료', -1, '조정완료'),
    ('NB-HD-01', '2026-03-23 09:00:00', '완료', 0, '정상'),
    ('NB-PT-03', '2026-03-23 09:10:00', '완료', 2, '조정완료'),
    ('UA-SS-01', '2026-03-24 09:00:00', '완료', 0, '정상'),
    ('UA-JK-04', '2026-03-24 09:10:00', '완료', -1, '조정완료');

-- ===========================
-- 21. PhysicalInventory
-- ===========================
INSERT INTO PhysicalInventory (
    ps_id,
    pi_date,
    pi_state,
    pid_quantity,
    real_quantity,
    different_quantity,
    update_state
)
SELECT
    ps.ps_id,
    plan.pi_date,
    plan.pi_state,
    ps.quantity,
    ps.quantity + plan.real_delta,
    plan.real_delta,
    plan.update_state
FROM tmp_pi_plan plan
JOIN InboundItem ii
    ON ii.product_id = plan.product_id
JOIN ProductStock ps
    ON ps.inbound_item_id = ii.inbound_item_id
ORDER BY plan.pi_date;

-- ===========================
-- 22. ProductStockLog
-- ===========================
INSERT INTO ProductStockLog (
    ps_id,
    event_time,
    move_quantity,
    event_type,
    product_status,
    destination
)
SELECT
    ps.ps_id,
    i.inbound_at,
    ii.quantity,
    '입고',
    'IN_STOCK',
    '창고 섹션'
FROM ProductStock ps
JOIN InboundItem ii
    ON ps.inbound_item_id = ii.inbound_item_id
JOIN Inbound i
    ON ii.inbound_id = i.inbound_id
ORDER BY ps.ps_id;

INSERT INTO ProductStockLog (
    ps_id,
    event_time,
    move_quantity,
    event_type,
    product_status,
    destination
)
SELECT
    ps.ps_id,
    orq.outbound_date,
    -top.outbound_quantity,
    '출고',
    'OUT_PROGRESS',
    orq.outbound_address
FROM ProductStock ps
JOIN OutboundItem oi
    ON ps.outbound_item_id = oi.outbound_item_id
JOIN tmp_outbound_plan top
    ON oi.outbound_item_id = top.outbound_item_id
JOIN OutboundRequest orq
    ON oi.outbound_request_id = orq.outbound_request_id
WHERE orq.approved_status = 'APPROVED'
ORDER BY ps.ps_id;

-- ===========================
-- 23. Estimate
-- ===========================
INSERT INTO Estimate (
    estimate_id,
    member_id,
    staff_id,
    is_guest,
    guest_name,
    guest_contact,
    guest_email,
    estimate_title,
    estimate_content,
    estimate_status,
    estimate_password,
    estimate_response,
    estimate_request_at,
    estimate_response_at
)
VALUES
    (1, 1, 4, 0, NULL, NULL, NULL, '나이키 2분기 보관 견적', '상의 800박스와 하의 500박스 기준 보관 견적 요청', 'answered', NULL, '월 보관료와 입출고 수수료를 포함한 견적을 회신했습니다.', '2026-02-01 14:00:00', '2026-02-02 10:00:00'),
    (2, 2, 4, 1, '김게스트', '010-5111-0001', 'guest1@brand.local', '팝업스토어 단기보관 문의', '3주 행사 물량 단기 보관 가능 여부 문의', 'request', 'guest-est-001', NULL, '2026-02-04 15:00:00', NULL),
    (3, 3, 4, 0, NULL, NULL, NULL, '아디다스 출고 대행 견적', '일 평균 120건 출고 대행 운영 견적 요청', 'answered', NULL, '출고 대행 단가와 SLA 기준을 전달했습니다.', '2026-02-06 13:00:00', '2026-02-07 11:00:00'),
    (4, 4, 5, 0, NULL, NULL, NULL, '아디다스 성수기 증설 문의', '성수기 추가 보관 공간 비용 문의', 'request', NULL, NULL, '2026-02-08 17:00:00', NULL),
    (5, 5, 5, 0, NULL, NULL, NULL, '푸마 부산권 물류 견적', '부산권 당일배송 대응 가능 여부 확인 요청', 'answered', NULL, '당일배송 옵션과 마감 조건을 안내했습니다.', '2026-02-10 10:00:00', '2026-02-11 09:30:00'),
    (6, 6, 5, 1, '이게스트', '010-5111-0002', 'guest2@brand.local', '브랜드 런칭 초기 보관 문의', '초기 SKU 20종 기준 월 보관료 문의', 'request', 'guest-est-002', NULL, '2026-02-12 16:00:00', NULL),
    (7, 7, 6, 0, NULL, NULL, NULL, '뉴발란스 재고실사 문의', '월 1회 정기 실사 서비스 비용 문의', 'answered', NULL, '실사 비용과 리포트 제공 범위를 전달했습니다.', '2026-02-14 14:30:00', '2026-02-15 10:30:00'),
    (8, 8, 6, 0, NULL, NULL, NULL, '뉴발란스 리패키징 견적', '합포장 및 재포장 작업 비용 문의', 'request', NULL, NULL, '2026-02-16 09:10:00', NULL),
    (9, 9, 6, 0, NULL, NULL, NULL, '언더아머 온라인 전용센터 문의', '온라인 SKU 전용 운영 시 보관 및 출고 단가 문의', 'answered', NULL, '전용센터 배정 가능 여부와 예상 단가를 회신했습니다.', '2026-02-18 13:20:00', '2026-02-19 10:20:00'),
    (10, 10, 7, 1, '박게스트', '010-5111-0003', 'guest3@brand.local', '단기 프로모션 물량 견적', '2개월 단기 프로모션 재고 보관 및 출고 대행 문의', 'request', 'guest-est-003', NULL, '2026-02-21 11:40:00', NULL);

-- ===========================
-- 24. Sales
-- ===========================
INSERT INTO Sales (
    sales_id,
    sales_code,
    warehouse_name,
    sales_date,
    category,
    client_name,
    amount,
    description,
    reg_date,
    mod_date,
    status
)
VALUES
    (1, 'SAL-202601-00001', '수도권 통합 의류센터', '2026-01-31', '보관료', '나이키', 18500000, '1월 월간 보관료', '2026-01-31 18:00:00', '2026-01-31 18:00:00', 'ACTIVE'),
    (2, 'SAL-202602-00002', '수도권 통합 의류센터', '2026-02-28', '입고수수료', '아디다스', 9200000, '2월 입고 검수 수수료', '2026-02-28 18:00:00', '2026-02-28 18:00:00', 'ACTIVE'),
    (3, 'SAL-202603-00003', '영남 스포츠웨어센터', '2026-03-31', '출고수수료', '푸마', 8700000, '3월 출고 처리 수수료', '2026-03-31 18:00:00', '2026-03-31 18:00:00', 'ACTIVE'),
    (4, 'SAL-202604-00004', '영남 스포츠웨어센터', '2026-04-30', '보관료', '뉴발란스', 13200000, '4월 월간 보관료', '2026-04-30 18:00:00', '2026-04-30 18:00:00', 'ACTIVE'),
    (5, 'SAL-202605-00005', '서부 이커머스센터', '2026-05-31', '출고수수료', '언더아머', 9100000, '5월 출고 대행 수수료', '2026-05-31 18:00:00', '2026-05-31 18:00:00', 'ACTIVE'),
    (6, 'SAL-202606-00006', '수도권 통합 의류센터', '2026-06-30', '부가작업', '나이키', 6400000, '택부착 및 재포장 작업 매출', '2026-06-30 18:00:00', '2026-06-30 18:00:00', 'ACTIVE'),
    (7, 'SAL-202607-00007', '수도권 통합 의류센터', '2026-07-31', '보관료', '아디다스', 19100000, '7월 월간 보관료', '2026-07-31 18:00:00', '2026-07-31 18:00:00', 'ACTIVE'),
    (8, 'SAL-202608-00008', '영남 스포츠웨어센터', '2026-08-31', '입고수수료', '푸마', 7800000, '8월 입고 수수료', '2026-08-31 18:00:00', '2026-08-31 18:00:00', 'ACTIVE'),
    (9, 'SAL-202609-00009', '영남 스포츠웨어센터', '2026-09-30', '출고수수료', '뉴발란스', 9600000, '9월 출고 수수료', '2026-09-30 18:00:00', '2026-09-30 18:00:00', 'ACTIVE'),
    (10, 'SAL-202610-00010', '서부 이커머스센터', '2026-10-31', '보관료', '언더아머', 14300000, '10월 월간 보관료', '2026-10-31 18:00:00', '2026-10-31 18:00:00', 'ACTIVE'),
    (11, 'SAL-202611-00011', '수도권 통합 의류센터', '2026-11-30', '부가작업', '나이키', 5200000, '행사 물량 세트 구성 작업', '2026-11-30 18:00:00', '2026-11-30 18:00:00', 'ACTIVE'),
    (12, 'SAL-202612-00012', '서부 이커머스센터', '2026-12-31', '출고수수료', '언더아머', 11800000, '12월 연말 출고 수수료', '2026-12-31 18:00:00', '2026-12-31 18:00:00', 'ACTIVE');

-- ===========================
-- 25. Expense
-- ===========================
INSERT INTO Expense (
    expense_id,
    expense_code,
    warehouse_name,
    expense_date,
    category,
    amount,
    description,
    reg_date,
    mod_date,
    status
)
VALUES
    (1, 'EXP-202601-00001', '수도권 통합 의류센터', '2026-01-31', '인건비', 8200000, '1월 현장 인건비', '2026-01-31 18:10:00', '2026-01-31 18:10:00', 'ACTIVE'),
    (2, 'EXP-202602-00002', '수도권 통합 의류센터', '2026-02-28', '포장자재', 2100000, '2월 포장 부자재 비용', '2026-02-28 18:10:00', '2026-02-28 18:10:00', 'ACTIVE'),
    (3, 'EXP-202603-00003', '영남 스포츠웨어센터', '2026-03-31', '운송비', 3900000, '3월 간선 운송비', '2026-03-31 18:10:00', '2026-03-31 18:10:00', 'ACTIVE'),
    (4, 'EXP-202604-00004', '영남 스포츠웨어센터', '2026-04-30', '설비유지', 2600000, '4월 랙 유지보수 비용', '2026-04-30 18:10:00', '2026-04-30 18:10:00', 'ACTIVE'),
    (5, 'EXP-202605-00005', '서부 이커머스센터', '2026-05-31', '임차료', 7100000, '5월 창고 임차료', '2026-05-31 18:10:00', '2026-05-31 18:10:00', 'ACTIVE'),
    (6, 'EXP-202606-00006', '수도권 통합 의류센터', '2026-06-30', '전산비', 1800000, 'WMS 서버 및 라이선스 비용', '2026-06-30 18:10:00', '2026-06-30 18:10:00', 'ACTIVE'),
    (7, 'EXP-202607-00007', '수도권 통합 의류센터', '2026-07-31', '인건비', 8500000, '7월 성수기 추가 인력 비용', '2026-07-31 18:10:00', '2026-07-31 18:10:00', 'ACTIVE'),
    (8, 'EXP-202608-00008', '영남 스포츠웨어센터', '2026-08-31', '포장자재', 2300000, '8월 포장 자재 구매 비용', '2026-08-31 18:10:00', '2026-08-31 18:10:00', 'ACTIVE'),
    (9, 'EXP-202609-00009', '영남 스포츠웨어센터', '2026-09-30', '운송비', 4050000, '9월 택배 및 간선 운송비', '2026-09-30 18:10:00', '2026-09-30 18:10:00', 'ACTIVE'),
    (10, 'EXP-202610-00010', '서부 이커머스센터', '2026-10-31', '설비유지', 2400000, '10월 자동포장기 유지보수', '2026-10-31 18:10:00', '2026-10-31 18:10:00', 'ACTIVE'),
    (11, 'EXP-202611-00011', '수도권 통합 의류센터', '2026-11-30', '임차료', 7200000, '11월 창고 임차료', '2026-11-30 18:10:00', '2026-11-30 18:10:00', 'ACTIVE'),
    (12, 'EXP-202612-00012', '서부 이커머스센터', '2026-12-31', '전산비', 1950000, '12월 시스템 운영비', '2026-12-31 18:10:00', '2026-12-31 18:10:00', 'ACTIVE');

DROP TEMPORARY TABLE IF EXISTS tmp_pi_plan;
DROP TEMPORARY TABLE IF EXISTS tmp_outbound_plan;
DROP TEMPORARY TABLE IF EXISTS tmp_variant;

COMMIT;
