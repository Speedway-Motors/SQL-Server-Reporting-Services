
-- DECEASED FILES FROM RRD THAT USE THE MODIFIED FLAGGING RULES
/*
Cat Descripiton     StartDate  File 
343	2012 STR FALL	2012-10-01 F     -- 1st Catalog to use the new rules
347	2012 FALL RACE	2012-10-22 F
344	2012 STR LTFALL	2012-11-05 F
357	2013 RACE WNTR	2012-12-17 F
362	2013 SPRNT WNTR	2013-01-07 F
349	2013 ST ERLYSPG	2013-01-14 F
367	AFCO ERLY SPRNG	2013-01-28 F
358	2013 RACE SPRG1	2013-02-11 F
350	2013 SPRNG RMAL	2013-02-25 F           



2-5 bus days after we send file they return deceased   

*/
select * from tblCustomer
where ixCustomer like '0%'

-- 
select count(*) from [SMI Reporting].dbo.tblCustomer -- 1,754 flagged as Deceased AS of 3-4-13 @1PM
where sMailingStatus = 8                             -- 3,838 AS OF 3-5-13 @3PM
and flgDeletedFromSOP = 0



/***** CATALOG 343   *******************/
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_16962_DeceasedCat343FileDate09182012
/*
CustCount	DstnctCustCount
969	        969

*/
select DC343.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_16962_DeceasedCat343FileDate09182012 DC343
    left join [SMI Reporting].dbo.tblCustomer C on DC343.ixCustomer = C.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
order by flgDeletedFromSOP desc 

-- 8 flagged as deleted
-- 961 in file to give to Al   




/***** CATALOG 347   *******************/
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_16962_DeceasedCat347FileDate10092012
/*
CustCount	DstnctCustCount
693	        693

*/
select DC347.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_16962_DeceasedCat347FileDate10092012 DC347
    left join [SMI Reporting].dbo.tblCustomer C on DC347.ixCustomer = C.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
order by flgDeletedFromSOP desc 
-- 0 flagged as deleted

select * from PJC_16962_DeceasedCat347FileDate10092012
where ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat343FileDate09182012)
-- 342 in file to give to Al   




/***** CATALOG 344   *******************/
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_16962_DeceasedCat344FileDate10242012
/*
CustCount	DstnctCustCount
1216	    1216

*/
select DC344.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_16962_DeceasedCat344FileDate10242012 DC344
    left join [SMI Reporting].dbo.tblCustomer C on DC344.ixCustomer = C.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
order by flgDeletedFromSOP desc 
-- 0 flagged as deleted

select * from PJC_16962_DeceasedCat344FileDate10242012
where ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat343FileDate09182012)-- CAT 343
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat347FileDate10092012)-- CAT 347
-- 259 in file to give to Al   





/***** CATALOG 357   *******************/
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_16962_DeceasedCat357FileDate12042012
/*
CustCount	DstnctCustCount
603	        603

*/
select DC344.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_16962_DeceasedCat357FileDate12042012 DC344
    left join [SMI Reporting].dbo.tblCustomer C on DC344.ixCustomer = C.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
order by flgDeletedFromSOP desc 
-- 0 flagged as deleted

select * from PJC_16962_DeceasedCat357FileDate12042012
where ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat343FileDate09182012)-- CAT 343
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat347FileDate10092012)-- CAT 347
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat344FileDate10242012)-- CAT 344  
-- 63 in file to give to Al   



/***** CATALOG 362   *******************/
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_16962_DeceasedCat362FileDate12262012
/*
CustCount	DstnctCustCount
182	        182

*/
select DC344.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_16962_DeceasedCat362FileDate12262012 DC344
    left join [SMI Reporting].dbo.tblCustomer C on DC344.ixCustomer = C.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
order by flgDeletedFromSOP desc 
-- 0 flagged as deleted

select * from PJC_16962_DeceasedCat362FileDate12262012
where ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat343FileDate09182012)-- CAT 343
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat347FileDate10092012)-- CAT 347
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat344FileDate10242012)-- CAT 344  
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat357FileDate12042012)-- CAT 357   
-- 70 in file to give to Al   




/***** CATALOG 349   *******************/
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_16962_DeceasedCat349FileDate01042013
/*
CustCount	DstnctCustCount
3146	        3146

*/
select DF.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_16962_DeceasedCat349FileDate01042013 DF
    left join [SMI Reporting].dbo.tblCustomer C on DF.ixCustomer = C.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
order by flgDeletedFromSOP desc 
-- 0 flagged as deleted


