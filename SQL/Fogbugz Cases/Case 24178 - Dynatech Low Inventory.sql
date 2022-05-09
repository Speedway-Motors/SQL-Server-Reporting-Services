SELECT SKU.ixSKU 
     , LSL.iQOS AS LSLiQOS-- local location 
     , OSL.iQOS AS OSLiQOS-- other locations 
     , ISNULL(LSL.iQOS,0) + ISNULL(OSL.iQOS,0) AS BLiQOS -- Both locations QOS 
     , INV.iQuantityCommitted AS QtyCommitted 
     , ISNULL(ISNULL(LSL.iQOS,0) + ISNULL(OSL.iQOS,0),0) - ISNULL(INV.iQuantityCommitted,0) AS QAV -- 'Balance' 
     , ISNULL(YTD.YTDQTYSold,0) AS TMSales -- 12 Month Sales     
     , ISNULL(BOM.TotalQty,0) AS TMBOM -- 12 Month BOM     
     , ISNULL(PO.POQty, 0) AS POQtyOnDelivery
     , ISNULL(BOMDt.BOMQty,0) AS BOMQtyOnDelivery
     , PO.ExpectedDelivery AS POExpectedDelivery
     , BOMDt.DueDate AS BOMExpectedDelivery 
FROM (SELECT DISTINCT ixSKU 
	  FROM tblSKU S 
	  WHERE ixPGC LIKE 'Z%' --2278
        AND ixPGC <> 'ZP' --2163
        AND flgActive = 1 --1389
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
			 AND ((ISNULL(BTM.iCompletedQuantity,0) < BTM.iQuantity 
					AND iOpenQuantity = 0 
					AND iReleasedQuantity > 0)  
				  OR iOpenQuantity > 0) 
		   GROUP BY BTM.ixFinishedSKU                              
		  ) BOMDt ON BOMDt.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
LEFT JOIN -- 12 month sales
          (SELECT AMS.ixSKU
                , SUM(AMS.AdjustedQTYSold) AS YTDQTYSold
		   FROM vwAdjustedDailySKUSales AMS
           WHERE AMS.dtDate >= DATEADD(mm, DATEDIFF(mm,0,GETDATE())-12, 0) -- 12 months ago
             AND AMS.dtDate < GETDATE() -- previous month
           GROUP BY AMS.ixSKU
          ) YTD ON YTD.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS	
LEFT JOIN -- 12 month BOM 
          (SELECT ST.ixSKU AS ixSKU
                , ISNULL(SUM(ST.iQty),0) * -1 AS TotalQty 
		   FROM tblSKUTransaction ST 
		   LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
		   WHERE D.dtDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE()
		     AND ST.sTransactionType = 'BOM' 
			 AND ST.iQty < 0
	       GROUP BY ST.ixSKU
	       ) BOM ON BOM.ixSKU  COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU  COLLATE SQL_Latin1_General_CP1_CS_AS          	  
--WHERE V.ixVendor IN (@Vendor) 