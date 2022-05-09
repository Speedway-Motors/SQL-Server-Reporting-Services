SELECT S.ixSKU --New product SKU 
     , S.sDescription --New product description
     , S.ixForecastingSKU 
     , FSku.Descr AS FSkuDescr 
     , INV.TMForecast AS FSkuFC --12 Mo. forecast for the forecasting SKU 
     , INV.TMSales AS FSkuSales --12 Mo. sales for the forecasting SKU 
     , AdjSales.Sales AS AdjTMSales --Adjusted 12 Mo. sales for the forecasting SKU 
     , (dbo.BOM12MonthUsage (S.ixSKU)) AS TMBOM --12 Mo. BOM for the new product SKU 
FROM tblSKU S 
LEFT JOIN (SELECT IFC.ixSKU AS ixSKU 
			    , ISNULL(IFC.i12MonthSupply,0) + ISNULL(SL.iQAV,0) AS TMForecast
			    , ISNULL(IFC.i12MonthSales,0) AS TMSales
		   FROM tblInventoryForecast IFC
		   LEFT JOIN tblSKULocation SL ON SL.ixSKU = IFC.ixSKU 
		                              and SL.ixLocation = '99'
           ) INV ON INV.ixSKU = S.ixForecastingSKU 		
LEFT JOIN (SELECT ixForecastingSKU AS FSku 
                , sDescription AS Descr
           FROM tblSKU S 
          ) FSku ON FSku.FSku = S.ixForecastingSKU            
LEFT JOIN (SELECT SALES.ixSKU 
                , ISNULL(SALES.Qty,0) - ISNULL(RTNS.Qty,0) AS Sales
           FROM (SELECT OL.ixSKU AS ixSKU 
                      , SUM(ISNULL(OL.iQuantity,0)) AS Qty
                 FROM tblOrderLine OL 
                 LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
                 WHERE O.dtShippedDate BETWEEN DATEADD(dd, -365, GETDATE()) AND GETDATE()
				   AND O.sOrderType <> 'Internal' 
				   AND O.sOrderChannel <> 'INTERNAL' 
				   AND O.mMerchandise > 0
				   AND O.sOrderStatus = 'Shipped' 
				   AND O.ixOrder NOT LIKE '%-%'
				 GROUP BY OL.ixSKU 
				) SALES 
		   LEFT JOIN (SELECT ixSKU 
						   , SUM(ISNULL(iQuantityReturned,0)) AS Qty
					  FROM tblCreditMemoDetail CMD
					  LEFT JOIN tblCreditMemoMaster CMM ON CMM.ixCreditMemo = CMD.ixCreditMemo
					  WHERE CMM.dtCreateDate BETWEEN DATEADD(dd, -365, GETDATE()) AND GETDATE()
						AND CMM.flgCanceled = '0' 
				      GROUP BY ixSKU 
					  ) RTNS ON RTNS.ixSKU = SALES.ixSKU   
		   ) AdjSales ON AdjSales.ixSKU = S.ixSKU          
WHERE S.dtCreateDate BETWEEN '01/01/11' AND GETDATE() -- @StartDate AND @EndDate 
  AND S.flgActive = '1' 
  AND S.flgDeletedFromSOP = '0'                                                
--  AND S.ixForecastingSKU IS NOT NULL
ORDER BY ixSKU 