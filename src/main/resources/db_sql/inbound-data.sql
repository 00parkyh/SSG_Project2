use wmstestdb;

-- ===========================
-- 1. Partner (10건)
-- ===========================
INSERT INTO Partner (partner_name, business_number, address)
VALUES ('Nike', '123-45-67890', '서울시 강남구'),
       ('Adidas', '223-45-67890', '서울시 서초구'),
       ('Puma', '323-45-67890', '서울시 마포구'),
       ('Reebok', '423-45-67890', '서울시 성동구'),
       ('New Balance', '523-45-67890', '서울시 동대문구'),
       ('Converse', '623-45-67890', '서울시 종로구'),
       ('Fila', '723-45-67890', '서울시 강서구'),
       ('Under Armour', '823-45-67890', '서울시 용산구'),
       ('Asics', '923-45-67890', '서울시 광진구'),
       ('Vans', '103-45-67890', '서울시 중구');

-- ===========================
-- 2. Category (5건)
-- ===========================
INSERT INTO category (category_name)
VALUES ('아우터'),
       ('상의'),
       ('하의'),
       ('신발'),
       ('기타');

-- ===========================
-- 3. Member (10건)
-- ===========================
INSERT INTO Member (member_login_id, member_pw, member_name, member_phone, member_email, partner_id)
VALUES ('user01', 'pw01', '홍길동', '010-0000-0001', 'user01@example.com', 1),
       ('user02', 'pw02', '김철수', '010-0000-0002', 'user02@example.com', 2),
       ('user03', 'pw03', '이영희', '010-0000-0003', 'user03@example.com', 3),
       ('user04', 'pw04', '박민수', '010-0000-0004', 'user04@example.com', 4),
       ('user05', 'pw05', '최수지', '010-0000-0005', 'user05@example.com', 5),
       ('user06', 'pw06', '장훈', '010-0000-0006', 'user06@example.com', 6),
       ('user07', 'pw07', '강민', '010-0000-0007', 'user07@example.com', 7),
       ('user08', 'pw08', '오세훈', '010-0000-0008', 'user08@example.com', 8),
       ('user09', 'pw09', '한지민', '010-0000-0009', 'user09@example.com', 9),
       ('user10', 'pw10', '서지훈', '010-0000-0010', 'user10@example.com', 10);

-- ===========================
-- 4. Staff (10건)
-- ===========================
INSERT INTO Staff (staff_pw, staff_name, staff_phone, staff_email, staff_login_id)
VALUES ('pw101', '김관리', '010-1000-0001', 'staff01@example.com', 'staff01'),
       ('pw102', '이관리', '010-1000-0002', 'staff02@example.com', 'staff02'),
       ('pw103', '박관리', '010-1000-0003', 'staff03@example.com', 'staff03'),
       ('pw104', '최관리', '010-1000-0004', 'staff04@example.com', 'staff04'),
       ('pw105', '정관리', '010-1000-0005', 'staff05@example.com', 'staff05'),
       ('pw106', '강관리', '010-1000-0006', 'staff06@example.com', 'staff06'),
       ('pw107', '윤관리', '010-1000-0007', 'staff07@example.com', 'staff07'),
       ('pw108', '오관리', '010-1000-0008', 'staff08@example.com', 'staff08'),
       ('pw109', '한관리', '010-1000-0009', 'staff09@example.com', 'staff09'),
       ('pw110', '서관리', '010-1000-0010', 'staff10@example.com', 'staff10');

-- ===========================
-- 5. Warehouse (10건)
-- ===========================
INSERT INTO WAREHOUSE (admin_id, name, warehouse_type, warehouse_capacity, warehouse_status, registration_date,
                       latest_update_date, address, latitude, longitude)
