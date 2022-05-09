-- Booneville current SKU inventory

/*
Chris Chance: 
    - how many SKUs do we have in Boonville? Unique skus 5,937  if you use JEF's flag as an indicator ir we list them in the Catalor or on the Web then 5,686
    - what's the total QAV of all the Speedway SKUs in Boonville
    - What's the cube volume?   i.e. Sum of LxWxH for all QAV
    Questions refer to Speedway inv
 
*/

SELECT SKULL.ixLocation, -- S.sSEMACategory, 
    count(SKULL.ixSKU) UniqueSKUs, 
    SUM(SKULL.iQAV) TotQAV, 
    SUM(S.mAverageCost*SKULL.iQAV) ExtAvgCost, 
    SUM(S.mPriceLevel1*SKULL.iQAV) ExtMerch,
    SUM((S.iLength * S.iWidth * S.iHeight) * SKULL.iQAV)/1728 'ExtVolumeCubicFt'  -- 1728 cubic inches per cubic foot
FROM tblSKULocation SKULL
    JOIN tblSKU S on SKULL.ixSKU = S.ixSKU 
WHERE S.flgDeletedFromSOP = 0 -- 338545
    and ixLocation = 47 -- 338,674
    and SKULL.iQAV > 0 -- 6,032
    and S.flgIntangible = 0 -- 5,937
    and S.ixSKU NOT like 'INS%' -- 3  
    and S.ixSKU NOT like 'TECH%' -- 0  
    and S.ixSKU NOT like '91088%' -- 41 
    and S.ixSKU NOT like 'BOX%' -- 13   
    and S.ixSKU NOT like 'GIFT%' -- 13  
    and S.ixSKU NOT IN ('GGA','IMCA','BP10','26425','25599603','91078004','91078002','910965','910851','910980') -- more inserts & decals  
    and S.sDescription LIKE '%BUMPER COVER%'  

GROUP BY SKULL.ixLocation--, S.sSEMACategory
order by SUM((S.iLength * S.iWidth * S.iHeight) * SKULL.iQAV)/1728 DESC
/*
            Unique  Tot     ExtAvg      Ext     Ext Volume
Location	SKUs	QAV	    Cost	    Merch   Cubic Ft
47	        5,872	106,758	$888k	    $2.23m	9,872



47	        5,898	122,526	$888k	    $2.23m	16,468
*/


SELECT S.ixSKU, S.sDescription, SKULL.ixLocation, S.iLength, S.iWidth, S.iHeight, S.mPriceLevel1, S.sSEMASubCategory,S.sSEMAPart,
    count(SKULL.ixSKU) UniqueSKUs, 
    SUM(SKULL.iQAV) TotQAV, 
    SUM(S.mAverageCost*SKULL.iQAV) ExtAvgCost, 
    SUM(S.mPriceLevel1*SKULL.iQAV) ExtMerch,
    SUM((S.iLength * S.iWidth * S.iHeight) * SKULL.iQAV)/1728 'ExtVolumeCubicFt'  -- 1728 cubic inches per cubic foot
FROM tblSKULocation SKULL
    JOIN tblSKU S on SKULL.ixSKU = S.ixSKU 
WHERE S.flgDeletedFromSOP = 0 -- 338545
    and ixLocation = 47 -- 338,674
    and SKULL.iQAV > 0 -- 6,032
    and S.flgIntangible = 0 -- 5,937
    and S.ixSKU NOT like 'INS%' -- 3   
    and S.ixSKU NOT like 'TECH%' -- 3   
    and S.ixSKU NOT like '91088%' -- 3   
    and S.ixSKU NOT like 'BOX-%' -- 3      
    and S.ixSKU NOT LIKE 'GIFT%'
    and S.ixSKU NOT IN ('GGA','IMCA','BP10','26425','25599603','91078004','91078002','910965','910851','910980') -- more inserts & decals
    AND S.sSEMACategory = 'Exterior, Accessories and Trim'    
GROUP BY S.ixSKU, S.sDescription, SKULL.ixLocation, S.iLength, S.iWidth, S.iHeight, S.mPriceLevel1, S.sSEMASubCategory,S.sSEMAPart
order by SUM((S.iLength * S.iWidth * S.iHeight) * SKULL.iQAV)/1728 desc


/* 
cubic feet vol of 16,469 is roughly 10 trailer trucks assuming:
standard 53 ft trailer truck that can hold up to 3,400 cubic feet 
50% wasted space (no clue what the typical % is)
*/

-- SKUs missing 1 or more dimensions
SELECT count(SKULL.ixSKU) UniqueSKUs -- 259
FROM tblSKULocation SKULL
    JOIN tblSKU S on SKULL.ixSKU = S.ixSKU and ixLocation = 47 
where S.flgDeletedFromSOP = 0 
and SKULL.iQAV > 0
and S.flgIntangible = 0 
and (S.iLength is NULL
  OR S.iLength = 0
  OR S.iWidth is NULL
  OR S.iWidth = 0
  OR S.iHeight is NULL
  OR S.iHeight = 0
  )
group by SKULL.ixLocation


