
SELECT DISTINCT O.ixCustomer 
INTO [SMITemp].dbo.ASC_TwoYearCustomerNumbers
FROM tblOrder O     
WHERE dtOrderDate BETWEEN DATEADD(mm, -24, GETDATE()) AND GETDATE() -- 334,377 records 


SELECT DISTINCT TY.ixCustomer 
     , MinOrderDate 
INTO [SMITemp].dbo.ASC_TwoYearCustomerMinOrderDate   
-- DROP TABLE [SMITemp].dbo.ASC_TwoYearCustomerMinOrderDate   
FROM [SMITemp].dbo.ASC_TwoYearCustomerNumbers TY 
LEFT JOIN (SELECT DISTINCT ixCustomer 
				, MIN(dtOrderDate) AS MinOrderDate
		   FROM tblOrder O 
		   WHERE sOrderType = 'Retail' 
		     AND sOrderChannel <> 'INTERNAL' 
		     --AND mMerchandise > 0 
		     AND sOrderStatus IN ('Shipped', 'Backordered', 'Open') 
		   GROUP BY ixCustomer  
		  ) MinDate ON MinDate.ixCustomer = TY.ixCustomer      -- 334,377 records 
		  

  
SELECT DISTINCT MD.ixCustomer 
     , MinOrderDate 
     , dtAccountCreateDate AS AcctCreateDate 
INTO [SMITemp].dbo.ASC_TwoYearCustomerDateInfo 
-- DROP TABLE [SMITemp].dbo.ASC_TwoYearCustomerDateInfo      
FROM [SMITemp].dbo.ASC_TwoYearCustomerMinOrderDate MD  		  
LEFT JOIN tblCustomer C ON C.ixCustomer = MD.ixCustomer 
WHERE C.dtAccountCreateDate = MD.MinOrderDate   -- 176,072 records 


SELECT DISTINCT CDI.ixCustomer 
     , MinOrderDate 
    -- , O.ixOrder 
     , MIN(T.chTime) AS MinOrderTime
INTO [SMITemp].dbo.ASC_TwoYearCustomerTimeInfo     
-- DROP TABLE [SMITemp].dbo.ASC_TwoYearCustomerTimeInfo    
FROM [SMITemp].dbo.ASC_TwoYearCustomerDateInfo CDI     
LEFT JOIN tblOrder O ON O.ixCustomer = CDI.ixCustomer 
LEFT JOIN tblTime T ON T.ixTime = O.ixOrderTime 
WHERE sOrderType = 'Retail' 
  AND sOrderChannel <> 'INTERNAL' 
  -- AND mMerchandise > 0 
  AND sOrderStatus IN ('Shipped', 'Backordered', 'Open') 
  AND O.dtOrderDate = CDI.MinOrderDate 
GROUP BY CDI.ixCustomer
       , MinOrderDate  
ORDER BY ixCustomer  -- 176,072 records 



SELECT DISTINCT CTI.ixCustomer 
     , MinOrderDate 
     , MIN(O.ixOrder) AS OrderNumber 
INTO [SMITemp].dbo.ASC_TwoYearCustomerOrders  
-- DROP TABLE [SMITemp].dbo.ASC_TwoYearCustomerOrders      
FROM [SMITemp].dbo.ASC_TwoYearCustomerTimeInfo CTI     
LEFT JOIN tblOrder O ON O.ixCustomer = CTI.ixCustomer 
LEFT JOIN tblTime T ON T.ixTime = O.ixOrderTime 
WHERE MinOrderDate BETWEEN DATEADD(mm, -24, GETDATE()) AND GETDATE()
  AND sOrderType = 'Retail' 
  AND sOrderChannel <> 'INTERNAL' 
 -- AND mMerchandise > 0 
  AND sOrderStatus IN ('Shipped', 'Backordered', 'Open') 
  AND O.dtOrderDate = CTI.MinOrderDate 
  AND T.chTime = CTI.MinOrderTime 
GROUP BY CTI.ixCustomer 
       , MinOrderDate  
ORDER BY ixCustomer  -- 120,420 records 


-- Create the view for Tableau 

CREATE VIEW vwTwoYearNewCustomerOrders AS 
-- DROP VIEW vwTwoYearNewCustomerOrders
SELECT TYCO.OrderNumber AS ixOrder
     , TYCO.ixCustomer
     , 'US.' + sShipToZip AS ixGeography 
     , OL.ixSKU
     , OL.iQuantity
     , OL.mUnitPrice
     , OL.mExtendedPrice
     , OL.flgLineStatus
     , OL.dtOrderDate
     , OL.dtShippedDate
     , OL.mCost
     , OL.mExtendedCost
     , O.mShipping / Lines.OrderLines AS DisaggShipRev 
     , (mShipping * .785) / Lines.OrderLines AS DisaggShipCost 
     , OL.flgKitComponent
     , OL.iOrdinality
     , OL.ixPicker
     , O.mMerchandise AS MerchTotal
     , Lines.OrderLines
FROM [SMITemp].dbo.ASC_TwoYearCustomerOrders TYCO
LEFT JOIN tblOrderLine OL ON OL.ixOrder = TYCO.OrderNumber
LEFT JOIN tblOrder O ON O.ixOrder = TYCO.OrderNumber
LEFT JOIN (SELECT ixOrder 
                , COUNT(DISTINCT iOrdinality) AS OrderLines 
           FROM tblOrderLine OL 
           WHERE dtShippedDate BETWEEN DATEADD(mm, -24, GETDATE()) AND GETDATE()
            -- AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') --, 'Backordered', 'Lost') 
		   GROUP BY ixOrder
          ) Lines ON Lines.ixOrder = TYCO.OrderNumber


SELECT TOP 10 * FROM vwTwoYearNewCustomerOrders