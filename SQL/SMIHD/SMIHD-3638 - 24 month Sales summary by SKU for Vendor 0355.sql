-- SMIHD-3638 - 24 month Sales summary by SKU for Vendor 0355
SELECT V.ixVendor AS VendorNumber 
     , V.sName AS VendorName 
     , SKU.ixSKU AS SKU  
	 , SKU.sDescription AS SKUDescription
	 , SKU.mPriceLevel1 AS Retail
	 , SUM(OL.iQuantity) AS ActualUnitsSold
	 , SUM(OL.mExtendedPrice) AS Sales 
	 , SUM(OL.mExtendedCost) AS COGS
	 , SUM(OL.mExtendedPrice) - SUM(OL.mExtendedCost) AS GM 
FROM tblOrderLine OL
LEFT JOIN vwSKULocalLocation SKU ON SKU.ixSKU = OL.ixSKU
LEFT JOIN tblOrder O on OL.ixOrder = O.ixOrder
LEFT JOIN tblVendorSKU VS ON VS.ixSKU = OL.ixSKU AND VS.iOrdinality = 1 
LEFT JOIN tblVendor V ON V.ixVendor = VS.ixVendor
WHERE V.ixVendor = '0355'
  AND OL.flgLineStatus IN ('Shipped', 'Dropshipped') -- This particular vendor doesn't do dropship. JEF wants ALL of their sales.
  AND O.sOrderType <> 'Internal'
  AND OL.dtShippedDate BETWEEN '02/19/14' AND '02/18/15' --'02/19/15' AND '02/18/16' Ran a set for each 12 month range
  AND OL.flgKitComponent = 0 -- KIT COMPONENT CHECK
GROUP BY V.ixVendor
       , V.sName
       , SKU.ixSKU
       , SKU.sDescription
       , SKU.mPriceLevel1	
ORDER BY SKU.ixSKU




--'0355'




