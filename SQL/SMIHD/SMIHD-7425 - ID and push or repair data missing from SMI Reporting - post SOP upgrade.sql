-- SMIHD-7425 - ID and push or repair data missing from SMI Reporting - post SOP upgrade

/********************************************
 **********     SMI Reporting       *********
 ********************************************/
 
select ixDate, dtDate, sDayOfWeek3Char
from tblDate where ixDate between 18017 and 18030
order by ixDate desc
/*
18030	2017-05-12	FRI
18029	2017-05-11	THU
18028	2017-05-10	WED <--
18027	2017-05-09	TUE 
18026	2017-05-08	MON
18025	2017-05-07	SUN
18024	2017-05-06	SAT
18023	2017-05-05	FRI
18022	2017-05-04	THU
18021	2017-05-03	WED
18020	2017-05-02	TUE
18019	2017-05-01	MON
18018	2017-04-30	SUN
18017	2017-04-29	SAT
*/

-- Check Bulk Insert SSA job history - completed 100%
select COUNT(*) from tblCatalogDetail       --   6,314,618 as of 5/3/17 @5:18PM v on staging & DW1 ^     6,330,255 5-8 9am
select COUNT(*) from tblGiftCardDetail      --      49,851 as of 5/3/17 @5:18PM v on staging & DW1 ^     49,957 5-8 9am
select COUNT(*) from tblGiftCardMaster      --      62,848 as of 5/3/17 @5:18PM v on staging & DW1 ^     63,198 5-8 9am
select count(*) from tblMailingOptIn        --  11,402,339 as of 5/3/17 @5:28PM v on staging & DW1 ^     11,413,043 5-8 9am 
select count(*) from tblMergedCustomers     --      48,692 as of 5/3/17 @5:28PM v on staging & DW1 ^     48,737 5-8 9am 
select count(*) from tblOrderPromoCodeXref  --      95,662 as of 5/3/17 @5:41PM v on staging & DW1 ^     95,919 5-8 9am 
select count(*) from tblShippingPromo       --      52,507 as of 5/3/17 @5:18PM v on staging & DW1 ^     52,552 5-8 9am 
select count(*) from tblSKUPromo            --     121,961 as of 5/3/17 @5:18PM v on staging & DW1 ^     122,506 5-8 9am 
select count(*) from tblSKUTransaction      --  32,086,121 as of 5/3/17 @5:52PM v on staging & DW1 ^     32,207,657 5-8 9am 
select COUNT(*) from tblCatalogMaster       --         428 as of 5/3/17 @5:18PM v on staging & DW1 =     428 5-8 9am
select count(*) from tblCreditMemoReasonCode--         127 as of 5/3/17 @5:52PM v on staging & DW1 =     127 5-8 9am 
select count(*) from tblProductLine         --       7,829 as of 5/3/17 @5:41PM v on staging & DW1 =     7,833 5-8 9am 
select count(*) from tblSnapshotSKU         -- 248,647,266 as of 5/3/17 @5:41PM v on staging & DW1 =     250,351,278 5-8 9am -- table properties for size
select count(*) from tblFIFODetail          -- 228,837,507 as of 5/3/17 @5:52PM v on staging & DW1 ^     229,832,783 5-8 9am -- table properties for size
select count(*) from tblCatalogRequest      --     554,310 as of 5/3/17 @5:52PM v on staging & DW1 =     554,310 5-8 9am -- NOT UPDATING
select count(*) from tblCustomerOffer       --  26,403,957 as of 5/3/17 @5:41PM v on staging & DW1 =     26,403,957 5-8 9am -- NOT UPDATING     SMIHD-7462 had to push 1 record manually 5-8-17
select count(*) from tblInventoryForecast   --     343,459 as of 5/3/17 @5:41PM v on staging & DW1 =     343,459 5-8 9am -- NOT UPDATING        SMIHD-7503
select count(*) from tblOrderTiming         --   1,654,860 as of 5/3/17 @5:41PM v on staging & DW1 =     1,654,860 5-8 9am -- NOT UPDATING      SMIHD-7504
-- tabels with  dtDateLastSOPUpdate
select top 1 dtDateLastSOPUpdate, ixTimeLastSOPUpdate from tblCatalogRequest order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc -- 2017-05-03
select top 1 dtDateLastSOPUpdate, ixTimeLastSOPUpdate from tblCustomerOffer order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc -- 2017-05-03
select top 1 dtDateLastSOPUpdate, ixTimeLastSOPUpdate from tblInventoryForecast order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc -- 2017-04-29
select top 1 dtDateLastSOPUpdate, ixTimeLastSOPUpdate from tblOrderTiming order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc -- 2017-04-29
select top 1 dtDateLastSOPUpdate, ixTimeLastSOPUpdate from tblCreditMemoReasonCode order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc -- 2017-05-08
select top 1 dtDateLastSOPUpdate, ixTimeLastSOPUpdate from tblGiftCardDetail order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc -- 2017-05-08
select top 1 dtDateLastSOPUpdate, ixTimeLastSOPUpdate from tblGiftCardMaster order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc -- 2017-05-08
select top 1 dtDateLastSOPUpdate, ixTimeLastSOPUpdate from tblMergedCustomers order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc -- 2017-05-08
select top 1 dtDateLastSOPUpdate, ixTimeLastSOPUpdate from tblOrderPromoCodeXref order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc -- 2017-05-08
select top 1 dtDateLastSOPUpdate, ixTimeLastSOPUpdate from tblProductLine order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc -- 2017-05-05
select top 1 dtDateLastSOPUpdate, ixTimeLastSOPUpdate from tblSnapshotSKU order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc --
select top 1 dtDateLastSOPUpdate, ixTimeLastSOPUpdate from tblSKUTransaction order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc -- 
select top 1 dtDateLastSOPUpdate, ixTimeLastSOPUpdate from tblMailingOptIn order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc -- 2017-05-08 @20sec

