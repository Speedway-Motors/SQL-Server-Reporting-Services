/******************************************************************
Case: 13920
Desc: Order Cascade Analysis for Marketing

Notes: The groups overlap.  e.g. The 3Mo counts are a
    subset of the 6Mo counts, the 6Mo a subset of the 12Mo.
    Excluded backorders
*******************************************************************/
 

-- 11Q2-12Q1 12 Month
select O.ixCustomer
from tblOrder O
    join tblDate D on O.ixShippedDate = D.ixDate
where   O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    and O.ixOrder not like '%-%' -- excluding backorders
    and O.dtShippedDate between '04/01/2011' and '03/31/2012'
group by ixCustomer   
having COUNT(O.ixOrder) >= 1 -- changed minimum order count ard re-ran for each set


-- 11Q4-12Q1 6 Month
select O.ixCustomer
from tblOrder O
    join tblDate D on O.ixShippedDate = D.ixDate
where   O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    and O.ixOrder not like '%-%'
    and O.dtShippedDate between '10/01/2011' and '03/31/2012'
group by ixCustomer   
having COUNT(O.ixOrder) >= 1


-- 12Q1 3 Month
select O.ixCustomer
from tblOrder O
    join tblDate D on O.ixShippedDate = D.ixDate
where   O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    and O.ixOrder not like '%-%'
    and O.dtShippedDate between '01/01/2012' and '03/31/2012'
group by ixCustomer   
having COUNT(O.ixOrder) >= 1





    
    


    