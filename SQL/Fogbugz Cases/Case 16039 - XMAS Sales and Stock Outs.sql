

select
	SKU.ixSKU as 'SKU',
	convert(varchar, SKU.dtCreateDate, 101) as 'Create Date',
	SKU.mPriceLevel1 as 'Retail',
	SKU.sDescription as 'Description',
	(PGC.ixPGC + ' ' + PGC.sDescription) as 'PGC-Desc',
	SKU.sSEMACategory as 'SEMA Level1',
	SKU.sSEMASubCategory as 'SEMA Level2',
	SKU.sSEMAPart as 'SEMA Level3',
	SKUL.iQOS as 'QOS',
	SKUL.iQAV as 'QAV',
	isnull(SS.LYQuantity,0) as '12 Mth Sales',
	isnull(XS.LYQuantity,0) as 'XMAS Sales',
	isnull(XSSO.LYQuantity,0) as 'Backordered XMAS',
	VSKU.ixVendor as 'Vendor',
	V.sName as 'Vendor Name'
from
	tblSKU SKU
	left join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
	left join tblSKULocation SKUL on SKU.ixSKU = SKUL.ixSKU and ixLocation='99'
	left join vwSKUSalesPrev12Months SS on SKU.ixSKU = SS.ixSKU
	left join tblVendorSKU VSKU on VSKU.ixSKU = SKU.ixSKU and VSKU.iOrdinality = 1
	left join tblVendor V on VSKU.ixVendor = V.ixVendor
	left join vwXMASSales XS on XS.ixSKU = SKU.ixSKU
	LEFT JOIN vwXMASSalesSO XSSO on XSSO.ixSKU = SKU.ixSKU
where
	(PGC.sDescription like '%GIFT%' or (SKU.sSEMASubCategory in ('Adhesives', 'Aftermarket Horns', 'Appearance Products', 'Books', 'Cleaning Products', 'Clothing', 'Garage Equipment', 'Graphics', 'Jewelry', 'Miscellaneous Merchandise', 'Signs and Posters', 'Towing', 'Wax and Polish')))
	and SKU.flgActive = 1
	and not(SKU.sSEMAPart in ('Racing Gloves', 'Racing Shoes'))
	and not(SKU.ixSKU like 'UP%')
	and not(SKU.ixSKU like '%GS')
	and not(SKU.ixSKU like 'INS%')
	and V.ixVendor <> '9999'
	and V.ixVendor <> '0009'