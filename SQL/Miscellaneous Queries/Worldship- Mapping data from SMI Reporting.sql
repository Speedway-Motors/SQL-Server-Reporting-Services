-- Worldship- Mapping data from SMI Reporting
select --O.ixOrder,
/*
O.ixOrder,O.ixCustomer,
O.sShipToCOLine,O.sShipToStreetAddress1,O.sShipToStreetAddress2,O.sShipToCity,O.sShipToState,O.sShipToZip,O.sShipToCountry,
O.sOrderType,O.sOrderChannel, O.iShipMethod,O.sSourceCodeGiven,
O.sMatchbackSourceCode,O.sMethodOfPayment,O.sOrderTaker,O.sPromoApplied,
-- O.mMerchandise,O.mMerchandiseCost,O.mShipping,O.mTax,O.mCredits,O.mPromoDiscount,O.mPublishedShipping,O.mAmountPaid,O.mBrokerage,O.mDisbursement,O.mVAT,O.mPST,O.mDuty,O.mTransactionFee,
O.sOrderStatus,O.flgIsBackorder,O.dtOrderDate,O.dtShippedDate,
O.ixAccountManager,O.ixAuthorizationStatus,O.ixOrderType,O.sOptimalShipOrigination,O.sCanceledReason,
O.ixCanceledBy,O.flgPrinted,O.ixAuthorizationDate,O.ixAuthorizationTime,O.flgIsResidentialAddress,
O.sWebOrderID,O.sPhone,O.dtHoldUntilDate,O.flgDeviceType,O.sUserAgent,O.dtAuthorizationDate,
O.sAttributedCompany,O.ixPrimaryShipLocation,O.ixPrintPrimaryTrailer,O.ixPrintSecondaryTrailer,
O.iTotalOrderLines,O.iTotalTangibleLines,O.iTotalShippedPackages,
O.ixCustomerType,O.ixQuote,O.ixConvertedOrder
*/  
/* O.ixOrder, O.sShipToCountry, 
    OL.,OL.ixSKU,OL.iQuantity,OL.mUnitPrice,OL.mExtendedPrice,OL.flgLineStatus,
    OL.dtOrderDate,OL.dtShippedDate,
    OL.mCost,OL.mExtendedCost,
    OL.flgKitComponent,OL.iOrdinality,OL.iKitOrdinality,
    OL.mSystemUnitPrice,OL.mExtendedSystemPrice,
    OL.ixPriceDevianceReasonCode,OL.sPriceDevianceReason,
    OL.ixPicker,OL.sTrackingNumber,
    OL.iMispullQuantity,OL.flgOverride,
    OL.dtDateLastSOPUpdate,OL.ixTimeLastSOPUpdate,
*/      
    S.ixSKU,S.mPriceLevel1,S.mPriceLevel2,S.mPriceLevel3,S.mPriceLevel4,S.mPriceLevel5,S.mLatestCost,S.mAverageCost,
    S.ixPGC,S.sDescription,S.flgUnitOfMeasure,S.flgTaxable,S.dtCreateDate,S.ixRoyaltyVendor,
    S.dtDiscontinuedDate,S.flgActive,S.sBaseIndex,
    S.dWeight,S.dDimWeight,S.iLength,S.iWidth,S.iHeight,
    S.sOriginalSource,
    S.flgAdditionalHandling,
    S.ixBrand,S.ixOriginalPart,S.ixHarmonizedTariffCode,
    S.flgIsKit,S.iMaxQOS,S.iRestockPoint,S.iCartonQuantity,
    S.flgShipAloneStatus,S.flgIntangible,S.ixCreator,S.iLeadTime,S.sSEMACategory,S.sSEMASubCategory,S.sSEMAPart,
    S.flgMadeToOrder,S.ixForecastingSKU,S.iMinOrderQuantity,
    S.sWebUrl,S.sWebImageUrl,S.sWebDescription,
    S.sCountryOfOrigin,S.sAlternateItem1,S.sAlternateItem2,S.sAlternateItem3,
    S.flgBackorderAccepted,
    S.ixReasonCode,S.sHandlingCode,
    S.ixProductLine,S.mMSRP,
    S.iDropshipLeadTime,
    S.ixCAHTC,S.flgORMD,S.mZone4Rate,S.flgMSDS,S.sCycleCode
  
from tblOrder O
left join tblOrderLine OL on O.ixOrder = OL.ixOrder
left join tblSKU S on S.ixSKU = OL.ixSKU
where --O.dtOrderDate = '03/04/16' AND 
O.ixOrder = '6043697' --Like '67788%'
--and O.sShipToCountry <> 'US'

/* MAPPING

SMI Reporting			                WorldShip
================================        ============================================================
tblSKU::sDescription			        Goods::Description Of Good
tblOrder::sShipToZip			        Ship To::Postal Code
tblOrderLine::iQuantity			        Goods::Invoice/CN22 Units
tblOrder::sShipToState			        Ship To::State/Province/County
??? orders::GeneralDescription			    Shipment Information::Description of Goods
tblOrder::sShipToStreetAddress1			Ship To::Address 1
? orders::ShipToName			            Ship To::Company or Name
tblOrder::sShipToCOLine			        Ship To::Attention
tblOrder::sShipToStreetAddress2			Ship To::Address 2
tblOrderLine::mUnitPrice			    Goods::Invoice/SED/CN22 Unit Price
? orders::Email			                Ship To::Email Address
tblOrder::sPhone			            Ship To::Telephone
tblSKU::ixHarmonizedTariffCode			Goods::Inv/NAFTA/CN22 Tariff Code
tblOrder::sShipToCountry			    Ship To::Country/Territory
tblOrder::sShipToCity			        Ship To::City or Town
??? orders::GeneralDescription			    International Documentation::CN 22 Goods Type
??? orders::GeneralDescription			    International Documentation::CN 22 Goods Type Other Description
tblSKU::flgUnitOfMeasure			    Goods::Invoice/CN22 Unit Of Measure
tblOrder::ixOrder			            Package::Reference 1
tblOrder::ixCustomer			        Ship To::Customer ID
tblSKU::sCountryOfOrigin			    Goods::Inv/NAFTA/CO/CN22 Country/Territory Of Origin
tblOrderLine::ixSKU			            Goods::Part Number

*/

select * from vwOrderLineWorldShip where ixOrder = '6043697'
ixOrder	ixSKU	iQuantity	mUnitPrice
6043697	9101536-020	1	84.99
6043697	91015361-020	1	97.99
6043697	91015900	1	149.99
6043697	91015904	1	59.99