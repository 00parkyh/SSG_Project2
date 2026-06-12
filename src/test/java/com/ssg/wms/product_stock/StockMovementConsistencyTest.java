package com.ssg.wms.product_stock;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = "file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Transactional
public class StockMovementConsistencyTest {

    private static final List<String> ALL_PRODUCTS = Arrays.asList("NK-JK-01", "NK-JK-02", "NK-HD-03", "NK-HD-04");
    private static final List<String> TRANSFER_PRODUCTS = Arrays.asList("NK-JK-01", "NK-HD-03");

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public void setDataSource(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Test
    public void shouldKeepStockConsistentWhenMovingNikeProductsBetweenWarehouses() {
        long capitalWarehouseId = findWarehouseIdByName("수도권");
        long yeongnamWarehouseId = findWarehouseIdByName("영남");

        cleanupProductStock(yeongnamWarehouseId, ALL_PRODUCTS);

        for (String productId : ALL_PRODUCTS) {
            assertEquals(0, getStockQuantity(yeongnamWarehouseId, productId));
        }

        Map<String, Integer> capitalInitialStock = getStockSnapshot(capitalWarehouseId, ALL_PRODUCTS);
        Map<String, Integer> yeongnamInitialStock = getStockSnapshot(yeongnamWarehouseId, ALL_PRODUCTS);

        for (String productId : ALL_PRODUCTS) {
            moveFromExternalSourceToWarehouse("인천항", capitalWarehouseId, productId, 2000, 200);
        }

        assertMovementLimit("EXT_INBOUND", "인천항", 200, 40);

        for (String productId : ALL_PRODUCTS) {
            assertEquals(capitalInitialStock.get(productId) + 2000, getStockQuantity(capitalWarehouseId, productId));
        }

        for (String productId : TRANSFER_PRODUCTS) {
            moveBetweenWarehouses(capitalWarehouseId, yeongnamWarehouseId, productId, 1000, 100);
        }

        assertMovementLimitAndTotal("TRANSFER_OUT", "영남 스포츠웨어센터", 100, 2000);
        assertMovementLimit("TRANSFER_IN", "수도권 통합 의류센터", 100, 20);

        assertEquals(capitalInitialStock.get("NK-JK-01") + 1000, getStockQuantity(capitalWarehouseId, "NK-JK-01"));
        assertEquals(capitalInitialStock.get("NK-JK-02") + 2000, getStockQuantity(capitalWarehouseId, "NK-JK-02"));
        assertEquals(capitalInitialStock.get("NK-HD-03") + 1000, getStockQuantity(capitalWarehouseId, "NK-HD-03"));
        assertEquals(capitalInitialStock.get("NK-HD-04") + 2000, getStockQuantity(capitalWarehouseId, "NK-HD-04"));

        assertEquals(yeongnamInitialStock.get("NK-JK-01") + 1000, getStockQuantity(yeongnamWarehouseId, "NK-JK-01"));
        assertEquals(yeongnamInitialStock.get("NK-HD-03") + 1000, getStockQuantity(yeongnamWarehouseId, "NK-HD-03"));
        assertEquals(0, getStockQuantity(yeongnamWarehouseId, "NK-JK-02"));
        assertEquals(0, getStockQuantity(yeongnamWarehouseId, "NK-HD-04"));

        int capitalBeforeInvalidTransfer = getStockQuantity(capitalWarehouseId, "NK-JK-01");
        int yeongnamBeforeInvalidTransfer = getStockQuantity(yeongnamWarehouseId, "NK-JK-01");

        assertThrows(IllegalArgumentException.class,
                () -> moveBetweenWarehouses(capitalWarehouseId, yeongnamWarehouseId, "NK-JK-01", 101, 100));

        assertEquals(capitalBeforeInvalidTransfer, getStockQuantity(capitalWarehouseId, "NK-JK-01"));
        assertEquals(yeongnamBeforeInvalidTransfer, getStockQuantity(yeongnamWarehouseId, "NK-JK-01"));
    }

    private void moveFromExternalSourceToWarehouse(String sourceName, long warehouseId, String productId, int totalQuantity, int maxMoveQuantity) {
        validateMoveQuantity(totalQuantity, maxMoveQuantity);

        int remainingQuantity = totalQuantity;
        while (remainingQuantity > 0) {
            int moveQuantity = Math.min(remainingQuantity, maxMoveQuantity);
            long inboundItemId = createInboundItem(warehouseId, productId, moveQuantity);
            long stockId = createProductStock(warehouseId, productId, inboundItemId, moveQuantity);
            insertStockLog(stockId, moveQuantity, "EXT_INBOUND", "IN_STOCK", sourceName);
            remainingQuantity -= moveQuantity;
        }
    }

    private void moveBetweenWarehouses(long sourceWarehouseId, long targetWarehouseId, String productId, int totalQuantity, int maxMoveQuantity) {
        validateMoveQuantity(totalQuantity, maxMoveQuantity);
        if (getStockQuantity(sourceWarehouseId, productId) < totalQuantity) {
            throw new IllegalStateException("Insufficient stock");
        }

        String targetWarehouseName = findWarehouseName(targetWarehouseId);
        String sourceWarehouseName = findWarehouseName(sourceWarehouseId);

        int remainingQuantity = totalQuantity;
        while (remainingQuantity > 0) {
            int moveQuantity = Math.min(remainingQuantity, maxMoveQuantity);
            decreaseSourceStock(sourceWarehouseId, productId, moveQuantity, targetWarehouseName);

            long inboundItemId = createInboundItem(targetWarehouseId, productId, moveQuantity);
            long stockId = createProductStock(targetWarehouseId, productId, inboundItemId, moveQuantity);
            insertStockLog(stockId, moveQuantity, "TRANSFER_IN", "IN_STOCK", sourceWarehouseName);

            remainingQuantity -= moveQuantity;
        }
    }

    private void validateMoveQuantity(int totalQuantity, int maxMoveQuantity) {
        if (totalQuantity > maxMoveQuantity && totalQuantity % maxMoveQuantity != 0) {
            throw new IllegalArgumentException("Move quantity must be split by maxMoveQuantity");
        }
        if (totalQuantity <= 0 || maxMoveQuantity <= 0) {
            throw new IllegalArgumentException("Quantity must be positive");
        }
        if (totalQuantity <= maxMoveQuantity) {
            return;
        }
    }

    private void decreaseSourceStock(long warehouseId, String productId, int moveQuantity, String destination) {
        List<Map<String, Object>> stocks = jdbcTemplate.queryForList(
                "SELECT ps.ps_id, ps.quantity " +
                        "FROM ProductStock ps " +
                        "JOIN InboundItem ii ON ps.inbound_item_id = ii.inbound_item_id " +
                        "WHERE ps.warehouse_id = ? AND ii.product_id = ? AND ps.quantity > 0 " +
                        "ORDER BY ps.ps_id",
                warehouseId,
                productId
        );

        int remainingQuantity = moveQuantity;
        for (Map<String, Object> stock : stocks) {
            if (remainingQuantity == 0) {
                break;
            }

            long stockId = ((Number) stock.get("ps_id")).longValue();
            int currentQuantity = ((Number) stock.get("quantity")).intValue();
            int deductedQuantity = Math.min(currentQuantity, remainingQuantity);
            int updatedQuantity = currentQuantity - deductedQuantity;

            jdbcTemplate.update(
                    "UPDATE ProductStock SET quantity = ?, last_update_date = NOW() WHERE ps_id = ?",
                    updatedQuantity,
                    stockId
            );
            insertStockLog(stockId, -deductedQuantity, "TRANSFER_OUT", "IN_STOCK", destination);

            remainingQuantity -= deductedQuantity;
        }

        if (remainingQuantity > 0) {
            throw new IllegalStateException("Insufficient stock");
        }
    }

    private long createInboundItem(long warehouseId, String productId, int quantity) {
        KeyHolder inboundKeyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement statement = connection.prepareStatement(
                    "INSERT INTO Inbound (warehouse_id, member_id, inbound_status, inbound_requested_at, inbound_updated_at, inbound_at) " +
                            "VALUES (?, 1, 'approved', NOW(), NOW(), NOW())",
                    Statement.RETURN_GENERATED_KEYS
            );
            statement.setLong(1, warehouseId);
            return statement;
        }, inboundKeyHolder);

