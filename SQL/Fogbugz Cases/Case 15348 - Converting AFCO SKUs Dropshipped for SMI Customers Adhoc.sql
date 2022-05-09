SELECT D.iYear as Year
	 , D.iMonth as Month
	 , COUNT(DISTINCT OL.ixOrder) as DistinctOrders
	 , SUM(OL.iQuantity) as DropshippedLines
	 , COUNT(DISTINCT OL.ixSKU) as DistinctSKUs
FROM tblOrderLine OL
LEFT JOIN tblDate D on D.ixDate = OL.ixOrderDate 
JOIN tblVendorSKU VS on VS.ixSKU = OL.ixSKU
JOIN tblVendor V on V.ixVendor = VS.ixVendor   
WHERE OL.dtOrderDate BETWEEN '01/01/10' AND '08/22/12' --@StartDate and @EndDate
  AND OL.flgLineStatus = 'Dropshipped'
  AND V.ixVendor IN (@Vendor)
  AND VS.iOrdinality = 1
GROUP BY D.iYear
	   , D.iMonth
ORDER BY D.iYear DESC
	   , D.iMonth DESC
	   


