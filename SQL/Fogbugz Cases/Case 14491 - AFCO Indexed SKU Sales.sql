--Dataset to retreive all base index SKUs that have index parts 

SELECT DISTINCT sBaseIndex
FROM tblSKU 
WHERE sBaseIndex <> ixSKU
ORDER BY sBaseIndex 

-- main query for the report 

SELECT S.sBaseIndex AS BaseSKU 
     , S.flgUnitOfMeasure AS Unit
     , S.sDescription AS SKUDescription
     , S.ixSKU AS IndexSKU
     , ISNULL(OL.QtySold,0) AS IndexQtySold
     , ISNULL(CMD.QtyRtnd,0) AS IndexQtyReturned  
     , ISNULL(OL.QtySold,0) - ISNULL(CMD.QtyRtnd,0) AS IndexAdjustedQtySold
FROM tblSKU S     
LEFT JOIN (SELECT ixSKU
                , SUM(iQuantity) AS QtySold 
           FROM tblOrderLine OL 
           WHERE OL.dtOrderDate BETWEEN @SalesStartDate AND @SalesEndDate --'08/01/11' AND '08/01/12'  
			 AND OL.flgLineStatus = 'Shipped'
		   GROUP BY ixSKU 
		   ) AS OL ON OL.ixSKU = S.ixSKU 
-- to back out returned quantities of the SKUs 
LEFT JOIN (SELECT ixSKU
                , SUM(iQuantityReturned) AS QtyRtnd
           FROM tblCreditMemoDetail CMD  
           LEFT JOIN tblCreditMemoMaster CMM ON CMM.ixCreditMemo = CMD.ixCreditMemo
           WHERE CMM.dtCreateDate BETWEEN @SalesStartDate AND @SalesEndDate -- '08/01/11' AND '08/01/12' 
             AND CMM.flgCanceled = '0' 
           GROUP BY ixSKU
           ) AS CMD ON CMD.ixSKU = S.ixSKU    
WHERE S.sBaseIndex  IN (@BaseIndex) -- = '80286'			    
  AND S.flgActive = '1' 
  AND S.flgDeletedFromSOP = '0'
GROUP BY S.sBaseIndex 
     , S.flgUnitOfMeasure
     , S.sDescription 
     , S.ixSKU
     , OL.QtySold
     , CMD.QtyRtnd