VALUES (1, '강남창고', '일반', 1000, 1, '2025-01-01', CURRENT_TIMESTAMP, '서울시 강남구', 37.4979, 127.0276),
       (2, '서초창고', '일반', 800, 1, '2025-01-02', CURRENT_TIMESTAMP, '서울시 서초구', 37.4910, 127.0330),
       (3, '마포창고', '냉동', 600, 1, '2025-01-03', CURRENT_TIMESTAMP, '서울시 마포구', 37.5663, 126.9010),
       (4, '성동창고', '일반', 500, 1, '2025-01-04', CURRENT_TIMESTAMP, '서울시 성동구', 37.5446, 127.0362),
       (5, '동대문창고', '냉장', 700, 1, '2025-01-05', CURRENT_TIMESTAMP, '서울시 동대문구', 37.5740, 127.0396),
       (6, '종로창고', '일반', 400, 1, '2025-01-06', CURRENT_TIMESTAMP, '서울시 종로구', 37.5700, 126.9910),
       (7, '강서창고', '일반', 300, 1, '2025-01-07', CURRENT_TIMESTAMP, '서울시 강서구', 37.5500, 126.8490),
       (8, '용산창고', '냉장', 900, 1, '2025-01-08', CURRENT_TIMESTAMP, '서울시 용산구', 37.5313, 126.9810),
       (9, '광진창고', '일반', 600, 1, '2025-01-09', CURRENT_TIMESTAMP, '서울시 광진구', 37.5478, 127.0857),
       (10, '중구창고', '냉동', 500, 1, '2025-01-10', CURRENT_TIMESTAMP, '서울시 중구', 37.5636, 126.9975);

-- ===========================
-- 6. Section (10건)
-- ===========================
INSERT INTO Section (warehouse_id, section_name, section_type, section_purpose, allocated_area)
VALUES (1, 'A구역', '일반', '상의 보관', 100),
       (2, 'B구역', '냉동', '아이스크림', 80),
       (3, 'C구역', '냉장', '음료 보관', 60),
       (4, 'D구역', '일반', '하의 보관', 50),
       (5, 'E구역', '냉장', '신발 보관', 70),
       (6, 'F구역', '일반', '기타', 40),
       (7, 'G구역', '일반', '아우터 보관', 30),
       (8, 'H구역', '냉장', '음료 보관', 90),
       (9, 'I구역', '일반', '상의 보관', 60),
       (10, 'J구역', '냉동', '냉동식품', 50);

-- ===========================
-- 7. Product (10건)
-- ===========================
INSERT INTO Product (product_id, category_cd, partner_id, product_name, product_price, product_origin)
VALUES ('P001', 1, 1, '나이키 아우터', 100000, 'USA'),
       ('P002', 2, 2, '아디다스 티셔츠', 50000, 'GER'),
       ('P003', 3, 3, '푸마 바지', 60000, 'GER'),
       ('P004', 4, 4, '리복 운동화', 80000, 'USA'),
       ('P005', 5, 5, '뉴발란스 모자', 20000, 'USA'),
       ('P006', 1, 6, '컨버스 자켓', 90000, 'USA'),
       ('P007', 2, 7, '휠라 티셔츠', 45000, 'KOR'),
       ('P008', 3, 8, '언더아머 바지', 70000, 'USA'),
       ('P009', 4, 9, '아식스 운동화', 75000, 'JPN'),
       ('P010', 5, 10, '반스 모자', 15000, 'USA');

-- ===========================
-- 8. inbound (10건)
-- ===========================
INSERT INTO inbound (warehouse_id, staff_id, member_id, inbound_status)
VALUES (1, 1, 1, 'request'),
       (2, 2, 2, 'request'),
       (3, 3, 3, 'request'),
       (4, 4, 4, 'request'),
       (5, 5, 5, 'request'),
       (6, 6, 6, 'request'),
       (7, 7, 7, 'request'),
       (8, 8, 8, 'request'),
       (9, 9, 9, 'request'),
       (10, 10, 10, 'request');

