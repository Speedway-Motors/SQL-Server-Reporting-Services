-- Case 24153 - process Cat 382 deceased files from Dingley
    -- code copied from Case 23858

/*******************************************************************************************
 **************************   DECEASED FILES files from DINGLEY  
 **************************     *deceased records flagged with 
 **************************     4E under REASON column!!!
 *******************************************************************************************
                    Cat        Deceased     Deceased    Deceased    Deceased    Deceased
                    ty         File         Qty         Qty         Qty After   Exempt         
Cat Descripiton     StartDate  Created      In File     B4 update   update      After Update
=== =============== =========  =========    =======     =========   =========   ======== 
 *older history available in the older SQL files
376	'14 SR ERLY SUM	2014-05-26  05-14-14         94     380         387         315
385	SPRNT SUM. '14	2014-06-09  05-30-14         43     397         
381	'14 RACE SUMMER	2014-06-23  06-11-14         67     387          
???393	2014 EMI	2014-07-07 
388	'14 MIDSUM SR	2014-07-07  06-25-14        106     388         396         327          
389	SR LATE SUM '14	2014-08-11  07-31-14        105     396         404         327       
387	'14 SUM TBUCKET	2014-07-14 
389	SR LATE SUM '14	2014-08-11  
390	SR '14 EAR FALL	2014-09-22  09-12-14         50     404         404     
382	'14 FALL RACE	2014-10-20  10-08-14         49     407         407         327    
*/
-- verify we have ALL of the deceased files from recent catalogs
-- Dingley is expected to send us a deceased file WITHIN 5 BUSINESS DAYS of receing our pull file
select ixCatalog 'Cat',sDescription 'Description',dtStartDate 'StartDate'
from [SMI Reporting].dbo.tblCatalogMaster
where dtStartDate >= '10/07/2014'
order by dtStartDate

-- DECEASED NAMES ARE MARKED AS CATEGORY 4E !!!
PJC_24153_DeceasedCat382_FD10082014

-- ALTERNATE WAY TO IMPORT DECEASED FILE
select ixCustomer 
into [SMITemp].dbo.PJC_24153_DeceasedCat382_FD10082014
from tblCustomer
where ixCustomer in ('1481680','1733586','1402588','407034','441981','271712','622641','798042','801054','12609','19328','472107','997623','1475957','131765','309176','309921','310193','670832','848953','324553','326135','678787','162592','514612','164648','346271','73744','174220','74647','1354551','879807','533386','1550910','202195','207757','734670','736149','1742669','574104','1057438','758077','411253','765103','595582','949668','611666','612041','788077')



-- DROP TABLE PJC_24153_DeceasedCat382_FD10082014
select count(ixCustomer) CustCnt, 
    count(distinct ixCustomer) DstnctCustCnt
from [SMITemp].dbo.PJC_24153_DeceasedCat382_FD10082014
-- CustCnt    DstnctCustCnt
-- 49           49

-- Customer Count - Flagged DECEASED
select count(*) from [SMI Reporting].dbo.tblCustomer -- 407
where sMailingStatus = 8                             
    and flgDeletedFromSOP = 0                            



/************************************ Dezombification ************************************/
    -- in SOP under <20> Reporting Menu
    --           run <9> UPDATE DECEASED EXEMP LIST 
    -- RESULTS: "number marked as deceased exempt = 8"

    
    -- # of customers marked as Deceased Exempt in SOP (they will NEVER get flagged as deceased again)
    -- WAIT A FEW SECONDS AFTER RUNNING THE UPDATE DECEASED EXEMP LIST job in SOP BEFORE 
    select count(*) QTY
    from [SMI Reporting].dbo.tblCustomer 
    where flgDeceasedMailingStatusExempt = 1
        and flgDeletedFromSOP = 0 
        -- mark results in comment section near the top


/********** PROCESSING FILE   *******************/
-- Customers to load through SOP via <10> Upload Deceased Customer List
select DC.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus,
    C.dtDeceasedStatusUpdateDate, C.ixDeceasedStatusSource, C.flgDeceasedMailingStatusExempt, C.dtDateLastSOPUpdate, C.ixTimeLastSOPUpdate
from  [SMITemp].dbo.PJC_24153_DeceasedCat382_FD10082014 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where  (C.sMailingStatus not in ('8','9')
        OR C.sMailingStatus is NULL
        )
  and C.flgDeletedFromSOP = 0
  and C.flgDeceasedMailingStatusExempt is NULL
-- load customers from above query into a txt file <382Deceased.txt>
-- in SOP Reporting menu execute <10> Load Deceased Customer List  
-- 8 in file to load into SOP 
-- re-run above query to make sure all updated
/*
ixCustomer
407034
1402588
1481680
1733586
*/


-- Refeed customers from query below to see if some records need to be flagged as Deleted From SOP
select ixCustomer, dtDateLastSOPUpdate
from [SMI Reporting].dbo.tblCustomer -- 396
where flgDeletedFromSOP = 0  
    and (sMailingStatus = 8 
         OR
         flgDeceasedMailingStatusExempt is NOT NULL
        )
order by dtDateLastSOPUpdate


    -- Most Recent Order Date for each customer in Deceased File
    --     if no orders, customer excluded
    select O.ixCustomer, C.sMailingStatus, max(O.dtOrderDate) LastOrd
        from [SMI Reporting].dbo.tblOrder O
        join [SMITemp].dbo.PJC_24153_DeceasedCat382_FD10082014 DC on O.ixCustomer = DC.ixCustomer
        join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
    group by  O.ixCustomer, C.sMailingStatus
    order by   sMailingStatus, LastOrd desc 
    /*
    ixCustomer	sMailingStatus	LastOrd
    1733586	    0	            2014-09-01 00:00:00.000
    1481680	    0	            2014-08-07 00:00:00.000
    1402588	    0	            2014-07-28 00:00:00.000
    1733586	    0	            2014-09-01 00:00:00.000
    1481680	    0	            2014-08-07 00:00:00.000
    1402588	    0	            2014-07-28 00:00:00.000
    407034	    0	            2012-04-07 00:00:00.000
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
         $6,383.47  09-15-2014
         $6,911.79  12-22-2014
        */




