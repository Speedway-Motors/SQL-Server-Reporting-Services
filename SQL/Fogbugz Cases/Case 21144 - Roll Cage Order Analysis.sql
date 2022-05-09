
-- To create the table of customers who have ordered roll cages since 2011 - present 
SELECT DISTINCT O.ixCustomer 
     , MIN(O.dtShippedDate) AS MinRCOrderDate 
     , SUM(O.mMerchandise) AS MinRCOrderSales 
     , SUM(O.mMerchandise) - SUM(O.mMerchandiseCost) AS MinRCOrderGross
     , (SUM(O.mMerchandise) - SUM(O.mMerchandiseCost))/(SUM(O.mMerchandise)) AS MinRCOrderGPercent     
    -- , COUNT(DISTINCT ixSKU) AS MinRCOrderSKUCnt
--INTO [SMITemp].dbo.ASC_21144_RollCageCustomers    --DROP TABLE [SMITemp].dbo.ASC_21144_RollCageCustomers 
FROM tblOrder O 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
WHERE O.dtShippedDate >= '01/01/2011' 
  AND sOrderStatus = 'Shipped' 
  AND ixSKU IN ('91673060-48','91673010','91673070')  
  AND sOrderType <> 'Internal' 
  AND sOrderChannel <> 'INTERNAL'
GROUP BY O.ixCustomer  
ORDER BY MinRCOrderSales --FirstOrder 

 
-- To retrieve data regarding sales/profit prior to the roll cage order and subsequent to the order 
SELECT RCC.ixCustomer 
     , C.dtAccountCreateDate 
	 , C.ixCustomerType     
     , C.iPriceLevel 
     , RCC.MinRCOrderDate
     , RCC.MinRCOrderSales 
     , RCC.MinRCOrderGross
     , RCC.MinRCOrderGPercent
     , SB.Sales AS SalesBefore
     , SB.Gross AS GPBefore 
     -- do calc for GP % on Excel 
     , SS.Sales AS SalesSince
     , SS.Gross AS GPSince
     , SS.GPercent AS GPercentSince 
FROM [SMITemp].dbo.ASC_21144_RollCageCustomers RCC  -- 292 rows 
LEFT JOIN tblCustomer C ON C.ixCustomer = RCC.ixCustomer 
LEFT JOIN (SELECT DISTINCT O.ixCustomer 
                , SUM(mMerchandise) AS Sales 
                , SUM(mMerchandise) - SUM(mMerchandiseCost) AS Gross 
                , (SUM(O.mMerchandise) - SUM(O.mMerchandiseCost))/(SUM(O.mMerchandise)) AS GPercent
           FROM tblOrder O 
           LEFT JOIN [SMITemp].dbo.ASC_21144_RollCageCustomers RCC ON RCC.ixCustomer = O.ixCustomer 
           WHERE sOrderStatus = 'Shipped' 
			 AND sOrderType <> 'Internal' 
			 AND sOrderChannel <> 'INTERNAL'
			 AND O.dtShippedDate >= RCC.MinRCOrderDate
		   GROUP BY O.ixCustomer 	 
		  ) SS /* Sales Since (and including) */ ON SS.ixCustomer = RCC.ixCustomer 
LEFT JOIN (SELECT DISTINCT O.ixCustomer 
                , SUM(mMerchandise) AS Sales 
                , SUM(mMerchandise) - SUM(mMerchandiseCost) AS Gross 
               -- , (SUM(O.mMerchandise) - SUM(O.mMerchandiseCost))/(SUM(O.mMerchandise)) AS GPercent
           FROM tblOrder O 
           LEFT JOIN [SMITemp].dbo.ASC_21144_RollCageCustomers RCC ON RCC.ixCustomer = O.ixCustomer 
           WHERE sOrderStatus = 'Shipped' 
			 AND sOrderType <> 'Internal' 
			 AND sOrderChannel <> 'INTERNAL'
			 AND O.dtShippedDate < RCC.MinRCOrderDate
			 AND O.dtShippedDate > '01/01/07'
		   GROUP BY O.ixCustomer 	 
		  ) SB /* Sales Before */ ON SB.ixCustomer = RCC.ixCustomer 

-- To retrieve a list of SKUs ordered the same day as the roll cage 
SELECT DISTINCT OS.ixSKU
     , S.sDescription
     , S.mPriceLevel1 AS Retail 
     , S.mAverageCost  
FROM [SMITemp].dbo.ASC_21144_RollCageCustomers RCC 
LEFT JOIN (SELECT O.ixCustomer 
                , OL.ixSKU 
           FROM tblOrder O 
           LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
           LEFT JOIN [SMITemp].dbo.ASC_21144_RollCageCustomers RCC ON RCC.ixCustomer = O.ixCustomer 
           WHERE O.dtShippedDate = RCC.MinRCOrderDate 
             AND O.sOrderStatus = 'Shipped' 
             AND O.sOrderChannel <> 'INTERNAL' 
             AND O.sOrderType <> 'Internal' 
             AND OL.flgKitComponent = 0 
           ) OS /* Orders on the same day */ ON OS.ixCustomer = RCC.ixCustomer 
LEFT JOIN tblSKU S ON S.ixSKU = OS.ixSKU 
WHERE S.flgIntangible = 0 

-- To retrieve a list of SKUs ordered after the initial roll cage order 
SELECT DISTINCT OS.ixSKU
     , S.sDescription
     , S.mPriceLevel1 AS Retail 
     , S.mAverageCost  
FROM [SMITemp].dbo.ASC_21144_RollCageCustomers RCC 
LEFT JOIN (SELECT O.ixCustomer 
                , OL.ixSKU 
           FROM tblOrder O 
           LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder 
           LEFT JOIN [SMITemp].dbo.ASC_21144_RollCageCustomers RCC ON RCC.ixCustomer = O.ixCustomer 
           WHERE O.dtShippedDate > RCC.MinRCOrderDate 
             AND O.sOrderStatus = 'Shipped' 
             AND O.sOrderChannel <> 'INTERNAL' 
             AND O.sOrderType <> 'Internal' 
             AND OL.flgKitComponent = 0 
           ) OS /* Orders on the same day */ ON OS.ixCustomer = RCC.ixCustomer 
LEFT JOIN tblSKU S ON S.ixSKU = OS.ixSKU 
WHERE S.flgIntangible = 0 