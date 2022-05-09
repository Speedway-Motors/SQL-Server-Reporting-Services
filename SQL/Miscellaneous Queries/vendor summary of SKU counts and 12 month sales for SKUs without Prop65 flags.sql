-- vendor summary of SKU counts and 12 month sales for SKUs without Prop65 flags
SELECT V.ixVendor, V.sName, 
    SALES.Sales12Mo, UF.UnflaggedSKUs
FROM tblSKU S
    LEFT JOIN tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    LEFT JOIN tblVendor V on V.ixVendor = VS.ixVendor
    LEFT JOIN (-- 12 Mo SALES & Quantity Sold
            SELECT VS.ixVendor --OL.ixSKU
                ,SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
            FROM tblOrderLine OL 
                join tblDate D on D.dtDate = OL.dtOrderDate 
                 left join tblVendorSKU VS on OL.ixSKU = VS.ixSKU and VS.iOrdinality > 1
                 left join tblSKU S on VS.ixSKU = S.ixSKU
            WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                and S.flgDeletedFromSOP = 0
                and S.flgProp65 is NULL
            GROUP BY VS.ixVendor
            ) SALES on SALES.ixVendor = VS.ixVendor
    LEFT JOIN (-- UNFLAGGED SKUs by Vendor
            SELECT VS.ixVendor,
                count(S.ixSKU) 'UnflaggedSKUs'
            FROM tblSKU S 
                 left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
            WHERE S.flgDeletedFromSOP = 0
                and S.flgProp65 is NULL
            GROUP BY VS.ixVendor
            ) UF on UF.ixVendor = VS.ixVendor
WHERE S.flgDeletedFromSOP = 0
    and S.flgProp65 is NULL
   --  and V.ixVendor = '0265'
GROUP BY V.ixVendor, V.sName, SALES.Sales12Mo, UF.UnflaggedSKUs
 HAVING UF.UnflaggedSKUs > 0
--  SALES.Sales12Mo > 1000000
--  OR UF.UnflaggedSKUs > 1400
ORDER BY UF.UnflaggedSKUs desc

select count(S.ixSKU)
from tblSKU S
    left join vwGarageSaleSKUs GS on S.ixSKU = GS.ixSKU
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 99
where S.flgDeletedFromSOP = 0
    and S.flgProp65 is NULL   -- 114,377
/*    and (S.ixSKU like 'UP%' or S.ixSKU like 'AUP%'
        or GS.ixSKU is NOT NULL
        or S.ixSKU like '%.GS')
*/
and SL.iQAV > 0

