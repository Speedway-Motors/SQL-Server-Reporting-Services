-- Refeed Stale tables

select * from vwDataFreshness
order by sTableName, DaysOld



/****************** Bins **************************/
-- 199,390 records @1-18-17
select * from tblBin
where flgDeletedFromSOP = 0
--and ixLocation = 99
order by dtDateLastSOPUpdate, ixBin


select * from tblBin where ixBin = '7C24G13'

update tblBin
set flgDeletedFromSOP = 1
where ixBin in ('3A25B2','3A35A2','3A35B2','3A36A2','3A36B2','3A37A2','3B15F4')
and ixLocation = 99


/****************** BOMs **************************/
-- 9,714 records @1-18-17
-- 15 mins to refeed ALL records through Reporting Feeds Menu  <3> BOMs
select * from tblBOMTemplateMaster
where flgDeletedFromSOP = 0
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate, 
    ixFinishedSKU

select * from tblBOMTemplateMaster
where ixFinishedSKU = '2010201'
/*
   DW-STAGING1 ONLY!!!!!!
BEGIN TRAN
    UPDATE tblBOMTemplateMaster
    SET flgDeletedFromSOP = 1
    WHERE ixFinishedSKU in ('213SN7A3535','213SN7A5555','721269','9107706','94036014-R','960004','91539741-1','HZ5THNF-.38','HZ8HCSC-.38-2.00','HZ8HCSC-.38-2.50','HZ8HCSC-.38-3.00','491100048','10680100A','98621126','910047-FBLK','91631916.3','9163354.1','7957435251','7958223881','98621190','98621191','98621192','98621193','98621194','9606225','350510','350500','98621319','98621318','98620002','91140117','95611146','HSSPPHS-10-32-.38','HZ2SFW-SAE-10','HSSPPHS-10-32-.31','HZ2PSMS-6-.75','HZ2PPHS-6-32-1.00','HB8SSC-6-32-.75','HZ2PPHS-10-32-.31','HZ2PPHS-10-32-.25','HZ2PPHS-10-32-.38','HZ2SRHSC-6-32-.25','HZ2SRHSC-6-32-.38','HZ2SRHSC-.38-3.50','HZ2SRHSC-8-32-.50','HZ2SRHSC-10-24-.38','HZ2SRHSC-8-32-.38','HZ2SRHSC-8-32-.75','HZ2SNC-8-32','HZ2HNC-6-32','HZ2HNC-8-32','HZZERK00F-.25-.52','HZ2PSMS-10-.50','HZ2PSMS-10-1.00','HZ2PFHSC-10-24-.75','HZ8HN-USS-.50','94036014-L','HZ8HN-USS-.44','5501130','HSSPPHS-8-32-.63','91084100-SET','P8P0.62F01N','96621262','96621235','3403134','91667960-CHR','91667960-BLK','91667960-RAW','92618407','7154900')
ROLLBACK TRAN
*/
/****************** BOM Sequence **************************/
-- 10 seconds to refeed ALL records through Reporting Feeds Menu <4> BOM Sequences
-- 571 records @1-18-17
select * from tblBOMSequence
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate, 
    ixFinishedSKU

select * from tblBOMTemplateMaster
where ixFinishedSKU = '2010201'

/****************** BOM Transfers **************************/
-- 72,756 records @1-18-17
select top 10000 * from tblBOMTransferMaster -- feeds approx 1k/min
--where flgDeletedFromSOP = 0
WHERE dtDateLastSOPUpdate =  '2/1/2016'
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate, 
    ixTransferNumber

select * from tblBOMTransferMaster
where ixTransferNumber = '1088337-1'

1088337-1	1756047-RH	50	50	0	11348	11348	NULL	0	0	2014-03-12 	70138
1088337-1	1756047-RH	50	50	0	11348	11348	NULL	0	0	2014-06-11 	53837


/****************** CUSTOMERS **************************/
select ixCustomer, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblCustomer
where flgDeletedFromSOP = 0
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate, 
    ixCustomer

