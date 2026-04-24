-- Trigger definitions aligned with DDLV4.1.sql

DELIMITER $$

CREATE TRIGGER `trg_after_inbound_approve_insert_stock_auto`
BEFORE UPDATE ON `Inbound`
FOR EACH ROW
BEGIN
    DECLARE selected_section_id INT;

    IF OLD.inbound_status = 'request'
       AND NEW.inbound_status = 'approved'
       AND NEW.warehouse_id IS NOT NULL THEN

        SELECT s.section_id
          INTO selected_section_id
          FROM Section s
          LEFT JOIN ProductStock ps
            ON s.section_id = ps.section_id
           AND s.warehouse_id = ps.warehouse_id
         WHERE s.warehouse_id = NEW.warehouse_id
         GROUP BY s.section_id
         ORDER BY COALESCE(SUM(ps.quantity), 0) ASC
         LIMIT 1;

        IF selected_section_id IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '선택한 창고에 사용 가능한 섹션이 없습니다.';
        END IF;

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
            NEW.warehouse_id,
            selected_section_id,
            ii.inbound_item_id,
            NULL,
            ii.quantity,
            'IN_STOCK',
            NOW()
        FROM InboundItem ii
        WHERE ii.inbound_id = NEW.inbound_id;

    END IF;
END$$

DELIMITER ;

DELIMITER //

CREATE TRIGGER `trg_after_outbound_approve_update_stock`
AFTER UPDATE ON `OutboundRequest`
FOR EACH ROW
BEGIN
    DECLARE v_quantity_to_process INT;
    DECLARE v_ps_id INT;
    DECLARE v_stock_quantity INT;
    DECLARE v_outbound_item_id INT;
    DECLARE v_product_id VARCHAR(20);
    DECLARE v_outbound_quantity INT;
    DECLARE done_outer BOOLEAN DEFAULT FALSE;

    DECLARE cur_outbound_item CURSOR FOR
        SELECT outbound_item_id, product_id, outbound_quantity
        FROM OutboundItem
        WHERE outbound_request_id = NEW.outbound_request_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done_outer = TRUE;

    IF OLD.approved_status = 'PENDING' AND NEW.approved_status = 'approved' THEN

        OPEN cur_outbound_item;

        read_loop: LOOP
            FETCH cur_outbound_item INTO v_outbound_item_id, v_product_id, v_outbound_quantity;

            IF done_outer THEN
                LEAVE read_loop;
            END IF;

            SET v_quantity_to_process = v_outbound_quantity;

            stock_loop: LOOP
                SET v_ps_id = NULL;

                SELECT ps.ps_id, ps.quantity
                  INTO v_ps_id, v_stock_quantity
                  FROM ProductStock ps
                  JOIN InboundItem ii
                    ON ps.inbound_item_id = ii.inbound_item_id
                 WHERE ps.outbound_item_id IS NULL
                   AND ps.warehouse_id = NEW.warehouse_id
                   AND ii.product_id = v_product_id
                   AND ps.quantity > 0
                 ORDER BY ii.inbound_item_id ASC
                 LIMIT 1;

                IF v_ps_id IS NULL OR v_quantity_to_process <= 0 THEN
                    LEAVE stock_loop;
                END IF;

                IF v_stock_quantity >= v_quantity_to_process THEN
                    UPDATE ProductStock
                       SET quantity = quantity - v_quantity_to_process,
                           outbound_item_id = v_outbound_item_id,
                           last_update_date = NOW(),
                           product_status = 'OUT_PROGRESS'
                     WHERE ps_id = v_ps_id;

                    SET v_quantity_to_process = 0;

                ELSE
                    UPDATE ProductStock
                       SET quantity = 0,
                           outbound_item_id = v_outbound_item_id,
                           last_update_date = NOW(),
                           product_status = 'OUT_PROGRESS'
                     WHERE ps_id = v_ps_id;

                    SET v_quantity_to_process = v_quantity_to_process - v_stock_quantity;
                END IF;

            END LOOP stock_loop;
        END LOOP read_loop;

        CLOSE cur_outbound_item;
    END IF;
END //

DELIMITER ;

DELIMITER $$

CREATE TRIGGER `trg_after_product_stock_insert_log`
AFTER INSERT ON `ProductStock`
FOR EACH ROW
BEGIN
    IF NEW.outbound_item_id IS NULL AND NEW.product_status = 'IN_STOCK' THEN
        INSERT INTO ProductStockLog (
            ps_id,
            event_time,
            move_quantity,
            event_type,
            product_status,
            destination
        )
        VALUES (
            NEW.ps_id,
            NOW(),
            NEW.quantity,
            '입고',
            NEW.product_status,
            '창고 섹션'
        );
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER `trg_after_product_stock_update_log`
AFTER UPDATE ON `ProductStock`
FOR EACH ROW
BEGIN
    DECLARE quantity_moved INT;

    IF OLD.outbound_item_id IS NULL AND NEW.outbound_item_id IS NOT NULL THEN
        SET quantity_moved = OLD.quantity - NEW.quantity;

        IF quantity_moved > 0 THEN
            INSERT INTO ProductStockLog (
                ps_id,
                event_time,
                move_quantity,
                event_type,
                product_status,
                destination
            )
            VALUES (
                NEW.ps_id,
                NOW(),
                -quantity_moved,
                '출고',
                NEW.product_status,
                (
                    SELECT outbound_address
                    FROM OutboundRequest
                    WHERE outbound_request_id = (
                        SELECT outbound_request_id
                        FROM OutboundItem
                        WHERE outbound_item_id = NEW.outbound_item_id
                    )
                )
            );
        END IF;
    END IF;
END$$

DELIMITER ;
