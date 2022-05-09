SELECT 
	(case when iShipMethod in (2,3,4,5,10,11,12) then 'UPS'
	 else 'Other' end)as 'ShipMethod', 
	(case when mMerchandise >= 0 and mMerchandise <= 19.99 then '$0-$20'
	      when mMerchandise >= 20 and mMerchandise <= 39.99 then '$20-$40'
		  when mMerchandise >= 40 and mMerchandise <= 99.99 then '$40-$100'
		  when mMerchandise >= 100 and mMerchandise <= 199.99 then '$100-$200'
		  when mMerchandise >= 200 and mMerchandise <= 349.99 then '$200-$350'
		  when mMerchandise >= 350 and mMerchandise <= 499.99 then '$350-$500'
		  when mMerchandise >= 500 and mMerchandise <= 749.99 then '$500-$750'
	      when mMerchandise >= 750 and mMerchandise <= 999.99 then '$750-$1000'
		  when mMerchandise >= 1000 and mMerchandise <= 1249.99 then '$1000-$1250'
		  when mMerchandise >= 1250 and mMerchandise <= 1599.99 then '$1250-$1600'
		  else '$1600+' end) as 'SalesAmt',
	count(ixOrder) as 'Orders',
	sum(mMerchandise) as 'Sales',
	sum(mShipping) as 'Shipping'
FROM tblOrder
WHERE  dtShippedDate > '01/15/2011'
   and sShipToCountry = 'CANADA'
--and sShipToCountry in ('US','USA')
GROUP BY 
	(case when mMerchandise >= 0 and mMerchandise <= 19.99 then '$0-$20'
	      when mMerchandise >= 20 and mMerchandise <= 39.99 then '$20-$40'
		  when mMerchandise >= 40 and mMerchandise <= 99.99 then '$40-$100'
		  when mMerchandise >= 100 and mMerchandise <= 199.99 then '$100-$200'
		  when mMerchandise >= 200 and mMerchandise <= 349.99 then '$200-$350'
		  when mMerchandise >= 350 and mMerchandise <= 499.99 then '$350-$500'
		  when mMerchandise >= 500 and mMerchandise <= 749.99 then '$500-$750'
	      when mMerchandise >= 750 and mMerchandise <= 999.99 then '$750-$1000'
		  when mMerchandise >= 1000 and mMerchandise <= 1249.99 then '$1000-$1250'
		  when mMerchandise >= 1250 and mMerchandise <= 1599.99 then '$1250-$1600'
		  else '$1600+' end),
	(case when iShipMethod in (2,3,4,5,10,11,12) then 'UPS'
	 else 'Other' end)

--ORDER BY QTY desc
/*
iShipMethod	QTY
10	511
8	181
12	176
11	51
1	4
*/

