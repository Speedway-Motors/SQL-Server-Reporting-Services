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
  -- AND S.ixSKU = '[Enter SKU Here]'
	  
	  
	  
	