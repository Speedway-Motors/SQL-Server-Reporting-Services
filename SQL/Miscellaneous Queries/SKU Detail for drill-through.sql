-- SKU Detail for drill-through
select top 10
    ixSKU 'SKU'
    , sDescription 'Description'
   -- , mPriceLevel1 'PriceLvl1', mPriceLevel2 'PriceLvl2' , mPriceLevel3 'PriceLvl3', mPriceLevel4 'PriceLvl4', mPriceLevel5 'PriceLvl5'
   -- , mLatestCost 'Latest Cost'
   -- , mAverageCost'Avg Cost'
   -- , mMSRP
    , ixPGC 'PGC'
    , flgUnitOfMeasure 'UnitOfMsr'
    , flgTaxable 'Taxable'
    , dtCreateDate 'Create Date'
    , ixRoyaltyVendor 'Royalty Vendor'
    , dtDiscontinuedDate 'Discontinued Date'
    , flgActive 'Active'
    , sBaseIndex 'Base Index'
    , dWeight 'Weight', iLength 'Length', iWidth 'Width', iHeight 'Height'
    , sOriginalSource 'Original Source'
    , flgAdditionalHandling 'Addtnl Handling'
    , ixBrand 'Brand'
    , ixOriginalPart 'Original Part'
    , ixHarmonizedTariffCode 'HTC'
    , flgIsKit 'Kit'
    
    , iMaxQOS
    , iRestockPoint
    , iCartonQuantity
    , flgShipAloneStatus
    , flgIntangible
    , ixCreator
    , iLeadTime
    , sSEMACategory, sSEMASubCategory, sSEMAPart
    , flgMadeToOrder
    , ixForecastingSKU
    , flgDeletedFromSOP
    , iMinOrderQuantity
    -- WEB info
    , sWebUrl, sWebImageUrl, sWebDescription
    , sCountryOfOrigin
    , sAlternateItem1, sAlternateItem2, sAlternateItem3
    , flgBackorderAccepted
    --, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
    , ixReasonCode
    , sHandlingCode
    , ixProductLine
    , iDropshipLeadTime, ixCAHTC

FROM tblSKU
WHERE --ixSKU = '930C8' and
    flgActive = 1 and ixSKU not LIKE 'UP%' and len(ixSKU) = 5
    AND ixSKU in (select ixSKU from tblPODetail where ixExpectedDeliveryDate > 16700)
    and sHandlingCode is NOT Null
    and ixHarmonizedTariffCode is NOT NULL
order by newid()