SELECT ixTime, chTime from tblTime where ixTime in (4883,8276,12008) order by ixTime
/*  ixTime	chTime
    4883	01:21:23  
    8276	02:17:56  
    12008	03:20:08  
*/

select top 10 * from tblShippingPromo       --      52,507 as of 5/3/17 @5:18PM v on staging & DW1 ^     52,552 5-8 9am 
select top 10 * from tblSKUPromo            --     121,961 as of 5/3/17 @5:18PM v on staging & DW1 ^     122,506 5-8 9am 

-- BULK INSERT TABLES
SELECT sTableName, sRowCount, CONVERT(VARCHAR, dtDate, 102)  AS 'Date'
from tblTableSizeLog
where dtDate >= '05/10/2017'
    and sTableName in ('tblCatalogDetail','tblCatalogMaster','tblFIFODetail',
                        'tblGiftCardDetail','tblGiftCardMaster','tblShippingPromo','tblSKUPromo')
order by sTableName


-- WORKING TABLES
SELECT sTableName, sRowCount, CONVERT(VARCHAR, dtDate, 102)  AS 'Date'
from tblTableSizeLog
where dtDate >= '05/10/2017'
    and sTableName in ('tblCatalogRequest','tblCreditMemoReasonCode','tblCustomerOffer','tblInventoryForecast',
                        'tblMailingOptIn','tblMergedCustomers','tblOrderTiming','tblProductLine','tblOrderPromoCodeXref',
                        'tblOrderPromoCodeXref','tblPromoCodeMaster',
                        'tblSKUTransaction','tblSnapshotSKU','tblSourceCode','tblTrailerZipTNT','tblVendor')
order by sTableName


-- TABLES WITH POTENTIAL ISSUES
SELECT sTableName, sRowCount, CONVERT(VARCHAR, dtDate, 102)  AS 'Date'
from tblTableSizeLog
where dtDate >= '05/08/2017'
    and sTableName in ('######')
order by sTableName

 
select * from vwDataFreshness
where sTableName in ('tblSKUTransaction','tblSnapshotSKU','tblFIFODetail','tblShippingPromo','tblSKUPromo','tblGiftCardMaster','tblGiftCardDetail','tblFIFODetail',
    'tblCreditMemoReasonCode','tblCatalogDetail','tblCatalogMaster','tblSnapshotSKU','tblMailingOptIn','tblMergedCustomers','tblCatalogRequest','tblCreditMemoReasonCode')
order by sTableName, DaysOld
/* AS OF 6:06PM 5-3-17
sTableName	            Records	DaysOld
tblCatalogRequest	    918	   <=1
tblCreditMemoReasonCode	127	   <=1
tblGiftCardDetail	    49851   <=1
tblGiftCardMaster	    62848   <=1
tblMailingOptIn	        21750   <=1
tblMergedCustomers	    104	   <=1
*/

select * from vwDataFreshness
--where sTableName in ('#######')
order by sTableName, DaysOld
   
