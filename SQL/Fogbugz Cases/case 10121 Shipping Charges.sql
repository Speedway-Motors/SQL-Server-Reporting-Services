select iShipMethod MoP, count(ixOrder) NumOrders, sum(mShipping) Shipping
from tblOrder
where dtOrderDate between '01/01/10' and '07/30/10'
   and sOrderStatus = 'Shipped'
   and sOrderChannel <> 'Internal'
   and ixCustomer <> '15242' -- Excluding Speedway
   and mMerchandise <> 0
group by iShipMethod
order by iShipMethod

select iShipMethod MoP, count(ixOrder) NumOrders, sum(mShipping) Shipping
from tblOrder
where dtOrderDate between '01/01/11' and '07/30/11'
   and sOrderStatus = 'Shipped'
   and sOrderChannel <> 'Internal'
   and ixCustomer <> '15242' -- Excluding Speedway
   and mMerchandise <> 0
group by iShipMethod
order by iShipMethod




-- FREE SHIPPING
select iShipMethod MoP, count(ixOrder) NumOrders, sum(mShipping) Shipping -- 6,796 to 6,590
from tblOrder
where dtOrderDate between '01/01/10' and '07/30/10'
   and sOrderStatus = 'Shipped'
   and sOrderChannel <> 'Internal'
   and ixCustomer <> '15242' -- Excluding Speedway
   and (mShipping = 0 or mShipping is NULL)
   and mMerchandise <> 0
group by iShipMethod
order by iShipMethod

select iShipMethod MoP, count(ixOrder) NumOrders, sum(mShipping) Shipping
from tblOrder
where dtOrderDate between '01/01/11' and '07/30/11'
   and sOrderStatus = 'Shipped'
   and sOrderChannel <> 'Internal'
   and ixCustomer <> '15242' -- Excluding Speedway
   and mMerchandise <> 0
   and (mShipping = 0 or mShipping is NULL)
group by iShipMethod
order by iShipMethod




-- Avg shipper per Customer
select isNull(SH2010.ixCustomer,SH2011.ixCustomer),
		SH2010.NumOrders2010,
		SH2010.Shipping2010,
		SH2010.AvgSHperOrder2010,
		SH2011.NumOrders2011,
		SH2011.Shipping2011,
		SH2011.AvgSHperOrder2011
FROM
	(select ixCustomer, count(ixOrder) NumOrders2010, sum(mShipping) Shipping2010, sum(mShipping)/count(ixOrder) AvgSHperOrder2010
	from tblOrder
	where dtOrderDate between '01/01/10' and '07/30/10'
	   and sOrderStatus = 'Shipped'
	   and sOrderChannel <> 'Internal'
	   and ixCustomer <> '15242' -- Excluding Speedway
	group by ixCustomer
	) SH2010
FULL OUTER JOIN 
	(select ixCustomer, count(ixOrder) NumOrders2011, sum(mShipping) Shipping2011, sum(mShipping)/count(ixOrder) AvgSHperOrder2011
	from tblOrder
	where dtOrderDate between '01/01/11' and '07/30/11'
	   and sOrderStatus = 'Shipped'
	   and sOrderChannel <> 'Internal'
	   and ixCustomer <> '15242' -- Excluding Speedway
	group by ixCustomer
	) SH2011 on SH2010.ixCustomer = SH2011.ixCustomer
ORDER BY isNull(SH2010.ixCustomer,SH2011.ixCustomer)


/*
SELECT sOrderStatus, count(*)
from tblOrder
where dtOrderDate between '01/01/10' and '07/30/11'
group by sOrderStatus
*/