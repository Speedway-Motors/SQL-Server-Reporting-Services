-- Grouped by shipped date 
SELECT OL.dtShippedDate
     , COUNT(DISTINCT OL.ixOrder) AS OrdCnt 
     , SUM(OL.mExtendedPrice) AS TotalMerch      
     , SUM(SkuPromo.mExtendedPromoDiscount) AS TotalDiscount 
FROM (SELECT First.*
                , Second.ixSKU
                , Second.mExtendedPromoDiscount
		   FROM (SELECT DISTINCT ixOrder 
					  , SP.ixPromoId
					  , sDescription 
					  , dtStartDate
					  , dtEndDate
					  , flgSiteWide
					  , iOrdinality
				 FROM tblSKUPromo SP 
				 LEFT JOIN tblPromoCodeMaster PCM ON PCM.ixPromoId = SP.ixPromoId  
				 WHERE SP.ixPromoId = '699'				   
				 ) First 
			LEFT JOIN (SELECT SP.ixOrder 
							, SP.ixSKU
							, SP.iOrdinality
							, SP.ixPromoId
							, SUM(mExtendedPrePromoPrice) - SUM(mExtendedPostPromoPrice) AS mExtendedPromoDiscount
					   FROM tblSKUPromo SP 
					   LEFT JOIN tblOrderLine OL ON OL.ixOrder = SP.ixOrder AND OL.iOrdinality = SP.iOrdinality AND OL.ixSKU = SP.ixSKU 
					   WHERE OL.dtOrderDate BETWEEN '01/01/12' AND GETDATE()
					     AND ixPromoId = '699'
					   GROUP BY SP.ixOrder
							  , SP.ixSKU
							  , SP.iOrdinality
							  , SP.ixPromoId
						) Second ON Second.ixOrder = First.ixOrder AND Second.iOrdinality = First.iOrdinality
           ) SkuPromo 
LEFT JOIN tblOrderLine OL ON SkuPromo.ixOrder = OL.ixOrder AND SkuPromo.iOrdinality = OL.iOrdinality AND SkuPromo.ixSKU = OL.ixSKU  
LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
WHERE O.sOrderStatus = 'Shipped' -- OL.flgLineStatus IN ('Shipped', 'Dropshipped', 'Backordered') 
GROUP BY OL.dtShippedDate     
ORDER BY OL.dtShippedDate      



--Grouped by SEMA1 
SELECT S.sSEMACategory
     , COUNT(DISTINCT OL.ixOrder) AS OrdCnt 
     , SUM(OL.mExtendedPrice) AS TotalMerch      
  --   , SUM(SkuPromo.mExtendedPromoDiscount) AS TotalDiscount 
FROM (SELECT First.*
                , Second.ixSKU
                , Second.mExtendedPromoDiscount
		   FROM (SELECT DISTINCT ixOrder 
					  , SP.ixPromoId
					  , sDescription 
					  , dtStartDate
					  , dtEndDate
					  , flgSiteWide
					  , iOrdinality
				 FROM tblSKUPromo SP 
				 LEFT JOIN tblPromoCodeMaster PCM ON PCM.ixPromoId = SP.ixPromoId  
				 WHERE SP.ixPromoId = '699'				   
				 ) First 
			LEFT JOIN (SELECT SP.ixOrder 
							, SP.ixSKU
							, SP.iOrdinality
							, SP.ixPromoId
							, SUM(mExtendedPrePromoPrice) - SUM(mExtendedPostPromoPrice) AS mExtendedPromoDiscount
					   FROM tblSKUPromo SP 
					   LEFT JOIN tblOrderLine OL ON OL.ixOrder = SP.ixOrder AND OL.iOrdinality = SP.iOrdinality AND OL.ixSKU = SP.ixSKU 
					   WHERE OL.dtOrderDate BETWEEN '01/01/12' AND GETDATE()
					     AND ixPromoId = '699'
					   GROUP BY SP.ixOrder
							  , SP.ixSKU
							  , SP.iOrdinality
							  , SP.ixPromoId
						) Second ON Second.ixOrder = First.ixOrder AND Second.iOrdinality = First.iOrdinality
           ) SkuPromo 
LEFT JOIN tblOrderLine OL ON SkuPromo.ixOrder = OL.ixOrder AND SkuPromo.iOrdinality = OL.iOrdinality AND SkuPromo.ixSKU = OL.ixSKU  
LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU
WHERE O.sOrderStatus = 'Shipped' -- OL.flgLineStatus IN ('Shipped', 'Dropshipped', 'Backordered') 
  AND OL.dtShippedDate = '02/07/15'
GROUP BY sSEMACategory
    



