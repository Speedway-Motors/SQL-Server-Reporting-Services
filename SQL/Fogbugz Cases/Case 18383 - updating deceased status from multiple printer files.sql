-- Case 18383 - updating deceased status from multiple printer files

-- DECEASED FILES FROM RRD THAT USE THE MODIFIED FLAGGING RULES
/*
Cat Descripiton     StartDate  File (F)ed (R)eady
343	2012 STR FALL	2012-10-01 F    <-- 1st Catalog to use the new rules
347	2012 FALL RACE	2012-10-22 F
344	2012 STR LTFALL	2012-11-05 F
357	2013 RACE WNTR	2012-12-17 F
362	2013 SPRNT WNTR	2013-01-07 F
349	2013 ST ERLYSPG	2013-01-14 F
367	AFCO ERLY SPRNG	2013-01-28 F
358	2013 RACE SPRG1	2013-02-11 F
350	2013 SPRNG RMAL	2013-02-25 F
           
365 2013 WINT TBUCK 2013-03-04 R
359 2013 SPRING     2013-03-11 R
351 2013 LT SPRING  2013-03-15 R
363 '13 SPRINT SPRG 2013-03-27 R
368 AFCO LATE SPRG  2013-04-16 R
352	'13 EARLY SUM.  2013-04-22 R   <-- last deceased file we will get from RRD

UPCOMING
360	'13 RACE SPRNG2     Start Date 2013-05-20         <-- 1st Catalog from Dingley
371	2013 FLIP #2        Start Date 2013-06-17    
*/

-- Flagged Deceased Count
select count(*) from [SMI Reporting].dbo.tblCustomer 
where sMailingStatus = 8                             
and flgDeletedFromSOP = 0                            
/*
-- 1,754 AS of 03-04-13 @1PM
-- 3,838 AS of 03-05-13 @3PM after processing batch of deceased files
-- 3,664 AS of 05-29-13 @4PM
-- 3,787 AS of 05-29-13 @#  after processing batch of deceased files

*/



-- verify we have all of the deceased files
-- 2-5 bus days after we send catalog pull file RRD returns a deceased file
select * from [SMI Reporting].dbo.tblCatalogMaster
where dtStartDate >= '05/01/2013'
order by dtStartDate

select * from [SMI Reporting].dbo.tblCatalogMaster
where ixCatalog = '353'




/***** 1ST FILE - CAT 365   *******************/
-- DROP TABLE PJC_18383_DeceasedCat365FileDate03042013
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_18383_DeceasedCat365FileDate03042013
/*
CustCount	DstnctCustCount
66	        66

*/
select DC.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_18383_DeceasedCat365FileDate03042013 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
order by flgDeletedFromSOP desc 

-- 0 flagged as deleted
-- 48 in file to give to Al   

select * from tblCustomer where ixCustomer = '1260069'


/***** 2ND FILE - CAT 359   *******************/
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_18383_DeceasedCat359FileDate03112013
/*
CustCount	DstnctCustCount
22	        22

*/
select DC359.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_18383_DeceasedCat359FileDate03112013 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
order by flgDeletedFromSOP desc 
-- 0 flagged as deleted

select * from PJC_18383_DeceasedCat359FileDate03112013
where ixCustomer not in (Select ixCustomer from PJC_18383_DeceasedCat365FileDate03042013)-- CAT 365
-- 17 in file to give to Al   





/***** 3RD FILE - CAT  351   *******************/
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_18383_DeceasedCat351FileDate03152013

/*
CustCount	DstnctCustCount
258	        258

*/
select DC.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_18383_DeceasedCat351FileDate03152013 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
order by flgDeletedFromSOP desc 
-- 0 flagged as deleted

select * from PJC_18383_DeceasedCat351FileDate03152013
where ixCustomer not in (Select ixCustomer from PJC_18383_DeceasedCat365FileDate03042013)-- CAT 365
  and ixCustomer not in (Select ixCustomer from PJC_18383_DeceasedCat359FileDate03112013)-- CAT 359
-- 237 in file to give to Al   




/***** 4TH FILE - CAT 363   *******************/
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_18383_DeceasedCat363FileDate03272013
/*
CustCount	DstnctCustCount
35	        35

*/
select DC.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_18383_DeceasedCat363FileDate03272013 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
order by flgDeletedFromSOP desc 
-- 0 flagged as deleted

select * from PJC_18383_DeceasedCat363FileDate03272013
where ixCustomer not in (Select ixCustomer from PJC_18383_DeceasedCat365FileDate03042013)-- CAT 365
  and ixCustomer not in (Select ixCustomer from PJC_18383_DeceasedCat359FileDate03112013)-- CAT 359
  and ixCustomer not in (Select ixCustomer from PJC_18383_DeceasedCat351FileDate03152013)-- CAT 351 
-- 9 in file to give to Al   



/***** 5TH FILE - CAT 368   *******************/
-- DROP TABLE PJC_18383_DeceasedCat368FileDate04162013
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_18383_DeceasedCat368FileDate04162013
/*
CustCount	DstnctCustCount
112	        112

*/
select DC.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_18383_DeceasedCat368FileDate04162013 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
order by flgDeletedFromSOP desc 
-- 0 flagged as deleted

select * from PJC_18383_DeceasedCat368FileDate04162013
where ixCustomer not in (Select ixCustomer from PJC_18383_DeceasedCat365FileDate03042013)-- CAT 365
  and ixCustomer not in (Select ixCustomer from PJC_18383_DeceasedCat359FileDate03112013)-- CAT 359
  and ixCustomer not in (Select ixCustomer from PJC_18383_DeceasedCat351FileDate03152013)-- CAT 351  
  and ixCustomer not in (Select ixCustomer from PJC_18383_DeceasedCat363FileDate03272013)-- CAT 363    
-- 11 in file to give to Al   




/***** 6th FILE - CAT 352    *******************/
-- DROP TABLE PJC_18383_DeceasedCat352FileDate04222013
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_18383_DeceasedCat352FileDate04222013
/*
CustCount	DstnctCustCount
101	        101

*/
select DC.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus
from PJC_18383_DeceasedCat352FileDate04222013 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where   C.sMailingStatus <> 8 
  and C.flgDeletedFromSOP = 0
order by flgDeletedFromSOP desc 
-- 0 flagged as deleted

select * from PJC_18383_DeceasedCat352FileDate04222013
where ixCustomer not in (Select ixCustomer from PJC_18383_DeceasedCat365FileDate03042013)-- CAT 365
  and ixCustomer not in (Select ixCustomer from PJC_18383_DeceasedCat359FileDate03112013)-- CAT 359
  and ixCustomer not in (Select ixCustomer from PJC_18383_DeceasedCat351FileDate03152013)-- CAT 351  
  and ixCustomer not in (Select ixCustomer from PJC_18383_DeceasedCat363FileDate03272013)-- CAT 363  
  and ixCustomer not in (Select ixCustomer from PJC_18383_DeceasedCat368FileDate04162013)-- CAT 368      
-- 16 in file to give to Al   



select ixCustomer from [SMI Reporting].dbo.tblCustomer 
where sMailingStatus = 8                             
and flgDeletedFromSOP = 0  





