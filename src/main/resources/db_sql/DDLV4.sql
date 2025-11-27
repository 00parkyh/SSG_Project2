-- ===========================
-- 1. Partner
-- ===========================
CREATE TABLE `Partner` (
    `partner_id` int NOT NULL AUTO_INCREMENT COMMENT '거래처 고유 ID',
    `partner_name` VARCHAR(100) NOT NULL COMMENT '예: 나이키, 아디다스 ...',
    `business_number` VARCHAR(20) NOT NULL,
    `address` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
    `updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`partner_id`)
);

-- ===========================
-- 2. category
-- ===========================
CREATE TABLE `category` (
    `category_cd` int NOT NULL AUTO_INCREMENT,
    `category_name` varchar(200) NOT NULL,
    PRIMARY KEY (`category_cd`)
);

-- ===========================
-- 3. WAREHOUSE

-- ===========================
CREATE TABLE `WAREHOUSE` (
    `warehouse_id` int NOT NULL AUTO_INCREMENT COMMENT '창고 고유 식별',
    `admin_id` int NOT NULL COMMENT '창고관리담당자ID',
    `name` varchar(100) NOT NULL,
    `warehouse_type` varchar(100) NOT NULL,
    `warehouse_capacity` int NULL,
    `warehouse_status` tinyint NOT NULL,
    `registration_date` date NOT NULL,
    `latest_update_date` timestamp NOT NULL,
    `address` varchar(255) NOT NULL,
    `latitude` decimal(10,7) NOT NULL,
    `longitude` decimal(10,7) NOT NULL,
    PRIMARY KEY (`warehouse_id`)
);

-- ===========================
-- 4. Staff
-- ===========================
CREATE TABLE `Staff` (
    `staff_id` bigint NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `staff_pw` varchar(255) NOT NULL,
    `staff_name` varchar(255) NOT NULL,
    `staff_phone` varchar(255) NOT NULL,
    `staff_email` varchar(255) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `updated_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `status` varchar(20) NOT NULL DEFAULT 'ACTIVE',
    `role` varchar(255) NOT NULL DEFAULT 'MANAGER',
    `staff_login_id` varchar(255) NOT NULL
);

