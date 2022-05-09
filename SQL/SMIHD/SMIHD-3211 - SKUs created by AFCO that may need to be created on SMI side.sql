-- SMIHD-3211 SKUs created by AFCO that may need to be created on SMI side
SELECT S.ixSKU, S.sDescription, S.ixPGC, S.flgUnitOfMeasure, 
    S.dWeight, S.dDimWeight, S.iLength, S.iWidth, S.iHeight, 
    S.flgShipAloneStatus, S.flgAdditionalHandling, S.ixReasonCode, S.sHandlingCode, S.flgORMD, S.flgMSDS, 
    S.sAlternateItem1, S.sAlternateItem2, S.sAlternateItem3, 
    S.mMSRP, S.mPriceLevel1, S.mPriceLevel2, S.mPriceLevel3, S.mPriceLevel4, S.mPriceLevel5, 
    S.flgMadeToOrder, S.dtCreateDate, S.dtDiscontinuedDate,
    
    S.ixHarmonizedTariffCode, S.sCountryOfOrigin, S.ixBrand,	S.ixCreator,
    
    VS.iOrdinality 'VendorOrdinality', -- INCLUDE ALL LEVELS OR JUST PRIMARY VENDOR?
    VS.ixVendor 'VendorNum',	
    V.sName 'VendorName',	
    VS.mCost 'VendorCost'
FROM tblSKU S
left join tblVendorSKU VS on S.ixSKU = VS.ixSKU
left join tblVendor V on V.ixVendor = VS.ixVendor
WHERE S.flgDeletedFromSOP = 0
and S.dtCreateDate between '01/01/2016' and '01/31/2016'
ORDER BY S.ixSKU, VS.iOrdinality






