-- Case 23003 - process Cat 381 deceased files from Dingley
    -- code copied from Case 22892

/*******************************************************************************************
 **************************   DECEASED FILES files from DINGLEY   **************************
 *******************************************************************************************
                    Cat        Deceased     Deceased    Deceased    Deceased    Deceased
                    ty         File         Qty         Qty         Qty After   Exempt         
Cat Descripiton     StartDate  Created      In File     B4 update   update      Qty After Update
=== =============== =========  =========    =======     =========   =========   ======== 
361	'13 RACE FALL	2013-10-21  11-05-13         78     324         
356	'13 SR LATE FAL	2013-11-04  11-05-13         71
383	WIN. '14 SPRINT	2013-12-30  11-13-13         81          
377	'14 WINTER RACE	2013-12-23  12-11-13         85     
373	'14 SPRNG SR	2014-01-20  01-10-14
386	'14 SPNG TBUCK	2014-01-27  01-16-14         48     348         353        
378	'14 SPR RACE	2014-02-10  01-30-14         78     353         366              
374	'14 SPRNG SR	2014-03-03  02-20-14
384	SPRNG '14 SPRNT	2014-03-10  02-26-14
379	'14 SPRNG RACE	2014-03-24  03-12-14         63    
375	'14 LS STREET	2014-04-14  04-04-14        122     373
380	'14 RACE LT SPR	2014-05-05  04-25-14         82     380         380         315
376	'14 SR ERLY SUM	2014-05-26  05-14-14         94     380         387         315
385	SPRNT SUM. '14	2014-06-09  05-30-14         43     397         
381	'14 RACE SUMMER	2014-06-23  06-11-14         67     387          
???393	2014 EMI	2014-07-07 
388	'14 MIDSUM SR	2014-07-07 
387	'14 SUM TBUCKET	2014-07-14 
389	SR LATE SUM '14	2014-08-11 

*/
-- verify we have ALL of the deceased files from recent catalogs
-- Dingley is expected to send us a deceased file WITHIN 5 BUSINESS DAYS of receing our pull file
select ixCatalog 'Cat',sDescription 'Description',dtStartDate 'StartDate'
from [SMI Reporting].dbo.tblCatalogMaster
where dtStartDate >= '06/09/2014'
order by dtStartDate

-- DECEASED NAMES ARE MARKED AS CATEGORY 4E !!!


-- DROP TABLE PJC_23003_DeceasedCat381_FD06112014
select count(ixCustomer) CustCnt, 
    count(distinct ixCustomer) DstnctCustCnt
from PJC_23003_DeceasedCat381_FD06112014
-- CustCnt    DstnctCustCnt
-- 67           67

-- Customer Count - Flagged DECEASED
select count(*) from [SMI Reporting].dbo.tblCustomer -- 384
where sMailingStatus = 8                             
    and flgDeletedFromSOP = 0                            

/************************************ Dezombification ************************************/
    -- run the <9> UPDATE DECEASED EXEMP LIST job in SOP under <20> Reporting Menu
    -- RESULTS: "number marked as deceased exempt = 4"

    
    -- # of customers marked as Deceased Exempt in SOP (they will NEVER get flagged as deceased again)
    -- WAIT A FEW SECONDS AFTER RUNNING THE UPDATE DECEASED EXEMP LIST job in SOP BEFORE 
    select count(*) QTY
    from [SMI Reporting].dbo.tblCustomer 
    where flgDeceasedMailingStatusExempt = 1
        and flgDeletedFromSOP = 0 
        /* results AFTER running dezombifier
        QTY DateRun
        292 10-14-2013
        295 11-14-2013
        295 01-14-2013
        298 01-14-2013
        302 01-14-2013
        304 03-20-2014
        307 04-04-2014
        306 04-28-2014
        315 05-18-2014
        319 05-30-2014
        327 08-26-2014
        */


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
        /*
        TotalSales  DateRun        
           $323.96  05-18-2014
         $1,124.11  05-18-2014
         $1,109.12  08-26-2014
        */

/********** PROCESSING FILE   *******************/
-- Customers to load through SOP via <10> Upload Deceased Customer List
select DC.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus,
    C.dtDeceasedStatusUpdateDate, C.ixDeceasedStatusSource, C.flgDeceasedMailingStatusExempt, C.dtDateLastSOPUpdate, C.ixTimeLastSOPUpdate
from  PJC_23003_DeceasedCat381_FD06112014 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where  (C.sMailingStatus not in ('8','9')
        OR C.sMailingStatus is NULL
        )
  and C.flgDeletedFromSOP = 0
  and C.flgDeceasedMailingStatusExempt is NULL
-- load customers from above query into a txt file and go to SOP Reporting menu and execute <10> Load Deceased Customer List  
-- NONE in file to load into SOP 
-- re-run above query to make sure all updated
/*
ixCustomer
711073
924417
1096781
1151485
*/


-- Most Recent Order Date for each customer in Deceased File
select O.ixCustomer, max(O.dtOrderDate) LastOrd
    from [SMI Reporting].dbo.tblOrder O
    join PJC_23003_DeceasedCat381_FD06112014 DC on O.ixCustomer = DC.ixCustomer
group by  O.ixCustomer
order by   LastOrd desc 







