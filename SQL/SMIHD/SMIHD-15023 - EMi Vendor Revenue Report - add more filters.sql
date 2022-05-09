-- SMIHD-15023 - EMi Vendor Revenue Report - add more filters
/* ver 19.37.3  */
DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '01/01/19',    @EndDate = '09/10/19'  


/*
1) Eliminate sku sales by vendor 1410 if the order was executed using source code EMI340 or EMI300
2) Eliminate sku sales by vendor 1410 if the order was executed by FWG
3) Eliminate sku sales by vendor 1410 if the customer account is flagged 32 
 
The reason for this is so i can add the numbers this report gives me to the numbers from the EMI revenue repor
By adding these 3 rules, it should eliminate any sales that would also show up in that report. 
*/

SELECT-- OL.ixOrder, 
    S.ixSKU
    , S.sDescription
    , SUM(OL.iQuantity) 'QtySold'
    , SUM(OL.mExtendedPrice) 'Sales$'
    , SUM(OL.mExtendedCost) 'MerchCost'
    , (SUM(OL.mExtendedPrice)-SUM(OL.mExtendedCost)) 'GP$'
    , S.ixBrand
    , B.sBrandDescription
    , S.sSEMACategory
    , S.sSEMASubCategory
    , S.sSEMAPart
--INTO #VendorRevOrders -- DROP TABLE #VendorRevOrders
FROM tblOrder O 
        LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
        LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder  
                                AND OL.flgKitComponent = '0'   
        LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
        LEFT JOIN tblBrand B on S.ixBrand = B.ixBrand
        LEFT JOIN tblVendorSKU VS on S.ixSKU = VS.ixSKU
WHERE O.sOrderStatus = 'Shipped' 
  AND O.dtShippedDate BETWEEN @StartDate AND @EndDate -- per Jerry Malcolm, use date shipped
  AND VS.ixVendor = '1410'
  AND VS.iOrdinality = 1
  AND O.sSourceCodeGiven NOT IN ('EAGLE300','EAGLE340','EMI300','EMI340','PRS-EMI','EMP-EMI','CUST-SERV-EMI','MRR-EMI','EMI.DLR') -- ('EMI300','EMI340') -- DO NOT INCLUDE source codes EAGLE or INTERNAL-EMI 
  AND O.sMatchbackSourceCode NOT IN ('EAGLE300','EAGLE340','EMI300','EMI340','PRS-EMI','EMP-EMI','CUST-SERV-EMI','MRR-EMI','EMI.DLR') -- ('EMI300','EMI340') --
  AND O.sOrderTaker <> 'FWG'
  AND O.ixCustomerType <> '32'
GROUP BY S.ixSKU
    , S.sDescription
    , S.ixBrand
    , B.sBrandDescription
    , S.sSEMACategory
    , S.sSEMASubCategory
    , S.sSEMAPart
ORDER BY S.ixSKU --, VS.iOrdinality



/*  Eagle Motorsports Revenue via SMI SOP.rdl
DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '01/01/19',    @EndDate = '09/10/19' 

SELECT O.ixOrder /*
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
     , S.ixBrand
     , S.sDescription
     , OL.iQuantity
     , OL.mUnitPrice
     , OL.mExtendedPrice
    , OL.mExtendedCost
    */
INTO #EMIRevViaSOPOrders
FROM vwEagleOrder O 
    LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
    LEFT JOIN vwEagleOrderLine OL ON OL.ixOrder = O.ixOrder  
                             AND OL.flgKitComponent = '0'   
    LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
WHERE O.sOrderStatus = 'Shipped' 
  AND O.dtShippedDate BETWEEN @StartDate AND @EndDate -- per Jerry Malcolm, use date shipped
/********
 -- removing so that ALL used source codes will be displayed
  AND (O.sSourceCodeGiven in (@SourceCode)
           OR
          O.sMatchbackSourceCode in (@SourceCode))
********/
ORDER BY O.dtShippedDate,
    O.ixOrder,
    OL.iOrdinality
*/


SELECT VR.ixOrder, O.sSourceCodeGiven, O.sMatchbackSourceCode
FROM #VendorRevOrders VR
LEFT join tblOrder O on VR.ixOrder = O.ixOrder
WHERE VR.ixOrder in (SELECT * FROM #EMIRevViaSOPOrders)
ORDER BY O.sSourceCodeGiven

