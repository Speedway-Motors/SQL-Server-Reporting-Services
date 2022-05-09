SELECT SKU.ixSKU AS SKU
     , SKU.sDescription AS Description
     , SKU.ixPGC
     , SUBSTRING(SKU.ixPGC,1,1) AS MajorPJC
     , SUBSTRING(SKU.ixPGC,2,1) AS MinorPJC
     , ISNULL(SL.iQOS,0) AS QoH
     , ISNULL(SL.iQAV,0) AS QAV
     , ISNULL(YTD.YTDQTYSold,0) AS Sales12Mo
     , ISNULL(BOM.TotalQty,0) AS BOM12Mo     
     , ISNULL(SUM (ISNULL(iThisMonthForecast,0) + ISNULL(iPlus1MonthSales,0) + ISNULL(iPlus2MonthSales,0) + ISNULL(iPlus3MonthSales,0) + 
            ISNULL(iPlus4MonthSales,0) + ISNULL(iPlus5MonthSales,0) + ISNULL(iPlus6MonthSales,0) + ISNULL(iPlus7MonthSales,0) + 
            ISNULL(iPlus8MonthSales,0) + ISNULL(iPlus9MonthSales,0) + ISNULL(iPlus10MonthSales,0) + ISNULL(iPlus11MonthSales,0)
           ),0) AS '12MoForecast'     
     , ISNULL(SKU.mAverageCost,0) AS Cost
     , ((ISNULL(YTD.YTDQTYSold,0) + ISNULL(BOM.TotalQty,0)) * CAST(ISNULL(SKU.mAverageCost,0) AS MONEY)) AS ExCost
    -- Quarterly Usage to be calc. on report
    -- OH - Qtrly Usage to be calc. on report
     , PO.ExpectedDelivery 
     , PO.POQty
     , BOMOrd.DueDate
     , BOMOrd.BOMQty
     , V.ixVendor
     , V.sName
     , V.ixBuyer
     , SKU.dtCreateDate
     , SKU.dtDiscontinuedDate
FROM tblSKU SKU
LEFT JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS AND ixLocation = '99' 
LEFT JOIN -- 12 month sales
          (SELECT AMS.ixSKU
                , SUM(AMS.AdjustedQTYSold) AS YTDQTYSold
		   FROM vwAdjustedDailySKUSales AMS -- view is based on SHIPPED DATE
           WHERE AMS.dtDate >= DATEADD(mm, DATEDIFF(mm,0,getdate())-12, 0) -- 12 months ago
             AND AMS.dtDate < getdate() -- previous month
           GROUP BY AMS.ixSKU
          ) YTD ON YTD.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
LEFT JOIN tblInventoryForecast InvF ON InvF.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS  = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
--this is the query used to generate dbo.BOM12MonthUsage but the function ran extremely slow so this was added in
LEFT JOIN(SELECT ST.ixSKU AS ixSKU, ISNULL(SUM(ST.iQty),0) * -1 AS TotalQty 
		  FROM tblSKUTransaction ST 
		  LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
		  WHERE D.dtDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE()
		    AND ST.sTransactionType = 'BOM' 
			AND ST.iQty < 0
	      GROUP BY ST.ixSKU
	      ) BOM ON BOM.ixSKU  COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU  COLLATE SQL_Latin1_General_CP1_CS_AS
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
		   WHERE ISNULL(BTM.iCompletedQuantity,0) < BTM.iQuantity 
             AND dtCanceledDate IS NULL 
             AND (iOpenQuantity > 0
                    OR iReleasedQuantity <> 0) 
             AND flgReverseBOM = 0  
		   GROUP BY BTM.ixFinishedSKU                              
		  ) BOMOrd ON BOMOrd.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS	 
LEFT JOIN tblVendorSKU VS ON VS.ixSKU = SKU.ixSKU AND iOrdinality = 1 
LEFT JOIN tblVendor V ON V.ixVendor = VS.ixVendor 		       
WHERE SKU.ixSKU NOT LIKE 'UP%'
  AND (isnull(YTD.YTDQTYSold,0) > 0 OR BOM.TotalQty <> 0)
  AND SKU.flgActive = 1
GROUP BY SKU.ixSKU 
       , SKU.sDescription 
       , SKU.ixPGC
       , SUBSTRING(SKU.ixPGC,1,1) 
       , SUBSTRING(SKU.ixPGC,2,1)   
       , ISNULL(SL.iQOS,0) 
       , ISNULL(SL.iQAV,0)        
       , ISNULL(YTD.YTDQTYSold,0) 
       , ISNULL(SKU.mAverageCost,0) 
       , ISNULL(BOM.TotalQty,0) 
       , ((ISNULL(YTD.YTDQTYSold,0) + ISNULL(BOM.TotalQty,0)) * CAST(ISNULL(SKU.mAverageCost,0) AS MONEY))     
       , PO.ExpectedDelivery 
       , PO.POQty
       , BOMOrd.DueDate
       , BOMOrd.BOMQty
       , V.ixVendor
       , V.sName
       , V.ixBuyer
       , SKU.dtCreateDate
       , SKU.dtDiscontinuedDate       
 