-- CASE 14728 add SMI data to AFCO SKU PriceList

-- drop table PJC_AFCO_PriceList_SKUS
select * from PJC_AFCO_PriceList_SKUS -- 10508
where AfcoSKU not in (select sVendorSKU from tblVendorSKU where ixVendor in ('0106', '0311'))
order by AfcoSKU 

select APL.AfcoSKU
   , VS.ixVendor
   , ixSKU as 'SMISKU'
from PJC_AFCO_PriceList_SKUS APL
    left join tblVendorSKU VS on APL.AfcoSKU = VS.sVendorSKU and VS.ixVendor in ('0106', '0311')
order by AfcoSKU  

select VS.*, V.sName
from tblVendorSKU VS
    join tblVendor V on VS.ixVendor = V.ixVendor
where VS.sVendorSKU = '1021'


select APL.AfcoSKU
   , VS.ixVendor
   , VS.ixSKU as 'SMISKU'
from PJC_AFCO_PriceList_SKUS APL
    join tblVendorSKU VS on APL.AfcoSKU = VS.sVendorSKU and VS.iOrdinality = 1 and VS.ixVendor in ('0106', '0311')
    join tblSKU SKU on VS.ixSKU = SKU.ixSKU and SKU.flgDeletedFromSOP = 0 
order by AfcoSKU  




' 83296-B-DB-Y'
'TTJETKIT'


' 83296-B-NA-Y'

select * from PJC_AFCO_PriceList_SKUS
where AfcoSKU like '%83296-B-NA-Y%'
' 83296-B-NA-Y'
'83296-B-NA-Y'





select * from PJC_AFCO_PriceList_SKUS -- 10508
order by AfcoSKU


select APL.AfcoSKU
   , APL.Description
   , ixSKU as 'SMISKU'
   , VS.ixVendor
   , APL.JOBBER
   , APL.DEALER
   , APL.SMIPrice 
from PJC_AFCO_PriceList_SKUS APL
    left join tblVendorSKU VS on APL.AfcoSKU = VS.sVendorSKU and VS.ixVendor in ('0106', '0311')
order by AfcoSKU  