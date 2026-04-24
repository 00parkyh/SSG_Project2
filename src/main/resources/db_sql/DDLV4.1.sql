-- ===========================
-- 1. Partner
-- ===========================
CREATE TABLE Partner (
    partner_id int NOT NULL AUTO_INCREMENT COMMENT '거래처 고유 ID',
    partner_name VARCHAR(100) NOT NULL COMMENT '예: 나이키, 아디다스 ...',
    business_number VARCHAR(20) NOT NULL,
    address VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT current_timestamp(),
    updated_at TIMESTAMP NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (partner_id)
);

-- ===========================
-- 2. Category
-- ===========================
CREATE TABLE Category (
    category_cd int NOT NULL AUTO_INCREMENT,
    category_name varchar(200) NOT NULL,
    PRIMARY KEY (category_cd)
);

-- ===========================
-- 3. WAREHOUSE

-- ===========================
CREATE TABLE Warehouse (
    warehouse_id int NOT NULL AUTO_INCREMENT COMMENT '창고 고유 식별',
    admin_id int NOT NULL COMMENT '창고관리담당자ID',
    warehouse_name varchar(100) NOT NULL,
    warehouse_type varchar(100) NOT NULL,
    warehouse_capacity int NULL,
    warehouse_status tinyint NOT NULL,
    registration_date date NOT NULL,
    latest_update_date timestamp NOT NULL,
    address varchar(255) NOT NULL,
    latitude decimal(10,7) NOT NULL,
    longitude decimal(10,7) NOT NULL,
    PRIMARY KEY (warehouse_id)
);

-- ===========================
-- 4. Staff
-- ===========================
CREATE TABLE Staff (
    staff_id bigint NOT NULL PRIMARY KEY AUTO_INCREMENT,
    staff_login_id varchar(255) NOT NULL,
    staff_pw varchar(255) NOT NULL,
    staff_name varchar(255) NOT NULL,
    staff_phone varchar(255) NOT NULL,
    staff_email varchar(255) NOT NULL,
    created_at timestamp NOT NULL DEFAULT current_timestamp(),
    updated_at timestamp NOT NULL DEFAULT current_timestamp(),
    status varchar(20) NOT NULL DEFAULT 'ACTIVE',
    role varchar(255) NOT NULL DEFAULT 'MANAGER'
);

-- ===========================
-- 5. Member
-- ===========================
CREATE TABLE Member (
    member_id bigint NOT NULL PRIMARY KEY AUTO_INCREMENT,
    member_login_id varchar(255) NOT NULL,
    member_pw varchar(255) NOT NULL,
    member_name varchar(255) NOT NULL,
    member_phone varchar(255) NOT NULL,
    member_email varchar(255) NOT NULL,
    business_number varchar(20) NOT NULL,
    created_at timestamp NOT NULL DEFAULT current_timestamp(),
    updated_at timestamp NOT NULL DEFAULT current_timestamp(),
    status varchar(20) NOT NULL DEFAULT 'PENDING',
    role varchar(255) NOT NULL DEFAULT 'MEMBER',
    partner_id int NOT NULL,
    CONSTRAINT FK_Partner_TO_Member_1
        FOREIGN KEY (partner_id) REFERENCES Partner (partner_id)
);

-- ===========================
-- 6. Partner_Fee
-- ===========================
CREATE TABLE PartnerFee (
    fee_id int NOT NULL AUTO_INCREMENT,
    partner_id int NOT NULL,
    fee_type VARCHAR(255) NOT NULL,
    price DECIMAL NOT NULL,
    apply_date DATE NULL,
    PRIMARY KEY (fee_id),
    CONSTRAINT FK_Partner_TO_Partner_Fee_1
        FOREIGN KEY (partner_id) REFERENCES Partner (partner_id)
);

-- ===========================
-- 7. PARTNER_CONTRACT
-- ===========================
CREATE TABLE PartnerContract (
    CONTRACT_ID int NOT NULL AUTO_INCREMENT,
    partner_id int NOT NULL,
    CONTRACT_START DATE NULL,
    CONTRACT_AREA DECIMAL NULL,
    CONTRACT_STATUS VARCHAR(255) NOT NULL DEFAULT 'AVAILABLE',
    PRIMARY KEY (CONTRACT_ID),
    CONSTRAINT FK_Partner_TO_PARTNER_CONTRACT_1
        FOREIGN KEY (partner_id) REFERENCES Partner (partner_id)
);

