/*
truck freight charges for orders w/ crate motors.
need to know what crate motor orders look like - 
how many additional line items are on orders containing crate motors
 merch$ of additional parts, etc.
 */

--Summary Data  
SELECT DATEPART(year,dtOrderDate) AS Year
     , SUM(mMerchandise) AS TotalMerch 
     , SUM(mShipping) AS ShippingCharged
     , COUNT(DISTINCT O.ixOrder) AS TotalOrders 
     , SUM(Xtra.LineCount) AS TotalAddtlLines 
     , SUM(Xtra.AddtlMerch) AS TotalAddtlMerch
FROM tblOrder O
LEFT JOIN (SELECT DISTINCT ixOrder 
                , COUNT(DISTINCT OL.ixSKU) AS LineCount
                , SUM(mExtendedPrice) AS AddtlMerch  
		   FROM tblOrderLine OL 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   WHERE (sSEMASubCategory <> 'Crate Engines'
		           OR sSEMASubCategory IS NULL) 
		     AND flgIntangible = 0 
		     AND flgLineStatus IN ('Shipped', 'Dropshipped') 
		   GROUP BY ixOrder
		   ) Xtra ON Xtra.ixOrder = O.ixOrder 		   
WHERE O.ixOrder IN (SELECT DISTINCT ixOrder 
				    FROM tblOrderLine OL 
				    LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
				    WHERE sSEMACategory = 'Engine' 
					  AND sSEMASubCategory = 'Crate Engines'
			      ) 
  AND sOrderStatus = 'Shipped'	
  AND sOrderType <> 'Internal' 	
 -- AND O.ixOrder = '6467904'	 
  AND dtOrderDate >= '01/01/11'     
  AND mMerchandise > 0 
  AND iShipMethod <> 1 
  AND sOrderType = 'Retail'
GROUP BY  DATEPART(year,dtOrderDate)			     


--Order Data by Year 
SELECT O.ixOrder 
     , O.sOrderType
     , SUM(mMerchandise) AS TotalMerch 
     , SUM(mShipping) AS ShippingCharged
     , O.iShipMethod
     , SUM(Xtra.LineCount) AS TotalAddtlLines 
     , SUM(Xtra.AddtlMerch) AS TotalAddtlMerch
FROM tblOrder O
LEFT JOIN (SELECT DISTINCT ixOrder 
                , COUNT(DISTINCT OL.ixSKU) AS LineCount
                , SUM(mExtendedPrice) AS AddtlMerch  
		   FROM tblOrderLine OL 
		   LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
		   WHERE (sSEMASubCategory <> 'Crate Engines'
		           OR sSEMASubCategory IS NULL) 
		     AND flgIntangible = 0 
		     AND flgLineStatus IN ('Shipped', 'Dropshipped') 
		   GROUP BY ixOrder
		   ) Xtra ON Xtra.ixOrder = O.ixOrder 		   
WHERE O.ixOrder IN (SELECT DISTINCT ixOrder 
				    FROM tblOrderLine OL 
				    LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
				    WHERE sSEMACategory = 'Engine' 
					  AND sSEMASubCategory = 'Crate Engines'
			      ) 
  AND sOrderStatus = 'Shipped'	
  AND sOrderType <> 'Internal' 	
 -- AND O.ixOrder = '6467904'	 
  AND mMerchandise > 0 
  AND DATEPART(year,dtOrderDate) = '2011'	
GROUP BY O.ixOrder  
       , O.sOrderType
       , O.iShipMethod