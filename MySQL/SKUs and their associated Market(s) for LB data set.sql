-- SKUs and their associated Market(s) for LB data set
/*
select * from tblskubase limit 10
select * from tblskuvariant limit 10
select * from tblskubasemarket limit 10
select * from tblmarket limit 10
*/
/**** SKUs and their associated Market(s) ****/
-- UPDATED VERSION FROM CHRIS 1-21-15  
SELECT SV.ixSOPSKU as 'ixSKU', -- 327,889 Rows
     M.sMarketName as 'ixMarket'
FROM tblskubase SB
  left join tblskuvariant SV on SB.ixSKUBase = SV.ixSKUBase
  left join tblskubasemarket SBM on SBM.ixSKUBase = SB.ixSKUBase
  left join tblmarket M on M.ixMarket = SBM.ixMarket     
WHERE SV.ixSOPSKU is not null
  and M.sMarketName = 'Garage Sale'  
ORDER BY SV.ixSOPSKU 


/***** how many SKUs DO/DO NOT have markets assigned? ****/
SELECT count(distinct SV.ixSOPSKU) UniqueSKUCount
FROM tblskubase SB
  left join tblskuvariant SV on SB.ixSKUBase = SV.ixSKUBase
  left join tblskubasemarket SBM on SBM.ixSKUBase = SB.ixSKUBase
  left join tblmarket M on M.ixMarket = SBM.ixMarket     
WHERE SV.ixSOPSKU is not null -- 220,414 total SKUs.   of these, 119,301 have one or more markets
   and M.sMarketName is NULL  --                                 101,113 have NO market
 
-- 142,571 unique SKUs in Catalog WEB.14 
select distinct ixSKU from tblCatalogDetail 
where ixCatalog = 'WEB.14' 


SELECT distinct SV.ixSOPSKU
FROM tblskubase SB
  left join tblskuvariant SV on SB.ixSKUBase = SV.ixSKUBase
  left join tblskubasemarket SBM on SBM.ixSKUBase = SB.ixSKUBase
  left join tblmarket M on M.ixMarket = SBM.ixMarket     
WHERE SV.ixSOPSKU is not null -- 220,414 total SKUs.   of these, 119,301 have one or more markets
   and M.sMarketName is NULL  --                                 101,113 have NO market
   
   
  
  
  and M.sMarketName is NULL
 -- and M.sMarketName <> 'Garage Sale'  
ORDER BY SV.ixSOPSKU 
  
  
  

  
  select  -- 62,813 records
    sv.ixSOPSKU as 'itemid',
    a.sApplicationGroup as 'application_group',
    a.sApplicationValue as 'application_subgroup'
from 
    tblskuvariant_application_xref svax
    left join tblskuvariant sv on svax.ixSKUVariant = sv.ixSKUVariant
    left join tblapplication a on a.ixApplication = svax.ixApplication
    
    
  
