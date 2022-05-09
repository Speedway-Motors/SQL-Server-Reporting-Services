-- SMIHD-14042 -- List of all SMI SKUs with Harmonized Tariff Codes

SELECT ixSKU, ixHarmonizedTariffCode 
FROM tblSKU
where flgDeletedFromSOP = 0
and ixHarmonizedTariffCode is NOT NULL


select * from tblIPAddress