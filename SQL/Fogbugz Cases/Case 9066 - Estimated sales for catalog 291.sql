
/*cat 277 sales*/
select 
    sum(tblOrder.mMerchandise) as 'Merch Total',
    sum(tblOrder.mMerchandiseCost) as 'Merch Cost',
    sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders'
from tblOrder 
where 
	sMatchbackSourceCode like '277%' 
	and (dtOrderDate >= '11/16/09' and dtOrderDate <= '02/14/10')
	--and (dtOrderDate >= '05/04/09' and dtOrderDate <= '11/15/09')
	and sOrderStatus = 'Shipped'
	and sOrderChannel <> 'INTERNAL'


select 
    sum(tblOrder.mMerchandise) as 'Merch Total',
    sum(tblOrder.mMerchandiseCost) as 'Merch Cost',
    sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders'
from tblOrder 
where 
	sMatchbackSourceCode like '276%' 
	and (dtOrderDate >= '11/16/09' and dtOrderDate <= '02/14/10')
	and sOrderStatus = 'Shipped'
	and sOrderChannel <> 'INTERNAL'






select 
	sSourceCodeGiven,
    sum(tblOrder.mMerchandise) as 'Merch Total',
    sum(tblOrder.mMerchandiseCost) as 'Merch Cost',
    sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders'
from tblOrder 
where 
	sMatchbackSourceCode like '277%' 
	--sSourceCodeGiven like '277%' 
	--and (dtOrderDate >= '11/16/09' and dtOrderDate <= '02/14/10')
	--and (dtOrderDate >= '05/04/09' and dtOrderDate <= '11/15/09')
	and sOrderStatus = 'Shipped'
	and sOrderChannel <> 'INTERNAL'
group by
	sSourceCodeGiven