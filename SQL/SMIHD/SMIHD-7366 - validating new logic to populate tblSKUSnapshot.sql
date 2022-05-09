/*********************** comparing results in PJC_tblSKUSnapshotPopBySQLDB to tblSnapshotSKU **********************/
SELECT *, 
     ABS(NSS.mAverageCost-SS.mAverageCost) AvgCostDELTA,
     ABS(NSS.mLastCost-SS.mLastCost) LastCostDELTA
FROM PJC_tblSKUSnapshotPopBySQLDB NSS
    left join [SMI Reporting].[dbo].tblSnapshotSKU SS on NSS.ixSKU = SS.ixSKU -- 345,222
WHERE (SS.ixDate = 18015 and NSS.ixDate = 18015)
    AND 
        (ISNULL(NSS.iFIFOQuantity,0) <> ISNULL(SS.iFIFOQuantity,0)              -- 343,246 match       11 do not 
         OR ISNULL(NSS.mFIFOExtendedCost,0) <> ISNULL(SS.mFIFOExtendedCost,0)   -- 343,256 match        1 do not 
         OR ABS(ISNULL(NSS.mLastCost,0)-ISNULL(SS.mLastCost,0)) > .01           -- 343,253 match        4 do not -- ROUNDING. current SS goes to 3 decimals, internal SQL SS goes to 2            
         -- OR ABS(ISNULL(NSS.mAverageCost,0)-ISNULL(SS.mAverageCost,0)) > .01  -- 336,803 match    6,454 do not -- ROUNDING. current SS goes to 3 decimals, internal SQL SS goes to 2          
         OR (NSS.ixSKU IS NULL AND SS.ixSKU IS NOT NULL)
         OR (SS.ixSKU IS NULL AND NSS.ixSKU IS NOT NULL)
         )
order by -- ABS(ISNULL(NSS.mLastCost,0)-ISNULL(SS.mLastCost,0)) desc
            ABS(ISNULL(NSS.mAverageCost,0)-ISNULL(SS.mAverageCost,0)) desc   