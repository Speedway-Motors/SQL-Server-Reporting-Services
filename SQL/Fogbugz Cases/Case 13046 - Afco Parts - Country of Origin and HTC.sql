
SMI_ODS

select * from vwSKUAttributes
where ixTemplateAttributeId = 25

select * from vwSKUAttributes
where ixTemplateAttributeId = 76
and sValue is NOT null

25 = Harmonized Tariff Code
76 = Country of Origin

select distinct sTitle from vwSKUAttributes
order by sTitle

13046


select VS.ixSKU, VS.sVendorSKU, SKUA.sValue 'Harm Trf Code', SKUA2.sValue 'Country of Origin'
from [SMI Reporting].dbo.tblVendorSKU VS
    left join vwSKUAttributes SKUA on VS.ixSKU = SKUA.ixSKU and SKUA.ixTemplateAttributeId = 25
    left join vwSKUAttributes SKUA2 on VS.ixSKU = SKUA2.ixSKU and SKUA2.ixTemplateAttributeId = 76
where VS.ixVendor in ('0106','0311','0111') -- AFCO is the Vendor
and (SKUA.sValue is NOT NULL
    OR SKUA2.sValue is NOT NULL)
order by SKUA2.sValue

    
    

select VS.ixSKU, VS.sVendorSKU, SKU.ixHarmonizedTariffCode --.sValue 'Harm Trf Code', SKUA2.sValue 'Country of Origin'
from [SMI Reporting].dbo.tblVendorSKU VS
    join [SMI Reporting].dbo.tblSKU SKU on VS.ixSKU = SKU.ixSKU
where VS.ixVendor in ('0106','0311','0111')
and ixHarmonizedTariffCod
e is NOT NULL



