-- SKU Brand TNG vs SMI Reporting
 
 -- DROP TABLE [SMITemp].dbo.PJC_SOPBrandVsTNG
select source.ixSOPSKU, source.ixBrand 'TNGBrand', s.ixBrand 'SOPBrand'
into [SMITemp].dbo.PJC_SOPBrandVsTNG
FROM openquery([TNGREADREPLICA], '
                                select distinct
                                s.ixSOPSKU
                                , b.ixBrand
                                from tblskubase b
                                inner join tblskuvariant s on b.ixskubase = s.ixskubase
                                '
                                ) source
    left join [lnk-dwstaging1].[SMI Reporting].[dbo].tblSKU s on s.ixSKU = source.ixSOPSKU  collate SQL_Latin1_General_CP1_CI_AS 
--where coalesce(source.ixBrand, -9999) <> coalesce(s.ixBrand,-9999)


SELECT * 
FROM openquery([TNGREADREPLICA], '
                           <QUERY HERE>
                             ') TNG


select ixSOPSKU, ISNULL(TNGBrand,0) TNGBrand,
ISNULL(SOPBrand,0) SOPBrand
from [SMITemp].dbo.PJC_SOPBrandVsTNG
WHERE ISNULL(TNGBrand,0) <> ISNULL(SOPBrand,0)
order by TNGBrand, ixSOPSKU--, SOPBrand