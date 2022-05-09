-- FREQUENCY
-- Lifetime
-- drop table PJC_CustOrderCount
select ixCustomer, count(distinct ixOrder) OrdCount, sum(mMerchandise) TotSales
into PJC_CustOrderCount
from vwOrderAllHistory O
where     O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    and O.dtShippedDate >= '02/01/2006' -- for 72 month batch
group by ixCustomer

select count(ixCustomer)
from PJC_CustOrderCount
where OrdCount = 1

select count(ixCustomer)
from PJC_CustOrderCount
where OrdCount >= 2

select count(ixCustomer)
from PJC_CustOrderCount
where OrdCount >= 3

select count(ixCustomer)
from PJC_CustOrderCount
where OrdCount >= 5

/***********************/
-- MONETARY
select count(ixCustomer)
from PJC_CustOrderCount
where TotSales between 0 and 99.99

select count(ixCustomer)
from PJC_CustOrderCount
where TotSales between 100 and 199.99

select count(ixCustomer)
from PJC_CustOrderCount
where TotSales between 200 and 399.99

select count(ixCustomer)
from PJC_CustOrderCount
where TotSales between 400 and 699.99

select count(ixCustomer)
from PJC_CustOrderCount
where TotSales between 700 and 999.99

select count(ixCustomer)
from PJC_CustOrderCount
where TotSales > 999.99


-- Source of Customers with at least 1 purchase
select count(C.ixCustomer) CustCount,SCT.sDescription 'SC Type'
from tblCustomer C
    left join tblSourceCode SC on C.ixSourceCode = SC.ixSourceCode
    left join tblSourceCodeType SCT on SC.sSourceCodeType = SCT.ixSourceCodeType
    join PJC_CustOrderCount CC on C.ixCustomer = CC.ixCustomer
--where C.dtAccountCreateDate >= '02/01/2006'
group by SCT.sDescription
order by SCT.sDescription  
