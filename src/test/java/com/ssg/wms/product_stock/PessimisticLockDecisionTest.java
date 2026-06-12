package com.ssg.wms.product_stock;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.support.TransactionTemplate;

import javax.sql.DataSource;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = "file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class PessimisticLockDecisionTest {

    private static final String PRODUCT_ID = "NK-JK-01";
    private static final int INITIAL_QUANTITY = 100;
    private static final int REQUEST_QUANTITY = 100;
    private static final int CONCURRENT_REQUESTS = 2;

    private JdbcTemplate jdbcTemplate;
    private PlatformTransactionManager transactionManager;

    @Autowired
    public void setDataSource(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Autowired
    public void setTransactionManager(PlatformTransactionManager transactionManager) {
        this.transactionManager = transactionManager;
    }

    @Test
    public void concurrentDecreaseWithoutLock_shouldBreakStockConsistency() throws Exception {
        StockFixture fixture = createStockFixture(INITIAL_QUANTITY);

        try {
            CountDownLatch allReadersReady = new CountDownLatch(CONCURRENT_REQUESTS);
            CountDownLatch updateStart = new CountDownLatch(1);

            List<Boolean> results = runConcurrently(CONCURRENT_REQUESTS,
                    () -> decreaseWithoutLock(fixture.stockId, REQUEST_QUANTITY, allReadersReady, updateStart));

            int successCount = countSuccess(results);
            int finalQuantity = getStockQuantity(fixture.stockId);
            boolean invariantValid = isStockInvariantValid(successCount, finalQuantity);

            printResult("NO LOCK", successCount, finalQuantity, invariantValid);

            assertEquals(CONCURRENT_REQUESTS, successCount);
            assertEquals(0, finalQuantity);
            assertFalse(invariantValid);
        } finally {
            cleanupFixture(fixture);
        }
    }

    @Test
    public void concurrentDecreaseWithPessimisticLock_shouldKeepStockConsistency() throws Exception {
        StockFixture fixture = createStockFixture(INITIAL_QUANTITY);

        try {
            List<Boolean> results = runConcurrently(CONCURRENT_REQUESTS,
                    () -> decreaseWithPessimisticLock(fixture.stockId, REQUEST_QUANTITY));

            int successCount = countSuccess(results);
            int finalQuantity = getStockQuantity(fixture.stockId);
            boolean invariantValid = isStockInvariantValid(successCount, finalQuantity);

            printResult("FOR UPDATE", successCount, finalQuantity, invariantValid);

            assertEquals(1, successCount);
            assertEquals(0, finalQuantity);
            assertTrue(invariantValid);
        } finally {
            cleanupFixture(fixture);
        }
    }

    private boolean decreaseWithoutLock(long stockId, int quantity, CountDownLatch allReadersReady, CountDownLatch updateStart) {
        TransactionTemplate transactionTemplate = newTransactionTemplate();

        return Boolean.TRUE.equals(transactionTemplate.execute(status -> {
            Integer currentQuantity = jdbcTemplate.queryForObject(
                    "SELECT quantity FROM ProductStock WHERE ps_id = ?",
                    Integer.class,
                    stockId
            );

            if (currentQuantity == null || currentQuantity < quantity) {
                return false;
            }

            allReadersReady.countDown();
            await(allReadersReady);
            updateStart.countDown();
            await(updateStart);

            jdbcTemplate.update(
                    "UPDATE ProductStock SET quantity = ?, last_update_date = NOW() WHERE ps_id = ?",
                    currentQuantity - quantity,
                    stockId
            );
            return true;
        }));
    }

    private boolean decreaseWithPessimisticLock(long stockId, int quantity) {
        TransactionTemplate transactionTemplate = newTransactionTemplate();

        return Boolean.TRUE.equals(transactionTemplate.execute(status -> {
            Integer currentQuantity = jdbcTemplate.queryForObject(
                    "SELECT quantity FROM ProductStock WHERE ps_id = ? FOR UPDATE",
                    Integer.class,
                    stockId
            );

            if (currentQuantity == null || currentQuantity < quantity) {
                return false;
            }

            jdbcTemplate.update(
                    "UPDATE ProductStock SET quantity = ?, last_update_date = NOW() WHERE ps_id = ?",
                    currentQuantity - quantity,
                    stockId
            );
            return true;
        }));
    }

    private TransactionTemplate newTransactionTemplate() {
        TransactionTemplate transactionTemplate = new TransactionTemplate(transactionManager);
        transactionTemplate.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
        transactionTemplate.setIsolationLevel(TransactionDefinition.ISOLATION_READ_COMMITTED);
        transactionTemplate.setTimeout(10);
        return transactionTemplate;
    }

    private List<Boolean> runConcurrently(int threadCount, Callable<Boolean> task) throws Exception {
        ExecutorService executorService = Executors.newFixedThreadPool(threadCount);

        try {
            List<Future<Boolean>> futures = new ArrayList<>();
            for (int i = 0; i < threadCount; i++) {
                futures.add(executorService.submit(task));
            }

            List<Boolean> results = new ArrayList<>();
            for (Future<Boolean> future : futures) {
                results.add(future.get(15, TimeUnit.SECONDS));
            }
            return results;
        } finally {
            executorService.shutdownNow();
        }
    }

    private int countSuccess(List<Boolean> results) {
        int count = 0;
        for (Boolean result : results) {
            if (Boolean.TRUE.equals(result)) {
                count++;
            }
        }
        return count;
    }

    private boolean isStockInvariantValid(int successCount, int finalQuantity) {
        return successCount * REQUEST_QUANTITY + finalQuantity == INITIAL_QUANTITY;
    }

    private void printResult(String label, int successCount, int finalQuantity, boolean invariantValid) {
        int processedQuantity = successCount * REQUEST_QUANTITY;

        System.out.printf(
                "[%s]%ninitialQuantity=%d%nrequestCount=%d%nrequestQuantity=%d%nsuccessCount=%d%nprocessedQuantity=%d%nfinalQuantity=%d%ninvariantValid=%s%n%n",
                label,
                INITIAL_QUANTITY,
                CONCURRENT_REQUESTS,
                REQUEST_QUANTITY,
                successCount,
                processedQuantity,
                finalQuantity,
                invariantValid
        );
    }

    private int getStockQuantity(long stockId) {
        Integer quantity = jdbcTemplate.queryForObject(
                "SELECT quantity FROM ProductStock WHERE ps_id = ?",
                Integer.class,
                stockId
        );
        return quantity == null ? 0 : quantity;
    }

    private StockFixture createStockFixture(int quantity) {
        long warehouseId = findWarehouseIdByName("수도권");
        long sectionId = findSectionId(warehouseId, PRODUCT_ID);
        long inboundId = createInbound(warehouseId);
        long inboundItemId = createInboundItem(inboundId, PRODUCT_ID, quantity);
        long stockId = createProductStock(warehouseId, sectionId, inboundItemId, quantity);

        return new StockFixture(inboundId, inboundItemId, stockId);
    }

    private long createInbound(long warehouseId) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement statement = connection.prepareStatement(
                    "INSERT INTO Inbound (warehouse_id, member_id, inbound_status, inbound_requested_at, inbound_updated_at, inbound_at) " +
                            "VALUES (?, 1, 'approved', NOW(), NOW(), NOW())",
                    Statement.RETURN_GENERATED_KEYS
            );
            statement.setLong(1, warehouseId);
            return statement;
        }, keyHolder);
        return keyHolder.getKey().longValue();
    }

    private long createInboundItem(long inboundId, String productId, int quantity) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement statement = connection.prepareStatement(
                    "INSERT INTO InboundItem (inbound_id, product_id, quantity) VALUES (?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS
            );
            statement.setLong(1, inboundId);
            statement.setString(2, productId);
            statement.setInt(3, quantity);
            return statement;
        }, keyHolder);
        return keyHolder.getKey().longValue();
    }

    private long createProductStock(long warehouseId, long sectionId, long inboundItemId, int quantity) {
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

    private void cleanupFixture(StockFixture fixture) {
        jdbcTemplate.update("DELETE FROM ProductStockLog WHERE ps_id = ?", fixture.stockId);
        jdbcTemplate.update("DELETE FROM PhysicalInventory WHERE ps_id = ?", fixture.stockId);
        jdbcTemplate.update("DELETE FROM ProductStock WHERE ps_id = ?", fixture.stockId);
        jdbcTemplate.update("DELETE FROM InboundItem WHERE inbound_item_id = ?", fixture.inboundItemId);
        jdbcTemplate.update("DELETE FROM Inbound WHERE inbound_id = ?", fixture.inboundId);
    }

    private long findWarehouseIdByName(String keyword) {
        return jdbcTemplate.queryForObject(
                "SELECT warehouse_id FROM Warehouse WHERE warehouse_name LIKE ? ORDER BY warehouse_id LIMIT 1",
                Long.class,
                "%" + keyword + "%"
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

    private void await(CountDownLatch latch) {
        try {
            if (!latch.await(10, TimeUnit.SECONDS)) {
                throw new IllegalStateException("Timed out waiting for concurrent test latch");
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new IllegalStateException(e);
        }
    }

    private static class StockFixture {
        private final long inboundId;
        private final long inboundItemId;
        private final long stockId;

        private StockFixture(long inboundId, long inboundItemId, long stockId) {
            this.inboundId = inboundId;
            this.inboundItemId = inboundItemId;
            this.stockId = stockId;
        }
    }
}
