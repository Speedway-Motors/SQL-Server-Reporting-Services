select ixPrimaryShipLocation, FORMAT(count(ixOrder),'###,###') OrderCnt
FROM tblOrder 
WHERE dtShippedDate between '01/01/2020' and '01/31/2020'
group by ixPrimaryShipLocation
/*
Shipped Orders by Loc & Month

MON     LNK     TOL     TOT     TOL%
=====   ======  =====   ======  ====
12/19   45,904  1,967   47,871  4.1%    
01/20    6,213    120    6,333  1.9%    <-- as of 1/1/20

*/


/* Active, tangible, Non-GS SKUs with QAV

    42,241 LNK  
     7,546 TOL (17.9% of LNK's stocked SKUs)
*/

-- LNK
SELECT FORMAT(count(S.ixSKU),'###,###') 'SKUcnt'
FROM tblSKU S
    LEFT JOIN tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 99 
    LEFT JOIN (-- 12 Mo SALES & QTY SOLD
                SELECT OL.ixSKU,SUM(OL.iQuantity) AS 'QtySold12Mo', 
                    SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                FROM tblOrderLine OL 
                    LEFT JOIN tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                GROUP BY OL.ixSKU
                ) SALES on SALES.ixSKU = S.ixSKU
    LEFT JOIN tblSkuProfitabilityRollup SPR on SPR.ixSKU = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE flgDeletedFromSOP = 0
    and S.flgActive = 1                                                         -- 231,517
    and SPR.flgDiscVendor = 0                                                   -- 230,208
    and S.flgIntangible = 0                                                     -- 230,146
    and SPR.flgDropShip = 0                                                     -- 156,829
    and SL.iQAV > 0                                                             --  61,240
    AND S.mPriceLevel1 > 0                                                      --  55,938
    AND flgMadeToOrder = 0                                                      --  54,791
    AND lower(S.sDescription) not like '%catalog%'                              --  54,785
    AND lower(S.sDescription) not like '%gift%'                                 --  54,772
    AND (sHandlingCode <> 'TR' 
        OR sHandlingCode IS NULL)                                               --  54,601
    -- picking bins
    AND ( sPickingBin LIKE 'B%'
       OR sPickingBin LIKE '3%' 
       OR sPickingBin LIKE '4%' 
       OR sPickingBin LIKE '5%' 
       OR sPickingBin LIKE 'Z%' 
       OR sPickingBin LIKE 'Y%' 
       OR sPickingBin LIKE 'X%' 
       OR sPickingBin LIKE 'A%' 
       OR sPickingBin LIKE 'V%' 
       )                                                                        -- 51,246
    AND sPickingBin NOT IN ('A KIT','BOM','BP/SH','Z25A1','Z25A3')              -- 50,138
    AND sPickingBin NOT LIKE 'BZ%'                                              -- 50,123
    -- GS weirdness
        and SUBSTRING(S.ixPGC,2,1) <> LOWER(SUBSTRING(S.ixPGC,2,1)) -- GS SKUs      --  44,169
        and SPR.flgGSVendor = 0                                                     --  44,027
        and SPR.flgGSItem = 0                                                       --  43,774
        and SPR.flgGarageSale = 0                                                   --  43,385
        AND (S.ixSKU NOT LIKE '%.GS'
            AND S.ixSKU NOT LIKE 'AUP%' 
            AND S.ixSKU NOT LIKE 'UP%' 
            )                                                                       --  43,385
        AND (UPPER(sWebDescription) NOT LIKE '%GARAGE SALE%'  
            AND UPPER(sDescription) NOT LIKE '%GARAGE SALE%' 
            )                                                                       --  43,385
    and (-- Sold at least X qty in 12 months or newly created SKUs
            SALES.QtySold12Mo > 10 -- WHAT'S the MIN 12 mo qty sold we care about???    --  21,685
            OR
            S.dtCreateDate >= '10/01/2019')  -- is 3 monts the def for new SKUs that are stocked?  --  21,839



-- TOL
SELECT FORMAT(count(S.ixSKU),'###,###') 'SKUcnt'
FROM tblSKU S
    LEFT JOIN tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 85 
    LEFT JOIN (-- 12 Mo SALES & QTY SOLD
                SELECT OL.ixSKU,SUM(OL.iQuantity) AS 'QtySold12Mo', 
                    SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                FROM tblOrderLine OL 
                    LEFT JOIN tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                GROUP BY OL.ixSKU
                ) SALES on SALES.ixSKU = S.ixSKU
    LEFT JOIN tblSkuProfitabilityRollup SPR on SPR.ixSKU = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE flgDeletedFromSOP = 0
    and S.flgActive = 1                                                         -- 231,517
    and SPR.flgDiscVendor = 0                                                   -- 230,208
    and S.flgIntangible = 0                                                     -- 230,146
    and SPR.flgDropShip = 0                                                     -- 156,829   <-- conditions here and above, LOCATION is irrelevant
    and SL.iQAV > 0                                                             --  7,683
    -- GS weirdness
        and SUBSTRING(S.ixPGC,2,1) <> LOWER(SUBSTRING(S.ixPGC,2,1)) -- GS SKUs      --  7,641
        and SPR.flgGSVendor = 0                                                     --  7,641
        and SPR.flgGSItem = 0                                                       --  7,641
        and SPR.flgGarageSale = 0                                                   --  7,550
    and (-- Sold at least X qty in 12 months or newly created SKUs
            SALES.QtySold12Mo > 0 -- WHAT'S the MIN 12 mo qty sold we care about???
            OR
            S.dtCreateDate >= '06/01/2019')  -- is 6 monts the def for new SKUs that are stocked?  --  7,546

-- COMBINED
SELECT FORMAT(count(distinct S.ixSKU),'###,###') 'SKUcnt'
FROM tblSKU S
    LEFT JOIN tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation in (85,99) 
WHERE flgDeletedFromSOP = 0
    and flgActive = 1                                                           -- 231,479
    and SUBSTRING(S.ixPGC,2,1) <> LOWER(SUBSTRING(S.ixPGC,2,1)) -- GS SKUs      -- 223,556
    and SL.iQAV > 0                                                             --  55,024
    and S.flgIntangible = 0                                                     --  54,965

select * FROM vwGarageSaleSKUs -- 84,493



	flgInactive 



SELECT TOP 1 * FROM tblSkuProfitabilityRollup

SELECT flgDropShip, count(*) FROM tblSkuProfitabilityRollup
WHERE flgDropShip is NOT NULL
    and flgActive = 1
group by flgDropShip
0	158162
1	73332

SELECT flgGSVendor, count(*) FROM tblSkuProfitabilityRollup
WHERE flgGSVendor is NOT NULL
    and flgActive = 1
group by flgGSVendor

flgNeedsToShipLTL