select * from PJC_16962_DeceasedCat349FileDate01042013
where ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat343FileDate09182012)-- CAT 343
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat347FileDate10092012)-- CAT 347
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat344FileDate10242012)-- CAT 344  
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat357FileDate12042012)-- CAT 357   
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat362FileDate12262012)-- CAT 362     
-- 1737 in file to give to Al   
  






/***** CATALOG 367   *******************/
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_16962_DeceasedCat367FileDate01142013
/*
CustCount	DstnctCustCount
86	        86

*/
select DC344.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_16962_DeceasedCat367FileDate01142013 DC344
    left join [SMI Reporting].dbo.tblCustomer C on DC344.ixCustomer = C.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
order by flgDeletedFromSOP desc 
-- 0 flagged as deleted

select * from PJC_16962_DeceasedCat367FileDate01142013
where ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat343FileDate09182012)-- CAT 343
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat347FileDate10092012)-- CAT 347
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat344FileDate10242012)-- CAT 344  
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat357FileDate12042012)-- CAT 357   
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat362FileDate12262012)-- CAT 362    
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat349FileDate01042013)-- CAT 349      
-- 9 in file to give to Al   





/***** CATALOG 358   *******************/
-- DROP table PJC_16962_DeceasedCat358FileDate01292013
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_16962_DeceasedCat358FileDate01292013
/*
CustCount	DstnctCustCount
1111	        1111

*/
select DC344.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_16962_DeceasedCat358FileDate01292013 DC344
    left join [SMI Reporting].dbo.tblCustomer C on DC344.ixCustomer = C.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
order by flgDeletedFromSOP desc 
-- 0 flagged as deleted

select * from PJC_16962_DeceasedCat358FileDate01292013
where ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat343FileDate09182012)-- CAT 343
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat347FileDate10092012)-- CAT 347
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat344FileDate10242012)-- CAT 344  
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat357FileDate12042012)-- CAT 357   
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat362FileDate12262012)-- CAT 362 
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat349FileDate01042013)-- CAT 349    
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat367FileDate01142013)-- CAT 367     
-- 387 in file to give to Al   



-- 931 newly deceased custs
-- below....have placed order since
select DC344.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_16962_DeceasedCat358FileDate01292013 DC344
    left join [SMI Reporting].dbo.tblCustomer C on DC344.ixCustomer = C.ixCustomer
    join [SMI Reporting].dbo.tblOrder O on C.ixCustomer = O.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
  and O.dtOrderDate >= '01/30/2013'
order by flgDeletedFromSOP desc 








/***** CATALOG 350   *******************/
-- DROP table PJC_16962_DeceasedCat350FileDate02112013
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_16962_DeceasedCat350FileDate02112013
/*
CustCount	DstnctCustCount
39	        39

*/
select DC344.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_16962_DeceasedCat350FileDate02112013 DC344
    left join [SMI Reporting].dbo.tblCustomer C on DC344.ixCustomer = C.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
order by flgDeletedFromSOP desc 
-- 0 flagged as deleted

select * from PJC_16962_DeceasedCat350FileDate02112013
where ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat343FileDate09182012)-- CAT 343
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat347FileDate10092012)-- CAT 347
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat344FileDate10242012)-- CAT 344  
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat357FileDate12042012)-- CAT 357   
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat362FileDate12262012)-- CAT 362 
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat349FileDate01042013)-- CAT 349    
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat367FileDate01142013)-- CAT 367     
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat358FileDate01292013)-- CAT 358     
-- 387 in file to give to Al   




   

/***** CATALOG 365   *******************/
-- DROP table PJC_16962_DeceasedCat365FileDate03042013
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_16962_DeceasedCat365FileDate03042013
/*
CustCount	DstnctCustCount
65	        65

*/
select DC344.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_16962_DeceasedCat365FileDate03042013 DC344
    left join [SMI Reporting].dbo.tblCustomer C on DC344.ixCustomer = C.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
order by flgDeletedFromSOP desc 
-- 0 flagged as deleted

select * from PJC_16962_DeceasedCat365FileDate03042013
where ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat343FileDate09182012)-- CAT 343
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat347FileDate10092012)-- CAT 347
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat344FileDate10242012)-- CAT 344  
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat357FileDate12042012)-- CAT 357   
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat362FileDate12262012)-- CAT 362 
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat349FileDate01042013)-- CAT 349    
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat367FileDate01142013)-- CAT 367     
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat358FileDate01292013)-- CAT 358    
  and ixCustomer not in (Select ixCustomer from PJC_16962_DeceasedCat350FileDate02112013)-- CAT 350      
-- 48 in file to give to Al   