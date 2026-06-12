package com.ssg.wms.outbound.service;

import com.ssg.wms.outbound.domain.Criteria;
import com.ssg.wms.outbound.domain.dto.DispatchDTO;
import com.ssg.wms.outbound.domain.dto.OutboundItemDTO;
import com.ssg.wms.outbound.domain.dto.OutboundOrderDTO;
import com.ssg.wms.outbound.mappers.DispatchMapper;
import com.ssg.wms.outbound.mappers.OutboundMapper;
import com.ssg.wms.outbound.mappers.OutboundOrderMapper;
import com.ssg.wms.outbound.mappers.WaybillMapper;
import com.ssg.wms.product_stock.service.ProductStockService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Log4j2
public class OutboundOrderServiceImpl implements OutboundOrderService {

    private final OutboundOrderMapper outboundOrderMapper;
    private final OutboundMapper outboundMapper;
    private final DispatchMapper dispatchMapper;
    private final WaybillMapper waybillMapper;
    private final ProductStockService productStockService;

    @Override
    public List<OutboundOrderDTO> getAllRequests(Criteria criteria, String search) {
        log.info("Outbound order list requested. search={}", search);
        return outboundOrderMapper.getAllOrders(criteria, search);
    }

    @Override
    public List<OutboundOrderDTO> getFilteredOrders(Criteria criteria, String filterType, String searchValue) {
        log.info("Outbound order filtered list requested. filterType={}, searchValue={}", filterType, searchValue);
        return outboundOrderMapper.getFilteredOrders(criteria, filterType, searchValue);
    }

    @Override
    public OutboundOrderDTO getRequestDetailById(Long approvedOrderId) {
        log.info("Outbound order detail requested. approvedOrderId={}", approvedOrderId);
        OutboundOrderDTO outboundOrderDTO = outboundOrderMapper.getOrderDetailById(approvedOrderId);

        if (outboundOrderDTO == null) {
            throw new RuntimeException("Outbound order not found. approvedOrderId=" + approvedOrderId);
        }
        return outboundOrderDTO;
    }

    @Override
    @Transactional
    public void updateOrderStatus(OutboundOrderDTO outboundOrderDTO) {
        log.info("Outbound order status update started. dto={}", outboundOrderDTO);

        OutboundOrderDTO existingOrder = getRequestDetailById(outboundOrderDTO.getApprovedOrderID());
        if (outboundOrderDTO.getWarehouseId() == null) {
            outboundOrderDTO.setWarehouseId(existingOrder.getWarehouseId());
        }

        int updatedOrder = outboundOrderMapper.updateOrderStatus(outboundOrderDTO);
        log.info("Outbound order updated. rows={}", updatedOrder);

        int updatedRequest = outboundOrderMapper.updateOutboundRequestStatus(
                outboundOrderDTO.getApprovedOrderID(),
                outboundOrderDTO.getApprovedStatus(),
                outboundOrderDTO.getWarehouseId()
        );
        log.info("Outbound request updated. rows={}", updatedRequest);

        if ("승인".equals(outboundOrderDTO.getApprovedStatus())) {
            decreaseApprovedOrderStock(existingOrder, outboundOrderDTO.getWarehouseId());
            upsertDispatchAndWaybill(outboundOrderDTO);
        }

        log.info("Outbound order status update completed.");
    }

    private void decreaseApprovedOrderStock(OutboundOrderDTO existingOrder, Long warehouseId) {
        List<OutboundItemDTO> outboundItems = outboundMapper.getOutboundRequestItems(existingOrder.getOutboundRequestID());

        for (OutboundItemDTO item : outboundItems) {
            productStockService.decreaseStockByProduct(
                    warehouseId,
                    item.getProductId(),
                    item.getOutboundQuantity()
            );
        }
    }

    private void upsertDispatchAndWaybill(OutboundOrderDTO outboundOrderDTO) {
        Long dispatchId = dispatchMapper.getDispatchIdByApprovedOrderId(outboundOrderDTO.getApprovedOrderID());
        log.info("Existing dispatch lookup result. dispatchId={}", dispatchId);

        if (dispatchId == null) {
            log.info("Creating dispatch. approvedOrderId={}, warehouseId={}",
                    outboundOrderDTO.getApprovedOrderID(),
                    outboundOrderDTO.getWarehouseId());

            dispatchMapper.insertDispatchInformation(outboundOrderDTO);
            dispatchId = outboundOrderDTO.getDispatchId();
            log.info("Dispatch created. dispatchId={}", dispatchId);
        } else {
            DispatchDTO dispatchDTO = DispatchDTO.builder()
                    .dispatchId(dispatchId)
                    .approvedOrderID(outboundOrderDTO.getApprovedOrderID())
                    .carId(outboundOrderDTO.getCarId())
                    .carType(outboundOrderDTO.getCarType())
                    .driverName(outboundOrderDTO.getDriverName())
                    .dispatchStatus(outboundOrderDTO.getDispatchStatus())
                    .loadedBox(outboundOrderDTO.getLoadedBox())
                    .maximumBox(outboundOrderDTO.getMaximumBOX())
                    .warehouseId(outboundOrderDTO.getWarehouseId())
                    .build();

            dispatchMapper.updateDispatchInformation(dispatchDTO);
            log.info("Dispatch updated. dispatchId={}", dispatchId);
        }

        outboundOrderDTO.setDispatchId(dispatchId);
        outboundOrderDTO.setWaybillNumber(generateUniqueWaybillNumber());
        waybillMapper.insertWaybill(outboundOrderDTO);
        log.info("Waybill created. waybillNumber={}", outboundOrderDTO.getWaybillNumber());
    }

    private String generateUniqueWaybillNumber() {
        return "WB-" + System.currentTimeMillis();
    }
}