-- ===========================
-- 5. Member
-- ===========================
CREATE TABLE `Member` (
    `member_id` bigint NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `member_login_id` varchar(255) NOT NULL,
    `member_pw` varchar(255) NOT NULL,
    `member_name` varchar(255) NOT NULL,
    `member_phone` varchar(255) NOT NULL,
    `member_email` varchar(255) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `updated_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `status` varchar(20) NOT NULL DEFAULT 'PENDING',
    `role` varchar(255) NOT NULL DEFAULT 'MEMBER',
    `partner_id` int NOT NULL,
    CONSTRAINT `FK_Partner_TO_Member_1`
        FOREIGN KEY (`partner_id`) REFERENCES `Partner` (`partner_id`)
);

-- ===========================
-- 6. Partner_Fee
-- ===========================
CREATE TABLE `Partner_Fee` (
    `fee_id` int NOT NULL AUTO_INCREMENT,
    `partner_id` int NOT NULL,
    `fee_type` VARCHAR(255) NOT NULL,
    `price` DECIMAL NOT NULL,
    `apply_date` DATE NULL,
    PRIMARY KEY (`fee_id`),
    CONSTRAINT `FK_Partner_TO_Partner_Fee_1`
        FOREIGN KEY (`partner_id`) REFERENCES `Partner` (`partner_id`)
);

-- ===========================
-- 7. PARTNER_CONTRACT
-- ===========================
CREATE TABLE `PARTNER_CONTRACT` (
    `CONTRACT_ID` int NOT NULL AUTO_INCREMENT,
    `partner_id` int NOT NULL,
    `CONTRACT_START` DATE NULL,
    `CONTRACT_AREA` DECIMAL NULL,
    `CONTRACT_STATUS` VARCHAR(255) NOT NULL DEFAULT 'AVAILABLE',
    PRIMARY KEY (`CONTRACT_ID`),
    CONSTRAINT `FK_Partner_TO_PARTNER_CONTRACT_1`
        FOREIGN KEY (`partner_id`) REFERENCES `Partner` (`partner_id`)
);

-- ===========================
-- 8. Section
-- ===========================
CREATE TABLE `Section` (
    `section_id` int NOT NULL AUTO_INCREMENT,
    `warehouse_id` int NOT NULL,
    `section_name` varchar(50) NOT NULL,
    `section_type` varchar(50) NOT NULL,
    `section_purpose` text NULL,
    `allocated_area` int NULL,
    PRIMARY KEY (`section_id`, `warehouse_id`),
    CONSTRAINT `FK_WAREHOUSE_TO_Section_1`
        FOREIGN KEY (`warehouse_id`) REFERENCES `WAREHOUSE` (`warehouse_id`)
);

-- ===========================
-- 9. LOCATION
-- ===========================
CREATE TABLE `LOCATION` (
    `location_id` int NOT NULL AUTO_INCREMENT,
    `warehouse_id` int NOT NULL,
    `location_code` varchar(100) NOT NULL,
    `floor_num` int NOT NULL,
    `location_type_code` varchar(50) NOT NULL,
    `max_volume` decimal(10,3) NULL,
    PRIMARY KEY (`location_id`),
    CONSTRAINT `FK_WAREHOUSE_TO_LOCATION_1`
        FOREIGN KEY (`warehouse_id`) REFERENCES `WAREHOUSE` (`warehouse_id`)
);

-- ===========================
-- 10. Product
-- ===========================
CREATE TABLE `Product` (
    `product_id` varchar(20) NOT NULL,
    `category_cd` int NOT NULL,
    `partner_id` int NOT NULL,
    `product_name` varchar(200) NOT NULL,
    `product_price` BIGINT NULL,
    `product_origin` varchar(200) NULL,
    PRIMARY KEY (`product_id`),
    CONSTRAINT `FK_category_TO_Product_1`
        FOREIGN KEY (`category_cd`) REFERENCES `category` (`category_cd`),
    CONSTRAINT `FK_Partner_TO_Product_1`
        FOREIGN KEY (`partner_id`) REFERENCES `Partner` (`partner_id`)
);

-- ===========================
-- 11. inbound
-- ===========================
CREATE TABLE `inbound` (
    `inbound_id` int NOT NULL AUTO_INCREMENT,
    `warehouse_id` int NULL,
    `staff_id` bigint NULL,
    `member_id` bigint NOT NULL,
    `inbound_status` varchar(100) NOT NULL DEFAULT 'request',
    `inbound_reject_reason` varchar(200) NULL,
    `inbound_requested_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `inbound_updated_at` timestamp NULL DEFAULT current_timestamp(),
    `inbound_at` timestamp NULL,
    PRIMARY KEY (`inbound_id`),
    CONSTRAINT `FK_WAREHOUSE_TO_inbound_1`
        FOREIGN KEY (`warehouse_id`) REFERENCES `WAREHOUSE` (`warehouse_id`),
    CONSTRAINT `FK_Staff_TO_inbound_1`
        FOREIGN KEY (`staff_id`) REFERENCES `Staff` (`staff_id`),
    CONSTRAINT `FK_Member_TO_inbound_1`
        FOREIGN KEY (`member_id`) REFERENCES `Member` (`member_id`)
);

-- ===========================
-- 12. inbound_item
-- ===========================
CREATE TABLE `inbound_item` (
    `inbound_item_id` int NOT NULL AUTO_INCREMENT,
    `product_id` varchar(20) NOT NULL,
    `inbound_id` int NOT NULL,
    `quantity` int NOT NULL,
    PRIMARY KEY (`inbound_item_id`),
    CONSTRAINT `FK_Product_TO_inbound_item_1`
        FOREIGN KEY (`product_id`) REFERENCES `Product` (`product_id`),
    CONSTRAINT `FK_inbound_TO_inbound_item_1`
        FOREIGN KEY (`inbound_id`) REFERENCES `inbound` (`inbound_id`)
);

