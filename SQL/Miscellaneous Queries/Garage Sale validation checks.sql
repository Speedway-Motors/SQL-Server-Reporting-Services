-- Garage Sale validation checks

select S.ixSKU, S.ixPGC, VS.ixVendor 'PrimaryVendor', NULL 'GS_URL'
into [SMITemp].dbo.PJC_22451_PossibleGS_SKUs
from tblSKU S
    left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1      -- 63,564
where flgDeletedFromSOP = 0
    AND (
        (S.ixSKU like 'UP%'
         or S.ixSKU like 'AUP%'
         or S.ixSKU like '%GS') 
        OR VS.ixVendor IN ('9106','0009')
OR SUBSTRING(ixPGC,2,1) <> UPPER(SUBSTRING(ixPGC,2,1)) -- 2nd char of ixPGC is LOWER CASE    
        )
    

update GS 
set GS_URL = 1--,
   --NEXTCOLUMN = TNG.NEXTCOLUMN
from [SMITemp].dbo.PJC_22451_PossibleGS_SKUs GS
 join [SMITemp].dbo.ASC_22451_GSSkusFromTNG TNG on GS.ixSKU = TNG.ixSKU


dbo.ASC_22451_GSSkusFromTNG


select * from ASC_22451_GSSkusFromTNG -- 33,276     32,236

select * from PJC_22451_PossibleGS_SKUs
where ixSKU not in (select ixSKU from ASC_22451_GSSkusFromTNG)

select * from ASC_22451_GSSkusFromTNG
where ixSKU not in (select ixSKU from PJC_22451_PossibleGS_SKUs)

insert into PJC_22451_PossibleGS_SKUs
select ixSKU, NULL, NULL, 1
from ASC_22451_GSSkusFromTNG TNG
where TNG.ixSKU NOT in (select ixSKU from PJC_22451_PossibleGS_SKUs)

update GS 
set ixPGC = SKU.ixPGC,
   --NEXTCOLUMN = TNG.NEXTCOLUMN
from [SMITemp].dbo.PJC_22451_PossibleGS_SKUs GS
 join [SMI Reporting].dbo.tblSKU SKU on GS.ixSKU = SKU.ixSKU
 
 update GS 
set PrimaryVendor = VS.ixVendor--,
   --NEXTCOLUMN = TNG.NEXTCOLUMN
from [SMITemp].dbo.PJC_22451_PossibleGS_SKUs GS
 join [SMI Reporting].dbo.tblVendorSKU VS on GS.ixSKU = VS.ixSKU and VS.iOrdinality = 1


update GS 
set flgActive = SKU.flgActive
   --NEXTCOLUMN = TNG.NEXTCOLUMN
from [SMITemp].dbo.PJC_22451_PossibleGS_SKUs GS
 join [SMI Reporting].dbo.tblSKU SKU on GS.ixSKU = SKU.ixSKU



select * from PJC_22451_PossibleGS_SKUs