-- ===========================
-- 8. Section
-- ===========================
CREATE TABLE Section (
    section_id int NOT NULL AUTO_INCREMENT,
    warehouse_id int NOT NULL,
    section_name varchar(50) NOT NULL,
    section_type varchar(50) NOT NULL,
    section_purpose text NULL,
    allocated_area int NULL,
    PRIMARY KEY (section_id, warehouse_id),
    CONSTRAINT FK_WAREHOUSE_TO_Section_1
        FOREIGN KEY (warehouse_id) REFERENCES Warehouse (warehouse_id)
);

-- ===========================
-- 9. LOCATION
-- ===========================
CREATE TABLE Location (
    location_id int NOT NULL AUTO_INCREMENT,
    warehouse_id int NOT NULL,
    location_code varchar(100) NOT NULL,
    floor_num int NOT NULL,
    location_type_code varchar(50) NOT NULL,
    max_volume decimal(10,3) NULL,
    PRIMARY KEY (location_id),
    CONSTRAINT FK_WAREHOUSE_TO_LOCATION_1
        FOREIGN KEY (warehouse_id) REFERENCES Warehouse (warehouse_id)
);

-- ===========================
-- 10. Product
-- ===========================
CREATE TABLE Product (
    product_id varchar(20) NOT NULL,
    category_cd int NOT NULL,
    partner_id int NOT NULL,
    product_name varchar(200) NOT NULL,
    product_price BIGINT NULL,
    product_origin varchar(200) NULL,
    PRIMARY KEY (product_id),
    CONSTRAINT FK_category_TO_Product_1
        FOREIGN KEY (category_cd) REFERENCES Category (category_cd),
    CONSTRAINT FK_Partner_TO_Product_1
        FOREIGN KEY (partner_id) REFERENCES Partner (partner_id)
);

-- ===========================
-- 11. Inbound
-- ===========================
CREATE TABLE Inbound (
    inbound_id int NOT NULL AUTO_INCREMENT,
    warehouse_id int NULL,
    staff_id bigint NULL,
    member_id bigint NOT NULL,
    inbound_status varchar(100) NOT NULL DEFAULT 'request',
    inbound_reject_reason varchar(200) NULL,
    inbound_requested_at timestamp NOT NULL DEFAULT current_timestamp(),
    inbound_updated_at timestamp NULL DEFAULT current_timestamp(),
    inbound_at timestamp NULL,
    PRIMARY KEY (inbound_id),
    CONSTRAINT FK_WAREHOUSE_TO_inbound_1
        FOREIGN KEY (warehouse_id) REFERENCES Warehouse (warehouse_id),
    CONSTRAINT FK_Staff_TO_inbound_1
        FOREIGN KEY (staff_id) REFERENCES Staff (staff_id),
    CONSTRAINT FK_Member_TO_inbound_1
        FOREIGN KEY (member_id) REFERENCES Member (member_id)
);

-- ===========================
-- 12. InboundItem
-- ===========================
CREATE TABLE InboundItem (
    inbound_item_id int NOT NULL AUTO_INCREMENT,
    product_id varchar(20) NOT NULL,
    inbound_id int NOT NULL,
    quantity int NOT NULL,
    PRIMARY KEY (inbound_item_id),
    CONSTRAINT FK_Product_TO_inbound_item_1
        FOREIGN KEY (product_id) REFERENCES Product (product_id),
    CONSTRAINT FK_inbound_TO_inbound_item_1
        FOREIGN KEY (inbound_id) REFERENCES Inbound (inbound_id)
);

-- ===========================
-- 13. OutboundRequest
-- ===========================
CREATE TABLE OutboundRequest (
                                 outbound_request_id    INT AUTO_INCREMENT PRIMARY KEY,
                                 outbound_date          TIMESTAMP NULL,
                                 approved_status        VARCHAR(100) NULL,
                                 outbound_address       VARCHAR(100) NULL,
                                 member_id             BIGINT NOT NULL,
                                 warehouse_id          INT NULL,
                                 staff_id              BIGINT NULL,
                                 requested_delivery_date TIMESTAMP NULL,
                                 CONSTRAINT FK_Member_TO_outboundRequest_1
                                     FOREIGN KEY (member_id) REFERENCES Member (member_id),
                                 CONSTRAINT FK_Staff_TO_outboundRequest_1
                                     FOREIGN KEY (staff_id) REFERENCES Staff (staff_id),
                                 CONSTRAINT FK_WAREHOUSE_TO_outboundRequest_1
                                     FOREIGN KEY (warehouse_id) REFERENCES Warehouse (warehouse_id)
);


