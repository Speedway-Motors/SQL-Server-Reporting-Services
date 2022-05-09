-- sum of ORDERLINE merchandise price <> ORDER merchandise price
SELECT O.ixOrder,
	   O.dtOrderDate,
	   O.mMerchandise         OMerch,
	   sum(OL.mExtendedPrice) OLMerch,
	      (O.mMerchandise - sum(OL.mExtendedPrice)) Delta
FROM  tblOrder O
	   left join tblOrderLine OL on OL.ixOrder = O.ixOrder
WHERE  OL.flgKitComponent = 0
  -- and O.dtOrderDate >= '01/01/08'
--and   
	and OL.flgLineStatus in ('Shipped','Dropshipped')
GROUP BY O.ixOrder,
	      O.dtOrderDate,
	      O.mMerchandise
HAVING -- since OL prices go to 3 dec point, there are many with a delta less +/- 1 cent
        (O.mMerchandise - sum(OL.mExtendedPrice)) >  .01
     OR (O.mMerchandise - sum(OL.mExtendedPrice)) < -.01
ORDER BY O.dtOrderDate




