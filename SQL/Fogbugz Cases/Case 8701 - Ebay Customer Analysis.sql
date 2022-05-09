
select sSourceCodeGiven, sMatchbackSourceCode
from tblOrder
where sOrderChannel in ('EBAY','AUCTION')
group by sSourceCodeGiven, sMatchbackSourceCode


select * 
from tblOrder 
	left join tblCustomer on tblOrder.ixCustomer = tblCustomer.ixCustomer
where
	tblCustomer.ixSourceCode = 'EBAY' and tblOrder.sOrderStatus = 'Shipped' and dtOrderDate >= '03/01/10'



create view vwNewEbayCust
as
SELECT
     FD.ixCustomer, 
     MIN(O.ixOrder) AS ixOrder,
	 O.dtOrderDate
FROM 
     (SELECT     
		C.ixCustomer, MIN(O.dtOrderDate) AS dtOrderDate
      FROM
        dbo.tblOrder AS O 
        INNER JOIN dbo.tblCustomer AS C ON O.ixCustomer = C.ixCustomer
      WHERE
		--(O.dtOrderDate >= '01/01/2010' AND (O.dtOrderDate < '01/01/2011') and
		(O.mMerchandise > 0) AND (O.sOrderStatus = 'Shipped') AND (O.sOrderChannel in ('EBAY','AUCTION'))
		--AND 
        --(O.ixCustomer NOT IN
        --   (SELECT DISTINCT A.ixCustomer
        --    FROM dbo.tblOrder AS A
        --    WHERE(A.dtOrderDate < '01/01/10')))
      GROUP BY C.ixCustomer) AS FD
    INNER JOIN dbo.tblOrder AS O ON O.ixCustomer = FD.ixCustomer AND O.dtOrderDate = FD.dtOrderDate
GROUP BY FD.ixCustomer, O.dtOrderDate

select * from vwNewEbayCust



select * 
from tblOrder
	join vwNewEbayCust on tblOrder.ixCustomer = vwNewEbayCust.ixCustomer
where
	vwNewEbayCust.ixCustomer is not null and tblOrder.sOrderStatus not in ('Cancelled','Pick Ticket')

select 
	tblOrder.ixCustomer,
    sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders'
from tblOrder
	join vwNewEbayCust on tblOrder.ixCustomer = vwNewEbayCust.ixCustomer
where
	vwNewEbayCust.ixCustomer is not null and tblOrder.sOrderStatus not in ('Cancelled','Pick Ticket')
group by tblOrder.ixCustomer


select * from tblOrder where ixOrder in ('3095778','2769088','3210794','4108906','4109707','4462008','4712003','3263470','3756780','4325320','4269825')







/*select out non-Ebay customers*/

select
	count(distinct(tblOrder.ixCustomer)) as '# Customers',
	count(distinct(vwNewCustOrder.ixOrder)) as '# New Customers',
    sum(tblOrder.mMerchandise) as 'Merch Total',
    sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders'
from
    tblOrder
    left join vwNewCustOrder on tblOrder.ixOrder = vwNewCustOrder.ixOrder
	--left join vwNewEbayCust on tblOrder.ixCustomer = vwNewEbayCust.ixCustomer
where 	
	(tblOrder.dtOrderDate >= '03/01/10' and tblOrder.dtOrderDate <= '07/08/11')
	and
	tblOrder.mMerchandise > 0
	and
    --tblOrder.sOrderStatus not in ('Cancelled','Pick Ticket')
	tblOrder.sOrderStatus = 'Shipped'
	and
    (tblOrder.sOrderChannel not in ('INTERNAL','EBAY','AUCTION') and tblOrder.sSourceCodeGiven not in ('INTERNAL','MRR','MRRWEB','PRS','PRSWEB','EMP','EMPR','EMPS'))
	and
	(tblOrder.ixCustomer not in
           (SELECT DISTINCT ixCustomer
            FROM vwNewEbayCust ))


select
	tblOrder.ixCustomer,
	tblOrder.ixOrder,
	tblOrder.dtOrderDate,
	tblOrder.mMerchandise,
	tblOrder.sOrderType,
	tblOrder.sOrderChannel,
	--tblOrder.sSourceCodeGiven,
	tblOrder.sMatchbackSourceCode,
	vwNewCustOrder.ixOrder,
	vw_OneTimeBuyer.NumOrders
from
    tblOrder
    left join vwNewCustOrder on tblOrder.ixOrder = vwNewCustOrder.ixOrder
	--left join vwNewEbayCust on tblOrder.ixCustomer = vwNewEbayCust.ixCustomer
	left join vw_OneTimeBuyer on tblOrder.ixCustomer = vw_OneTimeBuyer.ixCustomer
where 	
	tblOrder.dtOrderDate >= '03/01/10' and tblOrder.dtOrderDate <= '07/08/11'
	and
	tblOrder.mMerchandise > 0
	and
    --tblOrder.sOrderStatus not in ('Cancelled','Pick Ticket')
	tblOrder.sOrderStatus = 'Shipped'
	and
    (tblOrder.sOrderChannel not in ('INTERNAL','EBAY','AUCTION') and tblOrder.sSourceCodeGiven not in ('INTERNAL','MRR','MRRWEB','PRS','PRSWEB','EMP','EMPR','EMPS'))
	and
	(tblOrder.ixCustomer not in
           (SELECT DISTINCT ixCustomer
            FROM vwNewEbayCust ))
group by
	tblOrder.ixCustomer,
	tblOrder.ixOrder,
	tblOrder.dtOrderDate,
	tblOrder.mMerchandise,
	tblOrder.sOrderType,
	tblOrder.sOrderChannel,
	--tblOrder.sSourceCodeGiven,
	tblOrder.sMatchbackSourceCode,
	vwNewCustOrder.ixOrder,
	vw_OneTimeBuyer.NumOrders
	




/*pulling out new customers during this time frame*/

alter view vwTempNewOrders
as
select *
from vwNewCustOrder
where dtOrderDate >= '03/01/10' and dtOrderDate <= '07/08/11'

select
	count(distinct(tblOrder.ixCustomer)) as '# Customers',
	count(distinct(vwTempNewOrders.ixCustomer)) as '# New Customers',
    sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders',
    sum(tblOrder.mMerchandise) as 'Merch Total'
from
    tblOrder
	--left join vwNewEbayCust on tblOrder.ixCustomer = vwNewEbayCust.ixCustomer
	join vwTempNewOrders on tblOrder.ixCustomer = vwTempNewOrders.ixCustomer
where 	
	tblOrder.dtOrderDate >= '03/01/10' and tblOrder.dtOrderDate <= '07/08/11'
	and
	tblOrder.mMerchandise > 0
	and
    --tblOrder.sOrderStatus not in ('Cancelled','Pick Ticket')
	tblOrder.sOrderStatus = 'Shipped'
	and
    (tblOrder.sOrderChannel not in ('INTERNAL','EBAY','AUCTION') and tblOrder.sSourceCodeGiven not in ('INTERNAL','MRR','MRRWEB','PRS','PRSWEB','EMP','EMPR','EMPS'))
	and
	(tblOrder.ixCustomer not in
           (SELECT DISTINCT ixCustomer
            FROM vwNewEbayCust ))


select
	tblOrder.ixCustomer,
	tblOrder.ixOrder,
	tblOrder.dtOrderDate,
	tblOrder.mMerchandise,
	tblOrder.sOrderType,
	tblOrder.sOrderChannel,
	--tblOrder.sSourceCodeGiven,
	tblOrder.sMatchbackSourceCode,
	vwTempNewOrders.ixOrder
from
    tblOrder
	--left join vwNewEbayCust on tblOrder.ixCustomer = vwNewEbayCust.ixCustomer
	join vwTempNewOrders on tblOrder.ixCustomer = vwTempNewOrders.ixCustomer
where 	
	tblOrder.dtOrderDate >= '03/01/10' and tblOrder.dtOrderDate <= '07/08/11'
	and
	tblOrder.mMerchandise > 0
	and
    --tblOrder.sOrderStatus not in ('Cancelled','Pick Ticket')
	tblOrder.sOrderStatus = 'Shipped'
	and
    (tblOrder.sOrderChannel not in ('INTERNAL','EBAY','AUCTION') and tblOrder.sSourceCodeGiven not in ('INTERNAL','MRR','MRRWEB','PRS','PRSWEB','EMP','EMPR','EMPS'))
	and
	(tblOrder.ixCustomer not in
           (SELECT DISTINCT ixCustomer
            FROM vwNewEbayCust ))
group by
	tblOrder.ixCustomer,
	tblOrder.ixOrder,
	tblOrder.dtOrderDate,
	tblOrder.mMerchandise,
	tblOrder.sOrderType,
	tblOrder.sOrderChannel,
	--tblOrder.sSourceCodeGiven,
	tblOrder.sMatchbackSourceCode,
	vwTempNewOrders.ixOrder

