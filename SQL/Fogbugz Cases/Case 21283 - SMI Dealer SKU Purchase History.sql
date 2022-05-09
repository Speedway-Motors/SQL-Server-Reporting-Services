SELECT DISTINCT O.ixCustomer 
     , ISNULL(C.sCustomerFirstName, ' ') + ' ' + ISNULL(C.sCustomerLastName, ' ') AS Name 
     , OL.ixSKU 
     , S.sDescription 
     , S.mPriceLevel1 AS Retail 
     , OL.mUnitPrice AS DealerPrice
     , S.mAverageCost AS Cost  
     -- do calc on the report side -- , (ISNULL(OL.mUnitPrice,0)/ISNULL(S.mAverageCost,0))/ISNULL(OL.mUnitPrice,0) AS GP
     -- do calc on the report side -- , (ISNULL(S.mPriceLevel1,0) - ISNULL(OL.mUnitPrice,0))/((ISNULL(S.mPriceLevel1,0) + ISNULL(OL.mUnitPrice,0))/2) AS RetailtoDealerDiff
FROM tblOrder O 
LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer 
WHERE O.dtShippedDate BETWEEN @StartDate AND @EndDate -- '01/01/14' AND '03/24/14' 
  AND sOrderType IN (@DealerType) -- ('MRR', 'PRS') 
  AND sOrderChannel <> 'INTERNAL' 
  AND O.ixCustomer IN (@Customer) -- = '1569235'
  AND O.sOrderStatus = 'Shipped' 
  AND OL.flgKitComponent = 0 
  AND OL.ixSKU NOT LIKE ('%-99')
  AND OL.ixSKU NOT IN ('DLR', 'NCSHIP')
  AND S.flgIntangible = 0 
ORDER BY ixSKU
     
