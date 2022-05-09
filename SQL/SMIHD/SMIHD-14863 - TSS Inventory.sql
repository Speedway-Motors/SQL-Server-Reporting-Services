-- SMIHD-14863 - TSS Inventory
select SL.ixSKU,            -- 182 SKUs with QAV as of 2-04-2020
SL.iQAV, S.mAverageCost,
(S.mAverageCost* SL.iQAV) 'ExtAvgCost',
ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription'
FROM tblSKU S 
 JOIN tblSKULocation SL on SL.ixSKU = S.ixSKU and SL.ixLocation = 97 and SL.iQAV > 0
ORDER BY (S.mAverageCost* SL.iQAV) DESC




-- TANGIBLE SKUs
SELECT S.ixSKU 'SKU',
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', 
    SMIInv.iQAV 'SMIQAV',
    SL.iQAV 'TSSQAV', 
    ' ' 'QTYFound',
    SMIInv.sPickingBin 'SMIPickBin',
    (S.mAverageCost * SL.iQAV) 'InvValue'
    -- SL.iQC, SL.iQCB, SL.iQCBOM, SL.iQCXFER, <-- all were zeros as of 8-21-19
    --SL.sPickingBin, -- all picking bins were "TSS"
    --  S.sSEMACategory 'Category', S.sSEMASubCategory 'Sub-Category', S.sSEMAPart 'Part' , S.dtDiscontinuedDate
FROM tblSKU S
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 97
    left join (select ixSKU, iQAV, sPickingBin
               from tblSKULocation
               where ixLocation = 99
               ) SMIInv on SMIInv.ixSKU = S.ixSKU
WHERE S.flgDeletedFromSOP = 0
    AND S.flgIntangible = 0
    AND (SL.iQOS > 0
         OR SL.iQAV > 0
         OR SL.iQC > 0
         OR SL.iQCB > 0
         OR SL.iQCBOM > 0
         OR SL.iQCXFER > 0
        )
   -- and SL.iQOS <> SL.iQAV all matched 100% as of 8-21-19
Order by SMIInv.iQAV -- (S.mAverageCost * SL.iQAV) desc



-- TOTAL Inventory Value of Tangible SKUs
SELECT SUM(S.mAverageCost * SL.iQAV) 'TotInvValue', FORMAT(COUNT(distinct S.ixSKU),'###,###') 'SKUCnt'
FROM tblSKU S
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 97
    left join (select ixSKU, iQAV, sPickingBin
               from tblSKULocation
               where ixLocation = 97
               ) SMIInv on SMIInv.ixSKU = S.ixSKU
WHERE S.flgDeletedFromSOP = 0
    AND S.flgIntangible = 1
    AND (SL.iQOS > 0
         OR SL.iQAV > 0
         OR SL.iQC > 0
         OR SL.iQCB > 0
         OR SL.iQCBOM > 0
         OR SL.iQCXFER > 0
        )
/*
Tot
Inv     SKU     As
Value   Count   Of
======= =====   ==========
$21,015	  547   2019.10.24
$64,592	1,331   2019.09.23
$64,550         2019.09.18
$67,904         2019.08.21


*/











-- INTANGIBLE SKUs
-- Connie removed all of their quantity 9-23-19
SELECT S.ixSKU 'SKU',
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', 
    SL.iQAV 'TSSQAV' 
FROM tblSKU S
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 97
    left join (select ixSKU, iQAV
               from tblSKULocation
               where ixLocation = 99
               ) SMIInv on SMIInv.ixSKU = S.ixSKU
WHERE S.flgDeletedFromSOP = 0
    AND S.flgIntangible = 1
    AND (SL.iQOS > 0
         OR SL.iQAV > 0
         OR SL.iQC > 0
         OR SL.iQCB > 0
         OR SL.iQCBOM > 0
         OR SL.iQCXFER > 0
        )
Order by SMIInv.iQAV 
