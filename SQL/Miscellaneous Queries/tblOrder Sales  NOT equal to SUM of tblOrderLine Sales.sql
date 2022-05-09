-- tblOrder Sales <> sum of tblOrderLine Sales
SELECT   O.ixOrder,
	      O.dtOrderDate,
	      O.mMerchandise    'OMerchSales',
	      sum(OL.mExtendedPrice) OLMerch,
         (sum(OL.mExtendedPrice) - O.mMerchandise) Dif
FROM  tblOrder O
	   left join tblOrderLine OL on OL.ixOrder = O.ixOrder
WHERE  OL.flgKitComponent = 0
  --  and O.dtOrderDate >= '01/01/13'
  and O.dtShippedDate >= '01/01/13'
  -- and O.dtShippedDate > DATEADD(mm, -3, getdate()) -- last 3 months
	--and OL.flgLineStatus in ('Shipped','Dropshipped')  
  and O.sOrderStatus = 'Shipped'
GROUP BY O.ixOrder,
	      O.dtOrderDate,
	      O.mMerchandise
HAVING (O.mMerchandise - sum(OL.mExtendedPrice))> 0
ORDER BY	Dif desc
