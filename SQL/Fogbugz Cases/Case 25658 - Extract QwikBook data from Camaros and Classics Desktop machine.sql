-- Case 25658 - Extract QwikBook data from Camaros and Classics Desktop machine
select SKUM.ixSKU, SKUM.sDescription, iQOS, mLatestCost,
 (iQOS * mLatestCost) ExtCost
from vwSKUMultiLocation SKUM 
    join tblVendorSKU VS ON SKUM.ixSKU = VS.ixSKU
where VS.ixVendor = 0265
    and iQOS <> 0
    and flgDeletedFromSOP = 0
    
    
select 
--SKUM.ixSKU, SKUM.sDescription, iQOS, mLatestCost, 
SUM (iQOS * mLatestCost) ExtCost_QOSxLatestCost, 
SUM (iQOS * mAverageCost) ExtCost_QOSxAverageCost,
SUM (iQAV * mLatestCost) ExtCost_QAVxLatestCost,
SUM (iQAV * mAverageCost) ExtCost_QAVxAverageCost
from vwSKUMultiLocation SKUM 
    join tblVendorSKU VS ON SKUM.ixSKU = VS.ixSKU
where VS.ixVendor = 0265
    --and iQOS <> 0
    and flgDeletedFromSOP = 0    
    and dtCreateDate > = '03/03/2015'
    
GROUP BY  SKUM.ixSKU, SKUM.sDescription, iQOS, mLatestCost 
ORDER BY ExtCost_QOSxLatestCost desc     
/*
Time    Total
=====   ==========
14:00   $43,278.55
14:10   $43,336.81
15:25   $46,063.58
15:40   $46,209.37
15:51   $46,510.48
16:07   $46,387.01 @3-6-2015



*/


-- Primary Vendors for the SKUs we received from C&C
SELECT VS.ixVendor, V.sName, count(VS.ixSKU)
from tblVendorSKU VS
    left join tblVendor V on VS.ixVendor = V.ixVendor
where ixSKU in (select ixSKU from tblVendorSKU where ixVendor = '0265')
and iOrdinality = 1
group by VS.ixVendor, V.sName
order by sName