-- ===========================
-- 9. inbound_item (10건)
-- ===========================
INSERT INTO inbound_item (product_id, inbound_id, quantity)
VALUES ('P001', 1, 10),
       ('P002', 2, 20),
       ('P003', 3, 15),
       ('P004', 4, 5),
       ('P005', 5, 12),
       ('P006', 6, 8),
       ('P007', 7, 18),
       ('P008', 8, 25),
       ('P009', 9, 7),
       ('P010', 10, 30);

-- ===========================
-- 10. Product_Stock (10건)
-- ===========================
INSERT INTO Product_Stock (warehouse_id, section_id, inbound_item_id, quantity, product_status)
VALUES (1, 1, 1, 10, 'AVAILABLE'),
       (2, 2, 2, 20, 'AVAILABLE'),
       (3, 3, 3, 15, 'AVAILABLE'),
       (4, 4, 4, 5, 'AVAILABLE'),
       (5, 5, 5, 12, 'AVAILABLE'),
       (6, 6, 6, 8, 'AVAILABLE'),
       (7, 7, 7, 18, 'AVAILABLE'),
       (8, 8, 8, 25, 'AVAILABLE'),
       (9, 9, 9, 7, 'AVAILABLE'),
       (10, 10, 10, 30, 'AVAILABLE');

-- ===========================
-- 11. Physical_Inventory (10건)
-- ===========================
INSERT INTO Physical_Inventory (PS_ID, pi_date, pi_state, pid_quantity, real_quantity, different_quantity, update_state)
VALUES (1, CURRENT_TIMESTAMP, 'START', 10, 10, 0, 'PENDING'),
       (2, CURRENT_TIMESTAMP, 'START', 20, 20, 0, 'PENDING'),
       (3, CURRENT_TIMESTAMP, 'START', 15, 15, 0, 'PENDING'),
       (4, CURRENT_TIMESTAMP, 'START', 5, 5, 0, 'PENDING'),
       (5, CURRENT_TIMESTAMP, 'START', 12, 12, 0, 'PENDING'),
       (6, CURRENT_TIMESTAMP, 'START', 8, 8, 0, 'PENDING'),
       (7, CURRENT_TIMESTAMP, 'START', 18, 18, 0, 'PENDING'),
       (8, CURRENT_TIMESTAMP, 'START', 25, 25, 0, 'PENDING'),
       (9, CURRENT_TIMESTAMP, 'START', 7, 7, 0, 'PENDING'),
       (10, CURRENT_TIMESTAMP, 'START', 30, 30, 0, 'PENDING');

-- ===========================
-- 12. product_stock_log (10건)
-- ===========================
INSERT INTO product_stock_log (PS_ID, event_time, move_quantity, event_type, product_status, destination)
VALUES (1, CURRENT_TIMESTAMP, 10, 'IN', 'AVAILABLE', 'Warehouse A'),
       (2, CURRENT_TIMESTAMP, 20, 'IN', 'AVAILABLE', 'Warehouse B'),
       (3, CURRENT_TIMESTAMP, 15, 'IN', 'AVAILABLE', 'Warehouse C'),
       (4, CURRENT_TIMESTAMP, 5, 'IN', 'AVAILABLE', 'Warehouse D'),
       (5, CURRENT_TIMESTAMP, 12, 'IN', 'AVAILABLE', 'Warehouse E'),
       (6, CURRENT_TIMESTAMP, 8, 'IN', 'AVAILABLE', 'Warehouse F'),
       (7, CURRENT_TIMESTAMP, 18, 'IN', 'AVAILABLE', 'Warehouse G'),
       (8, CURRENT_TIMESTAMP, 25, 'IN', 'AVAILABLE', 'Warehouse H'),
       (9, CURRENT_TIMESTAMP, 7, 'IN', 'AVAILABLE', 'Warehouse I'),
       (10, CURRENT_TIMESTAMP, 30, 'IN', 'AVAILABLE', 'Warehouse J');
