-- Case 23904 - 2013 Holiday BFCM average orders

/*
11/27/13 - 12/03/13 
Total Orders
AOV
Between $0 and $49
Between $50 and $99
Between $100 and $149
Between $150 and $199
Between $200 and $249
Between $250 and $299
Between $300 and $349
Between $350 and $399
$400+
*/

select COUNT(O.ixOrder) OrdCnt,
  (Case when O.mMerchandise Between 0.01 and 49.99 then '$.01-$ 49.99'
        when O.mMerchandise Between  50 and  99.99 then '$50 -$ 99.99'
        when O.mMerchandise Between 100 and 149.99 then '$100-$149.99'
        when O.mMerchandise Between 150 and 199.99 then '$150-$199.99'
        when O.mMerchandise Between 200 and 249.99 then '$200-$249.99'
        when O.mMerchandise Between 250 and 299.99 then '$250-$299.99'
        when O.mMerchandise Between 300 and 349.99 then '$300-$349.99'
        when O.mMerchandise Between 350 and 399.99 then '$350-$399.99'
        when O.mMerchandise >= 400 then '$400+'
        Else 'RuhRoh'
        End) SalesGroup
from tblOrder O
WHERE   O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    --and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtOrderDate between '11/27/13' and '12/03/13'
    and (O.ixCustomerType is NULL
         or
        O.ixCustomerType not in ('30','40')
        )
Group by  (Case when O.mMerchandise Between 0.01 and 49.99 then '$.01-$ 49.99'
        when O.mMerchandise Between  50 and  99.99 then '$50 -$ 99.99'
        when O.mMerchandise Between 100 and 149.99 then '$100-$149.99'
        when O.mMerchandise Between 150 and 199.99 then '$150-$199.99'
        when O.mMerchandise Between 200 and 249.99 then '$200-$249.99'
        when O.mMerchandise Between 250 and 299.99 then '$250-$299.99'
        when O.mMerchandise Between 300 and 349.99 then '$300-$349.99'
        when O.mMerchandise Between 350 and 399.99 then '$350-$399.99'
        when O.mMerchandise >= 400 then '$400+'
        Else 'RuhRoh'
        End)   
Order by SalesGroup    
    
select ixCustomerType, count(*)
from tblOrder O
where O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    --and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtOrderDate between '11/27/13' and '12/03/13'
group by ixCustomerType    


select * from tblOrder O
where dtOrderDate between '11/27/13' and '12/03/13'
and ixCustomerType is NULL
and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    --and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtOrderDate between '11/27/13' and '12/03/13'
    
    
select SUM(mMerchandise)
from tblOrder O
WHERE   O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    --and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtOrderDate between '11/27/13' and '12/03/13'
    and (O.ixCustomerType is NULL
         or
        O.ixCustomerType not in ('30','40')
        )    