-- SMIHD-4532 generate prelim report for fraud tool
See C#2173460

This has the potential to be the largest fraud loss for Speedway in the last 20 years.  

We need to put an additional fraud tool in place.  
My first thought is that I want an email to be sent  once 

any customer (except flags of 30,32, 40, 45, 46, 80, or 82.1)  
orders (base off of order date not ship date) for the third (or more) time within a seven day period.   

This may be too restrictive.  

I need a preliminary report generated (either pdf or excel) which would give me an idea of how many times this has happened in the last year.  
Customer # /Customer Flag /Order number / Order date / Total amount / MOP.


select 
distinct o1.ixCustomer
from
tblOrder o1
inner join tblOrder o2 on o1.ixOrder <> o2.ixOrder and o1.ixCustomer = o2.ixCustomer  and abs(datediff(day,o1.dtOrderDate,o2.dtOrderDate)) < 7 AND o2.dtOrderDate >= '01/01/2016'
inner join tblOrder o3 on o1.ixOrder <> o3.ixOrder and o2.ixOrder <> o3.ixOrder and o1.ixCustomer = o3.ixCustomer  and abs(datediff(day,o2.dtOrderDate,o3.dtOrderDate)) < 7 AND o3.dtOrderDate >= '01/01/2016'
where o1.dtOrderDate >= '01/01/2016'




-- DROP TABLE [SMITemp].dbo.PJC_SMIHD4523_CODcusts3plusOrdersYTD
select C.ixCustomer, D.iISOWeek, Count(ixOrder) OrdCnt
into [SMITemp].dbo.PJC_SMIHD4523_CODcusts3plusOrdersYTD -- 89 Custs
from tblOrder O
    join tblCustomer C on O.ixCustomer = C.ixCustomer
    join tblDate D on O.ixShippedDate = D.ixDate
where dtShippedDate >= '01/01/2016' 
    and C.ixCustomerType NOT IN ('30','32', '35', '40', '44', '45', '46', '80', '82.1')  
    and O.sOrderStatus = 'Shipped'
    and O.ixOrder NOT LIKE '%-%'
    and O.ixOrder NOT LIKE 'PC%'
    and O.ixOrder NOT LIKE 'Q%'
    and O.mMerchandise > 0
    and O.ixCustomer in (Select distinct ixCustomer from tblOrder
                         where dtShippedDate >= '01/01/2016' and sMethodOfPayment = 'COD')
GROUP BY C.ixCustomer, D.iISOWeek   
HAVING COUNT(ixOrder) > 2

-- DROP TABLE [SMITemp].dbo.PJC_SMIHD4523_CustsToReview
SELECT distinct ixCustomer -- 56
into [SMITemp].dbo.PJC_SMIHD4523_CustsToReview
from [SMITemp].dbo.PJC_SMIHD4523_CODcusts3plusOrdersYTD



SELECT O.ixCustomer, O.ixCustomerType, O.ixOrder, O.dtOrderDate, O.mMerchandise, O.sMethodOfPayment
from tblOrder O
   -- join [SMITemp].dbo.PJC_SMIHD4523_CustsToReview T on O.ixCustomer = T.ixCustomer
where dtShippedDate >= '05/25/2016' 
    and O.ixCustomerType NOT IN ('30','32', '35', '40', '44', '45', '46', '80', '82.1') 
    and O.sOrderStatus = 'Shipped'
    and O.ixOrder NOT LIKE '%-%'
    and O.ixOrder NOT LIKE 'PC%'
    and O.ixOrder NOT LIKE 'Q%'
    and O.sMethodOfPayment NOT IN ('CASH','ACCTS RCVBL')
    and O.mMerchandise > 100  
    and O.ixCustomer in 
                            (select C.ixCustomer--, D.iISOWeek, Count(ixOrder) OrdCnt
                            from tblOrder O
                                join tblCustomer C on O.ixCustomer = C.ixCustomer
                            where dtShippedDate >= '05/25/2016' 
                                and C.ixCustomerType NOT IN ('30','32', '35', '40', '44', '45', '46', '80', '82.1')  
                                and O.sOrderStatus = 'Shipped'
                                and O.ixOrder NOT LIKE '%-%'
                                and O.ixOrder NOT LIKE 'PC%'
                                and O.ixOrder NOT LIKE 'Q%'
                                and O.sMethodOfPayment NOT IN ('CASH','ACCTS RCVBL')
                                and O.mMerchandise > 100
                                and O.ixCustomer in (Select distinct ixCustomer from tblOrder
                                                     where dtShippedDate >= '05/25/2016' and sMethodOfPayment = 'COD')
                            GROUP BY C.ixCustomer--, D.iISOWeek   
                            HAVING COUNT(ixOrder) > 2
                           )
ORDER by ixCustomer, O.dtOrderDate, O.ixOrder





SELECT O.ixCustomer, O.ixCustomerType, O.ixOrder, O.dtOrderDate, O.mMerchandise, O.sMethodOfPayment
from tblOrder O
   -- join [SMITemp].dbo.PJC_SMIHD4523_CustsToReview T on O.ixCustomer = T.ixCustomer
where dtShippedDate >=  DATEADD(dd, -8, getdate())  -- past 8 days
    and O.ixCustomerType NOT IN ('30','32', '35', '40', '44', '45', '46', '80', '82.1') 
    and O.sOrderStatus = 'Shipped'
    and O.ixOrder NOT LIKE '%-%'
    and O.ixOrder NOT LIKE 'PC%'
    and O.ixOrder NOT LIKE 'Q%'
    and O.sMethodOfPayment NOT IN ('CASH','ACCTS RCVBL')
    and O.mMerchandise > 100  
    and O.ixCustomer in 
                            (select C.ixCustomer--, D.iISOWeek, Count(ixOrder) OrdCnt
                            from tblOrder O
                                join tblCustomer C on O.ixCustomer = C.ixCustomer
                            where dtShippedDate >=  DATEADD(dd, -8, getdate())  -- past 8 days 
                                and C.ixCustomerType NOT IN ('30','32', '35', '40', '44', '45', '46', '80', '82.1')  
                                and O.sOrderStatus = 'Shipped'
                                and O.ixOrder NOT LIKE '%-%'
                                and O.ixOrder NOT LIKE 'PC%'
                                and O.ixOrder NOT LIKE 'Q%'
                                and O.sMethodOfPayment NOT IN ('CASH','ACCTS RCVBL')
                                and O.mMerchandise > 100
                                and O.ixCustomer in (Select distinct ixCustomer from tblOrder
                                                     where dtShippedDate >=  DATEADD(dd, -8, getdate())  -- past 8 days
                                                          and sMethodOfPayment = 'COD')
                            GROUP BY C.ixCustomer--, D.iISOWeek   
                            HAVING COUNT(ixOrder) > 2
                           )
ORDER by ixCustomer, O.dtOrderDate, O.ixOrder


SELECT distinct dtOrderDate, datepart("dd",DATEADD(dd, -7, dtOrderDate) )
from tblOrder
where dtOrderDate >=  DATEADD(dd, -8, getdate())  -- past 8 days
order by dtOrderDate


and dtOrderDate >= '06/01/2016'
order by dtOrderDate



select distinct sMethodOfPayment from tblOrder
/*
ixCustomer	iISOWeek	OrdCnt
2173460	19	6
975658	1	4
*/


select * from tblCustomerType where ixCustomerType in ('35','44')

select * from tblMethodOfPayment


select * from tblOrder where ixCustomer = '975658'


select * from tblBOMTemplateMaster where ixFinishedSKU = '91645542'
