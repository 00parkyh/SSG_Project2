
create table category
(
    category_cd   int auto_increment
        primary key,
    category_name varchar(200) not null
);


create table driver
(
    driver_id   int auto_increment
        primary key,
    driver_name varchar(30)                           not null,
    car_id      int                                   not null,
    car_number  varchar(20)                           null,
    car_type    varchar(20)                           null,
    status      enum ('대기', '운행중', '휴무') default '대기' null
);

create table outboundRequest
(
    outboundRequest_ID    int auto_increment
        primary key,
    outboundDate          timestamp    null,
    approvedStatus        varchar(100) null,
    outboundAddress       varchar(100) null,
    member_id             bigint       not null,
    warehouse_id          int          null,
    staff_id              bigint       null,
    requestedDeliveryDate timestamp    null,
    constraint FK_Member_TO_outboundRequest_1
        foreign key (member_id) references Member (member_id),
    constraint FK_Staff_TO_outboundRequest_1
        foreign key (staff_id) references Staff (staff_id),
    constraint FK_WAREHOUSE_TO_outboundRequest_1
        foreign key (warehouse_id) references WAREHOUSE (warehouse_id)
);

create table outboundItem
(
    outbound_item_id   int auto_increment
        primary key,
    outboundRequest_ID int         not null,
    Product_ID         varchar(20) not null,
    outboundQuantity   int         not null,
    constraint FK_Product_TO_outboundItem_1
        foreign key (Product_ID) references Product (product_id),
    constraint FK_outboundRequest_TO_outboundItem_1
        foreign key (outboundRequest_ID) references outboundRequest (outboundRequest_ID)
);

create table outboundOrder
(
    approvedOrder_ID   int auto_increment
        primary key,
    outboundRequest_ID int         not null,
    approvedDate       timestamp   null,
    instructionNo      varchar(10) null,
    orderStatus        varchar(20) null,
    constraint FK_outboundRequest_TO_outboundOrder_1
        foreign key (outboundRequest_ID) references outboundRequest (outboundRequest_ID)
);

create table dispatch
(
    dispatch_ID      int auto_increment
        primary key,
    approvedOrder_ID int         not null,
    carID            int         null,
    Cartype          varchar(20) null,
    driverName       varchar(10) null,
    assignedDate     timestamp   null,
    dispatchStatus   varchar(10) null,
    loadedBOX        int         null,
    maximumBOX       int         null,
    driver_id        int         null,
    constraint FK_outboundOrder_TO_dispatch_1
        foreign key (approvedOrder_ID) references outboundOrder (approvedOrder_ID),
    constraint fk_dispatch_driver
        foreign key (driver_id) references driver (driver_id)
);

create table waybill
(
    waybill_id        int auto_increment
        primary key,
    waybill_number    varchar(50)  null,
    waybill_date      timestamp    null,
    waybill_status    varchar(20)  null,
    dispatch_ID       int          not null,
    departure_Address varchar(100) null,
    arrival_Address   varchar(100) null,
    sender_Name       varchar(10)  null,
    receiver_Name     varchar(10)  null,
    constraint FK_dispatch_TO_waybill_1
        foreign key (dispatch_ID) references dispatch (dispatch_ID)
);

create table QR
(
    QR_id      int auto_increment
        primary key,
    created_at timestamp null,
    waybill_id int       not null,
    constraint FK_waybill_TO_QR_1
        foreign key (waybill_id) references waybill (waybill_id)
);



ALTER TABLE dispatch
    ADD COLUMN driver_id INT,
    ADD CONSTRAINT fk_dispatch_driver
        FOREIGN KEY (driver_id)
            REFERENCES driver(driver_id);




-- 카테고리 (category)
CREATE TABLE `category` (
                            `category_cd` int NOT NULL AUTO_INCREMENT,
                            `category_name` varchar(200) NOT NULL,
                            PRIMARY KEY (`category_cd`)
);

