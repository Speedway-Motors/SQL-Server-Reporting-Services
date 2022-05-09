 -- Case SMIHD1255 - process Cat 504 deceased files from Dingley
    -- code copied from Case 25822

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
403 '15 SPRNG RACE  2015-02-23 
503	'15 LS STREET	2015-03-16
404	'15 LT SPR RACE	2015-03-30
405	'15 ER SUM RACE	2015-05-04
504	'15 ER SUM SR	2015-04-20
*/
-- verify we have ALL of the deceased files from recent catalogs
-- Dingley is expected to send us a deceased file WITHIN 5 BUSINESS DAYS of receing our pull file
select ixCatalog 'Cat',sDescription 'Description',dtStartDate 'StartDate'
from [SMI Reporting].dbo.tblCatalogMaster
where dtStartDate >= '04/20/2015'
order by dtStartDate

-- DECEASED are marked CATEGORY 4E !!!
PJC_SMIHD1255_DeceasedCat504_FD04172015

-- ALTERNATE WAY TO IMPORT DECEASED FILE
select ixCustomer 
into [SMITemp].dbo.PJC_SMIHD1255_DeceasedCat504_FD04172015
from tblCustomer
where ixCustomer in ('12609','19328','73744','74647','131765','162592','164648','174220','202195','207757','271712','308907','309176','309921','310193','324553','326135','346271','407034','411253','441981','472107','514612','533386','574104','595582','611666','612041','622641','670832','678787','734670','736149','758077','765103','788077','798042','801054','848953','879807','949668','997623','1057438','1187289','1288933','1354551','1405084','1408880','1417177','1430981','1431989','1475957','1499886','1544988','1550910','1560185','1567141','1577286','1612186','1708374','1724283','1733586','1742669','2829836','2951236')


-- DROP TABLE x
select count(ixCustomer) CustCnt, 
    count(distinct ixCustomer) DistinctCnt
from [SMITemp].dbo.PJC_SMIHD1255_DeceasedCat504_FD04172015
-- CustCnt    DistinctCnt
-- 47	       47

-- Customer Count - Flagged DECEASED
select count(*) from [SMI Reporting].dbo.tblCustomer -- 479
where sMailingStatus = 8                             
    and flgDeletedFromSOP = 0                            

select from [SMI Reporting].dbo.tblCustomer -- 479
where flgDeceasedMailingStatusExempt

select flgDeceasedMailingStatusExempt, COUNT(*)
from [SMI Reporting].dbo.tblCustomer 
where flgDeletedFromSOP = 0
group by flgDeceasedMailingStatusExempt

SELECT D.ixCustomer, MAX(O.dtOrderDate) LatestOrder
FROM [SMITemp].dbo.PJC_SMIHD1255_DeceasedCat504_FD04172015 D
left join tblOrder O on D.ixCustomer = O.ixCustomer
GROUP BY D.ixCustomer
Order by LatestOrder desc
/************************************ Dezombification ************************************/
    -- in SOP under <20> Reporting Menu
    --           run <9> UPDATE DECEASED EXEMP LIST 
    -- paste results from SOP generated email
    total customers = 469
    number marked as deceased exempt = 1
    list of buyers marked:  469 


        
/********** PROCESSING FILE   *******************/
-- Customers to load through SOP via <10> Upload Deceased Customer List
select DC.ixCustomer, C.flgDeletedFromSOP, C.sMailingStatus,
    C.dtDeceasedStatusUpdateDate, C.ixDeceasedStatusSource, C.flgDeceasedMailingStatusExempt, C.dtDateLastSOPUpdate, C.ixTimeLastSOPUpdate
from  [SMITemp].dbo.PJC_SMIHD1255_DeceasedCat504_FD04172015 DC
    left join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
where  (C.sMailingStatus not in ('8','9')
        OR C.sMailingStatus is NULL
        )
  and C.flgDeletedFromSOP = 0
  and C.flgDeceasedMailingStatusExempt is NULL
-- load customers from above query into a txt file 504Deceased.txt
-- place file in \\cloak\QOPDL\CST Deceased Files  folder
-- in SOP Reporting menu execute <10> Load Deceased Customer List  
-- 1 in file to load into SOP 
--  AFTER SEVERAL MINUTES, re-run above query to make sure all updated
/*
ixCustomer
NONE
*/


-- Refeed customers from query below to see if some records need to be flagged as Deleted From SOP
select ixCustomer, dtDateLastSOPUpdate
from [SMI Reporting].dbo.tblCustomer -- 830
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
        join [SMITemp].dbo.PJC_SMIHD1255_DeceasedCat504_FD04172015 DC on O.ixCustomer = DC.ixCustomer
        join [SMI Reporting].dbo.tblCustomer C on DC.ixCustomer = C.ixCustomer
    group by  O.ixCustomer, C.sMailingStatus
    order by   sMailingStatus, LastOrd desc 
    /*
    ixCustomer	sMailingStatus	LastOrd
        2541840	8	2015-04-24 00:00:00.000
        342983	9	2013-04-29 00:00:00.000
        162592	9	2012-08-31 00:00:00.000
        1354551	9	2012-07-13 00:00:00.000
        848953	9	2011-07-28 00:00:00.000
        788077	9	2010-12-06 00:00:00.000
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
         $1,059.94  03-30-2015
         $1,507.73  06-23-2015
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
347	0
4	9
*/

