-- Case 19340 - process Cat 364 & 366 deceased files from Dingley

/*
-- DECEASED FILES files from RRD
Cat Descripiton     StartDate  File (F)ed (R)eady
343	2012 STR FALL	2012-10-01 F    <-- 1st Catalog to use the new flagging rules we instructed RRD to use
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

-- DECEASED FILES files from DINGLEY
                    Cat        Dec          Dec         Dec         Dec         Dec
                    ty         File         Qty         Qty         Qty After   Exempt         
Cat Descripiton     StartDate  Created      In File     B4 update   update      Qty After Update
=== =============== =========  =========    =======     =========   =========   ======== 
360	'13 RACE SPRNG2 05-20-13   05-29-13           0                 3,787                       <-- 1st Catalog from Dingley
353	'13 SR MID SUM. 06-17-13   06-17-13         140     233         314
366	2013 FALL TB    07-01-13   07-22-13?        314                             
364 FALL '13 SPRINT 07-08-13
354 expected date to finalize in CST = 7-22-13
  
*/

-- verify we have ALL of the of the deceased files from recent catalogs
-- 2-5 bus days after we send catalog pull file RRD returns a deceased file
select * from [SMI Reporting].dbo.tblCatalogMaster
where dtStartDate >= '06/17/2013'
order by dtStartDate

select * from [SMI Reporting].dbo.tblCatalogMaster
where ixCatalog = '354'



-- Flagged DECEASED
select count(*) from [SMI Reporting].dbo.tblCustomer 
where sMailingStatus = 8                             
    and flgDeletedFromSOP = 0                            
/*
1,754 @03-04-13 @1PM
3,838 @03-05-13 @3PM after processing batch of deceased files
3,664 @05-29-13 @4PM
3,787 @05-29-13 @#  after processing batch of deceased files
3,774 @06-20-13 @9AM
  233 @07-19-13 B4 processing theCat 353 batch
  314 @07-19-13 After processing theCat 353 batch
  314 @07-22-13 B4 processing theCat 364 & 366 batches
  315 @07-22-13 After processing theCat 364 & 366 batches
  
  
  
  
  
*/
select count(*) from [SMI Reporting].dbo.tblCustomer 
where flgDeceasedMailingStatusExempt = 1
    and flgDeletedFromSOP = 0  
/* Flagged DECEASED EXEMPT
  277 @07-22-13 Before processing theCat 364 & 366 batches





*/



/***** 1ST FILE - CAT 366   *******************/
-- DROP TABLE PJC_19340_DeceasedCat366FileDate07222013
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_19340_DeceasedCat366FileDate07222013
/*
CustCount	DstnctCustCount
51          51

*/
select DC.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus,
    C.dtDeceasedStatusUpdateDate, C.ixDeceasedStatusSource, C. flgDeceasedMailingStatusExempt
from PJC_19340_DeceasedCat366FileDate07222013 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where  (C.sMailingStatus not in ('8','9')
        OR C.sMailingStatus is NULL
        )
  and C.flgDeletedFromSOP = 0
  and C.flgDeceasedMailingStatusExempt is NULL
-- 2 in file to give to Al   
/*
1458768
723102
*/

select * from tblCustomer where ixCustomer = '1260069'

select O.ixCustomer, max(O.dtOrderDate) LastOrd
    from [SMI Reporting].dbo.tblOrder O
    join PJC_19340_DeceasedCat366FileDate07222013 DC on O.ixCustomer = DC.ixCustomer
group by  O.ixCustomer
order by   LastOrd desc 




/***** 2ND FILE - CAT 364 *******************/
select count(ixCustomer) CustCount, 
    count(distinct ixCustomer) DstnctCustCount
from PJC_19340_DeceasedCat364FileDate07222013
/*
CustCount	DstnctCustCount
42	        42

*/
select DC.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus,
    C.dtDeceasedStatusUpdateDate, C.ixDeceasedStatusSource, C.flgDeceasedMailingStatusExempt
from PJC_19340_DeceasedCat364FileDate07222013 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where   (C.sMailingStatus not in ('8','9')
        OR C.sMailingStatus is NULL
        )
order by flgDeletedFromSOP desc 
-- 0 records to give Al,  Only one returned at it was flagged as Exempt








select ixCustomer from [SMI Reporting].dbo.tblCustomer 
where sMailingStatus = 8                             
and flgDeletedFromSOP = 0  





select max(dtOrderDate)
from [SMI Reporting].dbo.tblOrder where ixCustomer = '723102'
