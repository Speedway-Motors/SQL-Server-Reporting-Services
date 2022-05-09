-- SMIHD-14597 - SKUs with Price Level Discrepancies
select S.ixSKU 'SKU'
    , ISNULL(S.sWebDescription, S.sDescription) 'SKU Description'
    ,S.mPriceLevel1 'PriceLevel1'
    ,S.mPriceLevel3 'PriceLevel3'
    ,S.mPriceLevel4 'PriceLevel4'
    ,S.mPriceLevel5 'PriceLevel5'
    ,SL.iQAV 'QAV'
    ,S.ixMerchant 'Merchant'
    ,VS.ixVendor 'PV'
    ,V.sName 'PVName'
    ,S.sSEMACategory 'Category'
   -- ,S.dtDateLastSOPUpdate
from tblSKU S
    left join tblSKULocation SL on S.ixSKU = SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS and SL.ixLocation = 99
    left join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
    left join tblVendor V on VS.ixVendor = V.ixVendor
where S.flgDeletedFromSOP = 0
    and SL.iQAV > 0
    and S.ixSKU NOT LIKE 'BOX-%'
    and S.ixSKU NOT IN ('NSI-RETURN')
    and S.flgIntangible = 0
    and (S.mPriceLevel3 > S.mPriceLevel1
         or
        S.mPriceLevel4 > S.mPriceLevel1
         or
        S.mPriceLevel5 > S.mPriceLevel1
        )
order by VS.ixVendor, S.ixSKU

-- select * from tblEmployee where ixEmployee = 'CGN'
