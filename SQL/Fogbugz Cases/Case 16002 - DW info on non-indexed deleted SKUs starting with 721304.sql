-- Case 16002 - DW info on non-indexed deleted SKUs starting with 721304

SELECT S.ixSKU AS SMISKU
     , S.sDescription AS SMIDescr
     , V.sName AS PrimaryVendor
     , VS.sVendorSKU AS PVSKU
     , VS.mCost AS PVCost 
     -- Last Vendor Purchased From 
     -- Last Vendor's SKU Purchased From
     , S.mLatestCost AS LastCost 
     , VS.mCost - S.mLatestCost AS DiffInCost     
FROM tblSKU S 
LEFT JOIN tblVendorSKU VS ON VS.ixSKU = S.ixSKU 
LEFT JOIN tblVendor V ON V.ixVendor = VS.ixVendor
WHERE VS.iOrdinality = '1' 
  and S.flgActive = '1' 
  and S.flgIntangible = '0' 
  and S.flgDeletedFromSOP = '0'
  and S.ixSKU NOT LIKE 'UP%' 
  and S.flgIsKit = '0' 
  and V.sName NOT IN ('SMITH COLLECTION', 'SPEEDWAY ADVERTISING', 'SPEEDWAY GARAGE SALE')  
ORDER BY DiffInCost     



select (V.sVendorname
        from tblVendor V
            join tblVendorSKU VS on V.ixVendor = VS.ixVendor
            
            
            
select * from tblSKU where ixSKU like '721304%' and ixSKU not like '%-%'

select D.dtDate, 

ST.ixSKU,
ST.sTransactionType,
ST.iQty,
ST.sToLocation,
ST.sBin,
ST.sToBin,
ST.sUser
 --max(ixDate),ixSKU, *
from tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
where ixSKU in ('721304','72130435','72130438','7213045','72130453','7213047','72130473','7213048')
 and ST.ixDate >= 16353
order by ixSKU, ST.ixDate desc

select * from tblSKULocation
where ixSKU in ('721304','72130435','72130438','7213045','72130453','7213047','72130473','7213048')
order by ixSKU

select distinct D.dtDate as 'Update Date',
    BS.ixSKU,
    BS.ixBin,
    BS.sCID,
    BS.sPickingBin,
    BS.ixLocation
from tblBinSku BS
    join tblDate D on BS.ixUpdateDate = D.ixDate
where ixSKU in ('721304','72130435','72130438','7213045','72130453','7213047','72130473','7213048')
order by ixSKU, D.dtDate desc


select ixSKU, SUM(iQuantity) QtySold, SUM(mExtendedPrice) Sales
from tblOrderLine 
where ixSKU in ('721304','72130435','72130438','7213045','72130453','7213047','72130473','7213048')
and flgLineStatus in ('Shipped','Dropshipped')
group by ixSKU






  






            
            
            


select POD.ixSKU            