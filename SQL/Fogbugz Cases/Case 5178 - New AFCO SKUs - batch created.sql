select SKU.ixSKU SMI_SKU,       -- 
     --  substring(SKU.ixSKU,4,500) AFCO_SKU,
     --  VS.sVendorSKU,
       SKU.sDescription,
       SKU.flgUnitofMeasure UoM,
       SKU.mPriceLevel1,
       SKU.mPriceLevel2,
       SKU.mPriceLevel3,
       SKU.mPriceLevel4,
       SKU.mPriceLevel5
from tblSKU SKU
  --  join [AFCOReporting].dbo.tblVendorSKU A_VS on SKU.ixSKU = A_VS.sVendorSKU
   -- join tblVendorSKU VS on VS.ixSKU = SKU.ixSKU
where dtCreateDate  = '10/27/10'
      and SKU.ixSKU not in (select ixSKU from PJC_temp_SKUS_created_102710)
    



order by SKU.ixSKU 









    
    ('31170110010','31170110110','31170110210','31170116310','31170120910','31170121910','31170129210') -- SKUs created by someone else that day.. found by looking at the items that had mPriceLevel2 on populated






/* deleting initial batch */
delete from tblSKU 
  --  join [AFCOReporting].dbo.tblVendorSKU A_VS on SKU.ixSKU = A_VS.sVendorSKU
   -- join tblVendorSKU VS on VS.ixSKU = SKU.ixSKU
where dtCreateDate  = '10/22/10' 
  and (ixSKU like '108%'
    or ixSKU like '311%'
    or ixSKU like '313%')
  and ixSKU not in 
    ('31170110010','31170110110','31170110210','31170116310','31170120910','31170121910','31170129210') -- SKUs created by someone else that day.. found by looking at the items that had mPriceLevel2 on populated

select * 
into PJC_temp_tblSKU_BU -- 66523
from tblSKU

select count(*) from tblSKU

select * 
into PJC_temp_tblSKU_BU -- 20295
from tblSKU

-- created table PJC_new_AFCO_skus and imported SKUs
delete from tblSKU
where ixSKU collate SQL_Latin1_General_CP1_CI_AS in (select ixSKU SQL_Latin1_General_CP1_CI_AS from PJC_new_AFCO_skus)

select count(*) from tblSKU


select * 
into PJC_temp_SKUS_created_102710
from tblSKU where dtCreateDate = '10/27/10'
and ixSKU <> '31170423010'

/*
10680205
106802051
10680206
10680207
106802071
10689041-M/L
10689042-M/L
10689043-M/L
10689044-M/L
10689045-M/L


1750726GS
31170423010
4581208-1
4581208-2
4581208-3
715BP15112GS
91018045GS
91613201GS
9403091-1
9403405-1
UP6312
UP6313
UP6314
UP6315
UP6316
UP6317
UP6318
UP6319
UP6320
UP6321
UP6322
UP6323
UP6324
UP6325
UP6326
UP6327
*/