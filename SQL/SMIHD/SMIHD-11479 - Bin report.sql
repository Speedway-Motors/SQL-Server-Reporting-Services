-- SMIHD-11479 - Pick Bin by Aisle report

SELECT B.ixBin'Bin'
    , B.sAisle 'Aisle' 
    , BS.ixSKU 'SKU'
    , BS.iSKUQuantity 'Qty'
    , S.dDimWeight 'SKUDimWt'
    , ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription'
    , SL.iPickingBinMin 'MinQty'
    , SL.iPickingBinMax 'MaxQty'
    , SL.iCartonQuantity 'CartonQty'
FROM tblBin B
    left join tblBinSku BS on B.ixBin = BS.ixBin and BS.ixLocation = 99
    left join tblSKU S on BS.ixSKU = S.ixSKU
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 99
WHERE B.flgDeletedFromSOP = 0
    and B.sBinType = 'P' -- picking bin
    and B.ixBin like 'V35A%'
    and BS.iSKUQuantity > 0 -- TEMP for testing only!
ORDER BY B.sAisle, B.ixBin, BS.ixSKU 


SELECT * 
FROM tblSKULocation
where iPickingBinMin > iPickingBinMax
--or iPickingBinMin is NULL
--or iPickingBinMax is NULL
--or iPickingBinMax < 1)
and ixLocation = 99
--and iQOS > 0


order by dtDateLastSOPUpdate




SELECT sBinType, count(*)
from tblBin
where flgDeletedFromSOP = 0
group by sBinType


1) This is for an Excel output the majority of the time?
2) Default sort oder (Aisle then Bin?)
3) Is this for any type of bin or only picking bins?
4) List bins even if they have no SKUs currently in them?
5) There are only 7 fields in the screenshot.  Is that all that's needed?  (Do you want SKU Description, SEMA Categories, etc.)

SELECT B.sAisle, count(B.ixBin)
from tblBin B
    join tblBinSku BS on B.ixBin = BS.ixBin and BS.ixLocation = 99
group by sAisle




