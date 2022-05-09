-- Two most recent orders for every customer
INSERT into [SMITemp].dbo.CustomerTwoMostRecentOrders_Rollup
SELECT *
--into [SMITemp].dbo.CustomerTwoMostRecentOrders_Rollup
FROM (
                SELECT O.ixCustomer, O.ixOrder, dtShippedDate, C.dtAccountCreateDate, -- 3,385,161 @ 1 minute
                    dense_rank() over (PARTITION by O.ixCustomer order by dtShippedDate desc, O.ixOrder desc) as OrderRank  
                -- Newer versions of SQL support the lag function which would have been really helpful here.
                --     , LAG( dtOrderDate,1,null) over (PARTITION by ixCustomer order by dtOrderDate ) as rnk
                from  tblOrder O
                    left join tblCustomer C on O.ixCustomer = C.ixCustomer
                WHERE O.sOrderStatus = 'Shipped'
                    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                    and O.sOrderType <> 'Internal'   -- USUALLY filtered
                ) R
WHERE OrderRank <= 2 
ORDER BY ixCustomer, OrderRank   
--  O.ixCustomer in (10082, 1128952)
-- TRUNCATE TABLE [SMITemp].dbo.CustomerTwoMostRecentOrders_Rollup 
-- DROP TABLE [SMITemp].dbo.CustomerTwoMostRecentOrders_Rollup 
select top 10 * from [SMITemp].dbo.CustomerTwoMostRecentOrders_Rollup
select count(*) from [SMITemp].dbo.CustomerTwoMostRecentOrders_Rollup -- 1151547

select * from [SMITemp].dbo.CustomerTwoMostRecentOrders_Rollup
where ixCustomer in ('1794861','664216')


select ixCustomer, COUNT(*)
from [SMITemp].dbo.CustomerTwoMostRecentOrders_Rollup
group by ixCustomer
having COUNT(*) > 2
ORDER BY  COUNT(*) desc

select * from [SMITemp].dbo.CustomerTwoMostRecentOrders_Rollup -- 14 orders shipped on 2 days!?!
where ixCustomer = '1050047'

select * from tblCustomer
where ixCustomer = '1050047'

select * from tblOrder where  ixCustomer = '878387'
and sOrderStatus = 'Shipped'
order by dtShippedDate