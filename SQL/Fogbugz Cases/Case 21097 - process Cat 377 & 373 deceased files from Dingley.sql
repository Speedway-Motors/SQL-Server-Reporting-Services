-- Case 21097 - process Cat 377 & 373 deceased files from Dingley

/*
-- DECEASED FILES files from RRD
Cat Descripiton     StartDate  File (F)ed (R)eady
343	2012 STR FALL	2012-10-01 F    <-- 1st Catalog to use the new flagging rules we instructed RRD to use
.
.
.
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
354	'13 SR LATE SUM	2013-08-12 
355	'13 SR EAR FALL	2013-09-30

361	'13 RACE FALL	2013-10-21  11-05-13         78     324         
356	'13 SR LATE FAL	2013-11-04  11-05-13         71
383	WIN. '14 SPRINT	2013-12-30  11-13-13         81          
377	'14 WINTER RACE	2013-12-23  12-11-13         85     
373	'14 SPRNG SR	2014-01-20  01-10-14
386	'14 SPNG TBUCK	2014-01-27 
378	'14 SPR RACE	2014-02-10 
374	'14 SPRNG SR	2014-03-03 
384	SPRNG '14 SPRNT	2014-03-10 

-- verify we have ALL of the deceased files from recent catalogs
-- Dingley is expected to send us a deceased file WITHIN 5 BUSINESS DAYS of receing our pull file
select ixCatalog 'Cat',sDescription 'Description',dtStartDate 'StartDate'
from [SMI Reporting].dbo.tblCatalogMaster
where dtStartDate >= '01/27/2014'
order by dtStartDate

-- Customer Count - Flagged DECEASED
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
  
  300 @10-14-13 after running the dezombifier to reactive customers who've ordered since they're deceased flagged date  
  300 @10-14-13 B4 processing the Cat 354 & 355 batches  
  328 @10-14-13 after processing the Cat 354 & 355 batches
  327 @10-14-13 after running the dezombifier
  
  323 @11-14-13 B4 processing theCat 356, 361, 386 batches
  341 @11-14-13 AFTER processing theCat 356, 361, 386 batches 
  
  349 @01-13-13 B4 processing theCat 377 & 373
   
*/

-- run the <9> UPDATE DECEASED EXEMP LIST job in SOP under <20> Reporting Menu

    -- WAIT A FEW SECONDS AFTER RUNNING THE UPDATE DECEASED EXEMP LIST job in SOP
    -- BEFORE RUNNING THIS!!!
-- # of customers marked as Deceased Exempt in SOP (they will NEVER get flagged as deceased again)
select count(*) from [SMI Reporting].dbo.tblCustomer 
where flgDeceasedMailingStatusExempt = 1
    and flgDeletedFromSOP = 0 
    -- WAIT A FEW SECONDS BEFORE 
-- 292 @10-14-2013
-- 295 @11-14-2013
-- 295 @01-14-2013
-- 298 @01-14-2013 after running dezombifier
-- 302 @01-14-2013 after running dezombifier


-- YTD Sales from Deceased Exempt customers
    SELECT C.ixCustomer, sum(O.mMerchandise) Sales -- $128K as of 10-13-2013 !?!
    from [SMI Reporting].dbo.tblOrder O
        join [SMI Reporting].dbo.tblCustomer C on O.ixCustomer = C.ixCustomer
    where C.flgDeceasedMailingStatusExempt = 1
        and C.flgDeletedFromSOP = 0  
        and O.sOrderStatus = 'Shipped'
        and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
        and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.dtShippedDate >= '01/01/2013'
    group by  C.ixCustomer   



/********** 1ST FILE - CAT 377   *******************/

-- DROP TABLE PJC_21097_DeceasedCat377FileDate12112013
select count(ixCustomer) CustCnt, 
    count(distinct ixCustomer) DstnctCustCnt
from PJC_21097_DeceasedCat377FileDate12112013
-- CustCnt    DstnctCustCnt
-- 81           81

-- Customers to load through SOP via
-- <10> Load Deceased Customer List
select DC.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus,
    C.dtDeceasedStatusUpdateDate, C.ixDeceasedStatusSource, C.flgDeceasedMailingStatusExempt, C.dtDateLastSOPUpdate, C.ixTimeLastSOPUpdate
from PJC_21097_DeceasedCat377FileDate12112013 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where  (C.sMailingStatus not in ('8','9')
        OR C.sMailingStatus is NULL
        )
  and C.flgDeletedFromSOP = 0
  and C.flgDeceasedMailingStatusExempt is NULL
-- 1 in file to load into SOP 
/*
ixCustomer
409272
*/

select * from [SMI Reporting].dbo.tblCustomer where ixCustomer = '409272'
select * from [SMI Reporting].dbo.tblTime where ixTime = 52697

-- Most Recent Orders
select O.ixCustomer, max(O.dtOrderDate) LastOrd
    from [SMI Reporting].dbo.tblOrder O
    join PJC_21097_DeceasedCat377FileDate12112013 DC on O.ixCustomer = DC.ixCustomer
group by  O.ixCustomer
order by   LastOrd desc 



/**** STOP HERE UNLESS THERE ARE ADDITIONAL DECEASED FILES TO PROCESS  ****/







/********** 2ND FILE - CAT 373 ******************
       16 customers (0 were dupes from 377 list)
*/
-- DROP table PJC_21097_DeceasedCat373FileDate01102014
select count(ixCustomer) CustCnt, 
    count(distinct ixCustomer) DstnctCustCnt
from PJC_21097_DeceasedCat373FileDate01102014
--CustCnt	DstnctCustCnt
--85        85


-- remove DUPES (0 customers already in the previous file)
DELETE 
from PJC_21097_DeceasedCat373FileDate01102014
where ixCustomer in (select ixCustomer from PJC_21097_DeceasedCat377FileDate12112013)

select * from PJC_21097_DeceasedCat373FileDate01102014

-- customers for file to give to Al
select DC.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus,
    C.dtDeceasedStatusUpdateDate, C.ixDeceasedStatusSource, C.flgDeceasedMailingStatusExempt
from PJC_21097_DeceasedCat373FileDate01102014 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where   (C.sMailingStatus not in ('8','9')
        OR C.sMailingStatus is NULL
        )
  and C.flgDeletedFromSOP = 0
  and C.flgDeceasedMailingStatusExempt is NULL        
order by flgDeletedFromSOP desc 
-- 0 records to give Al
/*
ixCustomer

*/
