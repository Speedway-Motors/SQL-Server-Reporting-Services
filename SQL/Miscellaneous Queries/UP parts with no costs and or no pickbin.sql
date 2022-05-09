select SKU.ixSKU, mLatestCost, mAverageCost, ixPGC, sDescription, 
SL.iQAV, SL.iQOS, dtCreateDate, dtDiscontinuedDate, sBaseIndex, sOriginalSource, 
ixOriginalPart, iMaxQOS, iRestockPoint, SL.iCartonQuantity, 
ixCreator, SL.sPickingBin
-- ixRoyaltyVendor, ixHarmonizedTariffCode, ixBrand, SKU.iLeadTime, 
-- dWeight, iLength, iWidth, iHeight,
--flgAdditionalHandling, flgShipAloneStatus, flgUnitOfMeasure,  
--sSEMACategory, sSEMASubCategory, sSEMAPart
 -- 10905
from tblSKU SKU
  join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU
  join tblSKULocation SL on SKU.ixSKU = SL.ixSKU
WHERE (mLatestCost = 0
		or mLatestCost is NULL
		or mAverageCost = 0
		or mAverageCost is NULL)
	AND sDescription <> 'SKU DELETED FROM SOP'
	AND flgActive = 1
	AND flgIntangible = 0
	and flgIsKit = 0
	and flgTaxable = 1
	and VS.iOrdinality = 1
	and VS.ixVendor not in ('9999','0999')
	and dtDiscontinuedDate > '10/05/2011'
	and SKU.ixSKU like 'UP%'
	and SL.ixLocation = 99
	--and SKU.ixSKU <> sBaseIndex

ORDER BY BS.sPickingBin	


select top 100 
ixSKU, sBaseIndex
 from tblSKU
order by NEWID()


select * from tblBin where ixBin = '999'