-- Order Line Data by SKU 
SELECT OL.ixOrder 
     , OL.dtOrderDate
     , OL.dtShippedDate
     , OL.ixSKU
     , ISNULL(S.sWebDescription, S.sDescription) AS Descrip
     , sSEMACategory
     , OL.iQuantity
     , ((OL.mExtendedPrice + mExtendedPromoDiscount) / iQuantity) AS UnitPricePreDiscount 
     , (OL.mExtendedPrice/iQuantity) AS UnitPricePostDiscount 
     , OL.mCost AS UnitCost 
     , ((((OL.mExtendedPrice + mExtendedPromoDiscount) / iQuantity)) - OL.mCost) / (((OL.mExtendedPrice + mExtendedPromoDiscount) / iQuantity)) AS PreDiscountGM
     , ((OL.mExtendedPrice/iQuantity)-OL.mCost)/((OL.mExtendedPrice/iQuantity)) AS PostDiscountGM
FROM (SELECT First.*
                , Second.ixSKU
                , Second.mExtendedPromoDiscount
		   FROM (SELECT DISTINCT ixOrder 
					  , SP.ixPromoId
					  , sDescription 
					  , dtStartDate
					  , dtEndDate
					  , flgSiteWide
					  , iOrdinality
				 FROM tblSKUPromo SP 
				 LEFT JOIN tblPromoCodeMaster PCM ON PCM.ixPromoId = SP.ixPromoId  
				 WHERE SP.ixPromoId = '699'				   
				 ) First 
			LEFT JOIN (SELECT SP.ixOrder 
							, SP.ixSKU
							, SP.iOrdinality
							, SP.ixPromoId
							, SUM(mExtendedPrePromoPrice) - SUM(mExtendedPostPromoPrice) AS mExtendedPromoDiscount
					   FROM tblSKUPromo SP 
					   LEFT JOIN tblOrderLine OL ON OL.ixOrder = SP.ixOrder AND OL.iOrdinality = SP.iOrdinality AND OL.ixSKU = SP.ixSKU 
					   WHERE OL.dtOrderDate BETWEEN '01/01/12' AND GETDATE()
					     AND ixPromoId = '699'
					   GROUP BY SP.ixOrder
							  , SP.ixSKU
							  , SP.iOrdinality
							  , SP.ixPromoId
						) Second ON Second.ixOrder = First.ixOrder AND Second.iOrdinality = First.iOrdinality
           ) SkuPromo 
LEFT JOIN tblOrderLine OL ON SkuPromo.ixOrder = OL.ixOrder AND SkuPromo.iOrdinality = OL.iOrdinality AND SkuPromo.ixSKU = OL.ixSKU  
LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
WHERE O.sOrderStatus = 'Shipped' -- OL.flgLineStatus IN ('Shipped', 'Dropshipped', 'Backordered')  
ORDER BY OL.dtShippedDate
       , OL.ixOrder
       
       
-- orders using a source code designated for event that did not use the promo code as well        
select * 
from tblOrder
WHERE sSourceCodeGiven = 'RAD0207'
  AND sOrderStatus = 'Shipped' 
  AND ixOrder NOT IN (SELECT ixOrder 
					  FROM tblSKUPromo
					  WHERE ixPromoId = '699'
					  )       
					  


-- Order Line Data by SKU for RAD source code 
SELECT OL.ixOrder 
     , OL.dtOrderDate
     , OL.dtShippedDate
     , OL.ixSKU
     , ISNULL(S.sWebDescription, S.sDescription) AS Descrip
     , sSEMACategory
     , OL.iQuantity
     , OL.mUnitPrice AS UnitPrice
     , OL.mCost AS UnitCost 
    -- , (OL.mUnitPrice-OL.mCost)/OL.mUnitPrice AS PostDiscountGM
FROM tblOrderLine OL 
LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
WHERE O.sOrderStatus = 'Shipped' -- OL.flgLineStatus IN ('Shipped', 'Dropshipped', 'Backordered')  
  AND O.sSourceCodeGiven = 'RAD0207' 
  AND O.ixOrder NOT IN (SELECT ixOrder 
					  FROM tblSKUPromo
					  WHERE ixPromoId = '699'
					  )      
ORDER BY OL.dtShippedDate
       , OL.ixOrder				
       
       
SELECT * 
FROM tblOrder
WHERE ixOrder = '5853990'       

SELECT *
FROM tblSourceCode
WHERE ixSourceCode = 'RAD0207'	  

SELECT * 
FROM tblSKU 
WHERE ixSKU = '35519258602'


SELECT *
FROM tblOrderLine
WHERE ixSKU = '35519258602'
  AND flgLineStatus = 'Shipped'
ORDER BY dtOrderDate DESC  