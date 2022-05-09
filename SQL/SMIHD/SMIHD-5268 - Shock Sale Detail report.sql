-- SMIHD-5268 - Shock Sales Detail report

DECLARE @StartDate datetime,        @EndDate datetime

SELECT  @StartDate = '01/01/16',    @EndDate = '08/23/16'  -- total mExtendedPrice running YTD =  $282,320.68   (verify it matches with Shock Sales report total for same date range)

SELECT -- SELECT STATEMENT is FROM  Eagle Motorsports Revenue via SMI SOP report
    O.ixOrder
     , O.dtOrderDate
     , O.ixCustomer
    , C.ixCustomerType
     , C.sCustomerFirstName
    , C.sCustomerLastName
   , O.sOrderChannel
    , O.sOrderTaker
    , O.sSourceCodeGiven
    , O.sMatchbackSourceCode
    , O.sOrderType
    , O.iShipMethod
       , O.mMerchandise
    , O.mMerchandiseCost
    , O.mShipping
    , O.mTax
     , O.mCredits
     , ISNULL(O.mMerchandise,0) + ISNULL(O.mShipping,0) + ISNULL(O.mTax,0) - ISNULL(O.mCredits,0) AS Total 
    , O.sMethodOfPayment
    , O.dtShippedDate
     , OL.iOrdinality
     , OL.ixSKU
     , SKU.ixBrand
     , SKU.sDescription
     , OL.iQuantity
     , OL.mUnitPrice
     , OL.mExtendedPrice
    , OL.mExtendedCost
FROM -- TABLES & CONDITIONS ARE FROM Shock Sales Report (Garage Sale folder)
	tblOrderLine OL
	right join vwSKULocalLocation SKU on OL.ixSKU = SKU.ixSKU
	right join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
	left join tblOrder O on OL.ixOrder = O.ixOrder
	left join tblCustomer C on O.ixCustomer = C.ixCustomer
WHERE			
	OL.flgLineStatus in ('Shipped', 'Dropshipped')
	and (O.sOrderType <> 'Internal')
	and OL.dtShippedDate between @StartDate	and @EndDate
                and OL.flgKitComponent = 0 -- KIT COMPONENT CHECK
	and substring(SKU.ixPGC,1,1) in ('k') -- all the lower case values for the 1st char of ixPGC
	
    
    
    
use [SMI Reporting]
/* Garage Sale Sales

Title - Garage Sale Sales

note: user SELECTs <Start Date>, <End Date>,

*/
SELECT
	SKU.ixPGC as 'SKU Product Group Code',
	PGC.sDescription as 'PGC Description',
	SKU.ixSKU as 'SKU', 
	SKU.sDescription as 'SKU Description',
	SKU.mPriceLevel1 as 'Retail',
	sum(OL.iQuantity) as 'Actual Units Sold',
	sum(OL.mExtendedPrice) as 'Sales',
	sum(OL.mExtendedCost) as 'Cost of Goods'
FROM
	tblOrderLine OL
	right join vwSKULocalLocation SKU on OL.ixSKU = SKU.ixSKU
	right join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
	left join tblOrder O on OL.ixOrder = O.ixOrder
WHERE			
	OL.flgLineStatus in ('Shipped', 'Dropshipped')
	and (O.sOrderType <> 'Internal')
	and OL.dtShippedDate >= @Start_Date
	and OL.dtShippedDate < @EndDate+1
                and OL.flgKitComponent = 0 -- KIT COMPONENT CHECK
	and substring(SKU.ixPGC,1,1) in ('k') -- all the lower case values for the 1st char of ixPGC
GROUP BY
	SKU.ixPGC,
	PGC.sDescription,
	SKU.ixSKU,
	SKU.sDescription,
	SKU.mPriceLevel1
	
ORDER BYSKU.ixPGC    