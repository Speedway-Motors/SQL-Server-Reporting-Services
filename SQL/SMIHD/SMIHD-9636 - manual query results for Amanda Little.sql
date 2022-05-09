-- SMIHD-9636 manual query results for Amanda Little
-- 1) SKU DETAIL OUTPUT
SELECT ixSKU 'SKU',
    sDescription 'SKUDescription',
/*    sBaseIndex 'BaseIndex',
    ixOriginalPart 'OriginalPart',
    sOriginalSource 'OriginalSource',
    ixForecastingSKU 'ForecastingSKU',
    sAlternateItem1 'AlternateItem1',
    sAlternateItem2 'AlternateItem2',
    sAlternateItem3 'AlternateItem3',
*/
    ixPGC 'PGC',
/*
    flgUnitOfMeasure 'UnitOfMeasure', -- Not really a flag
    ixCreator 'Creator',
    ixBrand 'Brand',
    sCycleCode 'CycleCode',
    iMinOrderQuantity 'MinOrderQuantity',
    iMaxQOS 'MaxQOS',
    iRestockPoint 'RestockPoint',
    iLeadTime 'LeadTime',
    iDropshipLeadTime 'DropshipLeadTime',
    sCountryOfOrigin 'CountryOfOrigin',
    sHandlingCode 'HandlingCode',
    ixHarmonizedTariffCode 'HarmonizedTariffCode',
    -- money
    mAverageCost 'AverageCost',
    mLatestCost 'LatestCost',
    mMSRP 'MSRP',
	*/
    mPriceLevel1 'PriceLevel1',
    mPriceLevel2 'PriceLevel2',
    mPriceLevel3 'PriceLevel3',
    mPriceLevel4 'PriceLevel4',
    mPriceLevel5 'PriceLevel5'
	/*,
    -- dimensions
    iLength 'Length',
    iWidth 'Width',
    iHeight 'Height',
    dWeight 'Weight',
    dDimWeight 'DimWeight',
    -- dates
    dtCreateDate 'CreateDate',
    dtDiscontinuedDate 'DiscontinuedDate',
    dtDateLastSOPUpdate 'LastSOPUpdate',
    -- flags
    flgActive,
    flgAdditionalHandling,
    flgBackorderAccepted,
    flgIntangible,
    flgIsKit,
    flgMadeToOrder,
    flgORMD ,
    flgShipAloneStatus
*/
FROM tblSKU
WHERE flgDeletedFromSOP = 0
ORDER BY ixSKU


-- 2) SKU QAV and PGC
SELECT S.ixSKU 'SKU'
,S.sDescription 'Description'
,S.ixPGC 'PGC'
-- ,SL.ixLocation
-- ,SL.iQOS --AS 'QOStblSKULoc.'
,SL.iQAV 'QAV'--AS 'QAVtblSKULoc.'
FROM tblSKU S
JOIN tblSKULocation SL ON SL.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS= S.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
WHERE S.flgDeletedFromSOP = 0 
  and SL.ixLocation = '99' --ixLocation '68' not needed (SMI inventory counts) 
ORDER BY S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS


-- 3) Daily run of credit info -- for dates: 1/9/18. 1/10/18, 1/11/18, 1/12/18
/* Credit Memo Summary.rdl
	ver 18.3.1
*/
DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '01/09/18',    @EndDate = '01/12/18'  

SELECT ixCreditMemo 'CreditMemo',	
	ixCustomer 'Customer',	
	ixOrder 'Order',	
	sOrderChannel 'Order Channel',	
	mMerchandise 'Merchandise',	
	sMemoType 'MemoType',
	dtCreateDate 'CreateDate',	
	mMerchandiseCost 'MerchCost',	
	ixOrderTaker 'OrderTaker',
	mShipping 'Shipping',
	mTax 'Tax',	
	mRestockFee 'RestockFee',	
	(CASE WHEN flgCanceled = 1 then 'Y'
	 else 'N'
	 END
	 ) 'Cancelled',
	sMethodOfPayment 'MethodOfPayment',
	--	dtDateLastSOPUpdate	ixTimeLastSOPUpdate	
	sMemoTransactionType 'MemoTransactionType'
FROM tblCreditMemoMaster
WHERE tblCreditMemoMaster.dtCreateDate between @StartDate and @EndDate --= '01/12/18'
ORDER BY dtCreateDate, ixCreditMemo


