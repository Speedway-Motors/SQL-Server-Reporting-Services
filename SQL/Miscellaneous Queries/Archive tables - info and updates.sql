-- Archive tables - info and updates
select distinct sTableName from tblTableSizeLog
where dtDate in ('2/19/18','1/1/18','7/1/17', '1/1/17') -- (18313,18264,18080,17899)
    -- AND sRowCount = 0
order by sTableName 

select dtDate, SUM(sRowCount) from tblTableSizeLog
group by dtDate
--HAVING SUM(sRowCount) < 80000000
order by SUM(sRowCount)
--dtDate

select distinct sTableName from tblTableSizeLog
where dtDate in ('2/19/18','1/1/18','7/1/17', '1/1/17')
AND sRowCount = 0

SELECT sTableName, dtDate, sRowCount
from tblTableSizeLog
where dtDate in ('2/19/18','1/1/18','7/1/17', '1/1/17') -- (18313,18264,18080,17899)
    AND sTableName in ('tblDoorEventArchive','tblDoorEventArchive010114to041414','tblDoorEventArchive041514to123114','tblLoanTicketDetail','tblLoanTicketMaster','tblLoanTicketScans','tblOrderFreeShippingEligible','tblOrderTNT','tblPromotionalInventory','tblSKUIndex')
    -- AND sRowCount = 0
order by sTableName, dtDate 




-- DROP TABLE tblOriginalSEMAValues_20170220
-- TRUNCATE TABLE tblCounterOrderScansArchive
-- DELETE FROM 
/*
SET ROWCOUNT 10000

DELETE
-- SELECT * 
FROM [SMI Reporting].dbo.tblCounterOrderScans       -- ARCHIVED 16804 -	17898
WHERE ixScanDate < 17533

*/

insert into tblCounterOrderScansArchive
SELECT * FROM [SMI Reporting].dbo.tblCounterOrderScans
WHERE ixScanDate <= 17899

SELECT COUNT (*) FROM 	tblCounterOrderScansArchive                 -- 30,147   16525	16802   2013-03-29  2013-12-31
SELECT COUNT (*) FROM 	[SMI Reporting].dbo.tblCounterOrderScans    -- 232,222  16804	18313   -- ARCHIVED <= 12/31/2015

SELECT COUNT (*) FROM 	tblCustomerOfferArchive     -- 4,288,096  2005-02-07 	2008-12-31 2013-12-31
SELECT COUNT (*) FROM 	tblErrorLogMasterArchive            -- 1,282,675    2013-06-02 	2014-12-31 

SELECT COUNT (*) FROM 	tblOrderArchive                     -- 2,170,797    1967-12-31 	2005-12-31 
SELECT COUNT (*) FROM 	tblOrderFreeShippingEligibleArchive --    32,074    17392	17392   2015-08-13 
SELECT COUNT (*) FROM 	tblOrderLineArchive                 -- 7,940,321    1967-12-31 	2005-12-31 

SELECT COUNT (*) FROM 	tblOriginalSEMAValues           --     246,321  2017-01-23 	2017-01-23 
SELECT COUNT (*) FROM 	tblOriginalSEMAValues_20170220  --     349,337  2017-02-20 	2017-02-20 
SELECT COUNT (*) FROM 	tblOriginalSEMAValues_20170222  --     349,401  2017-02-22 	2017-02-22 
SELECT COUNT (*) FROM 	tblSKUTransactionArchive        --  85,389,389  15185	17471   2009-07-28  2015-10-31
SELECT COUNT (*) FROM 	tblSnapshotSKUArchive           -- 200,240,609  15342	17167   2010-01-01     2014-12-31

SELECT ixDate, dtDate from tblDate where ixDate in (16525, 16802, 17392, 15185, 17471, 15342, 17167) order by ixDate
/*
15185	2009-07-28
15342	2010-01-01
16525	2013-03-29
16802	2013-12-31
17167	2014-12-31
17392	2015-08-13
17471	2015-10-31
*/


SELECT COUNT(*) FROM tblCounterOrderScans   --    232,221
SELECT COUNT(*) FROM tblCustomerOffer       -- 28,403,138
SELECT COUNT(*) FROM tblErrorLogMaster      --  5,102,045

SELECT COUNT(*) FROM 
SELECT COUNT(*) FROM 
SELECT COUNT(*) FROM 
SELECT COUNT(*) FROM 
SELECT COUNT(*) FROM 
SELECT COUNT(*) FROM 
SELECT COUNT(*) FROM 
SELECT COUNT(*) FROM 
SELECT COUNT(*) FROM 

SELECT MIN(dtDateLastSOPUpdate), MAX(dtDateLastSOPUpdate) FROM	

SELECT MIN(ixScanDate), MAX(ixScanDate) FROM tblCounterOrderScansArchive
SELECT MIN(ixScanDate), MAX(ixScanDate) FROM [SMI Reporting].dbo.tblCounterOrderScans

SELECT MIN(dtCreateDate), MAX(dtCreateDate) FROM	tblCustomerOfferArchive
SELECT MIN(dtDate), MAX(dtDate) FROM tblErrorLogMasterArchive 

SELECT MIN(dtOrderDate), MAX(dtOrderDate) FROM	tblOrderArchive
SELECT MIN(17392), MAX(17392) FROM	tblOrderFreeShippingEligibleArchive
SELECT MIN(dtOrderDate), MAX(dtOrderDate) FROM	tblOrderLineArchive

SELECT MIN(dtArchived), MAX(dtArchived) FROM	tblOriginalSEMAValues
SELECT MIN(dtArchived), MAX(dtArchived) FROM	tblOriginalSEMAValues_20170220
SELECT MIN(dtArchived), MAX(dtArchived) FROM	tblOriginalSEMAValues_20170222
SELECT MIN(ixDate), MAX(ixDate) FROM	tblSKUTransactionArchive
SELECT MIN(ixDate), MAX(ixDate) FROM	tblSnapshotSKUArchive


SELECT TOP 10 * FROM	tblCounterOrderScansArchive
SELECT TOP 10 * FROM	tblCustomerOfferArchive
SELECT TOP 10 * FROM	tblErrorLogMasterArchive

SELECT TOP 10 * FROM	tblOrderArchive
SELECT TOP 10 * FROM	tblOrderFreeShippingEligibleArchive
SELECT TOP 10 * FROM	tblOrderLineArchive

SELECT TOP 10 * FROM	tblOriginalSEMAValues
SELECT TOP 10 * FROM	tblOriginalSEMAValues_20170220
SELECT TOP 10 * FROM	tblOriginalSEMAValues_20170222
SELECT TOP 10 * FROM	tblSKUTransactionArchive
SELECT TOP 10 * FROM	tblSnapshotSKUArchive









