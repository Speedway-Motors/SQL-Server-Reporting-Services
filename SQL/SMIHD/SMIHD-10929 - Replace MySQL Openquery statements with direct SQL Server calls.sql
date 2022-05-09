-- SMIHD-10929 - Replace MySQL Openquery statements with direct SQL Server calls

/*
syntax example for calling directly:
SELECT TOP 10 * FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblOrder
SELECT TOP 10 * FROM [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblproductline
SELECT TOP 10 * FROM [DW.SPEEDWAY2.COM].DW.dbo.vwOrderLinePromoSummary order by TotalMerchandiseDiscount desc
*/


-- OPEN QUERY     250k rows @30 seconds
select * from openquery([TNGREADREPLICA], 
'
SELECT VSVURL.`Sku Number`
	 , SV.sSKUVariantName 
     , SB.sName
     , VSVURL.URL
FROM vwskuvariantactiveproductpageurl VSVURL
LEFT JOIN tblskuvariant SV ON SV.ixSOPSKU = VSVURL.`Sku Number`
LEFT JOIN tblskubase SB ON SB.ixSKUBase = SV.ixSKUBase ')


-- CONVERTED        250k rows @10 minutes
SELECT VSVURL.[Sku Number]  
	 , SV.sSKUVariantName 
     , SB.sName
     , VSVURL.URL
FROM [DW.SPEEDWAY2.COM].TngRawData.tngLive.vwskuvariantactiveproductpageurl VSVURL
LEFT JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskuvariant SV ON SV.ixSOPSKU = VSVURL.[Sku Number]
LEFT JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskubase SB ON SB.ixSKUBase = SV.ixSKUBase

DW.tng.






