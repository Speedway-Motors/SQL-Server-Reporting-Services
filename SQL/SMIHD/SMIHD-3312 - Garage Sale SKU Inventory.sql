-- SMIHD-3312 - Garage Sale SKU Inventory

-- 
SELECT count(distinct SKU.ixSKU) 
FROM tblSKU SKU
   join tblVendorSKU VS on VS.ixSKU = SKU.ixSKU and VS.iOrdinality = 1-- 11,952
   join tblSKULocation SL on SKU.ixSKU = SL.ixSKU and SL.ixLocation = 99
WHERE SKU.flgDeletedFromSOP = 0
--and SUBSTRING(SKU.ixPGC,2,1) <> UPPER(SUBSTRING(SKU.ixPGC,2,1)) -- 65,198
and SL.iQAV > 0             -- 10,694
and  VS.ixVendor = '0009'   -- 10,447


-- sku, description, create date,  cost, list price
--last touched date, location in WH
SELECT SKU.ixSKU 'SKU'
    , SKU.sDescription 'SKUDescription'
    , SKU.dtCreateDate 'Created'
    , TNG.dtCreate 'TNGCreated'
    , SKU.mLatestCost 'LatestCost'
    , SKU.mAverageCost 'AvgCost'
    , SKU.mPriceLevel1 'PriceLevel1'
    , SL.iQOS 'QtyOS'
    , SL.iQAV 'QtyAV'
    , SL.iQC 'QtyQC'
    , SL.iQCB 'QtyCB'
    , BS.ixBin 'Bin'
    , BS.iSKUQuantity 'QtyInBin'
    -- , SL.iQCBOM, SL.iQCXFER   <-- none with Qty... needed?
-- Last touched  --     -- sub-query or PROC for latest SKU Transaction
-- warehouse location
FROM tblSKU SKU
   join tblVendorSKU VS on VS.ixSKU = SKU.ixSKU and VS.iOrdinality = 1-- 11,952
   join tblSKULocation SL on SKU.ixSKU = SL.ixSKU and SL.ixLocation = 99
   join tblBinSku BS on SKU.ixSKU = BS.ixSKU and BS.iSKUQuantity > 0
LEFT JOIN (SELECT * 
           from openquery([TNGREADREPLICA],'SELECT ixSOPSKU, dtCreate, dtLastUpdate
                                FROM tblskuvariant SV 
                                            ')                             
            ) TNG on SKU.ixSKU COLLATE Latin1_General_CS_AS = TNG.ixSOPSKU COLLATE Latin1_General_CS_AS 
WHERE SKU.flgDeletedFromSOP = 0
--and SUBSTRING(SKU.ixPGC,2,1) <> UPPER(SUBSTRING(SKU.ixPGC,2,1)) -- 65,198   the rule they want to use to ID GS SKUs for THIS report is vendor 0009
    and SL.iQOS > 0             -- 10,694
    and VS.ixVendor = '0009'   -- 10,974
ORDER BY SKU.ixSKU, BS.iSKUQuantity desc

select COUNT(*) from tblBinSku

-- COLLATE Latin1_General_CS_AS 

select top 10 * from tblBinSku
order by dtDateLastSOPUpdate desc

select ixSKU, COUNT(distinct sPickingBin) PickBins
from tblBinSku
where ixLocation = 99
group by ixSKU
having COUNT(distinct sPickingBin) = 1
order by COUNT(distinct sPickingBin) desc

select ixSKU, COUNT(distinct ixBin) PickBins
from tblBinSku
where ixLocation = 99
and ixSKU in (SELECT SKU.ixSKU 
                FROM tblSKU SKU
                   join tblVendorSKU VS on VS.ixSKU = SKU.ixSKU and VS.iOrdinality = 1-- 11,952
                   join tblSKULocation SL on SKU.ixSKU = SL.ixSKU and SL.ixLocation = 99
                WHERE SKU.flgDeletedFromSOP = 0
                --and SUBSTRING(SKU.ixPGC,2,1) <> UPPER(SUBSTRING(SKU.ixPGC,2,1)) -- 65,198   the rule they want to use to ID GS SKUs for THIS report is vendor 0009
                and SL.iQOS > 0             -- 10,694
                and VS.ixVendor = '0009'   -- 10,974
                )
group by ixSKU
having COUNT(distinct ixBin) > 1
order by COUNT(distinct ixBin) desc

select * from tblBinSku
where ixSKU = '6741228-BLK-8'
and ixLocation = 99


SELECT TOP 10 * FROM tblSKUTransaction
where ixDate = 17970
order by NEWID()

SELECT ST.ixSKU, ST.sTransactionType, ST.iQty, ST.sTransactionInfo
FROM tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
    join tblTime T on ST.ixTime = T.ixTime 
ORDER BY ST.ixDate desc, ST.ixTime desc    
    
    

         
SELECT SKU.ixSKU, ST.*
from tblSKU SKU
join tblSKUTransaction ST on SKU.ixSKU = ST.ixSKU


SELECT ixSKU, MAX(ixDate

SELECT * FROM tblTime  

select ixSKU, MAX((ixDate*86400)+ixTime)
from tblSKUTransaction
group by ixSKU
order by MAX((ixDate*86400)+ixTime) desc
/*
54653000	1552732801
8352702189C	1552732801
5466800	1552732800
546638	1552732800
91050423	1552732800
3501100	1552732800
8026682	1552732800
60450610-3/4	1552732799
42510024-XXL	1552732798
91140397	1552732797
42510810HKR	1552732796
91048315	1552732782
91025610	1552732781
91048309	1552732781
80292430	1552732781
83523011324	1552732779
*/



       
 
 
 select * from tblSKU
 where sBaseIndex is NOT NULL
 and flgDeletedFromSOP = 0
 and sBaseIndex <> ixSKU
 
 select top 10 * from [SMIArchive}.dbo.BU_tblSKUIndex_20170314
 
 ixBaseSKU	ixSKU
9151386	    9151386-060
630456	    630456-FBLK-734
427122	    427122-68
910808	    910808-M-BLK
91645490	91645490-5/8
HZ5HCSF	    HZ5HCSF-.56-3.00
910723	    910723-RED-S
91012100	91012100-PRP
91599281	91599281-71
HZ8HCSC	    HZ8HCSC-.69-.75

SELECT ixSKU,  sBaseIndex
from tblSKU 
where ixSKU in ('9151386-060','630456-FBLK-734','427122-68','910808-M-BLK','91645490-5/8','HZ5HCSF-.56-3.00','910723-RED-S','91012100-PRP','91599281-71','HZ8HCSC-.69-.75')

