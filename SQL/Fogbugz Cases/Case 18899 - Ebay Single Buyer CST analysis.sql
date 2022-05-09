-- Case 18899 - Ebay Single Buyer CST analysis

/* ran EXEC spCSTSegmentPull 12,'1','1','SR','SR' 
    kept only the records with 1 Order and Monetary < $100
    imported them into PJC_18899_SingleBuyers 
*/
select count(*) from PJC_18899_SingleBuyers                     -- 26,170
select count(distinct ixCustomer) from PJC_18899_SingleBuyers   -- 26,170

delete from PJC_18899_SingleBuyers
where Monetary >= 100.00


update SB 
set SB.OrigSC = C.ixSourceCode
from PJC_18899_SingleBuyers SB
 join [SMI Reporting].dbo.tblCustomer C on SB.ixCustomer = C.ixCustomer
where C.flgDeletedFromSOP = 0 

select * from PJC_18899_SingleBuyers

-- adding the SC from their first/only order
update SB 
set SB.FirstOrdSCGiven = O.sSourceCodeGiven
from PJC_18899_SingleBuyers SB
 join [SMI Reporting].dbo.tblOrder O on SB.ixCustomer = O.ixCustomer
where     O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
  --  and O.dtShippedDate between '01/01/2012' and '12/31/2012'

select * from PJC_18899_SingleBuyers order by  FirstOrdSCGiven 
  
  
  
  
-- adding the MBSC from their first/only order
update SB 
set SB.FirstOrdSCMB = O.sMatchbackSourceCode
from PJC_18899_SingleBuyers SB
 join [SMI Reporting].dbo.tblOrder O on SB.ixCustomer = O.ixCustomer
where     O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders

select * from PJC_18899_SingleBuyers order by  FirstOrdSCMB 




/************** 24 MONTH **********************/
/* ran EXEC spCSTSegmentPull 24,'1','1','SR','SR' 
    kept only the records with 1 Order and Monetary < $100
    imported them into PJC_18899_SingleBuyers_24M 
*/
select count(*) from PJC_18899_SingleBuyers_24M                     -- 47,496
select count(distinct ixCustomer) from PJC_18899_SingleBuyers_24M   -- 47,496

delete from PJC_18899_SingleBuyers_24M
where ixCustomer in (select ixCustomer from PJC_18899_SingleBuyers) -- 26,170

select count(*) from PJC_18899_SingleBuyers_24M                     -- 21,326
select count(distinct ixCustomer) from PJC_18899_SingleBuyers_24M   -- 21,326



update SB 
set SB.OrigSC = C.ixSourceCode
from PJC_18899_SingleBuyers_24M SB
 join [SMI Reporting].dbo.tblCustomer C on SB.ixCustomer = C.ixCustomer
where C.flgDeletedFromSOP = 0 

select * from PJC_18899_SingleBuyers_24M

-- adding the SC from their first/only order
update SB 
set SB.FirstOrdSCGiven = O.sSourceCodeGiven
from PJC_18899_SingleBuyers_24M SB
 join [SMI Reporting].dbo.tblOrder O on SB.ixCustomer = O.ixCustomer
where     O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
  --  and O.dtShippedDate between '01/01/2012' and '12/31/2012'

select * from PJC_18899_SingleBuyers_24M order by  FirstOrdSCGiven 
  
  
  
  
-- adding the MBSC from their first/only order
update SB 
set SB.FirstOrdSCMB = O.sMatchbackSourceCode
from PJC_18899_SingleBuyers_24M SB
 join [SMI Reporting].dbo.tblOrder O on SB.ixCustomer = O.ixCustomer
where     O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders

select * from PJC_18899_SingleBuyers_24M order by  FirstOrdSCMB 





/************** 36 MONTH **********************/
/* ran EXEC spCSTSegmentPull 36,'1','1','SR','SR' 
    kept only the records with 1 Order and Monetary < $100
    imported them into PJC_18899_SingleBuyers_36M 
*/
select count(*) from PJC_18899_SingleBuyers_36M                     -- 64,683
select count(distinct ixCustomer) from PJC_18899_SingleBuyers_36M   -- 64,683

delete from PJC_18899_SingleBuyers_36M
where ixCustomer in (select ixCustomer from PJC_18899_SingleBuyers) -- 26,170

delete from PJC_18899_SingleBuyers_36M
where ixCustomer in (select ixCustomer from PJC_18899_SingleBuyers_24M) -- 21,326

-- drop table PJC_18899_SingleBuyers_36M
select count(*) from PJC_18899_SingleBuyers_36M                     -- 17,187
select count(distinct ixCustomer) from PJC_18899_SingleBuyers_36M   -- 17,187



update SB 
set SB.OrigSC = C.ixSourceCode
from PJC_18899_SingleBuyers_36M SB
 join [SMI Reporting].dbo.tblCustomer C on SB.ixCustomer = C.ixCustomer
where C.flgDeletedFromSOP = 0 

select * from PJC_18899_SingleBuyers_36M

-- adding the SC from their first/only order
update SB 
set SB.FirstOrdSCGiven = O.sSourceCodeGiven
from PJC_18899_SingleBuyers_36M SB
 join [SMI Reporting].dbo.tblOrder O on SB.ixCustomer = O.ixCustomer
