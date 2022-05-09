-- UK Source Code

-- see FB#20155  Source Code Deactivate
select * from tblSourceCode
where ixSourceCode in ('NA', 'WO', 'UK')

select * from tblCatalogMaster where sDescription = 'GEN.13'
/*
According to the [SMI Reporting] that source code is currently has the following attributes:

assigned to: Catalog 355
start date: 09/30/2013 
end date:   10/14/2014
Soure Code Type: CAT-H
Quantity Printed: 9,344
*/
-- Kyle says this source code is identical to 35510 (including the Qty printed, which is entered manually once they get the bill from the printer)

     
select * from tblCustomerOffer where ixSourceCode = 'UK'
-- There are only 388 customer offer records with that SourceCode however the CreateDate 
-- shows 10-05-2010 and the Active Star and End dates are older than that 12/31/2007 and 12/31/2009

select * from tblOrder
where sSourceCodeGiven in ('NA', 'WO', 'UK')
or sMatchbackSourceCode in ('NA', 'WO', 'UK')

select * from tblOrder
where sSourceCodeGiven = 'UK'
or sMatchbackSourceCode = 'UK'
and ixOrderDate >= 16438

select sum(mMerchandise) from tblOrder
where sSourceCodeGiven = 'UK'
or sMatchbackSourceCode = 'UK'
and ixOrderDate >= 16438

select count(ixOrder) -- 550
from tblOrder O
where sSourceCodeGiven = 'UK'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '01/01/2013' and '12/31/2013'
    
select count(ixOrder) -- 186
from tblOrder O
where sMatchbackSourceCode = 'UK'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '01/01/2013' and '12/31/2013'  


select ixOrder, dtOrderDate, sSourceCodeGiven, sMatchbackSourceCode  -- 186
from tblOrder O
where (sMatchbackSourceCode = 'UK'
       OR
       sMatchbackSourceCode = 'UK')
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '10/12/2013' and '12/31/2013'      
ORDER by dtOrderDate     
    
    


