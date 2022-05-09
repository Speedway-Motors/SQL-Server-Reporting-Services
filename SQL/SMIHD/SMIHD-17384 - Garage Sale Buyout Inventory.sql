/* SMIHD-17384 - Garage Sale Buyout Inventory.rdl
    ver 20.17.1
*/
SELECT ixPGC 'PGC',
    S.ixSKU 'SKU',
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    FORMAT(LR.LastReceived,'yyyy.MM.dd') 'LastReceived', 
    FORMAT(dtDiscontinuedDate,'yyyy.MM.dd') 'Discontinued',
    mLatestCost 'LatestCost',
    mAverageCost 'AvgCost',
    mPriceLevel1 'CurrentPriceLvl1',
    S.mMSRP as 'ListPrice',
    SL.iQOS 'QtyOnHand'
FROM tblSKU S
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 99
    left join (-- last received date
                select ixSKU, max(dtDate) 'LastReceived'
                from tblSKUTransaction ST
                    left join tblDate D on ST.ixDate = D.ixDate
                where sTransactionType = 'R'
                group by ixSKU
               ) LR on LR.ixSKU = SL.ixSKU
WHERE flgDeletedFromSOP = 0
    and ixPGC in ('Ra','Re','Rf','Ri','Rv','Rx') -- 16,046 total SKUs
    and SL.iQOS > 0                              -- 1,890
ORDER BY LR.LastReceived DESC, S.ixSKU


select ixPGC, sDescription
from tblPGC
where ixPGC like 'R%'
order by ixPGC

select ixPGC, sDescription
from tblPGC
where ixPGC in ('Ra','Re','Rf','Ri','Rv','Rx')
order by ixPGC
/*
ixPGC	sDescription
Ra	RACE - AFCO
Re	Simpson - Clearance
Rf	Race Buy Outs
Ri	Impact
Rv	ALPINESTARS-BUYOUT
Rx	RACE - SPARCO
*/

/*
active end day, 
date received --if that's possible, 
*/


SELECT * FROM tblCatalogDetail
where ixCatalog = 'WEB.20'
AND ixSKU = 'UP110343'

-- mMSRP = 'List Price'
select mMAP, mMSRP
from tblSKU
where ixSKU = 'AUP7244'

(-- last received date
select ixSKU, max(dtDate) 'LastReceived'
from tblSKUTransaction ST
    left join tblDate D on ST.ixDate = D.ixDate
where sTransactionType = 'R'
group by ixSKU
order by max(dtDate) desc) LR

select max(dtDate) from tblDate