CREATE TABLE `Partner` (
                           `partner_id` int NOT NULL AUTO_INCREMENT COMMENT '거래처 고유 ID',
                           `partner_name` VARCHAR(100) NOT NULL COMMENT '예: 나이키, 아디다스 ...',
                           `business_number` VARCHAR(20) NOT NULL,
                           `address` VARCHAR(255) NOT NULL,
                           `created_at` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
                           `updated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
                           PRIMARY KEY (`partner_id`)
);

-- 직원 (Staff)
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


-- 창고 (WAREHOUSE) - Staff 참조 (★위도, 경도 포함)
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

-- 고객 (Member) - Partner 참조
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

-- 출고요청 (outboundRequest) - Member, WAREHOUSE, Staff 참조
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



-- 출고품목 (outboundItem) - outboundRequest, Product 참조
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

-- 출고지시서 (shipmentOrder) - outboundRequest 참조
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


-- 배차 (dispatch) - shipmentOrder 참조
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





-- 운송장 (waybill) - dispatch 참조
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


-- QR (QR) - waybill 참조
CREATE TABLE `QR` (
                      `QR_id` int NOT NULL AUTO_INCREMENT,
                      `created_at` timestamp NULL,
                      `waybill_id` int NOT NULL,
                      PRIMARY KEY (`QR_id`),
                      CONSTRAINT `FK_waybill_TO_QR_1`
                          FOREIGN KEY (`waybill_id`) REFERENCES `waybill` (`waybill_id`)
);








INSERT INTO category (category_cd, category_name) VALUES
                                                      (1, '의류'),
                                                      (2, '신발'),
                                                      (3, '가방');

INSERT INTO Partner (partner_id, partner_name, business_number, address, created_at, updated_at) VALUES
                                                                                                     (1, '나이키', '123-45-67890', '서울시 강남구', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
                                                                                                     (2, '아디다스', '987-65-43210', '서울시 서초구', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());







INSERT INTO Member (member_login_id, member_pw, member_name, member_phone, member_email, partner_id)
VALUES
    ('user1', 'pw1', '홍길동', '010-3333-3333', 'user1@test.com', 1),
    ('user2', 'pw2', '김철수', '010-4444-4444', 'user2@test.com', 2);



INSERT INTO Staff (staff_pw, staff_name, staff_phone, staff_email, status, role, staff_login_id)
VALUES
    ('pw1', '관리자A', '010-1111-1111', 'adminA@ssg.com', 'ACTIVE', 'MANAGER', 'adminA'),
    ('pw2', '관리자B', '010-2222-2222', 'adminB@ssg.com', 'ACTIVE', 'MANAGER', 'adminB');




INSERT INTO WAREHOUSE (admin_id, name, warehouse_type, warehouse_capacity, warehouse_status, registration_date, latest_update_date, address, latitude, longitude)
VALUES
    (1, '서울창고', '일반창고', 1000, 1, CURRENT_DATE(), CURRENT_TIMESTAMP(), '서울시 강남구 물류단지', 37.4979, 127.0276),
    (2, '부산창고', '냉동창고', 800, 1, CURRENT_DATE(), CURRENT_TIMESTAMP(), '부산시 해운대구 물류단지', 35.1631, 129.1635);


INSERT INTO Partner (partner_name, business_number, address)
VALUES
    ('나이키', '123-45-67890', '서울시 강남구'),
    ('아디다스', '987-65-43210', '부산시 해운대구');






INSERT INTO Product (product_id, category_cd, partner_id, product_name, product_price) VALUES
                                                                                           ('P001', 1, 1, '운동화', 100000),
                                                                                           ('P002', 2, 2, '러닝화', 120000),
                                                                                           ('P003', 3, 1, '백팩', 50000);


INSERT INTO outboundRequest (outboundRequest_ID, outboundDate, approvedStatus, outboundAddress, member_id, warehouse_id, staff_id, requestedDeliveryDate) VALUES
                                                                                                                                                              (1, CURRENT_TIMESTAMP(), 'APPROVED', '서울시 강남구', 1, 1, 1, CURRENT_TIMESTAMP()),
                                                                                                                                                              (2, CURRENT_TIMESTAMP(), 'PENDING', '부산시 해운대구', 2, 2, 2, CURRENT_TIMESTAMP());




INSERT INTO outboundItem (outbound_item_id, outboundRequest_ID, Product_ID, outboundQuantity) VALUES
                                                                                                  (1, 1, 'P001', 10),
                                                                                                  (2, 1, 'P003', 5),
                                                                                                  (3, 2, 'P002', 20);


INSERT INTO outboundOrder (approvedOrder_ID, outboundRequest_ID, approvedDate, instructionNo, orderStatus) VALUES
                                                                                                               (1, 1, CURRENT_TIMESTAMP(), 'IN001', 'APPROVED'),
                                                                                                               (2, 2, NULL, 'IN002', 'PENDING');




INSERT INTO dispatch (dispatch_ID, approvedOrder_ID, carID, Cartype, driverName, assignedDate, dispatchStatus, loadedBOX, maximumBOX) VALUES
                                                                                                                                          (1, 1, 101, '트럭', '박운전', CURRENT_TIMESTAMP(), 'ASSIGNED', 50, 100),
                                                                                                                                          (2, 2, 102, '밴', '김운전', NULL, 'PENDING', 0, 50);



INSERT INTO waybill (waybill_id, waybill_number, waybill_date, waybill_status, dispatch_ID, departure_Address, arrival_Address, sender_Name, receiver_Name) VALUES
                                                                                                                                                                (1, 1001, CURRENT_TIMESTAMP(), 'IN_TRANSIT', 1, '서울창고', '서울시 강남구', '홍길동', '김영희'),

                                                                                                                                                                (2, 1002, CURRENT_TIMESTAMP(), 'PENDING', 2, '부산창고', '부산시 해운대구', '김철수', '이민수');



ALTER TABLE waybill MODIFY waybill_number VARCHAR(50);
ALTER TABLE outboundRequest MODIFY warehouse_id int NULL;
ALTER TABLE outboundRequest MODIFY staff_id BIGINT NULL;






-- 출고요청 테이블 (sr)
select sr.outboundRequest_ID, sr.outboundDate, sr.approvedStatus, sr.outboundAddress,
       sr.member_Id, sr.warehouse_Id, sr.staff_Id,

       -- 출고품목 테이블 (si)
       si.outbound_item_id, si.product_Id, si.outboundQuantity

from outboundRequest sr
         inner join outboundItem si
                    on sr.outboundRequest_ID = si.outboundRequest_ID
where si.outboundRequest_ID = 1
  and sr.member_Id = 1;



ALTER TABLE dispatch
    MODIFY COLUMN dispatch_ID BIGINT AUTO_INCREMENT;

SELECT
    -- 1. 출고요청 테이블 (sr)
    sr.outboundRequest_ID,
    sr.outboundDate,
    sr.approvedStatus,
    sr.outboundAddress,
    sr.requestedDeliveryDate,  -- 출고희망일 포함

    -- 2. 출고품목 테이블 (si)
    si.outbound_item_id,
    si.outboundQuantity,

    -- 3. 상품 테이블 (p)
    p.product_name,

    -- 4. 카테고리 테이블 (c)
    c.category_name,

    -- 5. 고객 테이블 (m)
    m.member_name,

    -- 6. 직원 테이블 (st)
    st.staff_name

FROM
    outboundRequest sr

-- 품목 정보 조인
        INNER JOIN
    outboundItem si
    ON sr.outboundRequest_ID = si.outboundRequest_ID

-- 상품 정보 조인
        INNER JOIN
    product p
    ON si.product_Id = p.product_id

-- 카테고리 정보 조인
        INNER JOIN
    Category c
    ON p.category_cd = c.category_cd

-- 고객 이름 조인
        INNER JOIN
    member m
    ON sr.member_id = m.member_id

-- 직원 이름 조인
        INNER JOIN
    staff st
    ON sr.staff_Id = st.staff_id

WHERE
    sr.outboundRequest_ID = 101   -- 예시: shipmentId 값
  AND
    sr.member_Id = 1;           -- 예시: userId 값










-- 출고지시서
SELECT
    so.approvedOrder_ID,             -- 1. 출고지시서 번호
    sr.outboundRequest_ID,          -- 2. 출고요청 ID
    sr.outboundDate,                -- 3. 출고 요청일
    sr.approvedStatus,              -- 4. 출고 상태
    Pt.partner_name,                -- 5. 거래처 이름
    Pd.product_name                 -- 6. 대표 상품 이름
FROM
    outboundOrder so
        INNER JOIN
    outboundRequest sr
    ON so.outboundRequest_ID = sr.outboundRequest_ID
        INNER JOIN
    outboundItem si
    ON sr.outboundRequest_ID = si.outboundRequest_ID
        INNER JOIN
    Product Pd
    ON si.Product_ID = Pd.product_id
        INNER JOIN
    Partner Pt
    ON Pd.partner_id = Pt.partner_id
        INNER JOIN
    Member M
    ON Pt.partner_id = M.partner_id -- ★ Partner와 Member의 연결 (Partner.id = Member.partner_id)
WHERE
    sr.outboundRequest_ID = 101     -- 특정 출고요청 ID 필터
  AND so.approvedOrder_ID = 1      -- 특정 출고지시서 ID 필터
GROUP BY
    so.approvedOrder_ID, Pd.product_name;




select * from outboundOrder;

SELECT
    -- Outbound Order 정보
    ob.orderStatus AS 요청상태,
    ob.approvedDate AS 승인일자,

    -- Dispatch 정보 (차량 및 배차)
    d.dispatch_ID AS 배차ID,
    d.driverName AS 기사이름,
    d.Cartype AS 차량종류,
    d.carID AS 차량번호,
    d.dispatchStatus AS 배차상태,
    d.maximumBOX AS 최대적재량,

    -- Waybill 정보 (운송장)
    w.waybill_number AS 운송장번호,
    w.waybill_status AS 운송장상태

FROM outboundOrder ob
-- Dispatch 테이블 연결 (FK: approvedOrder_ID)
         LEFT JOIN dispatch d ON ob.approvedOrder_ID = d.approvedOrder_ID
-- Waybill 테이블 연결 (FK: dispatch_ID)
         LEFT JOIN waybill w ON d.dispatch_ID = w.dispatch_ID
-- 우리가 업데이트한 ID를 조건으로 사용
WHERE ob.approvedOrder_ID = 1;



SELECT driverName, Cartype, dispatchStatus, carID
FROM dispatch
WHERE approvedOrder_ID = 1;


SELECT dispatch_ID, waybill_number, waybill_status
FROM waybill
WHERE dispatch_ID = 3;
-- 이 쿼리로 'WB-' 번호가 정상적으로 등록되었는지 확인합니다.


SELECT
    -- 1. Waybill 테이블 기본 정보
    w.waybill_id            AS "운송장아이디",
    w.waybill_number        AS "운송장고유번호",
    w.waybill_date          AS "운송장생성일자",
    w.departure_Address     AS "출발지주소",
    w.arrival_Address       AS "도착지주소",
    w.sender_Name           AS "발송인이름",
    w.receiver_Name         AS "수신자이름",

    -- 2. Dispatch 테이블에서 JOIN된 정보
    d.driverName            AS "차량기사이름",
    d.loadedBOX             AS "적재된박스개수"

FROM waybill w
-- dispatch 테이블과 dispatch_ID를 기준으로 JOIN
         LEFT JOIN dispatch d ON w.dispatch_ID = d.dispatch_ID
-- 방금 수정했던 운송장 ID (PK)를 기준으로 필터링
WHERE w.waybill_id = 11;