        long inboundId = inboundKeyHolder.getKey().longValue();

        KeyHolder itemKeyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement statement = connection.prepareStatement(
                    "INSERT INTO InboundItem (inbound_id, product_id, quantity) VALUES (?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS
            );
            statement.setLong(1, inboundId);
            statement.setString(2, productId);
            statement.setInt(3, quantity);
            return statement;
        }, itemKeyHolder);

        return itemKeyHolder.getKey().longValue();
    }

    private long createProductStock(long warehouseId, String productId, long inboundItemId, int quantity) {
        long sectionId = findSectionId(warehouseId, productId);

        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement statement = connection.prepareStatement(
                    "INSERT INTO ProductStock (warehouse_id, section_id, inbound_item_id, outbound_item_id, quantity, product_status, last_update_date) " +
                            "VALUES (?, ?, ?, NULL, ?, 'IN_STOCK', NOW())",
                    Statement.RETURN_GENERATED_KEYS
            );
            statement.setLong(1, warehouseId);
            statement.setLong(2, sectionId);
            statement.setLong(3, inboundItemId);
            statement.setInt(4, quantity);
            return statement;
        }, keyHolder);

        return keyHolder.getKey().longValue();
    }

    private void insertStockLog(long stockId, int moveQuantity, String eventType, String productStatus, String destination) {
        jdbcTemplate.update(
                "INSERT INTO ProductStockLog (ps_id, event_time, move_quantity, event_type, product_status, destination) " +
                        "VALUES (?, NOW(), ?, ?, ?, ?)",
                stockId,
                moveQuantity,
                eventType,
                productStatus,
                destination
        );
    }

    private void cleanupProductStock(long warehouseId, List<String> productIds) {
        for (String productId : productIds) {
            jdbcTemplate.update(
                    "DELETE FROM ProductStockLog WHERE ps_id IN (" +
                            "SELECT ps_id FROM ProductStock WHERE warehouse_id = ? AND inbound_item_id IN (" +
                            "SELECT inbound_item_id FROM InboundItem WHERE product_id = ?))",
                    warehouseId,
                    productId
            );
            jdbcTemplate.update(
                    "DELETE FROM PhysicalInventory WHERE ps_id IN (" +
                            "SELECT ps_id FROM ProductStock WHERE warehouse_id = ? AND inbound_item_id IN (" +
                            "SELECT inbound_item_id FROM InboundItem WHERE product_id = ?))",
                    warehouseId,
                    productId
            );
            jdbcTemplate.update(
                    "DELETE FROM ProductStock WHERE warehouse_id = ? AND inbound_item_id IN (" +
                            "SELECT inbound_item_id FROM InboundItem WHERE product_id = ?)",
                    warehouseId,
                    productId
            );
        }
    }

    private void assertMovementLimit(String eventType, String destination, int maxMoveQuantity, int expectedCount) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM ProductStockLog WHERE event_type = ? AND destination = ?",
                Integer.class,
                eventType,
                destination
        );
        Integer maxQuantity = jdbcTemplate.queryForObject(
                "SELECT COALESCE(MAX(ABS(move_quantity)), 0) FROM ProductStockLog WHERE event_type = ? AND destination = ?",
                Integer.class,
                eventType,
                destination
        );

        assertEquals(expectedCount, count);
        assertTrue(maxQuantity <= maxMoveQuantity);
    }

    private void assertMovementLimitAndTotal(String eventType, String destination, int maxMoveQuantity, int expectedTotalQuantity) {
        Integer totalQuantity = jdbcTemplate.queryForObject(
                "SELECT COALESCE(SUM(ABS(move_quantity)), 0) FROM ProductStockLog WHERE event_type = ? AND destination = ?",
                Integer.class,
                eventType,
                destination
        );
        Integer maxQuantity = jdbcTemplate.queryForObject(
                "SELECT COALESCE(MAX(ABS(move_quantity)), 0) FROM ProductStockLog WHERE event_type = ? AND destination = ?",
                Integer.class,
                eventType,
                destination
        );

        assertEquals(expectedTotalQuantity, totalQuantity);
        assertTrue(maxQuantity <= maxMoveQuantity);
    }

    private Map<String, Integer> getStockSnapshot(long warehouseId, List<String> productIds) {
        java.util.LinkedHashMap<String, Integer> snapshot = new java.util.LinkedHashMap<>();
        for (String productId : productIds) {
            snapshot.put(productId, getStockQuantity(warehouseId, productId));
        }
        return snapshot;
    }

    private int getStockQuantity(long warehouseId, String productId) {
        Integer quantity = jdbcTemplate.queryForObject(
                "SELECT COALESCE(SUM(ps.quantity), 0) " +
                        "FROM ProductStock ps " +
                        "JOIN InboundItem ii ON ps.inbound_item_id = ii.inbound_item_id " +
                        "WHERE ps.warehouse_id = ? AND ii.product_id = ?",
                Integer.class,
                warehouseId,
                productId
        );
        return quantity == null ? 0 : quantity;
    }

    private long findWarehouseIdByName(String keyword) {
        return jdbcTemplate.queryForObject(
                "SELECT warehouse_id FROM Warehouse WHERE warehouse_name LIKE ? ORDER BY warehouse_id LIMIT 1",
                Long.class,
                "%" + keyword + "%"
        );
    }

    private String findWarehouseName(long warehouseId) {
        return jdbcTemplate.queryForObject(
                "SELECT warehouse_name FROM Warehouse WHERE warehouse_id = ?",
                String.class,
                warehouseId
        );
    }

    private long findSectionId(long warehouseId, String productId) {
        Integer categoryCode = jdbcTemplate.queryForObject(
                "SELECT category_cd FROM Product WHERE product_id = ?",
                Integer.class,
                productId
        );

        String sectionType = categoryCode != null && (categoryCode == 3 || categoryCode == 4) ? "OUTER" : "TOP";

        return jdbcTemplate.queryForObject(
                "SELECT section_id FROM Section WHERE warehouse_id = ? AND section_type = ? ORDER BY section_id LIMIT 1",
                Long.class,
                warehouseId,
                sectionType
        );
    }
}
