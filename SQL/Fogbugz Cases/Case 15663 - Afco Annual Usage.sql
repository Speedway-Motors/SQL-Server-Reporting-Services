SELECT AUST.ixFinishedSKU AS SKU
     , ISNULL(BOM.TotalQty, 0) AS BOM12Mo
     , ISNULL(YTD.YTDQTYSold,0) AS YTDAdtQty
     , ISNULL(BOM.TotalQty,0) + ISNULL(YTD.YTDQTYSold,0) AS '0to12MoUsage'
FROM dbo.ASC_AfcoUsageSKUsTemp AUST
LEFT JOIN (SELECT AMS.ixSKU AS SKU
                , SUM(AMS.AdjustedQTYSold) AS YTDQTYSold
		   FROM vwAdjustedDailySKUSales AMS
		   WHERE AMS.dtDate BETWEEN '09/18/11' AND '09/17/12'  
		   GROUP BY AMS.ixSKU
          ) YTD on YTD.SKU COLLATE SQL_Latin1_General_CP1_CI_AS = AUST.ixFinishedSKU COLLATE SQL_Latin1_General_CP1_CI_AS
LEFT JOIN (SELECT ST.ixSKU AS SKU
                , ISNULL(SUM(ST.iQty),0) * -1 AS TotalQty 
		   FROM tblSKUTransaction ST 
		   LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
		   WHERE D.dtDate BETWEEN '09/18/11' AND '09/17/12' 
		     and ST.sTransactionType = 'BOM' 
			 and ST.iQty < 0
		   GROUP BY ST.ixSKU
		  ) BOM ON BOM.SKU COLLATE SQL_Latin1_General_CP1_CI_AS = AUST.ixFinishedSKU COLLATE SQL_Latin1_General_CP1_CI_AS
ORDER BY SKU		


SELECT AUST.ixFinishedSKU AS SKU
     , ISNULL(BOM.TotalQty, 0) AS BOM12Mo
     , ISNULL(YTD.YTDQTYSold,0) AS YTDAdtQty
     , ISNULL(BOM.TotalQty,0) + ISNULL(YTD.YTDQTYSold,0) AS '12to24MoUsage'
FROM dbo.ASC_AfcoUsageSKUsTemp AUST
LEFT JOIN (SELECT AMS.ixSKU AS SKU
                , SUM(AMS.AdjustedQTYSold) AS YTDQTYSold
		   FROM vwAdjustedDailySKUSales AMS
		   WHERE AMS.dtDate BETWEEN '09/18/10' AND '09/17/11'  
		   GROUP BY AMS.ixSKU
          ) YTD on YTD.SKU COLLATE SQL_Latin1_General_CP1_CI_AS = AUST.ixFinishedSKU COLLATE SQL_Latin1_General_CP1_CI_AS
LEFT JOIN (SELECT ST.ixSKU AS SKU
                , ISNULL(SUM(ST.iQty),0) * -1 AS TotalQty 
		   FROM tblSKUTransaction ST 
		   LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
		   WHERE D.dtDate BETWEEN '09/18/10' AND '09/17/11' 
		     and ST.sTransactionType = 'BOM' 
			 and ST.iQty < 0
		   GROUP BY ST.ixSKU
		  ) BOM ON BOM.SKU COLLATE SQL_Latin1_General_CP1_CI_AS = AUST.ixFinishedSKU COLLATE SQL_Latin1_General_CP1_CI_AS
ORDER BY SKU		
            