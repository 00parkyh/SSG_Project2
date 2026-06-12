package com.ssg.wms.product_stock.service;

import com.ssg.wms.product_stock.dto.PageRequestDTO;
import com.ssg.wms.product_stock.dto.PageResponseDTO;
import com.ssg.wms.product_stock.dto.PhysicalInventoryBatchUpdateDTO;
import com.ssg.wms.product_stock.dto.PhysicalInventoryDTO;
import com.ssg.wms.product_stock.dto.PhysicalInventoryRequest;
import com.ssg.wms.product_stock.dto.PhysicalInventoryUpdateDTO;

import java.util.List;

public interface PhysicalInventoryService {

    int registerPhysicalInventory(PhysicalInventoryRequest request);

    PageResponseDTO<PhysicalInventoryDTO> getPhysicalInventoryList(PageRequestDTO pageRequestDTO);

    List<PhysicalInventoryDTO> getPhysicalInventoryDetailList(String inventoryBatchId);

    void updatePhysicalInventory(PhysicalInventoryUpdateDTO updateDTO);

    void updatePhysicalInventoryBatch(PhysicalInventoryBatchUpdateDTO updateDTO);
}
