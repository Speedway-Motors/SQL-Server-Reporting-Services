SELECT DISTINCT O.ixOrder
     , mShipping
     , mShipping * .785 AS EstShipCost  
     , Lines.OrderLines
INTO [SMITemp].dbo.ASC_OneYearFedExUPSGround_ShipCostAndRev      
FROM tblOrder O 
LEFT JOIN (SELECT ixOrder 
                , COUNT(DISTINCT iOrdinality) AS OrderLines 
           FROM tblOrderLine OL 
           WHERE dtShippedDate BETWEEN DATEADD(mm, -12, (DATEADD(dd, -1,GETDATE()))) AND DATEADD(dd, -1, GETDATE())
             AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') --, 'Backordered', 'Lost') 
		   GROUP BY ixOrder
          ) Lines ON Lines.ixOrder = O.ixOrder
WHERE dtShippedDate BETWEEN DATEADD(mm, -12, (DATEADD(dd, -1,GETDATE()))) AND DATEADD(dd, -1, GETDATE())
  AND sOrderStatus = 'Shipped' 
  AND sOrderType = 'Retail' 
  AND iShipMethod IN (2,13,14) 
ORDER BY ixOrder  -- 345,929 orders 
       

CREATE VIEW vwOneYearFexExUPSGroundDisaggregated AS 
SELECT OY.ixOrder 
     , OL.ixCustomer
     , OL.ixSKU
     , OL.iQuantity
     , OL.mUnitPrice
     , OL.mExtendedPrice
     , OL.flgLineStatus
     , OL.dtOrderDate
     , OL.dtShippedDate
     , OL.mCost
     , OL.mExtendedCost
     , OY.mShipping / OY.OrderLines AS DisaggShipRev 
     , OY.EstShipCost / OY.OrderLines AS DisaggShipCost 
     , OL.flgKitComponent
     , OL.iOrdinality
     , OL.ixPicker
     , O.mMerchandise AS MerchTotal
     , OY.OrderLines
FROM [SMITemp].dbo.ASC_OneYearFedExUPSGround_ShipCostAndRev OY 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = OY.ixOrder
LEFT JOIN tblOrder O ON O.ixOrder = OY.ixOrder
WHERE OL.flgLineStatus NOT IN ('Backordered', 'Lost') 

