--order line level everything from last week that shipped order by cost 

SELECT S.sDescription
     , OL.ixSKU
     , OL.mCost     
     , OL.mExtendedCost
     , SUM(iQuantity) AS QTY
FROM tblOrderLine OL
LEFT JOIN tblOrder O ON O.ixOrder = OL.ixOrder 
LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
WHERE OL.dtOrderDate BETWEEN '02/11/13' AND '02/17/13'
  AND O.sOrderStatus = 'Shipped' 
  --AND O.mMerchandise > 0 
  AND O.sOrderType <> 'Internal' 
  AND O.sOrderChannel <> 'INTERNAL' 
  AND S.flgIntangible = '0'
  AND S.flgIsKit = '0'
  AND S.sDescription NOT LIKE '%GIFT%'
  AND S.sDescription NOT LIKE '%CATALOG%'
  AND S.sDescription NOT LIKE '%INSERT%'
  AND OL.ixSKU NOT LIKE '%-99'
  AND S.sDescription NOT LIKE '%DECAL%'
  AND S.sDescription NOT LIKE '%INSTRUCT%'
  AND OL.ixSKU NOT IN ('91088341-99', '91088358-99', '91088362-99', 'TECHELP-JDJ', '999', 
						'UPSSAT', 'RACEWISE-13', 'ORDERFORM')		
  AND OL.flgLineStatus = 'Dropshipped'										
GROUP BY S.sDescription
       , OL.ixSKU
       , OL.mCost  
       , OL.mExtendedCost
HAVING SUM(iQuantity) > 0       
ORDER BY mCost, S.sDescription


