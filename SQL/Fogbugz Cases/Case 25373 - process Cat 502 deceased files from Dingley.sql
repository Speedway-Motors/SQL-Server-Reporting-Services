-- Case 25373 - process Cat 502 deceased files from Dingley
    -- code copied from Case 25737

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
391	'14 SR LATEFALL	2014-11-03  10-23-14         65     402         420         336
501	'15 WINTER SR	2015-01-12 
402	'15 WINTER RACE	2015-01-26
*/
-- verify we have ALL of the deceased files from recent catalogs
-- Dingley is expected to send us a deceased file WITHIN 5 BUSINESS DAYS of receing our pull file
select ixCatalog 'Cat',sDescription 'Description',dtStartDate 'StartDate'
from [SMI Reporting].dbo.tblCatalogMaster
where dtStartDate >= '01/25/2015'
order by dtStartDate

-- DECEASED are marked CATEGORY 4E !!!
PJC_25373_DeceasedCat502_FD02032015

-- ALTERNATE WAY TO IMPORT DECEASED FILE
select ixCustomer 
into [SMITemp].dbo.PJC_25373_DeceasedCat502_FD02032015
from tblCustomer
where ixCustomer in ('12609','19328','73744','74647','131765','162592','164648','174220','202195','207757','271712','308907','309176','309921','310193','324553','326135','346271','407034','411253','441981','472107','514612','533386','574104','595582','611666','612041','622641','670832','678787','734670','736149','758077','765103','788077','798042','801054','848953','879807','949668','997623','1057438','1187289','1288933','1354551','1405084','1408880','1417177','1430981','1431989','1475957','1499886','1544988','1550910','1560185','1567141','1577286','1612186','1708374','1724283','1733586','1742669','2829836','2951236')


-- DROP TABLE PJC_25373_DeceasedCat502_FD02032015
select count(ixCustomer) CustCnt, 
    count(distinct ixCustomer) DstnctCustCnt
from [SMITemp].dbo.PJC_25373_DeceasedCat502_FD02032015
-- CustCnt    DstnctCustCnt
-- 86           86

-- Customer Count - Flagged DECEASED
select count(*) from [SMI Reporting].dbo.tblCustomer -- 443
where sMailingStatus = 8                             
    and flgDeletedFromSOP = 0                            

/************************************ Dezombification ************************************/
    -- in SOP under <20> Reporting Menu
    --           run <9> UPDATE DECEASED EXEMP LIST 
    -- paste results from SOP generated email
    total customers = 455
    number marked as deceased exempt = 1
    list of buyers marked:
    121916
    
        


        
/********** PROCESSING FILE   *******************/
-- Customers to load through SOP via <10> Upload Deceased Customer List
select DC.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus,
    C.dtDeceasedStatusUpdateDate, C.ixDeceasedStatusSource, C.flgDeceasedMailingStatusExempt, C.dtDateLastSOPUpdate, C.ixTimeLastSOPUpdate
from  [SMITemp].dbo.PJC_25373_DeceasedCat502_FD02032015 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where  (C.sMailingStatus not in ('8','9')
        OR C.sMailingStatus is NULL
        )
  and C.flgDeletedFromSOP = 0
  and C.flgDeceasedMailingStatusExempt is NULL
-- load customers from above query into a txt file 502Deceased.txt
-- in SOP Reporting menu execute <10> Load Deceased Customer List  
-- 14 in file to load into SOP 
--  AFTER SEVERAL MINUTES, re-run above query to make sure all updated
/*
ixCustomer
121916
1802774
203196
2152940
2242240
1872879
1688646
703110
1832652
761229
697039
1940665
447924
1559838
1875128
1384143
269903
1815536
1869502
2304148
2323142
1661387
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
        join [SMITemp].dbo.PJC_25373_DeceasedCat502_FD02032015 DC on O.ixCustomer = DC.ixCustomer
        join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
    group by  O.ixCustomer, C.sMailingStatus
    order by   sMailingStatus, LastOrd desc 
    /*
    ixCustomer	sMailingStatus	LastOrd
        121916	0	2015-03-23 00:00:00.000
        450095	0	2015-03-21 00:00:00.000
        951838	0	2015-03-05 00:00:00.000
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
            and O.dtShippedDate >= '01/01/2015'
        /*
        TotalSales  DateRun        
           $323.96  05-18-2014
         $1,124.11  05-18-2014
         $1,109.12  08-26-2014
         $6,383.47  09-15-2014
         $6,911.79  12-22-2014
         $6,509.83  01-05-2015
           $615.87  03-16-2015
           $289.98  03-29-2015
         */

-- how many people have been marked as do no mail after they were marked exempt?
-- possilby indicating complaint and/or valid deceased status
    select count(*) QTY,sMailingStatus
    from [SMI Reporting].dbo.tblCustomer 
    where flgDeceasedMailingStatusExempt = 1
        and flgDeletedFromSOP = 0 
    group by sMailingStatus
/*
QTY	sMailingStatus
341	0
2	9
*/

