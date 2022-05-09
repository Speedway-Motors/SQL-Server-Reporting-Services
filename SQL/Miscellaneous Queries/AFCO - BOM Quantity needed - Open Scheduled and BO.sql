-- AFCO - BOM Quantity needed - Open Scheduled and BO
SELECT S.ixSKU 
     , S.ixPGC
     , S.sDescription
     , BO.TotQty AS QtyOnBO 
     , BO.TotMerch AS MerchOnBO 
     , OpenOrders.TotQty AS QtyOpen
     , OpenOrders.TotMerch AS MerchOpen
     , Scheduled.TotQty AS QtyScheduled
     , Scheduled.TotMerch AS MerchScheduled 
FROM tblSKU S 
LEFT JOIN (SELECT OL.ixSKU 
                , SUM(OL.iQuantity) AS TotQty
                , SUM(OL.mExtendedPrice) AS TotMerch
           FROM tblOrder O 
            LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
           WHERE flgLineStatus = 'Backordered' 
             -- AND O.dtOrderDate BETWEEN @StartDate AND @EndDate
             AND O.sOrderStatus = 'Backordered' 
            GROUP BY OL.ixSKU
            ) BO ON BO.ixSKU = S.ixSKU
LEFT JOIN (SELECT OL.ixSKU 
                , SUM(OL.iQuantity) AS TotQty
                , SUM(OL.mExtendedPrice) AS TotMerch
           FROM tblOrder O 
           LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
           WHERE flgLineStatus = 'Open' 
             -- AND O.dtOrderDate BETWEEN @StartDate AND @EndDate
             AND O.sOrderStatus = 'Open' 
             AND O.dtHoldUntilDate IS NULL
           GROUP BY OL.ixSKU
          ) OpenOrders ON OpenOrders.ixSKU = S.ixSKU                                 
LEFT JOIN (SELECT OL.ixSKU 
                , SUM(OL.iQuantity) AS TotQty
                , SUM(OL.mExtendedPrice) AS TotMerch
           FROM tblOrder O 
           LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
           WHERE flgLineStatus = 'Open' 
             AND O.dtHoldUntilDate IS NOT NULL
             -- AND O.dtOrderDate BETWEEN @StartDate AND @EndDate
             AND O.sOrderStatus = 'Open' 
           GROUP BY OL.ixSKU
           ) Scheduled ON Scheduled.ixSKU = S.ixSKU
WHERE flgActive = 1 
  AND flgDeletedFromSOP = 0    
  AND flgIntangible = 0      
  AND (BO.TotQty IS NOT NULL 
        OR OpenOrders.TotQty IS NOT NULL
        OR Scheduled.TotQty IS NOT NULL)  
  AND S.ixSKU in ('52-45700','21000-1B','52-22534','25200-1B','52-53003','52-22544','52-22540','52-52002')                                 
  --AND S.ixSKU = '791-84210'
/* add the following conditions to find SKUs that have values for all the fields
        AND BO.TotQty > 0
        AND BO.TotMerch > 0 
        AND OpenOrders.TotQty > 0
        AND OpenOrders.TotMerch > 0
        AND Scheduled.TotQty > 0
        AND Scheduled.TotMerch > 0
*/