-- Case 16028 - Retail price delta SOP vs DWSTAGING1
--"SKUs Retail and Cost for Primary Vendor" report

select * from tblSKU where ixSKU = '449460-BLK-13'


select * from tblErrorLogMaster
where ixErrorCode = '1163'
and dtDate >= '10/01/2012'



select
	*
from
	tblCatalogDetail CD
	left join tblSKU SKU on CD.ixSKU = SKU.ixSKU
WHERE
	CD.ixCatalog = '346'
	and SKU.mPriceLevel1 <> CD.mPriceLevel1
	
	
	
	
select count(*) from tblSKU	
	where flgDeletedFromSOP = 0
	
	
	
-- SKUs that have dif retail prices on tblCatalogDetail vs tblSKU	
select *
from tblCatalogDetail CD
	left join tblSKU SKU on CD.ixSKU = SKU.ixSKU
WHERE CD.ixCatalog = '346'
	and SKU.mPriceLevel1 <> CD.mPriceLevel1	
	
	
select count(*) from tblSKU
where dtDateLastSOPUpdate < '10/08/2012'	
and flgDeletedFromSOP = 0