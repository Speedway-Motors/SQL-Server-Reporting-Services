SELECT 
	SKU.ixSKU SKU,
	SKU.sDescription 'Description',
	SKU.iQAV 'QAV',
	ADJSales.[12 Mo Qty Sold],
	(ADJSales.[12 Mo Qty Sold]/SKU.iMaxQOS) 'Est Restock per YR',
	SKU.iMaxQOS 'Max QOS',
	SKU.iRestockPoint 'Restock Point',
	BS.sPickingBin 'Pick Bin'
FROM
	tblSKU SKU	-- 87064
	join (select distinct ixSKU, sPickingBin
			   from tblBinSku
			   where ixLocation = '99'
			     and sPickingBin <> '999'
			     and sPickingBin is not NULL
		  ) BS on SKU.ixSKU = BS.ixSKU
	join (select ixSKU,sum(AdjustedQTYSold) '12 Mo Qty Sold'
	           from vwAdjustedMonthlySKUSales VW
	           where iYearMonth > '09/01/2010'
	           group by ixSKU
	           having sum(AdjustedQTYSold) > 0
	           ) ADJSales on SKU.ixSKU = ADJSales.ixSKU
WHERE SKU.flgActive = 1
   and SKU.flgIntangible = 0
   and SKU.ixSKU not like 'UP%'	
   and SKU.flgIsKit = 0 
   and dtDiscontinuedDate > '09/29/2011'
   and SKU.iMaxQOS > 0
   and SKU.iRestockPoint is not NULL
ORDER BY 'Est Restock per YR' desc  -- 22885
           
	           
	           
	           
--select * from tblSKU where flgActive = 1 -- 61898 active 85529	           
	           
	           
	           
	           
	           
	
	
	
	