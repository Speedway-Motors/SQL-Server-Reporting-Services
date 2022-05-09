-- Average age of BackOrders

SELECT (CASE WHEN DATEDIFF(MONTH,dtOrderDate, getdate()) < 4 THEN '  0-3'
			 WHEN DATEDIFF(MONTH,dtOrderDate, getdate()) between 4 and 6 THEN '  4-6'
			 WHEN DATEDIFF(MONTH,dtOrderDate, getdate()) between 7 and 9 THEN '  7-9'
			 WHEN DATEDIFF(MONTH,dtOrderDate, getdate()) between 10 and 12 THEN ' 10-12'
			 WHEN DATEDIFF(MONTH,dtOrderDate, getdate()) > 12 THEN '> 12'
			 ELSE 'UK'
			 END) AS 'Months Old',
	count(ixOrder) 'BOcnt'
from tblOrder
where sOrderStatus = 'Backordered'
group by (CASE WHEN DATEDIFF(MONTH,dtOrderDate, getdate()) < 4 THEN '  0-3'
			 WHEN DATEDIFF(MONTH,dtOrderDate, getdate()) between 4 and 6 THEN '  4-6'
			 WHEN DATEDIFF(MONTH,dtOrderDate, getdate()) between 7 and 9 THEN '  7-9'
			 WHEN DATEDIFF(MONTH,dtOrderDate, getdate()) between 10 and 12 THEN ' 10-12'
			 WHEN DATEDIFF(MONTH,dtOrderDate, getdate()) > 12 THEN '> 12'
			 ELSE 'UK'
			 END)
ORDER BY 'Months Old'
/*
Months 
Old		BOcnt	AsOf
=====	=====	=======
  0-3	4,042	3/15/22
  4-6	1,353
  7-9	  958
 10-12	  646
> 12	  435
*/




-- REFED BOs older than 6 months.  No status change on any of the records
select ixOrder, dtDateLastSOPUpdate
from tblOrder
where dtOrderDate < '03/16/2021'
	and sOrderStatus = 'Backordered'
order by dtDateLastSOPUpdate -- 490

select dtOrderDate, count(*)
from tblOrder
where sOrderStatus = 'Backordered'
group by dtOrderDate
order by dtOrderDate

SELECT DATEDIFF(MONTH,dtOrderDate, getdate())  'months old',
	count(ixOrder) 'BOcnt'
from tblOrder
where sOrderStatus = 'Backordered'
group by DATEDIFF(MONTH,dtOrderDate, getdate())
ORDER BY DATEDIFF(MONTH,dtOrderDate, getdate())

