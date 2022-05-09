-- Case 22620 - Generic Eagle Sports reports

Declare @StartDate datetime,
 @EndDate datetime
 
SELECT    @StartDate = '05/09/2014',
@EndDate = '05/13/2014'
 
-- Eagle Motorsports - Sales Summary
SELECT COUNT(O.ixOrder) OrdCount, 
    SUM(O.mMerchandise) TotMerch, 
    SUM(O.mShipping) TotShipping, 
    SUM(O.mTax) TotTax, 
    SUM(O.mCredits) TotCredits, 
    sum(O.mMerchandiseCost) TotMerchCost
from vwEagleOrder O
where O.dtShippedDate between @StartDate and @EndDate -- per Jerry Malcolm, use date shipped
    and (O.sSourceCodeGiven like '%EAG%'
         OR
         O.sMatchbackSourceCode like '%EAG%')
    and O.sOrderStatus = 'Shipped'
         
/*
OrdCount	TotMerch	TotShipping	TotTax	TotCredits	TotMerchCost
14	        3418.10	    28.30	    0.00	0.00	    2978.254
*/         
Declare @StartDate datetime,
 @EndDate datetime
 
SELECT    @StartDate = '05/09/2014',
@EndDate = '05/13/2014'

SELECT O.ixOrder
     , O.dtOrderDate
     , O.ixCustomer
     , C.sCustomerFirstName
     --, C.sCustomerLastName
     --, O.sOrderTaker
     --, O.sSourceCodeGiven
     --, O.sMatchbackSourceCode
     --, O.sOrderType
     --, O.iShipMethod
       , O.mMerchandise
     --, O.mMerchandiseCost
     --, O.mShipping
     --, O.mTax
     --, O.mCredits
     --, ISNULL(O.mMerchandise,0) + ISNULL(O.mShipping,0) + ISNULL(O.mTax,0) - ISNULL(O.mCredits,0) AS Total 
     --, O.sMethodOfPayment
     --, O.dtShippedDate
     , OL.iOrdinality
     , OL.ixSKU
     , S.sDescription
     , OL.iQuantity
     , OL.mExtendedPrice
    -- , OL.mExtendedCost
FROM vwEagleOrder O 
    LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
    LEFT JOIN vwEagleOrderLine OL ON OL.ixOrder = O.ixOrder  
                             AND OL.flgKitComponent = '0'   
    LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
WHERE O.sOrderStatus = 'Shipped' 
  AND O.dtShippedDate BETWEEN @StartDate AND @EndDate -- per Jerry Malcolm, use date shipped
ORDER BY O.dtShippedDate,
    O.ixOrder,
    OL.iOrdinality


Declare @StartDate datetime,
 @EndDate datetime
 
SELECT    @StartDate = '05/09/2014',
@EndDate = '05/18/2014'
         
-- Eagle Motorsports - Order Detail
SELECT O.ixOrder, O.ixCustomer, O.dtOrderDate, O.sOrderChannel, O.iShipMethod, O.sSourceCodeGiven, O.sMatchbackSourceCode, O.sMethodOfPayment, 
   O.sOrderTaker, O.mMerchandise, O.mShipping, O.mTax, O.mCredits, O.mMerchandiseCost, O.dtShippedDate,
   OL.ixSKU,  OL.iQuantity, OL.mUnitPrice, OL.mExtendedPrice, 
   OL.mCost, OL.mExtendedCost, OL.flgKitComponent, 
   OL.iOrdinality, OL.mExtendedSystemPrice, OL.sPriceDevianceReason, OL.ixPicker
from vwEagleOrder O
   left join vwEagleOrderLine OL on O.ixOrder = OL.ixOrder
where O.dtShippedDate between @StartDate and @EndDate -- per Jerry Malcolm, use date shipped
    and (O.sSourceCodeGiven like '%EAG%'
         OR
         O.sMatchbackSourceCode like '%EAG%')
    and O.sOrderStatus = 'Shipped'
    and (OL.flgLineStatus = 'Shipped' 
         OR
         OL.flgLineStatus is NULL)