where     O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
  --  and O.dtShippedDate between '01/01/2012' and '12/31/2012'

select * from PJC_18899_SingleBuyers_36M order by  FirstOrdSCGiven 
  
  
  
  
-- adding the MBSC from their first/only order
update SB 
set SB.FirstOrdSCMB = O.sMatchbackSourceCode
from PJC_18899_SingleBuyers_36M SB
 join [SMI Reporting].dbo.tblOrder O on SB.ixCustomer = O.ixCustomer
where     O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders

select * from PJC_18899_SingleBuyers_36M order by  FirstOrdSCMB 







/************** 48 MONTH **********************/
/* ran EXEC spCSTSegmentPull 48,'1','1','SR','SR' 
    kept only the records with 1 Order and Monetary < $100
    imported them into PJC_18899_SingleBuyers_48M 
*/
select count(*) from PJC_18899_SingleBuyers_48M                     -- 77,628
select count(distinct ixCustomer) from PJC_18899_SingleBuyers_48M   -- 77,628

delete from PJC_18899_SingleBuyers_48M
where ixCustomer in (select ixCustomer from PJC_18899_SingleBuyers) -- 26,170

delete from PJC_18899_SingleBuyers_48M
where ixCustomer in (select ixCustomer from PJC_18899_SingleBuyers_24M) -- 21,326


delete from PJC_18899_SingleBuyers_48M
where ixCustomer in (select ixCustomer from PJC_18899_SingleBuyers_36M) -- 17,187


-- drop table PJC_18899_SingleBuyers_48M
select count(*) from PJC_18899_SingleBuyers_48M                     -- 12,945
select count(distinct ixCustomer) from PJC_18899_SingleBuyers_48M   -- 12,945



update SB 
set SB.OrigSC = C.ixSourceCode
from PJC_18899_SingleBuyers_48M SB
 join [SMI Reporting].dbo.tblCustomer C on SB.ixCustomer = C.ixCustomer
where C.flgDeletedFromSOP = 0 

select * from PJC_18899_SingleBuyers_48M

-- adding the SC from their first/only order
update SB 
set SB.FirstOrdSCGiven = O.sSourceCodeGiven
from PJC_18899_SingleBuyers_48M SB
 join [SMI Reporting].dbo.tblOrder O on SB.ixCustomer = O.ixCustomer
where     O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
  --  and O.dtShippedDate between '01/01/2012' and '12/31/2012'

select * from PJC_18899_SingleBuyers_48M order by  FirstOrdSCGiven 
  
  
  
  
-- adding the MBSC from their first/only order
update SB 
set SB.FirstOrdSCMB = O.sMatchbackSourceCode
from PJC_18899_SingleBuyers_48M SB
 join [SMI Reporting].dbo.tblOrder O on SB.ixCustomer = O.ixCustomer
where     O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders

select * from PJC_18899_SingleBuyers_48M order by  FirstOrdSCMB 




/***** LINES 235-300 are for looking into why 48M ebay buyer % is so low ***/
select D.iYear, COUNT(C.ixCustomer) CustCount
from tblCustomer C
    join tblDate D on C.dtAccountCreateDate = D.dtDate
where C.ixSourceCode = 'EBAY'
group by D.iYear
order by D.iYear desc  
/*
iYear	CustCount
2013	9537
2012	14340
2011	12215
2010	2098
2009	5
2008	5
2007	104
*/

select D.iYearMonth, COUNT(C.ixCustomer) CustCount
from tblCustomer C
    join tblDate D on C.dtAccountCreateDate = D.dtDate
where C.ixSourceCode = 'EBAY'
    and D.iYear in (2009,2010)
group by D.iYearMonth
order by D.iYearMonth desc  

/*
iYearMonth	CustCount
2010-12-15 00:00:00.000	505
2010-11-15 00:00:00.000	429
2010-10-15 00:00:00.000	264
2010-09-15 00:00:00.000	259
2010-08-15 00:00:00.000	178
2010-07-15 00:00:00.000	124 -- end of 36M segment
2010-06-15 00:00:00.000	93  -- start of 48M segment
2010-05-15 00:00:00.000	86
2010-04-15 00:00:00.000	84
2010-03-15 00:00:00.000	73
*/



select COUNT(O.ixOrder) OrdCount, D.iYear, O.sOrderChannel
from tblOrder O
    join tblDate D on O.ixShippedDate = D.ixDate
where     O.sOrderStatus = 'Shipped'
    --and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel = 'AUCTION'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and D.iYear >= 2008
group by D.iYear, O.sOrderChannel 
order by O.sOrderChannel, D.iYear


select distinct C.ixCustomer, C.ixSourceCode, COUNT(O.ixOrder) OrdCount
from tblCustomer C
    join tblOrder O on C.ixCustomer = O.ixCustomer
    join tblDate D on O.ixShippedDate = D.ixDate
where     O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel = 'AUCTION'   -- verify if these should be filtered!
    and O.mMerchandise between 1 and 99.99 -- > 1 if looking at non-US orders
    and D.dtDate between '07/26/2009' and '07/26/2010'
GROUP BY C.ixCustomer, C.ixSourceCode
HAVING COUNT(O.ixOrder) = 1
order by ixSourceCode    
    