select * from tblCustomer
where ixCustomer = '1095311'



/****************** EMPLOYEES **************************/
-- 1,517 records @1-18-17
select * from tblEmployee
where flgDeletedFromSOP = 0
order by dtDateLastSOPUpdate

select --min(ixTimeLastSOPUpdate), max(ixTimeLastSOPUpdate),
count(*) 'Qty',
max(ixTimeLastSOPUpdate) - min(ixTimeLastSOPUpdate) 'TotSec',
(count(*)/(max(ixTimeLastSOPUpdate) - min(ixTimeLastSOPUpdate))) 'Rec/Sec'
from tblEmployee where dtDateLastSOPUpdate = '06/11/2014'



/****************** Inventory Forecast **************************/
-- 330,439 records @1-18-17
select ixSKU,dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblInventoryForecast
--where flgDeletedFromSOP = 0
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate, ixSKU

select ixSKU,dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblInventoryForecast
where ixSKU = '10730359002'

ixSKU	    dtDateLastSOPUpdate	    ixTimeLastSOPUpdate
10730359002	2014-06-10 	719766
10730359002	2014-06-11 	45932


/****************** KITS **************************/
-- 74,246 records @1-18-17

select * from tblKit
--where flgDeletedFromSOP = 0
order by dtDateLastSOPUpdate

select ixKitSKU, dtDateLastSOPUpdate, ixTimeLastSOPUpdate 
from tblKit
where ixKitSKU = '10616-THREADED-6-3-3'

10616-THREADED-6-3-3	2014-06-10 	57406
10616-THREADED-6-3-3	2014-06-11 	58544

select count(*) from tblKit -- 69700
where dtDateLastSOPUpdate = '06/11/2014'

select * from tblKit -- 69700
where dtDateLastSOPUpdate < '06/11/2014'
and ixKitSKU in (select ixSKU from tblSKU where flgDeletedFromSOP = 1)

select --min(ixTimeLastSOPUpdate), max(ixTimeLastSOPUpdate),
count(*) 'Qty',
max(ixTimeLastSOPUpdate) - min(ixTimeLastSOPUpdate) 'TotSec',
(count(*)/(max(ixTimeLastSOPUpdate) - min(ixTimeLastSOPUpdate))) 'Rec/Sec'
from tblKit where dtDateLastSOPUpdate = '06/11/2014'

/*
Qty	    TotSec	Rec/Sec
69693	1195	58
*/

/****************** Mailing Opt In **************************/
select * --ixCustomer,dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblMailingOptIn
--where flgDeletedFromSOP = 0
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate, ixCustomer

-- ixCust starts with '1067%' 72 CUSTS 360 lines




/****************** ORDERS **************************/
select ixOrder, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblOrder
where dtOrderDate >= '06/27/2011'
and  dtDateLastSOPUpdate is NULL
--dtDateLastSOPUpdate < '12/01/2012'
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate, 
    ixOrder


select ixOrder, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblOrder
where ixOrder = '4114822'



/****************** RECEIVERS **************************/
-- refeed REC/SEC using <D>ate Range = 69
-- refeed REC/SEC using <L>ist =       69
-- APPROX 24 mins to feed all 100K SMI Recievers
select * from tblReceiver
where flgDeletedFromSOP = 0
--and dtDateLastSOPUpdate = '2014-05-02'
order by ixCreateDate, dtDateLastSOPUpdate, ixTimeLastSOPUpdate, ixReceiver 

select ixReceiver, dtDateLastSOPUpdate, ixTimeLastSOPUpdate 
from tblReceiver
where ixReceiver = '122007'

149000	2014-05-06 	56635
149000	2014-06-11 	58822

select R.ixCreateDate, D.dtDate, count(*)
from tblReceiver R
    join tblDate D on R.ixCreateDate = D.ixDate
group by R.ixCreateDate, D.dtDate
order by R.ixCreateDate, D.dtDate
/*
ixCreateDate	dtDate	(No column name)
16351	    2012-10-06 	1
16353	    2012-10-08 	59
*/