-- ===========================
-- 13. outboundRequest
-- ===========================
CREATE TABLE `outboundRequest` (
    `outboundRequest_ID` int NOT NULL AUTO_INCREMENT,
    `outboundDate` TIMESTAMP NULL,
    `approvedStatus` varchar(100) NULL,
    `outboundAddress` varchar(100) NULL,
    `member_id` bigint NOT NULL,
    `warehouse_id` int NOT NULL,
    `staff_id` bigint NOT NULL,
    `requestedDeliveryDate` TIMESTAMP NULL,
    PRIMARY KEY (`outboundRequest_ID`),
    CONSTRAINT `FK_Member_TO_outboundRequest_1`
        FOREIGN KEY (`member_id`) REFERENCES `Member` (`member_id`),
    CONSTRAINT `FK_WAREHOUSE_TO_outboundRequest_1`
        FOREIGN KEY (`warehouse_id`) REFERENCES `WAREHOUSE` (`warehouse_id`),
    CONSTRAINT `FK_Staff_TO_outboundRequest_1`
        FOREIGN KEY (`staff_id`) REFERENCES `Staff` (`staff_id`)
);

-- ===========================
-- 14. outboundItem
-- ===========================
CREATE TABLE `outboundItem` (
    `outbound_item_id` int NOT NULL AUTO_INCREMENT,
    `outboundRequest_ID` int NOT NULL,
    `Product_ID` varchar(20) NOT NULL,
    `outboundQuantity` int NOT NULL,
    PRIMARY KEY (`outbound_item_id`),
    CONSTRAINT `FK_outboundRequest_TO_outboundItem_1`
        FOREIGN KEY (`outboundRequest_ID`) REFERENCES `outboundRequest` (`outboundRequest_ID`),
    CONSTRAINT `FK_Product_TO_outboundItem_1`
        FOREIGN KEY (`Product_ID`) REFERENCES `Product` (`product_id`)
);

-- ===========================
-- 15. outboundOrder
-- ===========================
CREATE TABLE `outboundOrder` (
    `approvedOrder_ID` int NOT NULL AUTO_INCREMENT,
    `outboundRequest_ID` int NOT NULL,
    `approvedDate` TIMESTAMP NULL,
    `instructionNo` varchar(10) NULL,
    `orderStatus` VARCHAR(20) NULL,
    PRIMARY KEY (`approvedOrder_ID`),
    CONSTRAINT `FK_outboundRequest_TO_outboundOrder_1`
        FOREIGN KEY (`outboundRequest_ID`) REFERENCES `outboundRequest` (`outboundRequest_ID`)
);

-- ===========================
-- 16. dispatch
-- ===========================
CREATE TABLE `dispatch` (
    `dispatch_ID` int NOT NULL AUTO_INCREMENT,
    `approvedOrder_ID` int NOT NULL,
    `carID` int NULL,
    `Cartype` varchar(20) NULL,
    `driverName` varchar(10) NULL,
    `assignedDate` TIMESTAMP NULL,
    `dispatchStatus` varchar(10) NULL,
    `loadedBOX` int NULL,
    `maximumBOX` int NULL,
    PRIMARY KEY (`dispatch_ID`),
    CONSTRAINT `FK_outboundOrder_TO_dispatch_1`
        FOREIGN KEY (`approvedOrder_ID`) REFERENCES `outboundOrder` (`approvedOrder_ID`)
);

-- ===========================
-- 17. waybill
-- ===========================
CREATE TABLE `waybill` (
    `waybill_id` int NOT NULL AUTO_INCREMENT,
    `waybill_number` int NULL,
    `waybill_date` TIMESTAMP NULL,
    `waybill_status` varchar(20) NULL,
    `dispatch_ID` int NOT NULL,
    `departure_Address` varchar(100) NULL,
    `arrival_Address` varchar(100) NULL,
    `sender_Name` varchar(10) NULL,
    `receiver_Name` varchar(10) NULL,
    PRIMARY KEY (`waybill_id`),
    CONSTRAINT `FK_dispatch_TO_waybill_1`
        FOREIGN KEY (`dispatch_ID`) REFERENCES `dispatch` (`dispatch_ID`)
);

