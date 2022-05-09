-- Case 23481 - process Cat 389 deceased files from Dingley
    -- code copied from Case 23147

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
*/
-- verify we have ALL of the deceased files from recent catalogs
-- Dingley is expected to send us a deceased file WITHIN 5 BUSINESS DAYS of receing our pull file
select ixCatalog 'Cat',sDescription 'Description',dtStartDate 'StartDate'
from [SMI Reporting].dbo.tblCatalogMaster
where dtStartDate >= '07/07/2014'
order by dtStartDate

-- DECEASED NAMES ARE MARKED AS CATEGORY 4E !!!
PJC_23481_DeceasedCat389_FD07312014

-- DROP TABLE PJC_23481_DeceasedCat389_FD07312014
select count(ixCustomer) CustCnt, 
    count(distinct ixCustomer) DstnctCustCnt
from PJC_23481_DeceasedCat389_FD07312014
-- CustCnt    DstnctCustCnt
-- 105	        105

-- Customer Count - Flagged DECEASED
select count(*) from [SMI Reporting].dbo.tblCustomer -- 396
where sMailingStatus = 8                             
    and flgDeletedFromSOP = 0                            



/************************************ Dezombification ************************************/
    -- run the <10> UPDATE DECEASED EXEMP LIST job in SOP under <20> Reporting Menu
    -- RESULTS: "number marked as deceased exempt = 4"

    
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
from  PJC_23481_DeceasedCat389_FD07312014 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where  (C.sMailingStatus not in ('8','9')
        OR C.sMailingStatus is NULL
        )
  and C.flgDeletedFromSOP = 0
  and C.flgDeceasedMailingStatusExempt is NULL
-- load customers from above query into a txt file <389Deceased.txt>
-- in SOP Reporting menu execute <10> Load Deceased Customer List  
-- 8 in file to load into SOP 
-- re-run above query to make sure all updated
/*
ixCustomer
1325186
1313685
445726
1308785
731342
1290982
1242984
1899054
*/


-- See if some records need to be flagged as Deleted From SOP
select ixCustomer, dtDateLastSOPUpdate
from [SMI Reporting].dbo.tblCustomer -- 396
where flgDeletedFromSOP = 0  
    and (sMailingStatus = 8 
         OR
         flgDeceasedMailingStatusExempt is NOT NULL
        )
order by dtDateLastSOPUpdate


    -- Most Recent Order Date for each customer in Deceased File
    select O.ixCustomer, max(O.dtOrderDate) LastOrd
        from [SMI Reporting].dbo.tblOrder O
        join PJC_23481_DeceasedCat389_FD07312014 DC on O.ixCustomer = DC.ixCustomer
    group by  O.ixCustomer
    order by   LastOrd desc 


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




