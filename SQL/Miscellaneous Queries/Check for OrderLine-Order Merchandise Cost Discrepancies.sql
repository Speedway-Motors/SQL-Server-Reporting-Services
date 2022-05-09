-- sum of ORDERLINE merchandise cost <> ORDER merchandise cost
SELECT   O.ixOrder,
	      O.dtOrderDate,
	      O.mMerchandiseCost    OMerchCost,
	      sum(OL.mExtendedCost) OLMerchCost,
         (sum(OL.mExtendedCost) - O.mMerchandiseCost) Dif
FROM  tblOrder O
	   left join tblOrderLine OL on OL.ixOrder = O.ixOrder
WHERE  OL.flgKitComponent = 0
  -- and O.dtShippedDate < '01/01/11'
   and O.dtShippedDate > DATEADD(mm, -3, getdate())
	and OL.flgLineStatus in ('Shipped','Dropshipped') -- 
   and O.sOrderStatus = 'Shipped'
GROUP BY O.ixOrder,
	      O.dtOrderDate,
	      O.mMerchandiseCost
HAVING ABS(O.mMerchandiseCost - sum(OL.mExtendedCost))> 1
ORDER BY	Dif desc

select DATEADD(mm, -2, getdate()) 

select ixOrder, mExtendedPrice ExPrice, mExtendedCost ExCost, iQuantity QTY, mUnitPrice, mCost,
 flgLineStatus, flgKitComponent KitComp, iOrdinality Ordin, dtOrderDate, dtShippedDate 
from tblOrderLine where ixOrder = '3802991'

select ixOrder, mMerchandise MerchPR, mMerchandiseCost MerchCost, -- flgsBackorder
 sOrderStatus,sOrderChannel,  dtOrderDate, dtShippedDate
from tblOrder where ixOrder = '3802991'

/*
ixOrder	ExPrice	ExCost	QTY	mUnitPrice	mCost	   flgLineStatus	KitComp	Ordin	dtOrderDate	dtShippedDate
4232109	859.99	627.79	1	   859.99	   627.79	Dropshipped	   0	      1	   2011-01-07 00:00:00.000	2011-01-07 00:00:00.000
4232109	634.99	463.54	1	   634.99	   463.54	Dropshipped	   0	      2	   2011-01-07 00:00:00.000	2011-01-07 00:00:00.000

ixOrder	Merch	   MerchCost	sOrderStatus	sOrderChannel	dtOrderDate	dtShippedDate
4232109	1494.98	0.00	      Shipped	      PHONE	         2011-01-07 00:00:00.000	2011-01-07 00:00:00.000
*/
select top 1 * from tblOrderLine
select top 1 * from tblOrder




SELECT   O.mMerchandise         OMerch,
	      sum(OL.mExtendedPrice) OLMerch,
         (O.mMerchandise  - sum(OL.mExtendedPrice)) Dif
FROM  tblOrder O
	   left join tblOrderLine OL on OL.ixOrder = O.ixOrder
WHERE  OL.flgKitComponent = 0
   and O.dtShippedDate < '01/01/10'
  -- and O.dtShippedDate < '01/01/11'
	and OL.flgLineStatus in ('Shipped','Dropshipped') -- ,'Dropshipped'
   and O.sOrderStatus = 'Shipped'
GROUP BY O.ixOrder,
	      O.dtOrderDate,
	      O.mMerchandise
HAVING ABS(O.mMerchandise - sum(OL.mExtendedPrice)) > 1
ORDER BY	Dif desc








