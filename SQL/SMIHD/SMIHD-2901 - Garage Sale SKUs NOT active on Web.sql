/* SMIHD-2901 - Garage Sale SKUs NOT active on Web
*/   
-- data from tng
select *                            -- 74,024 records  
from openquery  -- had to remove brackets around [TNGREADREPLICA]to avoid a quirky error
(TNGREADREPLICA, ' 
    SELECT distinct ixSOPSKU as ''SKU''
    , SV.iTotalQAV as ''QAV''
    , SV.sSOPDescription as ''SOPDescription''
    , SV.sSKUVariantName as ''SKUVariantName''
     -- ,M.sMarketName as ''ixMarket''
    FROM tblmarket M 
       join tblskubasemarket SBM on M.ixMarket = SBM.ixMarket  
       join tblskubase SB on SBM.ixSKUBase = SB.ixSKUBase 
       join tblskuvariant SV on SB.ixSKUBase = SV.ixSKUBase 
       inner join tblproductpageskubase PPSB on PPSB.ixSKUBase = SB.ixSKUBase
       inner join tblproductpage PP on PP.ixProductPage = PPSB.ixProductPage
    WHERE 
      SV.ixSOPSKU is not null 
      and SV.iTotalQAV > 0
          -- or
          --  SV.flgBackorderable = 1)
      and M.sMarketName = ''Garage Sale''
      and SV.flgPublish = 1
      and SB.flgWebPublish = 1
      and PP.flgActive = 0 -- NOT ACTIVE
    ORDER BY SV.ixSOPSKU
    ')



