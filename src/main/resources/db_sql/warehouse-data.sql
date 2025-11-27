-- 1. Partner (ID: 1, 2)
INSERT INTO `Partner` (`partner_name`, `business_number`, `address`) VALUES
                                                                         ('나이키 코리아', '123-45-67890', '서울시 강남구 테헤란로 123'),
                                                                         ('아디다스 글로벌', '987-65-43210', '부산시 해운대구 마린시티');

-- 2. category (ID: 1, 2)
INSERT INTO `category` (`category_name`) VALUES
                                             ('의류'),
                                             ('신발');

-- 3. Staff (ID: 1)
INSERT INTO `Staff` (`staff_pw`, `staff_name`, `staff_phone`, `staff_email`, `staff_login_id`, `role`) VALUES
    ('$2a$10$HASHEDPASSWORD', '김관리', '010-1111-2222', 'admin@wms.com', 'admin_kim', 'ADMIN');

-- 4. WAREHOUSE (ID: 1)
INSERT INTO `WAREHOUSE` (`admin_id`, `name`, `warehouse_type`, `warehouse_capacity`, `warehouse_status`, `registration_date`, `latest_update_date`, `address`, `latitude`, `longitude`) VALUES
    (1, '파주 허브센터', 'Hub', 50000, 1, '2025-01-01', NOW(), '경기도 파주시 문산읍 111', 37.8596000, 126.7797000);

-- 5. Member (ID: 1, 2 - Partner 참조)
INSERT INTO `Member` (`member_login_id`, `member_pw`, `member_name`, `member_phone`, `member_email`, `partner_id`, `status`) VALUES
                                                                                                                                 ('nike_user', '$2a$10$HASHEDPASSWORD', '박나이키', '010-3333-4444', 'nike@partner.com', 1, 'ACTIVE'),
                                                                                                                                 ('adidas_user', '$2a$10$HASHEDPASSWORD', '이아디', '010-5555-6666', 'adidas@partner.com', 2, 'ACTIVE');

-- 6. Section (ID: 1 - WAREHOUSE 참조)
INSERT INTO `Section` (`warehouse_id`, `section_name`, `section_type`, `section_purpose`, `allocated_area`) VALUES
    (1, 'A구역_의류보관', 'A', '의류 보관 전용', 1000);

-- 7. LOCATION (ID: 1 - WAREHOUSE 참조)
INSERT INTO `LOCATION` (`warehouse_id`, `location_code`, `floor_num`, `location_type_code`, `max_volume`) VALUES
    (1, 'A-01-01-01', 1, 'PICK', 10.500);

-- 8. Product (PROD0001NIKE, PROD0002ADID)
INSERT INTO `Product` (`product_id`, `category_cd`, `partner_id`, `product_name`, `product_price`) VALUES
                                                                                                       ('PROD0001NIKE', 1, 1, '나이키 후드티 블랙', 79000),
                                                                                                       ('PROD0002ADID', 2, 2, '아디다스 울트라 부스트', 159000);

-- 9. inbound (ID: 1)
INSERT INTO `inbound` (`warehouse_id`, `staff_id`, `member_id`, `inbound_status`, `inbound_at`) VALUES
    (1, 1, 1, 'completed', NOW());

-- 10. inbound_item (ID: 1)
INSERT INTO `inbound_item` (`product_id`, `inbound_id`, `quantity`) VALUES
    ('PROD0001NIKE', 1, 500);

-- 11. Product_Stock (ID: 1)
INSERT INTO `Product_Stock` (`warehouse_id`, `section_id`, `inbound_item_id`, `quantity`, `product_status`, `last_updatedate`) VALUES
    (1, 1, 1, 500, 'Available', NOW());\