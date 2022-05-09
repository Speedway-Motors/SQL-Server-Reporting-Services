SELECT V.ixVendor 
     , V.sName
     , V.ixBuyer
     , SKU.ixSKU 
     , LSL.iQOS AS LSLiQOS-- local location 
     , OSL.iQOS AS OSLiQOS-- other locations 
     , ISNULL(LSL.iQOS,0) + ISNULL(OSL.iQOS,0) AS BLiQOS -- Both locations QOS 
     , INV.iQuantityCommitted AS QtyCommitted 
     , ISNULL(ISNULL(LSL.iQOS,0) + ISNULL(OSL.iQOS,0),0) - ISNULL(INV.iQuantityCommitted,0) AS QAV -- 'Balance' 
     , ISNULL(PO.POQty, 0) AS POQtyOnDelivery
     , ISNULL(BOM.BOMQty,0) AS BOMQtyOnDelivery
     , PO.ExpectedDelivery AS POExpectedDelivery
     , BOM.DueDate AS BOMExpectedDelivery 
     , INV.iThisMonthForecast 
    -- , (ISNULL(SL.iQOS,0) - ISNULL(INV.iQuantityCommitted,0)) + (ISNULL(PO.POQty,0)+ ISNULL(BOM.BOMQty,0)) - INV.iThisMonthForecast AS Balance --Turn cell red if zero or negative, turn cell yellow if less than current months forecast and turn cell green if greater than current month forecast.
     , INV.iPlus1MonthSales
    -- , ((ISNULL(SL.iQOS,0) - ISNULL(INV.iQuantityCommitted,0)) + (ISNULL(PO.POQty,0)+ ISNULL(BOM.BOMQty,0)) - INV.iThisMonthForecast) - INV.iPlus1MonthSales AS BalanceTwo 
     , INV.iPlus2MonthSales
   --  , ((ISNULL(SL.iQOS,0) - ISNULL(INV.iQuantityCommitted,0)) + (ISNULL(PO.POQty,0)+ ISNULL(BOM.BOMQty,0)) - INV.iThisMonthForecast) - INV.iPlus1MonthSales - INV.iPlus2MonthSales AS BalanceThree
     , INV.iPlus3MonthSales
   --  , ((ISNULL(SL.iQOS,0) - ISNULL(INV.iQuantityCommitted,0)) + (ISNULL(PO.POQty,0)+ ISNULL(BOM.BOMQty,0)) - INV.iThisMonthForecast) - INV.iPlus1MonthSales - INV.iPlus2MonthSales - INV.iPlus3MonthSales AS BalanceFour 
FROM (SELECT DISTINCT ixSKU 
	  FROM tblSKU S 
	  WHERE flgActive = 1 --38869
	 ) SKU 
LEFT JOIN (SELECT ixSKU
                , iQOS 
           FROM tblSKULocation SL 
           WHERE ixLocation = 99 
          ) LSL ON LSL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS        
LEFT JOIN (SELECT ixSKU
                , iQOS 
           FROM tblSKULocation SL 
           WHERE ixLocation <> 99 
          ) OSL ON OSL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS                                       
LEFT JOIN tblInventoryForecast INV ON INV.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS                             
LEFT JOIN tblVendorSKU VS ON VS.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS AND VS.iOrdinality = 1 
LEFT JOIN tblVendor V ON V.ixVendor COLLATE SQL_Latin1_General_CP1_CS_AS = VS.ixVendor COLLATE SQL_Latin1_General_CP1_CS_AS
LEFT JOIN (SELECT POD.ixSKU 
                , SUM(POD.iQuantity - ISNULL(POD.iQuantityReceivedPending,0) - ISNULL(POD.iQuantityPosted,0)) AS POQty -- outstanding PO Qty
                , MIN(dtDate) AS ExpectedDelivery
		   FROM tblPODetail POD 
		   LEFT JOIN tblDate D ON D.ixDate = POD.ixExpectedDeliveryDate 
		   JOIN tblPOMaster POM ON POM.ixPO COLLATE SQL_Latin1_General_CP1_CS_AS = POD.ixPO COLLATE SQL_Latin1_General_CP1_CS_AS
                        AND POM.flgIssued = 1
                        AND POM.flgOpen = 1
           GROUP BY POD.ixSKU 
          ) PO ON PO.ixSKU = SKU.ixSKU  
LEFT JOIN (SELECT BTM.ixFinishedSKU AS ixSKU 
                , SUM(BTM.iQuantity - ISNULL(BTM.iCompletedQuantity,0)) AS BOMQty
                , MIN(dtDate) AS DueDate 
           FROM tblBOMTransferMaster BTM
           LEFT JOIN tblDate D ON D.ixDate = BTM.ixDueDate 
		   WHERE BTM.flgReverseBOM = 0
             AND BTM.dtCanceledDate is NULL
             AND flgClosed = 0              
             AND (ISNULL(BTM.iCompletedQuantity,0) < BTM.iQuantity 
                    OR iOpenQuantity > 0) 
           GROUP BY BTM.ixFinishedSKU                               
		  ) BOM ON BOM.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
WHERE V.ixVendor IN (@Vendor) 