select ixReceiver, dtDateLastSOPUpdate, ixTimeLastSOPUpdate -- 1,813
from tblReceiver
where ixCreateDate between 16354 and 16400
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate 

select ixDate, dtDate
from tblDate
where ixDate in (16401,16800)
16401	2012-11-25
16800	2013-12-29 

select R.ixCreateDate, D.dtDate, count(*)
from tblReceiver R
    join tblDate D on R.ixCreateDate = D.ixDate
group by R.ixCreateDate, D.dtDate
order by R.ixCreateDate, D.dtDate
/*
ixCreateDate	dtDate	(No column name)
16351	    2012-10-06 	1
16353	    2012-10-08 	59
*/

select ixReceiver, dtDateLastSOPUpdate, ixTimeLastSOPUpdate -- 18,277
from tblReceiver
where ixCreateDate between 16401 and 16800
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate 



select count(*) from tblKit -- 69700
where dtDateLastSOPUpdate = '06/11/2014'

select * from tblKit -- 69700
where dtDateLastSOPUpdate < '06/11/2014'
and ixKitSKU in (select ixSKU from tblSKU where flgDeletedFromSOP = 1)

-- REC/SEC using 
select --min(ixTimeLastSOPUpdate), max(ixTimeLastSOPUpdate),
count(*) 'Qty',
max(ixTimeLastSOPUpdate) - min(ixTimeLastSOPUpdate) 'TotSec',
(count(*)/(max(ixTimeLastSOPUpdate) - min(ixTimeLastSOPUpdate))) 'Rec/Sec'
from tblReceiver where ixCreateDate between 16801 and 17000
and dtDateLastSOPUpdate = '06/11/2014'

/*
Qty	    TotSec	Rec/Sec
18,277	262     69.8
 7,559  109     69.3
*/

/****************** SKUs **************************/
select ixSKU, dtDateLastSOPUpdate, ixTimeLastSOPUpdate  from tblSKU
where flgDeletedFromSOP = 0
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate, ixSKU 

select ixSKU, dtDateLastSOPUpdate, ixTimeLastSOPUpdate 
from tblSKU
where ixSKU = '3912500'

10616-THREADED-6-3-3	2014-06-10 	57406
10616-THREADED-6-3-3	2014-06-11 	58544

select ixSKU from tblSKU -- 349
where dtDateLastSOPUpdate < '03/05/2014' -- kicked off at 5:21
and flgDeletedFromSOP = 0

select * from tblSKU -- 69700
where dtDateLastSOPUpdate < '06/11/2014'
and ixKitSKU in (select ixSKU from tblSKU where flgDeletedFromSOP = 1)

select --min(ixTimeLastSOPUpdate), max(ixTimeLastSOPUpdate),
count(*) 'Qty',
max(ixTimeLastSOPUpdate) - min(ixTimeLastSOPUpdate) 'TotSec',
(count(*)/(max(ixTimeLastSOPUpdate) - min(ixTimeLastSOPUpdate))) 'Rec/Sec'
from tblSKU where dtDateLastSOPUpdate = '06/11/2014'

/*
Qty	    TotSec	Rec/Sec
69693	1195	58
*/

/****************** TIMECLOCK **************************/
select * from tblTimeClock
where ixDate between 16860 and 16861
order by dtDateLastSOPUpdate

SELECT * from tblTimeClock
where ixEmployee = 'TAH'
order by dtDateLastSOPUpdate

select --min(ixTimeLastSOPUpdate), max(ixTimeLastSOPUpdate),
count(*) 'Qty',
max(ixTimeLastSOPUpdate) - min(ixTimeLastSOPUpdate) 'TotSec',
(count(*)/(max(ixTimeLastSOPUpdate) - min(ixTimeLastSOPUpdate))) 'Rec/Sec'
from tblEmployee where dtDateLastSOPUpdate = '06/11/2014'
AND ixEmployee = 'CJN'
