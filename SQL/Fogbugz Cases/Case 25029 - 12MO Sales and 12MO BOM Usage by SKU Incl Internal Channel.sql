SELECT SKU.ixSKU AS SKU
     , SKU.sDescription AS Description
     , SKU.ixPGC
     , ISNULL(SL.iQOS,0) AS QtyOnHand
     , ISNULL(YTD.YTDQTYSold,0) AS '12MO Sales' 
     , ISNULL(BOM.TotalQty,0) AS '12MO BOM' 
FROM tblSKU SKU
LEFT JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS AND ixLocation = '99' 
LEFT JOIN -- 12 Month Sales
          (SELECT AMS.ixSKU
                , SUM(AMS.AdjustedQTYSold) AS YTDQTYSold
		   FROM vwAdjDailySKUSalesIncEXTOrdChan AMS
           WHERE AMS.dtDate BETWEEN DATEADD(mm, -12, GETDATE()) AND GETDATE()
           GROUP BY AMS.ixSKU
          ) YTD ON YTD.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
LEFT JOIN -- 12 Month BOM 
		 (SELECT ST.ixSKU AS ixSKU, ISNULL(SUM(ST.iQty),0) * -1 AS TotalQty 
		  FROM tblSKUTransaction ST 
		  LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
		  WHERE D.dtDate BETWEEN DATEADD(mm, -12, GETDATE()) AND GETDATE()
		    AND ST.sTransactionType = 'BOM' 
			AND ST.iQty < 0
	      GROUP BY ST.ixSKU) BOM ON BOM.ixSKU  COLLATE SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU  COLLATE SQL_Latin1_General_CP1_CS_AS
WHERE SKU.ixSKU = '700500180' -- Enter SKU between single quotes 
  AND SKU.flgActive = 1 
  AND SKU.flgDeletedFromSOP = 0 
GROUP BY SKU.ixSKU 
       , SKU.sDescription 
       , SKU.ixPGC
       , ISNULL(SL.iQOS,0) 
       , ISNULL(YTD.YTDQTYSold,0) 
       , ISNULL(BOM.TotalQty,0) 
    
