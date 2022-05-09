-- Case - 26059 - GS SKUs with QAV and all of their associated markets 

-- SAVED FINAL OUTPUT FILE AS "Case 26059 - all Markets for GS SKUs with QAV of 1 or more.xlsx"
-- use that as a format template if the data needs to be refreshed/repopulated!

/***** 1.  RUN in TOAD on tngLive (or Live read-only DB if avail) export output to Excel file.   ************/
SELECT SV.ixSOPSKU as 'ixSKU' -- 46,744
, SV.sSKUVariantName
, SCAT.sCategoryName
, SSUB.sSubCategoryName
, SP.sSemaPartName
, (CASE WHEN SV.iTotalQAV > 0 THEN 'X'
   ELSE NULL
   END) 'X'
, M.sMarketName as 'ixMarket'
FROM tblskubase SB
left join tblskuvariant SV on SB.ixSKUBase = SV.ixSKUBase
left join tblskubasemarket SBM on SBM.ixSKUBase = SB.ixSKUBase
left join tblmarket M on M.ixMarket = SBM.ixMarket 
left join tblsemapart SP ON SP.ixSemaPart = SV.ixSemaPart
left join tblsemacategorization SC ON SC.ixSemaPart = SP.ixSemaPart
left join tblsemacategory SCAT ON SCAT.ixSemaCategory = SC.ixSemaCategory
left join tblsemasubcategory SSUB ON SSUB.ixSemaSubCategory = SC.ixSemaSubCategory
join (-- Garage Sale SKUS
            SELECT SV.ixSOPSKU as 'ixSKU' -- 46,745
            FROM tblskubase SB
            left join tblskuvariant SV on SB.ixSKUBase = SV.ixSKUBase
            left join tblskubasemarket SBM on SBM.ixSKUBase = SB.ixSKUBase
            left join tblmarket M on M.ixMarket = SBM.ixMarket 
            left join tblsemapart SP ON SP.ixSemaPart = SV.ixSemaPart
            left join tblsemacategorization SC ON SC.ixSemaPart = SP.ixSemaPart
            left join tblsemacategory SCAT ON SCAT.ixSemaCategory = SC.ixSemaCategory
            left join tblsemasubcategory SSUB ON SSUB.ixSemaSubCategory = SC.ixSemaSubCategory
            WHERE SV.ixSOPSKU is not null
            and M.sMarketName = 'Garage Sale' 
            ) GS on GS.ixSKU = SV.ixSOPSKU

WHERE SV.ixSOPSKU is not null
-- and M.sMarketName = 'Garage Sale' 
-- and SV.ixSOPSKU IN ('AUP2013','AUP1933')
and SV.iTotalQAV > 0
ORDER BY SV.ixSOPSKU;





/***** 2. import raw data to [SMITemp].dbo.PJC_26059_GS_SKUs_AllMarketsRawData_05182015  ******/

SELECT count(*) 'TotRows', count(distinct SKU) 'DistSKUCnt'
from [SMITemp].dbo.PJC_26059_GS_SKUs_AllMarketsRawData_05182015
/*
TotRows	DistSKUCnt
43766	10655
*/

select * from [SMITemp].dbo.PJC_26059_GS_SKUs_AllMarketsRawData_05182015
SKU	Web Description	SEMA - Category			QAV	Market

select distinct Market from [SMITemp].dbo.PJC_26059_GS_SKUs_AllMarketsRawData_05182015
order by Market
    /*
    Classic Truck
    Drag Racing
    Garage Sale
    Muscle Car
    Open Wheel

    Oval Track
    Pedal Car
    Sport Compact
    Street Rod
    T-Bucket
    */




/***** 3. Create core of Roll-up table *****/
-- DROP TABLE PJC_26059_GS_SKUs_MktRollup
SELECT TOP 0
SKU, 
[Web Description], 
[SEMA - Category], [SEMA - SubCategory], [SEMA - Part]
,CAST(NULL as varchar(1)) 'Classic Truck'
,CAST(NULL as varchar(1)) 'Drag Racing'
,CAST(NULL as varchar(1)) 'Garage Sale'
,CAST(NULL as varchar(1)) 'Muscle Car'
,CAST(NULL as varchar(1)) 'Open Wheel'
,CAST(NULL as varchar(1)) 'Oval Track'
,CAST(NULL as varchar(1)) 'Pedal Car'
,CAST(NULL as varchar(1)) 'Sport Compact'
,CAST(NULL as varchar(1)) 'Street Rod'
,CAST(NULL as varchar(1)) 'T-Bucket'
INTO [SMITemp].dbo.PJC_26059_GS_SKUs_MktRollup
 from [SMITemp].dbo.PJC_26059_GS_SKUs_AllMarketsRawData_05182015
order by NEWID()

-- SELECT * FROM [SMITemp].dbo. PJC_26059_GS_SKUs_MktRollup




