-- PRS Catalog Price Changes - 2021 vs 2020

SELECT s.ixSKU, -- 99,447 same price       3,858 price changed (2,144 of which are KITS) 
    isnull(s.sWebDescription,s.sDescription) 'SKUDescriptin',      
    s.mPriceLevel1 as 'Retail',      
    cd.mPriceLevel3 as 'PRS.21',      
    cd1.mPriceLevel3 as 'PRS.20',      
    s.mAverageCost,      s.mLatestCost,
    s.sSEMACategory, s.sSEMASubCategory, s.sSEMAPart,
    V.ixVendor 'VNum', V.sName 'PVendor',
    (cd.mPriceLevel3-cd1.mPriceLevel3) 'PriceChange',
    ABS(cd.mPriceLevel3-cd1.mPriceLevel3) 'ABSPriceChange'
    --  s.dtCreateDate,           -- ALL created on or before 6-11-2020
    --  s.ixProductLifeCycleCode, -- ALL MATURE PLC
--INTO #PRS_SKUsWithPriceChanges  -- DROP TABLE #PRS_SKUsWithPriceChanges
FROM tblSKU s       
    left join tblCatalogDetail cd on s.ixSKU = cd.ixSKU and cd.ixCatalog = 'PRS.21'      
    left join tblCatalogDetail cd1 on s.ixSKU=cd1.ixSKU and cd1.ixCatalog='PRS.20'  
    left join tblVendorSKU VS on VS.ixSKU = s.ixSKU
                                 and VS.iOrdinality = 1
    left join tblVendor V on V.ixVendor = VS.ixVendor
WHERE cd.ixSKU is not null  
     and s.flgDeletedFromSOP = 0   
     and s.flgActive=1      
     and s.ixSKU not like 'UP%'   
     and cd1.mPriceLevel3 <> cd.mPriceLevel3 
     --and flgIsKit = 0
ORDER BY ABS(cd.mPriceLevel3-cd1.mPriceLevel3) DESC
   -- V.ixVendor

/*
SELECT count(ixSKU) 'SKUCnt', VNum, PVendor 
FROM #PRS_SKUsWithPriceChanges
GROUP BY VNum, PVendor
ORDER BY count(ixSKU) DESC

-- TOP 10 PVs with most SKU price changes
        
        PV
SKUCnt	Num	    PVendor
======  ====    ========================
2138	0002	SPEEDWAY KIT ITEMS
174 	3687	SOFFSEAL INC
146	    0106	AFCO RACING
131	    0120	WHEEL PROS
121	    0425	HOLLEY PERFORMANCE PROD
115	    0108	AFCO DROP.SHIP
81	    0001	BILL OF MATERIAL
54	    3714	SOFFSEAL DROP.SHIP
52	    0674	SPARCO MOTOR SPORTS INC
49	    3250	WHEELSMITH


SELECT count(ixSKU) 'SKUCnt', sSEMACategory
FROM #PRS_SKUsWithPriceChanges
GROUP BY sSEMACategory
ORDER BY count(ixSKU) DESC

 -- TOP 10 SEMA Categories with most SKU price changes

SKU
Cnt	sSEMACategory
=== ================================
2307 Chassis and Suspension
222	Exterior, Accessories and Trim
164	NULL
162	Wheel and Tire
136	Engine
116	Air and Fuel Delivery
85	Ignition, Charging and Starting
70	Safety Equipment
69	Brakes
62	Gaskets and Seals



SELECT AVG(PriceChange) 'AvgPriceChange', 
    AVG(ABSPriceChange) 'AvgABSPriceChange'
FROM #PRS_SKUsWithPriceChanges

Avg     AvgABS
Price   Price
Change	Change
======  ======
^$6.40	^$7.63

*/