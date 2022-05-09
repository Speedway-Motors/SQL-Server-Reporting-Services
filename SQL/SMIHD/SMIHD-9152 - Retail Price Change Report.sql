-- SMIHD-9152 - Retail Price Change Report

/******     NIGHTLY JOB STEPS FOR PRS    ********/
-- DROP TABLE tblSnapshotWEBPriceLevel1
-- TRUNCATE table tblSnapshotWEBPriceLevel1 -- 6 sec to DELETE all records from the table amd 6 sec to populate it with 275k records
INSERT INTO tblSnapshotWEBPriceLevel1
SELECT CD.ixSKU
    , CD.mPriceLevel1 'WEBPriceLevel1'
    , DATEADD(dd,0,DATEDIFF(dd,0,GETDATE())) 'dtDateRecorded'
    , dbo.GetCurrentixTime() 'ixTimeRecorded'
FROM tblCatalogDetail CD
WHERE CD.ixCatalog = (SELECT dbo.[GetCurrentWebCatalog] () ) -- current active WEB. catalog -- 275k


select COUNT(*) from tblSnapshotWEBPriceLevel1 -- 275,539
select top 10 * from tblSnapshotWEBPriceLevel1
275539
                                             

-- WEB price changes for PRS SKUs
SELECT YD.ixSKU 'SKU'
    , ISNULL(S.sWebDescription,S.sDescription) 'SKUDescription' 
    , YD.WEBPriceLevel1 'YesterDayWEBPriceLevel1'
    , CD.mPriceLevel1 'CurrentWEBPriceLevel1'
    , CD.mPriceLevel3 'CurrentWEBPriceLevel3'
    , CD.mPriceLevel4 'CurrentWEBPriceLevel4'    
    ,S.mAverageCost 'AvgCost'
    ,S.mLatestCost 'LatestCost'
    ,VS.mCost 'PVCost'
    ,VS.ixVendor 'PVNum'
    ,V.sName 'PVName'    
FROM tblSnapshotWEBPriceLevel1 YD
    join tblCatalogDetail CD on YD.ixSKU = CD.ixSKU and CD.ixCatalog = (SELECT dbo.[GetCurrentWebCatalog] ())
    join tblCatalogDetail CD2 on CD2.ixSKU = YD.ixSKU and CD2.ixCatalog = 'PRS.17'
    left join tblSKU S on YD.ixSKU = S.ixSKU
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on V.ixVendor = VS.ixVendor       
WHERE YD.WEBPriceLevel1 <> CD.mPriceLevel1

/* What does the timing need to be for the daily job and the daily report subscription?

tblCatalogDetail is populated nightly by 2:30am

Report runs at 4:30 am.... shows SKUs that have a PL that differs from the PL snapshot taken at 5am previous day

5am SS executes snapshot for current day


select count(*) 'RecCount',
MIN(ixTimeRecorded),
MAX(ixTimeRecorded)
from tblSnapshotWEBPriceLevel1

*/


SELECT
/* YD.ixSKU 'SKU'
    , ISNULL(S.sWebDescription,S.sDescription) 'SKUDescription' 
    , YD.WEBPriceLevel1 'YesterDayWEBPriceLevel1'
    , CD.mPriceLevel1 'CurrentWEBPriceLevel1'
    ,S.mAverageCost 'AvgCost'
    ,S.mLatestCost 'LatestCost'
    ,VS.mCost 'PVCost'
    ,VS.ixVendor 'PVNum'
*/    
    V.sName 'PVName'    
    , COUNT(YD.ixSKU) SKUCnt
FROM tblSnapshotWEBPriceLevel1 YD
    join tblCatalogDetail CD on YD.ixSKU = CD.ixSKU and CD.ixCatalog = (SELECT dbo.[GetCurrentWebCatalog] ())
    join tblCatalogDetail CD2 on CD2.ixSKU = YD.ixSKU and CD2.ixCatalog = 'PRS.17'
    left join tblSKU S on YD.ixSKU = S.ixSKU
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on V.ixVendor = VS.ixVendor       
WHERE YD.WEBPriceLevel1 <> CD.mPriceLevel1
group by V.sName
order by PVName



