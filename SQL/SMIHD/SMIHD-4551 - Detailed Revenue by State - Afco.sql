-- SMIHD-4551 - Detailed Revenue by State - Afco

select * from tblLocalTaxCode 
where sLocalTaxCode = 'NE'
order by dtDateLastSOPUpdate




select count(*) from [SMI Reporting].dbo.tblLocalTaxCode -- 5649
select count(*) from [AFCOReporting].dbo.tblLocalTaxCode -- 5156
                                                         -- 6,808 unique zips between the two tables



select SMI.*, AFCO.*
from [SMI Reporting].dbo.tblLocalTaxCode SMI
FULL OUTER JOIN [AFCOReporting].dbo.tblLocalTaxCode AFCO on SMI.ixZipCode = AFCO.ixZipCode -- 3,997 zips in both tables
where SMI.ixZipCode is NOT NULL 
and AFCO.ixZipCode is NOT NULL 
-- AND SMI.dTaxRate = AFCO.dTaxRate
-- AND SMI.sLocalTaxCode = AFCO.sLocalTaxCode
AND (SMI.sLocalTaxCode is NULL OR  AFCO.sLocalTaxCode is NULL )


select * from [SMI Reporting].dbo.tblLocalTaxCode 
where sLocalTaxCode like 'NE%'
order by dTaxRate desc