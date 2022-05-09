-- Case 25965 - list of all garage sale SKUs with quantity

select
	SKU.ixSKU as 'SKU', 
	SKU.sDescription as 'SKU Description',
	SKU.mPriceLevel1 as 'Retail',
	SKU.iQAV,
	SKU.ixPGC as 'PGC'	
from
 vwSKUMultiLocation SKU 
where SKU.flgDeletedFromSOP = 0
   and SUBSTRING(SKU.ixPGC,2,1) <> UPPER(SUBSTRING(SKU.ixPGC,2,1)) -- 2nd char of ixPGC is LOWER CASE
   and iQAV > 0


select top 10 * from vwSKUMultiLocation