-- ===========================
-- 14. OutboundItem
-- ===========================
CREATE TABLE OutboundItem (
    outbound_item_id int NOT NULL AUTO_INCREMENT,
    outbound_request_id int NOT NULL,
    product_id varchar(20) NOT NULL,
    outbound_quantity int NOT NULL,
    PRIMARY KEY (outbound_item_id),
    CONSTRAINT FK_outbound_request_to_outbound_item_1
        FOREIGN KEY (outbound_request_id) REFERENCES OutboundRequest (outbound_request_id),
    CONSTRAINT FK_Product_TO_outboundItem_1
        FOREIGN KEY (product_id) REFERENCES Product (product_id)
);

-- ===========================
-- 15. OutboundOrder
-- ===========================
CREATE TABLE OutboundOrder (
    approved_order_id int NOT NULL AUTO_INCREMENT,
    outbound_request_id int NOT NULL,
    approved_date TIMESTAMP NULL,
    instruction_no varchar(10) NULL,
    order_status VARCHAR(20) NULL,
    PRIMARY KEY (approved_order_id),
    CONSTRAINT FK_outboundRequest_to_outboundOrder_1
        FOREIGN KEY (outbound_request_id) REFERENCES OutboundRequest (outbound_request_id)
);

-- ===========================
-- 16. Driver
-- ===========================
CREATE TABLE Driver (
                        driver_id INT AUTO_INCREMENT PRIMARY KEY,
                        driver_name VARCHAR(30) NOT NULL,
                        car_id INT NOT NULL,
                        car_number VARCHAR(20),
                        car_type VARCHAR(20),
                        status ENUM('대기', '운행중', '휴무') DEFAULT '대기'
);

-- ===========================
-- 17. dispatch
-- ===========================
CREATE TABLE Dispatch (
                          dispatch_id      INT AUTO_INCREMENT PRIMARY KEY,
                          approved_order_id INT NOT NULL,
                          car_id            INT NULL,
                          car_type          VARCHAR(20) NULL,
                          driver_name       VARCHAR(10) NULL,
                          assigned_date     TIMESTAMP NULL,
                          dispatch_status   VARCHAR(10) NULL,
                          loaded_box        INT NULL,
                          maximum_box       INT NULL,
                          driver_id         INT NULL,
                          CONSTRAINT FK_outboundOrder_to_dispatch_1
                              FOREIGN KEY (approved_order_id) REFERENCES OutboundOrder (approved_order_id),
                          CONSTRAINT fk_dispatch_driver
                              FOREIGN KEY (driver_id) REFERENCES Driver (driver_id)
);


-- ===========================
-- 18. waybill
-- ===========================
CREATE TABLE Waybill (
                         waybill_id        INT AUTO_INCREMENT PRIMARY KEY,
                         waybill_number    VARCHAR(50) NULL,
                         waybill_date      TIMESTAMP NULL,
                         waybill_status    VARCHAR(20) NULL,
                         dispatch_id       INT NOT NULL,
                         departure_address VARCHAR(100) NULL,
                         arrival_address   VARCHAR(100) NULL,
                         sender_name       VARCHAR(10) NULL,
                         receiver_name     VARCHAR(10) NULL,
                         CONSTRAINT FK_dispatch_TO_waybill_1
                             FOREIGN KEY (dispatch_id) REFERENCES Dispatch (dispatch_id)
);


-- ===========================
-- 19. QR
-- ===========================
CREATE TABLE Qr (
    qr_id int NOT NULL AUTO_INCREMENT,
    created_at timestamp NULL,
    waybill_id int NOT NULL,
    PRIMARY KEY (qr_id),
    CONSTRAINT FK_waybill_to_qr_1
        FOREIGN KEY (waybill_id) REFERENCES Waybill (waybill_id)
);

-- ===========================
-- 20. Product_Stock
-- ===========================
CREATE TABLE ProductStock (
    ps_id int NOT NULL AUTO_INCREMENT,
    warehouse_id int NOT NULL,
    section_id int NOT NULL,
    inbound_item_id int NOT NULL,
    outbound_item_id int NULL,
    quantity int NOT NULL,
    product_status varchar(50) NOT NULL,
    last_update_date timestamp NULL,
    PRIMARY KEY (ps_id),
    CONSTRAINT FK_Section_to_product_stock
        FOREIGN KEY (section_id, warehouse_id) REFERENCES Section (section_id, warehouse_id),
    CONSTRAINT FK_inbound_item_to_product_stock_1
        FOREIGN KEY (inbound_item_id) REFERENCES InboundItem (inbound_item_id),
    CONSTRAINT FK_outboundItem_to_product_stock_1
        FOREIGN KEY (outbound_item_id) REFERENCES OutboundItem (outbound_item_id)
);