INSERT INTO Product (product_id, category_cd, partner_id, product_name, product_price, product_origin)
VALUES ('P011', 1, 1, '나이키 아우터2', 110000, 'USA'),
       ('P012', 2, 2, '아디다스 티셔츠2', 52000, 'GER'),
       ('P013', 3, 3, '푸마 바지2', 62000, 'GER'),
       ('P014', 4, 4, '리복 운동화2', 82000, 'USA'),
       ('P015', 5, 5, '뉴발란스 모자2', 22000, 'USA'),
       ('P016', 1, 6, '컨버스 자켓2', 91000, 'USA'),
       ('P017', 2, 7, '휠라 티셔츠2', 47000, 'KOR'),
       ('P018', 3, 8, '언더아머 바지2', 72000, 'USA'),
       ('P019', 4, 9, '아식스 운동화2', 77000, 'JPN'),
       ('P020', 5, 10, '반스 모자2', 16000, 'USA'),

       ('P021', 1, 1, '나이키 아우터3', 120000, 'USA'),
       ('P022', 2, 2, '아디다스 티셔츠3', 53000, 'GER'),
       ('P023', 3, 3, '푸마 바지3', 63000, 'GER'),
       ('P024', 4, 4, '리복 운동화3', 83000, 'USA'),
       ('P025', 5, 5, '뉴발란스 모자3', 23000, 'USA'),
       ('P026', 1, 6, '컨버스 자켓3', 92000, 'USA'),
       ('P027', 2, 7, '휠라 티셔츠3', 48000, 'KOR'),
       ('P028', 3, 8, '언더아머 바지3', 73000, 'USA'),
       ('P029', 4, 9, '아식스 운동화3', 78000, 'JPN'),
       ('P030', 5, 10, '반스 모자3', 17000, 'USA'),

       ('P031', 1, 1, '나이키 아우터4', 125000, 'USA'),
       ('P032', 2, 2, '아디다스 티셔츠4', 54000, 'GER'),
       ('P033', 3, 3, '푸마 바지4', 64000, 'GER'),
       ('P034', 4, 4, '리복 운동화4', 84000, 'USA'),
       ('P035', 5, 5, '뉴발란스 모자4', 24000, 'USA'),
       ('P036', 1, 6, '컨버스 자켓4', 93000, 'USA'),
       ('P037', 2, 7, '휠라 티셔츠4', 49000, 'KOR'),
       ('P038', 3, 8, '언더아머 바지4', 74000, 'USA'),
       ('P039', 4, 9, '아식스 운동화4', 79000, 'JPN'),
       ('P040', 5, 10, '반스 모자4', 18000, 'USA'),

       ('P041', 1, 1, '나이키 아우터5', 130000, 'USA'),
       ('P042', 2, 2, '아디다스 티셔츠5', 55000, 'GER'),
       ('P043', 3, 3, '푸마 바지5', 65000, 'GER'),
       ('P044', 4, 4, '리복 운동화5', 85000, 'USA'),
       ('P045', 5, 5, '뉴발란스 모자5', 25000, 'USA'),
       ('P046', 1, 6, '컨버스 자켓5', 94000, 'USA'),
       ('P047', 2, 7, '휠라 티셔츠5', 50000, 'KOR'),
       ('P048', 3, 8, '언더아머 바지5', 75000, 'USA'),
       ('P049', 4, 9, '아식스 운동화5', 80000, 'JPN'),
       ('P050', 5, 10, '반스 모자5', 19000, 'USA'),

       ('P051', 1, 1, '나이키 아우터6', 135000, 'USA'),
       ('P052', 2, 2, '아디다스 티셔츠6', 56000, 'GER'),
       ('P053', 3, 3, '푸마 바지6', 66000, 'GER'),
       ('P054', 4, 4, '리복 운동화6', 86000, 'USA'),
       ('P055', 5, 5, '뉴발란스 모자6', 26000, 'USA'),
       ('P056', 1, 6, '컨버스 자켓6', 95000, 'USA'),
       ('P057', 2, 7, '휠라 티셔츠6', 51000, 'KOR'),
       ('P058', 3, 8, '언더아머 바지6', 76000, 'USA'),
       ('P059', 4, 9, '아식스 운동화6', 81000, 'JPN'),
       ('P060', 5, 10, '반스 모자6', 20000, 'USA'),

       ('P061', 1, 1, '나이키 아우터7', 140000, 'USA'),
       ('P062', 2, 2, '아디다스 티셔츠7', 57000, 'GER'),
       ('P063', 3, 3, '푸마 바지7', 67000, 'GER'),
       ('P064', 4, 4, '리복 운동화7', 87000, 'USA'),
       ('P065', 5, 5, '뉴발란스 모자7', 27000, 'USA'),
       ('P066', 1, 6, '컨버스 자켓7', 96000, 'USA'),
       ('P067', 2, 7, '휠라 티셔츠7', 52000, 'KOR'),
       ('P068', 3, 8, '언더아머 바지7', 77000, 'USA'),
       ('P069', 4, 9, '아식스 운동화7', 82000, 'JPN'),
       ('P070', 5, 10, '반스 모자7', 21000, 'USA'),

       ('P071', 1, 1, '나이키 아우터8', 145000, 'USA'),
       ('P072', 2, 2, '아디다스 티셔츠8', 58000, 'GER'),
       ('P073', 3, 3, '푸마 바지8', 68000, 'GER'),
       ('P074', 4, 4, '리복 운동화8', 88000, 'USA'),
       ('P075', 5, 5, '뉴발란스 모자8', 28000, 'USA'),
       ('P076', 1, 6, '컨버스 자켓8', 97000, 'USA'),
       ('P077', 2, 7, '휠라 티셔츠8', 53000, 'KOR'),
       ('P078', 3, 8, '언더아머 바지8', 78000, 'USA'),
       ('P079', 4, 9, '아식스 운동화8', 83000, 'JPN'),
       ('P080', 5, 10, '반스 모자8', 22000, 'USA'),

       ('P081', 1, 1, '나이키 아우터9', 150000, 'USA'),
       ('P082', 2, 2, '아디다스 티셔츠9', 59000, 'GER'),
       ('P083', 3, 3, '푸마 바지9', 69000, 'GER'),
       ('P084', 4, 4, '리복 운동화9', 89000, 'USA'),
       ('P085', 5, 5, '뉴발란스 모자9', 29000, 'USA'),
       ('P086', 1, 6, '컨버스 자켓9', 98000, 'USA'),
       ('P087', 2, 7, '휠라 티셔츠9', 54000, 'KOR'),
       ('P088', 3, 8, '언더아머 바지9', 79000, 'USA'),
       ('P089', 4, 9, '아식스 운동화9', 84000, 'JPN'),
       ('P090', 5, 10, '반스 모자9', 23000, 'USA'),

       ('P091', 1, 1, '나이키 아우터10', 155000, 'USA'),
       ('P092', 2, 2, '아디다스 티셔츠10', 60000, 'GER'),
       ('P093', 3, 3, '푸마 바지10', 70000, 'GER'),
       ('P094', 4, 4, '리복 운동화10', 90000, 'USA'),
       ('P095', 5, 5, '뉴발란스 모자10', 30000, 'USA'),
       ('P096', 1, 6, '컨버스 자켓10', 99000, 'USA'),
       ('P097', 2, 7, '휠라 티셔츠10', 55000, 'KOR'),
       ('P098', 3, 8, '언더아머 바지10', 80000, 'USA'),
       ('P099', 4, 9, '아식스 운동화10', 85000, 'JPN'),
       ('P100', 5, 10, '반스 모자10', 24000, 'USA');
