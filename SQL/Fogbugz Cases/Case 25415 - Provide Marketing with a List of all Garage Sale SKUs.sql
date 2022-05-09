-- Case 25415 - Provide Marketing with a List of all Garage Sale SKUs

select
--	PGC.ixPGC as 'SKU Product Group Code',
--	PGC.sDescription as 'PGC Description',
	SKU.ixSKU as 'SKU', 
	SKU.iQAV,
	SKU.sDescription as 'SKU Description',
	SKU.mPriceLevel1 as 'Retail'
from
	vwSKUMultiLocation SKU
	left join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
where SUBSTRING(SKU.ixPGC,2,1) <> UPPER(SUBSTRING(SKU.ixPGC,2,1)) -- 2nd char of ixPGC is LOWER CASE
    and SKU.iQAV > 0
order by iQAV desc    