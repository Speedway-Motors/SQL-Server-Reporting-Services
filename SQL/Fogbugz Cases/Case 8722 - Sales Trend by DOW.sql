--select dtDate, iDayOfWeek from tblDate where dtDate >= '06/01/11'

--dtDate					iDayOfWeek
--2011-06-06 00:00:00.000	1=monday
--2011-06-07 00:00:00.000	2=tuesday
--2011-06-08 00:00:00.000	3=wednesday
--2011-06-09 00:00:00.000	4=thursday
--2011-06-10 00:00:00.000	5=friday
--2011-06-11 00:00:00.000	6=saturday
--2011-06-12 00:00:00.000	7=sunday


select
	(case when vwNewCustOrder.ixOrder is not null then 'New'
	  else 'NotNew' end) as 'NewCustomer',
	tblDate.iPeriodYear,
	tblDate.iPeriod,
	tblDate.iDayOfWeek,
	tblOrder.sOrderChannel,
    sum(tblOrder.mMerchandise) as 'Merch Total',
    sum(tblOrder.mMerchandiseCost) as 'Merch Cost',
    sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders',
	count(distinct(tblOrder.ixCustomer)) as '# Customers',
	count(distinct(vwNewCustOrder.ixOrder)) as '# New Customers'
from
	tblOrder
    left join vwNewCustOrder on tblOrder.ixOrder = vwNewCustOrder.ixOrder
    left join tblDate on tblOrder.ixOrderDate = tblDate.ixDate
where
    (tblOrder.sOrderChannel <> 'INTERNAL' and tblOrder.sSourceCodeGiven not in ('INTERNAL','MRR','MRRWEB','PRS','PRSWEB','EMP','EMPR','EMPS'))
	and
	tblOrder.sOrderStatus not in ('Cancelled','Pick Ticket')
	and
	tblOrder.dtOrderDate >= '01/05/08'
group by
	(case when vwNewCustOrder.ixOrder is not null then 'New'
	  else 'NotNew' end),
	tblDate.iPeriodYear,
	tblDate.iPeriod,
	tblDate.iDayOfWeek,
	tblOrder.sOrderChannel
	
