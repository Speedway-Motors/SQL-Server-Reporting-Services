-- SMIHD-7470 - Garage Sale Inventory Detail
SELECT TNG.ixSKU,
    SKUM.iQAV 'QtyAvAllLocations',
    SKU.sSEMAPart 
from openquery([TNGREADREPLICA], '
                SELECT distinct ixSOPSKU as ''ixSKU''
                FROM tblmarket M 
                   join tblskubasemarket SBM on M.ixMarket = SBM.ixMarket  
                   join tblskubase SB on SBM.ixSKUBase = SB.ixSKUBase 
                   join tblskuvariant SV on SB.ixSKUBase = SV.ixSKUBase 
                   inner join tblproductpageskubase PPSB on PPSB.ixSKUBase = SB.ixSKUBase
                   inner join tblproductpage PP on PP.ixProductPage = PPSB.ixProductPage
                WHERE 
                  SV.ixSOPSKU is not null 
                  and M.sMarketName = ''Garage Sale''
                  and SV.flgPublish = 1
                  and SB.flgWebPublish = 1
                  and PP.flgActive = 1
                ORDER BY SV.ixSOPSKU
                
             ') TNG
    join tblSKU SKU on TNG.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS -- 25,171
    join vwSKUMultiLocation SKUM on SKU.ixSKU = SKUM.ixSKU
WHERE SKU.flgDeletedFromSOP = 0
    and UPPER(sSEMAPart) IN ('BRAKE ROTORS','SHOCKS', 'LEAF SPRINGS', 'COIL SPRINGS') --'shocks, leaf springs, coil springs'
ORDER BY TNG.ixSKU,    SKU.sSEMAPart 


                
/*                
SELECT * from tblSKU where UPPER(sSEMAPart) = 'ROTORS'
SELECT * from tblSKU where UPPER(sSEMASubCategory) = 'ROTORS'
SELECT * from tblSKU where UPPER(sSEMACategory) = 'ROTORS'
*/