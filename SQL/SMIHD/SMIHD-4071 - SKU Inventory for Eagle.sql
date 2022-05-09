-- SMIHD-4071 - SKU Inventory for Eagle
  -- based on code from 3251
/*
We need a report generated to show the inventory level at Eagle. This would include all SKU's assigned to the "E" or "EMI" bin. Columns would include:

SKU #, Description,	E*99 Qty, EMI*98 Qty, Total Qty, COST

- SKU's with a negative qty or qty of zero would also need listed.

combined cost total would also be helpful. A header similar to the Eagle Revenue Report via SOP possibly.

This will allow us to conduct inventory without entering every SKU. We are conducting physical inventory at the end of January and this would be a useful tool.
*/

select S.ixSKU 'SKU', 
    S.sDescription 'SKUDescription', -- 2,056 previous version,   4,114 if including SKUs from vwEagleOrderLine last 12 months
    ISNULL(EMI.iSKUQuantity,0) 'E*98Qty', 
    ISNULL(SMI.iSKUQuantity,0) 'EMI*99Qty',
    (ISNULL(EMI.iSKUQuantity,0) + ISNULL(SMI.iSKUQuantity,0)) 'TotalQty',  
    S.mAverageCost 'AvgCost',
    ((ISNULL(EMI.iSKUQuantity,0) + ISNULL(SMI.iSKUQuantity,0))*S.mAverageCost) 'ExtAvgCost'
    --, S.flgIntangible 'Intangible'
from tblSKU S -- 285,671
    join (-- unique list of SKUs from either location for either bin
          select distinct SL.ixSKU -- 256,355
          from tblSKULocation SL
            join tblBinSku BS on SL.ixSKU = BS.ixSKU and SL.ixLocation = '98'
            join tblVendorSKU VS on SL.ixSKU = VS.ixSKU
            join tblVendor V on VS.ixVendor = V.ixVendor
     --       join tblVendorSKU VS ON SL.ixSKU = VS.ixSKU and VS.ixVendor = 1401
          where(BS.ixBin in ('EMI','E') OR BS.sPickingBin in ('EMI','E'))
          and (SL.iQAV > 0        -- Mike decided he only wanted to see ones with QAV > 0 or belonging to  vendor below
               OR
               VS.ixVendor = 1410 -- per Mike, vendor 1410 is the only one to use
             OR
               SL.ixSKU in (-- SKUs in EMI Order Line that have shipped in the last 12 months
                            SELECT distinct ixSKU from vwEagleOrderLine 
                            where flgLineStatus = 'Shipped'
                            and dtShippedDate between '04/06/2015' and '04/05/2016')
               )
          ) US ON S.ixSKU = US.ixSKU
    left join (select BS.ixSKU, BS.iSKUQuantity, -- 255,257
                    BS.ixLocation, BS.ixBin, BS.sPickingBin
                from tblBinSku BS-- 1553
                    left join tblSKU S on BS.ixSKU = S.ixSKU
                where S.flgDeletedFromSOP = 0
                    and BS.ixLocation = '98'
                    and (BS.ixBin = 'EMI'
                         OR BS.sPickingBin = 'EMI')
                    --AND  BS.iSKUQuantity > 0     -- 1,444                   
                ) EMI on EMI.ixSKU = S.ixSKU    
    left join (select BS.ixSKU, BS.iSKUQuantity, -- 246
                    BS.ixLocation, BS.ixBin, BS.sPickingBin
                from tblBinSku BS-- 1553
                    left join tblSKU S on BS.ixSKU = S.ixSKU
                where S.flgDeletedFromSOP = 0
                    and BS.ixLocation = '99'
                    and (BS.ixBin = 'E'
                         OR BS.sPickingBin = 'E')
                    --AND  BS.iSKUQuantity > 0     -- 246                         
                ) SMI on SMI.ixSKU = S.ixSKU
where S.flgDeletedFromSOP = 0
    and S.flgIntangible = 0
    AND S.ixSKU <> '94605' -- THIS SKU CAUSES Arithmetic overflow error DUE TO high QTY*Cost
-- AND BS.ixSKU in ('M3R1.00D.065H','94600-WELD','M2S2.0B.125H','910047-BLK.1','M2S1.25B.120H','M4R1.00N.02H','M2R1.375P.095H','M2R1.75P.095H','M2R1.25P.065H','M2R1.00P.065H')
order by 
--((ISNULL(EMI.iSKUQuantity,0) + ISNULL(SMI.iSKUQuantity,0))*S.mAverageCost) desc
S.ixSKU 
--SMI.iSKUQuantity desc, EMI.iSKUQuantity desc


SELECT * FROM tblSKU where ixSKU = '9708317'

select * from tblVendorSKU where ixVendor = '1401'
select * from tblVendor where ixVendor = '1401'

SELECT S.ixSKU 'SKU',
S.sDescription 'SKUDescription',
V.ixVendor,
V.sName
FROM tblSKU S
join tblVendorSKU VS on S.ixSKU = VS.ixSKU
join tblVendor V on VS.ixVendor = V.ixVendor
where VS.ixVendor in (1401, 1420, 9410)

SELECT * FROM tblVendor  -- per Mike, vendor 1410 is the only one to use
where UPPER(sName) like '%EMI%'
OR UPPER(sName) like '%EAGLE%'
ORDER BY sName



select COUNT (distinct BS.ixSKU)
from tblBinSku BS
join tblSKULocation SL on BS.ixSKU = SL.ixSKU -- 
where BS.ixBin = 'EMI'
and SL.iQAV > 0
and SL.ixLocation in (98)




select ixBin 'Bin', ixLocation 'Location', COUNT(ixSKU) UniqueSKUs
from tblBinSku
where ixBin in ('E','EMI')
and ixLocation in ('99','98')
group by ixBin, ixLocation
order by ixLocation


SELECT distinct(ixSKU)
from tblSKUTransaction
where ixDate between 17265 and 17629