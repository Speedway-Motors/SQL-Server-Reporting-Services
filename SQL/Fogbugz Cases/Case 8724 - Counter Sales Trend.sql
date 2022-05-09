select
	tblDate.iPeriodYear,
	tblDate.iPeriod,
	--tblDate.iDayOfWeek,
	--tblOrder.sOrderChannel,
    sum(tblOrder.mMerchandise) as 'Merch Total',
    sum(tblOrder.mMerchandiseCost) as 'Merch Cost',
    sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders',
	count(distinct(tblOrder.ixCustomer)) as '# Customers',
	count(distinct(vwNewCustOrder.ixOrder)) as '# New Customers'
from
	tblOrder
    left join vwNewCustOrder on tblOrder.ixOrder = vwNewCustOrder.ixOrder
    left join tblDate on tblOrder.ixOrderDate = tblDate.ixDate
	left join tblCustomer on tblOrder.ixCustomer = tblCustomer.ixCustomer
where
	(tblOrder.sOrderChannel = 'COUNTER' and tblOrder.sSourceCodeGiven not in ('INTERNAL','MRR','MRRWEB','PRS','PRSWEB','EMP','EMPR','EMPS'))
    --(tblOrder.sOrderChannel <> 'INTERNAL' and tblOrder.sSourceCodeGiven not in ('INTERNAL','MRR','MRRWEB','PRS','PRSWEB','EMP','EMPR','EMPS'))
	and	tblOrder.sOrderStatus = 'Shipped'
	and	tblOrder.dtOrderDate >= '01/05/08'
	and tblOrder.sMethodOfPayment <> 'ACCTS RCVBL'
	and tblOrder.mMerchandise > 0
	and tblCustomer.sMailToState not in ('AU','BC','F','GR','MAN','MB','NA','NSW','ONT','ON','QN','SK','STATE')
	and tblCustomer.sMailToState is not NULL
group by
	tblDate.iPeriodYear,
	tblDate.iPeriod--,
	--tblDate.iDayOfWeek,
	--tblOrder.sOrderChannel
	




select
	tblDate.iYear,
	tblDate.iMonth,
	--tblOrder.ixOrder,
	--tblOrder.ixCustomer,
	--tblOrder.sShipToCity,
	--tblOrder.sShipToState,
	tblCustomer.sMailToCity,
	tblCustomer.sMailToState,
    sum(tblOrder.mMerchandise) as 'Merch Total',
    sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders'
from tblOrder
	left join tblCustomer on tblOrder.ixCustomer = tblCustomer.ixCustomer
	left join tblDate on tblOrder.ixOrderDate = tblDate.ixDate
where 
	sOrderChannel = 'COUNTER' 
	and ((tblOrder.dtOrderDate >= '01/01/10' and tblOrder.dtOrderDate <= '06/30/10') OR (tblOrder.dtOrderDate >= '01/01/11' and tblOrder.dtOrderDate <= '06/30/11'))
	and sOrderStatus = 'Shipped'
	and tblOrder.sSourceCodeGiven not in ('INTERNAL','MRR','MRRWEB','PRS','PRSWEB','EMP','EMPR','EMPS')
	and tblOrder.sMethodOfPayment <> 'ACCTS RCVBL'
	and tblOrder.mMerchandise > 0
group by 
	tblDate.iYear,
	tblDate.iMonth,
	--tblOrder.ixOrder,
	--tblOrder.ixCustomer,
	--tblOrder.sShipToCity,
	--tblOrder.sShipToState,
	tblCustomer.sMailToCity,
	tblCustomer.sMailToState







