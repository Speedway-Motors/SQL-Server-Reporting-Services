-- unused or empty tables

-- TABLES TO THAT CAN BE REMOVED FROM REPLICATION
/* AS OF 5-2-2016
tblDoorEventArchive
tblLoanTicketDetail
tblLoanTicketMaster
tblLoanTicketScans
tblOrderFreeShippingEligible
tblOrderTNT
*/      
      
select distinct sTableName
from tblTableSizeLog
where sRowCount = 0 -- 150
    and dtDate >= '12/01/2020'
    and sTableName NOT IN ('tblAwsQueue') -- sometimes legit empty
    -- and sTableName like 'tbl%' -- 156

SELECT  sTableName, max(dtDate) 'LastPopulated'
from tblTableSizeLog
where sTableName in ('tblCompetitorPricing','tblDoorEvent','tblDoorEventArchive','tblDoorEventArchive010114to041414','tblDoorEventArchive041514to123114','tblLatestFeed','tblLoanTicketDetail','tblLoanTicketMaster','tblLoanTicketScans','tblOrderFreeShippingEligible','tblOrderTNT','tblPromotionalInventory','tblSKUIndex','tblSplitOrderXref')
and sRowCount > 0
group by sTableName
order by  max(dtDate) desc


SELECT * FROM  tblTableSizeLog

-- ALL tables that are CURRENTLY empty
SELECT sTableName,sRowCount
FROM tblTableSizeLog
WHERE  sRowCount = 0 
    and dtDate >= (GETDATE()-1) -- AFTER yesterday

	
Try converting it before summing. eg.

SELECT SUM(CONVERT(bigint, columnname)) FROM tablename
or

SELECT  FROM tablename

-- tables that have NEVER contained data
SELECT sTableName, SUM(CAST(sRowCount AS BIGINT)) 'RowsFromAllHistory'
FROM tblTableSizeLog
GROUP BY sTableName
HAVING SUM(CAST(sRowCount AS BIGINT)) = 0
/*
tblLoanTicketDetail
tblLoanTicketMaster
tblLoanTicketScans
*/




-- details on specific tables
SELECT sTableName, MIN(sRowCount) 'MinRowCount', 
    MAX(sRowCount) 'MaxRowCount', 
    MIN(dtDate) 'TrackingStart', 
    MAX(dtDate) 'LatestCheck'
FROM tblTableSizeLog
WHERE sTableName in ('tblDoorEventArchive','tblLoanTicketDetail','tblLoanTicketMaster','tblLoanTicketScans','tblOrderFreeShippingEligible','tblOrderTNT')
GROUP by sTableName
ORDER BY sTableName

-- Last time specified tables contained data
SELECT sTableName, CONVERT(VARCHAR,  MAX(dtDate), 102)  AS 'LastDateWRecords'
FROM (
        SELECT sTableName, dtDate, sRowCount
        FROM tblTableSizeLog
        where sTableName in ('tblDoorEventArchive','tblLoanTicketDetail','tblLoanTicketMaster','tblLoanTicketScans','tblOrderFreeShippingEligible','tblOrderTNT')
        and sRowCount > 0
      ) X
group by  sTableName     
/*
LastDate
WRecords	sTableName
2016.01.04	tblDoorEventArchive
2015.08.12	tblOrderFreeShippingEligible
2014.01.15	tblOrderTNT
*/


SELECT distinct(sTableName) -- 103
FROM tblTableSizeLog

SELECT sTableName, MIN(sRowCount) 'MinRowCount', 
    MAX(sRowCount) 'MaxRowCount', 
    MIN(dtDate) 'FirstDateWithRows', 
    MAX(dtDate) 'LastDateWithRows'
FROM tblTableSizeLog
WHERE -- sTableName in ('tblLoanTicketDetail','tblLoanTicketMaster','tblLoanTicketScans','tblOrderTNT')
-- and 
sRowCount <> 0
GROUP by sTableName
order by MaxRowCount desc