/***** 4. Populate one row for each unique SKU... exclude Mkt data for now  *****/
INSERT INTO [SMITemp].dbo.PJC_26059_GS_SKUs_MktRollup
SELECT distinct
SKU, 
[Web Description], 
[SEMA - Category], [SEMA - SubCategory], [SEMA - Part],
NULL, NULL, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL
from [SMITemp].dbo.PJC_26059_GS_SKUs_AllMarketsRawData_051820153





/***** 5. one update for each Market ****/
UPDATE RU
SET [Classic Truck] = 'X'
FROM [SMITemp].dbo.PJC_26059_GS_SKUs_MktRollup RU
join [SMITemp].dbo.PJC_26059_GS_SKUs_AllMarketsRawData_05182015 AM 
on RU.SKU = AM.SKU and AM.Market = 'Classic Truck' -- 4,841

UPDATE RU
SET [Drag Racing] = 'X'
FROM [SMITemp].dbo.PJC_26059_GS_SKUs_MktRollup RU
join [SMITemp].dbo.PJC_26059_GS_SKUs_AllMarketsRawData_05182015 AM 
on RU.SKU = AM.SKU and AM.Market = 'Drag Racing' -- 1,955

UPDATE RU
SET [Garage Sale] = 'X'
FROM [SMITemp].dbo.PJC_26059_GS_SKUs_MktRollup RU
join [SMITemp].dbo.PJC_26059_GS_SKUs_AllMarketsRawData_05182015 AM 
on RU.SKU = AM.SKU and AM.Market = 'Garage Sale' -- 10,655

UPDATE RU
SET [Muscle Car] = 'X'
FROM [SMITemp].dbo.PJC_26059_GS_SKUs_MktRollup RU
join [SMITemp].dbo.PJC_26059_GS_SKUs_AllMarketsRawData_05182015 AM 
on RU.SKU = AM.SKU and AM.Market = 'Muscle Car' -- 4,916

UPDATE RU
SET [Open Wheel] = 'X'
FROM [SMITemp].dbo.PJC_26059_GS_SKUs_MktRollup RU
join [SMITemp].dbo.PJC_26059_GS_SKUs_AllMarketsRawData_05182015 AM 
on RU.SKU = AM.SKU and AM.Market = 'Open Wheel' -- 5,559


UPDATE RU
SET [Oval Track] = 'X'
FROM [SMITemp].dbo.PJC_26059_GS_SKUs_MktRollup RU
join [SMITemp].dbo.PJC_26059_GS_SKUs_AllMarketsRawData_05182015 AM 
on RU.SKU = AM.SKU and AM.Market = 'Oval Track' -- 5,956

UPDATE RU
SET [Pedal Car] = 'X'
FROM [SMITemp].dbo.PJC_26059_GS_SKUs_MktRollup RU
join [SMITemp].dbo.PJC_26059_GS_SKUs_AllMarketsRawData_05182015 AM 
on RU.SKU = AM.SKU and AM.Market = 'Pedal Car' -- 45

UPDATE RU
SET [Sport Compact] = 'X'
FROM [SMITemp].dbo.PJC_26059_GS_SKUs_MktRollup RU
join [SMITemp].dbo.PJC_26059_GS_SKUs_AllMarketsRawData_05182015 AM 
on RU.SKU = AM.SKU and AM.Market = 'Sport Compact' -- 38

UPDATE RU
SET [Street Rod] = 'X'
FROM [SMITemp].dbo.PJC_26059_GS_SKUs_MktRollup RU
join [SMITemp].dbo.PJC_26059_GS_SKUs_AllMarketsRawData_05182015 AM 
on RU.SKU = AM.SKU and AM.Market = 'Street Rod' -- 4,974

UPDATE RU
SET [T-Bucket] = 'X'
FROM [SMITemp].dbo.PJC_26059_GS_SKUs_MktRollup RU
join [SMITemp].dbo.PJC_26059_GS_SKUs_AllMarketsRawData_05182015 AM 
on RU.SKU = AM.SKU and AM.Market = 'T-Bucket' -- 4,827

-- verify each insert Qty matches the original counts
SELECT Market, COUNT(*) 'SKUCount'
from [SMITemp].dbo.PJC_26059_GS_SKUs_AllMarketsRawData_05182015
group by Market
order by Market
/*
Classic Truck	4841
Drag Racing	    1955
Garage Sale	    10655
Muscle Car	    4916
Open Wheel	    5559

Oval Track	    5956
Pedal Car	    45
Sport Compact	38
Street Rod	    4974
T-Bucket	    4827
*/


SELECT * 
FROM [SMITemp].dbo.PJC_26059_GS_SKUs_MktRollup





-- SAVED FINAL OUTPUT FILE AS "Case 26059 - all Markets for GS SKUs with QAV of 1 or more.xlsx"
-- use that as a format template if the data needs to be refreshed/repopulated!

