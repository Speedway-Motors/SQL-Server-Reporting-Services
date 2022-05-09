-- Error Code 1163 - Failure to update tblSKU

select * from tblSKU where ixSKU = '9'
-- DELETE from tblSKU where ixSKU = '9'	

EXEC spUpdateSKU 
'9',        -- ixSKU
14.99,      -- mPriceLevel1
14.99,      -- mPriceLevel2
14.98,      -- mPriceLevel3
14.97,      -- mPriceLevel4
14.96,      -- mPriceLevel5
3.00,       -- mLatestCost
3.00,       -- mAverageCost 
'ZZ',       -- ixPGC
'PJC SKU TEST - delete from Prod',-- sDescription
'EA',       -- flgUnitOfMeasure
1,          -- flgTaxable
NULL,       -- ixCreateDate
'09/09/99', -- dtCreateDate
NULL,       -- ixRoyaltyVendor
20090,      -- ixDiscontinuedDate
'01/01/23', -- dtDiscontinuedDate
1,          -- flgActive
5501652,    -- sBaseIndex, 
1.500,      -- dWeight
NULL,       -- sOriginalSource
1,          -- flgAdditionalHandling
10013,      -- ixBrand
NULL,       -- ixOriginalPart
8708990050, -- ixHarmonizedTariffCode, 
1,          -- flgIsKit
99,         -- iLength
9,          -- iWidth
9.00009     -- iHeight
22,         -- iMaxQOS
2,          -- iRestockPoint, 
1,          -- flgShipAloneStatus
1,          -- flgIntangible, 
'JDS',      -- ixCreator
13,         -- iLeadTime,
1,          -- flgMadeToOrder
NULL,       -- ixForecastingSKU
1,          -- flgDeletedFromSOP
1,          -- iMinOrderQuantity
'MEXICO',   -- sCountryOfOrigin
NULL,       -- sAlternateItem1
NULL,       -- sAlternateItem2
NULL,       -- sAlternateItem3
1,          -- flgBackorderAccepted
'09/09/99', -- dtDateLastSOPUpdate
9999,       -- ixTimeLastSOPUpdate
12,         -- ixReasonCode
'DW',       -- sHandlingCode
NULL,       -- ixProductLine
NULL,       -- sWebUrl
NULL,       -- sWebDescription, 
9.99,       -- mMSRP (smallmoney)
NULL,       -- iDropshipLeadTime
'8708803000'-- ixCAHTC (varchar(20))


select ixCAHTC, count(*)
from tblSKU
group by ixCAHTC
order by count(*) desc
			
select * from tblSKU where ixSKU = '9'
-- DELETE from tblSKU where ixSKU = '9'


-- Valid PGC?
SELECT DISTINCT ixPGC
from tblPGC








-- Sales history for failing SKUs
select F.ixSKU, sum(OL.mExtendedPrice) TotSales
from tblOrderLine OL
    join PJC_FailingSKUs F on OL.ixSKU = F.ixSKU
where flgLineStatus in ('Shipped','Dropshipped')
and dtShippedDate >= '07/31/2010'
group by F.ixSKU
order by sum(OL.mExtendedPrice) desc

Select SKU.* 
from PJC_FailingSKUs F
join tblSKU SKU on F.ixSKU = SKU.ixSKU
order by dtCreateDate desc



Select count(SKU.ixSKU) Qty, V.sName as Vendor
from PJC_FailingSKUs F
join tblSKU SKU on F.ixSKU = SKU.ixSKU
join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU
join tblVendor V on VS.ixVendor = V.ixVendor
where VS.iOrdinality = 1
group by V.sName
order by count(SKU.ixSKU) desc



Select count(SKU.ixSKU) Qty, SKU.flgActive
from PJC_FailingSKUs F
join tblSKU SKU on F.ixSKU = SKU.ixSKU
group by SKU.flgActive
order by dtCreateDate desc



select dtDate, count(*) Qty1163
from tblErrorLogMaster
where ixErrorCode = 1163
group by dtDate
order by dtDate desc