-- ===========================
-- 18. QR
-- ===========================
CREATE TABLE `QR` (
    `QR_id` int NOT NULL AUTO_INCREMENT,
    `created_at` timestamp NULL,
    `waybill_id` int NOT NULL,
    PRIMARY KEY (`QR_id`),
    CONSTRAINT `FK_waybill_TO_QR_1`
        FOREIGN KEY (`waybill_id`) REFERENCES `waybill` (`waybill_id`)
);

-- ===========================
-- 19. Product_Stock
-- ===========================
CREATE TABLE `Product_Stock` (
    `ps_id` int NOT NULL AUTO_INCREMENT,
    `warehouse_id` int NOT NULL,
    `section_id` int NOT NULL,
    `inbound_item_id` int NOT NULL,
    `outbound_item_id` int NULL,
    `quantity` int NOT NULL,
    `product_status` varchar(50) NOT NULL,
    `last_updatedate` timestamp NULL,
    PRIMARY KEY (`ps_id`),
    CONSTRAINT `FK_Section_TO_Product_Stock`
        FOREIGN KEY (`section_id`, `warehouse_id`) REFERENCES `Section` (`section_id`, `warehouse_id`),
    CONSTRAINT `FK_inbound_item_TO_Product_Stock_1`
        FOREIGN KEY (`inbound_item_id`) REFERENCES `inbound_item` (`inbound_item_id`),
    CONSTRAINT `FK_outboundItem_TO_Product_Stock_1`
        FOREIGN KEY (`outbound_item_id`) REFERENCES `outboundItem` (`outbound_item_id`)
);

-- ===========================
-- 20. Physical_Inventory
-- ===========================
CREATE TABLE `Physical_Inventory` (
    `piID` int NOT NULL AUTO_INCREMENT,
    `PS_ID` int NOT NULL,
    `pi_date` timestamp NOT NULL,
    `pi_state` varchar(30) NOT NULL,
    `pid_quantity` int NOT NULL,
    `real_quantity` int NULL,
    `different_quantity` int NULL,
    `update_state` varchar(30) NULL,
    PRIMARY KEY (`piID`),
    CONSTRAINT `FK_Product_Stock_TO_Physical_Inventory_1`
        FOREIGN KEY (`PS_ID`) REFERENCES `Product_Stock` (`ps_id`)
);

-- ===========================
-- 21. product_stock_log
-- ===========================
CREATE TABLE `product_stock_log` (
    `log_ID` int NOT NULL AUTO_INCREMENT,
    `PS_ID` int NOT NULL,
    `event_time` timestamp NOT NULL,
    `move_quantity` int NOT NULL,
    `event_type` varchar(20) NOT NULL,
    `product_status` varchar(50) NOT NULL,
    `destination` varchar(30) NOT NULL,
    PRIMARY KEY (`log_ID`),
    CONSTRAINT `FK_Product_Stock_TO_product_stock_log_1`
        FOREIGN KEY (`PS_ID`) REFERENCES `Product_Stock` (`ps_id`)
);

-- ===========================
-- 22. Inquiry
-- ===========================
CREATE TABLE `Inquiry` (
    `inquiry_id` bigint NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `title` varchar(255) NOT NULL,
    `content` varchar(1000) NOT NULL,
    `writer` varchar(255) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `updated_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `status` varchar(20) NOT NULL DEFAULT 'AVAILABLE'
);

-- ===========================
-- 23. Reply
-- ===========================
CREATE TABLE `Reply` (
    `reply_id` bigint NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `inquiry_id` bigint NOT NULL,
    `content` varchar(500) NOT NULL,
    `writer` varchar(255) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `title` varchar(255) NOT NULL,
    CONSTRAINT `FK_Inquiry_TO_Reply_1`
        FOREIGN KEY (`inquiry_id`) REFERENCES `Inquiry` (`inquiry_id`)
);

-- ===========================
-- 24. Announcement
-- ===========================
CREATE TABLE `Announcement` (
    `announcement_id` bigint NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `title` varchar(255) NOT NULL,
    `content` varchar(1000) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `updated_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `status` varchar(20) NOT NULL DEFAULT 'AVAILABLE',
    `writer` varchar(255) NOT NULL,
    `is_important` tinyint NOT NULL DEFAULT 0
);