SmiReportingPublicationDataSnapshotWEBPriceLevel1


SELECT * FROM tblSnapshotWEBPriceLevel1




SELECT * FROM tblCatalogSKU
WHERE ixSKU = '1007001'

SELECT ixSKU, mPriceLevel1 'YdayWebPriceLevel1',
    GETDATE() 'dtDateRecorded'
from tblCatalogDetail CS
where ixCatalog = (fn -- 275,299


select * from vwDataFreshness
where sTableName = 'tblCustomer'


select COUNT(distinct ixCustomer)
from tblOrder
where dtShippedDate >= '12/01/2016'
and ixOrder NOT LIKE 'P%'
and ixOrder NOT LIKE 'Q%'

select * from tblCatalogDetail where ixCatalog = 'WEB.18'




-- FINDING TEST SKU TO ALTER
SELECT S.ixSKU, S.mPriceLevel1 'tblSKUPL1', S.mAverageCost, S.dtDiscontinuedDate, SKULL.iQAV, CD.mPriceLevel1 'CurrentWEBPL1'
FROM tblSnapshotWEBPriceLevel1 YD
    join tblCatalogDetail CD on YD.ixSKU = CD.ixSKU and CD.ixCatalog = (SELECT dbo.[GetCurrentWebCatalog] ())
    join tblCatalogDetail CD2 on CD2.ixSKU = YD.ixSKU and CD2.ixCatalog = 'PRS.17'
    join tblSKU S on S.ixSKU = YD.ixSKU
    join vwSKULocalLocation SKULL on S.ixSKU = SKULL.ixSKU
WHERE S.flgDeletedFromSOP = 0  
  and S.flgActive = 0
 -- and  SKULL.iQAV = 0
  --and S.mPriceLevel1 > 2000
ORDER BY S.dtDiscontinuedDate  

/***** TEST SKUS JESSE changed prices on 12-12-17 *******/
SELECT S.ixSKU, S.mPriceLevel1 'SKUPL1', CD2.mPriceLevel1 'WEBPL1', CD.mPriceLevel1 'PRSPL1'
FROM tblSKU S
    join tblCatalogDetail CD on S.ixSKU = CD.ixSKU and CD.ixCatalog = 'PRS.17'
    join tblCatalogDetail CD2 on S.ixSKU = CD2.ixSKU and CD2.ixCatalog = 'WEB.17'
WHERE S.ixSKU in ('282014108','282014118','282014128','282014158','282014168','282014178','282014188','282014198','282014218','282014248')
/*
ixSKU	    SKUPL1	WEBPL1	PRSPL1
=========   ======  ======  ======
282014108	296.99	297.99	274.99
282014118	295.99	296.99	274.99
282014128	295.99	296.99	274.99
282014158	296.99	297.99	274.99
282014168	295.99	296.99	280.99
282014178	298.99	297.99	274.99
282014188	297.99	296.99	295.99
282014198	290.99	289.99	274.99
282014218	297.99	296.99	277.99
282014248	297.99	296.99	277.99
*/



select * from tblOrderLine where ixSKU = '32535260'
order by dtOrderDate desc


/* DWSTAGING1

BEGIN TRAN

UPDATE tblCatalogDetail
set mPriceLevel1 = 3777.99
where ixCatalog = 'WEB.17'
AND ixSKU = '32535260'

ROLLBACK TRAN


tblSnapshotWEBPriceLevel1 

select * from tblSnapshotWEBPriceLevel1 where ixSKU = '32535260'
/*
-- STAGING ONLY!!!!
UPDATE tblSnapshotWEBPriceLevel1
set INVPriceLevel1 = 2999.99
where  ixSKU = '32535260'
*/