/**********     tblSnapshotSKU    **************/
    select ixDate, COUNT(*) 
    from tblSnapshotSKU -- NO data in tblSnapshotSKU for SUN or MON
    where ixDate >= 18018
    group by ixDate
    order by ixDate desc
    /* SMI
    ======= =====   ========    ==========
          0 18022   THUR 
    343,620	18021   WEDNESDAY   2017-05-03
          0 18020   TUESDAY     2017-05-02
    139,259 18019	MONDAY	    2017-05-01
          0 18018	SUNDAY	    2017-04-30
    343,438 18017	SATURDAY	2017-04-29  
    343,386 18016	FRIDAY	    2017-04-28  
    343,330 18015	THURSDAY	2017-04-27  
    
    
       AFCO
    ======= =====   ========    ==========       
         0   18019	MONDAY	    2017-05-01
         0   18018	SUNDAY	    2017-04-30
    63,930   18017	SATURDAY	2017-04-29  
    63,930   18016	FRIDAY	    2017-04-28  
    63,922   18015	THURSDAY	2017-04-27         
    */




select ixDate, COUNT(*) 
from tblFIFODetail FD
where ixDate >= 18017
group by ixDate
order by ixDate desc
/*
    SMI
Rows    ixDate  Day         Date
======= ======  =========   ==========

      0   18019	MONDAY	    2017-05-01
249,566   18018	SUNDAY	    2017-04-30  	
      0   18017	SATURDAY	2017-04-29
250,256   18016	FRIDAY	    2017-04-28
250,286   18015	THURSDAY	2017-04-27

    AFCO
Rows    ixDate  Day         Date
======= ======  =========   ==========
      0   18019	MONDAY	    2017-05-01
      0   18018	SUNDAY	    2017-04-30
      0   18017	SATURDAY	2017-04-29
 44,533   18016	FRIDAY	    2017-04-28
 44,182   18015	THURSDAY	2017-04-27

*/

select  * from tblCatalogRequest
order by dtDateLastSOPUpdate desc




SELECT COUNT(*) Records, GETDATE() 'As of'
from tblSnapshotSKU
where ixDate = 18019
/*
 13,434	2017-05-01 18:38
 13,915	2017-05-01 18:39
136,606	2017-05-01 20:33  -- 64k/hr   ETA 11:45PM
139259	2017-05-01 21:08
139259	2017-05-02 09:12

343k
*/

select * from tblMergedCustomers
order by dtDateMerged desc -- 2017-04-28

select * from tblOrderTiming
order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc -- 2017-04-29

select * from tblOrderTiming
order by dtLastUpdate desc -- 2017-04-29 

select COUNT(*) from tblCatalogDetail -- 48692

select * from tblOrderPromoCodeXref
order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate desc -- 2017-04-29 

select * from tblCatalogDetail


SELECT sTableName, sRowCount, CONVERT(VARCHAR, dtDate, 102)  AS 'Date'
 from tblTableSizeLog
where dtDate >= '2017.04.18'
    and sTableName = 'tblPromoCodeMaster'
order by dtDate

select COUNT(*) from tblPromoCodeMaster

select COUNT(*)
from tblOrderTiming -- 1,654,860

select * from tblOrderTiming
order by dtDateLastSOPUpdate desc

tblOrderTiming spUpdateOrderTiming

select * from tblVendor -- 1864
order by dtDateLastSOPUpdate

SELECT COUNT(*) from tblCustomerOffer -- 26,359,898
SELECT * from tblCustomerOffer -- 26,359,898
where dtDateLastSOPUpdate > = '04/20/2017'
order by dtDateLastSOPUpdate desc

select * from tblSourceCode
where ixSourceCode in ('41298','80298','51598')


select * from tblPromoCodeMaster
where UPPER(ixPromoCode) like '%FLASH%'


select ixSourceCode, COUNT(*) OfferCount
from tblCustomerOffer
where ixSourceCode like '%98'
 and dtActiveStartDate >= '01/01/2017'
group by ixSourceCode
order by ixSourceCode



select * from tblCustomerOffer
where dtDateLastSOPUpdate >= '05/03/2017'

select COUNT(*) from tblPromoCodeMaster -- 2141
select * from tblPromoCodeMaster
where dtDateLastSOPUpdate >= '05/03/2017' -- 2125
-- order by dtDateLastSOPUpdate desc

select distinct ixPromoId
from tblPromoCodeMaster -- 1957
where dtDateLastSOPUpdate >= '05/03/2017'

select distinct ixPromoCode
from tblPromoCodeMaster -- 1817
where dtDateLastSOPUpdate >= '05/03/2017'

select * from tblCreditMemoReasonCode



