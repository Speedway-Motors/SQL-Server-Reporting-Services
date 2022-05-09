-- Case 22515 - process Cat 380 deceased files from Dingley
    -- code copied from 22220
/*
-- DECEASED FILES files from RRD
Cat Descripiton     StartDate  File (F)ed (R)eady
343	2012 STR FALL	2012-10-01 F    <-- 1st Catalog to use the new flagging rules we instructed RRD to use
to
352	'13 EARLY SUM.  2013-04-22 R   <-- last deceased file we will get from RRD



/*******************************************************************************************
 **************************   DECEASED FILES files from DINGLEY   **************************
 *******************************************************************************************/
                    Cat        Deceased     Deceased    Deceased    Deceased    Deceased
                    ty         File         Qty         Qty         Qty After   Exempt         
Cat Descripiton     StartDate  Created      In File     B4 update   update      Qty After Update
=== =============== =========  =========    =======     =========   =========   ======== 
361	'13 RACE FALL	2013-10-21  11-05-13         78     324         
356	'13 SR LATE FAL	2013-11-04  11-05-13         71
383	WIN. '14 SPRINT	2013-12-30  11-13-13         81          
377	'14 WINTER RACE	2013-12-23  12-11-13         85     
373	'14 SPRNG SR	2014-01-20  01-10-14
386	'14 SPNG TBUCK	2014-01-27  01-16-14         48     348         353         353
378	'14 SPR RACE	2014-02-10  01-30-14         78     353         366              
374	'14 SPRNG SR	2014-03-03  02-20-14
384	SPRNG '14 SPRNT	2014-03-10  02-26-14
379	'14 SPRNG RACE	2014-03-24  03-12-14         63    
375	'14 LS STREET	2014-04-14  04-04-14        122     373
380	'14 RACE LT SPR	2014-05-05 

after this Deceased File
376	'14 SR ERLY SUM	2014-05-26 
376	'14 SR ERLY SUM	2014-05-26 
385	SPRNT SUM. '14	2014-06-09 
381	'14 RACE SUMMER	2014-06-23 

*/
-- verify we have ALL of the deceased files from recent catalogs
-- Dingley is expected to send us a deceased file WITHIN 5 BUSINESS DAYS of receing our pull file
select ixCatalog 'Cat',sDescription 'Description',dtStartDate 'StartDate'
from [SMI Reporting].dbo.tblCatalogMaster
where dtStartDate >= '05/04/2014'
order by dtStartDate

-- Customer Count - Flagged DECEASED
select count(*) from [SMI Reporting].dbo.tblCustomer -- 390
where sMailingStatus = 8                             
    and flgDeletedFromSOP = 0                            


-- run the <9> UPDATE DECEASED EXEMP LIST job in SOP under <20> Reporting Menu
-- "number marked as deceased exempt = 2"

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
-- 304 @03-20-2014 after running dezombifier
-- 307 @04-04-2014 after running dezombifier
-- 306 @04-28-2014 after running dezombifier
-- 315 @05-18-2014


-- YTD Sales from customers currently flagged as Deceased
    SELECT --C.ixCustomer, 
        sum(O.mMerchandise) Sales 
    from [SMI Reporting].dbo.tblOrder O
        join [SMI Reporting].dbo.tblCustomer C on O.ixCustomer = C.ixCustomer
    where C.sMailingStatus = 8     
        and C.flgDeletedFromSOP = 0  
        and O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.dtShippedDate >= '01/01/2014'
-- $323.96 as of 5-18-2014


/********** 1ST FILE - CAT 379   *******************/
PJC_22515_DeceasedCat380_FD04252014

-- DROP TABLE PJC_22515_DeceasedCat380_FD04252014
select count(ixCustomer) CustCnt, 
    count(distinct ixCustomer) DstnctCustCnt
from PJC_22515_DeceasedCat380_FD04252014
-- CustCnt    DstnctCustCnt
-- 82           82

-- Customers to load through SOP via <10> Upload Deceased Customer List
select DC.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus,
    C.dtDeceasedStatusUpdateDate, C.ixDeceasedStatusSource, C.flgDeceasedMailingStatusExempt, C.dtDateLastSOPUpdate, C.ixTimeLastSOPUpdate
from  PJC_22515_DeceasedCat380_FD04252014 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where  (C.sMailingStatus not in ('8','9')
        OR C.sMailingStatus is NULL
        )
  and C.flgDeletedFromSOP = 0
  and C.flgDeceasedMailingStatusExempt is NULL
-- load customers from above query into a txt file and
-- go to SOP Reporting menu and execute <10> Load Deceased Customer List  
-- 1 in file to load into SOP 
-- re-run above query to make sure all updated
/*
ixCustomer
NONE
*/

select * from [SMI Reporting].dbo.tblCustomer where ixCustomer = '409272'
select * from [SMI Reporting].dbo.tblTime where ixTime = 52697

-- Most Recent Orders
select O.ixCustomer, max(O.dtOrderDate) LastOrd
    from [SMI Reporting].dbo.tblOrder O
    join PJC_22515_DeceasedCat380_FD04252014 DC on O.ixCustomer = DC.ixCustomer
group by  O.ixCustomer
order by   LastOrd desc 