-- ===========================
-- 25. estimate
-- ===========================
CREATE TABLE `estimate` (
    `estimate_id` BIGINT NOT NULL AUTO_INCREMENT,
    `member_id` bigint NOT NULL,
    `staff_id` bigint NOT NULL,
    `is_guest` tinyint NOT NULL,
    `guest_name` varchar(20) NULL,
    `guest_contact` varchar(20) NULL,
    `guest_email` varchar(40) NULL,
    `estimate_title` varchar(200) NOT NULL,
    `estimate_content` TEXT NOT NULL,
    `estimate_status` varchar(20) NOT NULL DEFAULT 'request',
    `estimate_password` varchar(100) NULL,
    `estimate_response` TEXT NULL,
    `estimate_request_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `estimate_response_at` timestamp NULL,
    PRIMARY KEY (`estimate_id`),
    CONSTRAINT `FK_Member_TO_estimate_1`
        FOREIGN KEY (`member_id`) REFERENCES `Member` (`member_id`),
    CONSTRAINT `FK_Staff_TO_estimate_1`
        FOREIGN KEY (`staff_id`) REFERENCES `Staff` (`staff_id`)
);

-- ===========================
-- 26. Sales
-- ===========================
CREATE TABLE Sales
(
    sales_id       BIGINT AUTO_INCREMENT PRIMARY KEY                               NOT NULL COMMENT '매출 PK',
    sales_code     VARCHAR(50)                                                     NOT NULL COMMENT '매출 관리번호 (예: SAL-202511-00001)',
    warehouse_name VARCHAR(100)                                                    NOT NULL COMMENT '창고명',
    sales_date     DATE                                                            NOT NULL COMMENT '매출일자',
    category       VARCHAR(50)                                                     NULL COMMENT '매출 분류',
    client_name    VARCHAR(100)                                                    NOT NULL COMMENT '고객사명',
    amount         BIGINT                                                          NOT NULL COMMENT '매출 금액',
    description    VARCHAR(255)                                                    NULL COMMENT '상세 설명',
    reg_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP                             NOT NULL COMMENT '등록일시',
    mod_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL COMMENT '수정일시',
    status         VARCHAR(20)                                                     NOT NULL DEFAULT 'ACTIVE' COMMENT '상태 (ACTIVE, DELETED)'
);

-- ===========================
-- 27. Expense
-- ===========================
CREATE TABLE Expense
(
    expense_id     BIGINT AUTO_INCREMENT PRIMARY KEY                               NOT NULL COMMENT '지출 PK',
    expense_code   VARCHAR(50)                                                     NOT NULL COMMENT '지출 관리번호 (예: EXP-202511-00001)',
    warehouse_name VARCHAR(100)                                                    NOT NULL COMMENT '창고명',
    expense_date   DATE                                                            NOT NULL COMMENT '지출일자',
    category       VARCHAR(50)                                                     NULL COMMENT '지출 분류',
    amount         BIGINT                                                          NOT NULL COMMENT '지출 금액',
    description    VARCHAR(255)                                                    NULL COMMENT '상세 설명',
    reg_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP                             NOT NULL COMMENT '등록일시',
    mod_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL COMMENT '수정일시',
    status         VARCHAR(20)                                                     NOT NULL DEFAULT 'ACTIVE' COMMENT '상태 (ACTIVE, DELETED)'

);



-- ===========================
-- 28. Driver
-- ===========================
CREATE TABLE driver (
                        driver_id INT AUTO_INCREMENT PRIMARY KEY,
                        driver_name VARCHAR(30) NOT NULL,
                        car_id INT NOT NULL,
                        car_number VARCHAR(20),
                        car_type VARCHAR(20),
                        status ENUM('대기', '운행중', '휴무') DEFAULT '대기'
);
ALTER TABLE dispatch
    ADD COLUMN driver_id INT,
    ADD CONSTRAINT fk_dispatch_driver
        FOREIGN KEY (driver_id)
            REFERENCES driver(driver_id);