-- ===========================
-- 21. Physical_Inventory
-- ===========================
CREATE TABLE PhysicalInventory (
    pi_id int NOT NULL AUTO_INCREMENT,
    ps_id int NOT NULL,
    pi_date timestamp NOT NULL,
    pi_state varchar(30) NOT NULL,
    pid_quantity int NOT NULL,
    real_quantity int NULL,
    different_quantity int NULL,
    update_state varchar(30) NULL,
    PRIMARY KEY (pi_id),
    CONSTRAINT FK_Product_Stock_TO_Physical_Inventory_1
        FOREIGN KEY (ps_id) REFERENCES ProductStock (ps_id)
);

-- ===========================
-- 22. product_stock_log
-- ===========================
CREATE TABLE ProductStockLog (
    log_id int NOT NULL AUTO_INCREMENT,
    ps_id int NOT NULL,
    event_time timestamp NOT NULL,
    move_quantity int NOT NULL,
    event_type varchar(20) NOT NULL,
    product_status varchar(50) NOT NULL,
    destination varchar(30) NOT NULL,
    PRIMARY KEY (log_id),
    CONSTRAINT FK_Product_Stock_TO_product_stock_log_1
        FOREIGN KEY (ps_id) REFERENCES ProductStock (ps_id)
);

-- ===========================
-- 23. Inquiry
-- ===========================
CREATE TABLE Inquiry (
    inquiry_id bigint NOT NULL PRIMARY KEY AUTO_INCREMENT,
    title varchar(255) NOT NULL,
    content varchar(1000) NOT NULL,
    writer varchar(255) NOT NULL,
    created_at timestamp NOT NULL DEFAULT current_timestamp(),
    updated_at timestamp NOT NULL DEFAULT current_timestamp(),
    status varchar(20) NOT NULL DEFAULT 'AVAILABLE',
    inquiry_pwd varchar(30) not null
);

-- ===========================
-- 24. Reply
-- ===========================
CREATE TABLE Reply (
    reply_id bigint NOT NULL PRIMARY KEY AUTO_INCREMENT,
    inquiry_id bigint NOT NULL,
    content varchar(500) NOT NULL,
    writer varchar(255) NOT NULL,
    created_at timestamp NOT NULL DEFAULT current_timestamp(),
    title varchar(255),
    CONSTRAINT FK_Inquiry_TO_Reply_1
        FOREIGN KEY (inquiry_id) REFERENCES Inquiry (inquiry_id)
);

-- ===========================
-- 25. Announcement
-- ===========================
CREATE TABLE Announcement (
    announcement_id bigint NOT NULL PRIMARY KEY AUTO_INCREMENT,
    title varchar(255) NOT NULL,
    content varchar(1000) NOT NULL,
    created_at timestamp NOT NULL DEFAULT current_timestamp(),
    updated_at timestamp NOT NULL DEFAULT current_timestamp(),
    status varchar(20) NOT NULL DEFAULT 'AVAILABLE',
    writer varchar(255) NOT NULL,
    is_important tinyint NOT NULL DEFAULT 0
);

-- ===========================
-- 26. estimate
-- ===========================
CREATE TABLE Estimate (
    estimate_id BIGINT NOT NULL AUTO_INCREMENT,
    member_id bigint NOT NULL,
    staff_id bigint NOT NULL,
    is_guest tinyint NOT NULL,
    guest_name varchar(20) NULL,
    guest_contact varchar(20) NULL,
    guest_email varchar(40) NULL,
    estimate_title varchar(200) NOT NULL,
    estimate_content TEXT NOT NULL,
    estimate_status varchar(20) NOT NULL DEFAULT 'request',
    estimate_password varchar(100) NULL,
    estimate_response TEXT NULL,
    estimate_request_at timestamp NOT NULL DEFAULT current_timestamp(),
    estimate_response_at timestamp NULL,
    PRIMARY KEY (estimate_id),
    CONSTRAINT FK_Member_TO_estimate_1
        FOREIGN KEY (member_id) REFERENCES Member (member_id),
    CONSTRAINT FK_Staff_TO_estimate_1
        FOREIGN KEY (staff_id) REFERENCES Staff (staff_id)
);

-- ===========================
-- 27. Sales
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
-- 28. Expense
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


