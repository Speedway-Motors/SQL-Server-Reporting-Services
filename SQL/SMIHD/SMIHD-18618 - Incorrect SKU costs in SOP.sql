-- SMIHD-18618 - Incorrect SKU costs in SOP
-- ACTIVE BOM SKUs where the finished SKU shows a negative GP

    -- ACTIVE BOM SKUs where the finished SKU shows a negative GP
    SELECT S.ixSKU 'FinishedSKU', S.mPriceLevel1, mEMITotalLaborCost,	mEMITotalMaterialCost,	mSMITotalLaborCost,	mSMITotalMaterialCost, 
    S.mPriceLevel1 - (TM.mEMITotalLaborCost+ mEMITotalMaterialCost+ TM.mSMITotalMaterialCost+ mSMITotalLaborCost) 'GP', S.mAverageCost, S.mLatestCost
    FROM tblBOMTemplateMaster TM
        left join tblSKU S on TM.ixFinishedSKU = S.ixSKU
    WHERE S.flgDeletedFromSOP = 0
        /*and (TM.mEMITotalLaborCost > S.mPriceLevel1    --  679
            or TM.mEMITotalMaterialCost > S.mPriceLevel1 -- 69025
            or TM.mSMITotalLaborCost > S.mPriceLevel1   -- 4,528
            or TM.mSMITotalMaterialCost > S.mPriceLevel1 -- 5,171
            or  (TM.mEMITotalLaborCost+ S.mPriceLevel1+ TM.mSMITotalMaterialCost+ mSMITotalLaborCost) > S.mPriceLevel1  -- 12,463
            )
        */
        and S.mPriceLevel1 - (TM.mEMITotalLaborCost+ mEMITotalMaterialCost+ TM.mSMITotalMaterialCost+ mSMITotalLaborCost) < 0 -- GP < 0     -- 5,250
        and S.flgActive = 1
   --     AND TM.ixFinishedSKU in ('95035006','911404871','94611328','91622044-3')                -- '98622100.2'
    order by S.mPriceLevel1 - (TM.mEMITotalLaborCost+ mEMITotalMaterialCost+ TM.mSMITotalMaterialCost+ mSMITotalLaborCost) 


SELECT S.ixSKU, TM.* 
from tblSKU S
    left join tblBOMTemplateMaster on TM.ixFinishedSKU = S.ixSKU
where S.ixSKU in ('97610002','97065001-BLK','97614004-BLK','97065004-BLK','97614006','97065005-BLK','97614010','97065008','97614008','97065012','97065007','97065011','97065029','97065027','97065014','94605','94607151.1','91073072-pol')
    and TM.ixFinishedSKU iS NOT NULL




SELECT S.ixSKU, S.mPriceLevel1, mEMITotalLaborCost,	mEMITotalMaterialCost,	mSMITotalLaborCost,	mSMITotalMaterialCost
FROM tblBOMTemplateMaster TM
    left join tblSKU S on TM.ixFinishedSKU = S.ixSKU
WHERE S.flgDeletedFromSOP = 0
    and (TM.mEMITotalLaborCost+ S.mPriceLevel1+ TM.mSMITotalMaterialCost+ mSMITotalLaborCost) < S.mPriceLevel1


/* Eagle Motorsports Revenue via SMI SOP.rdl
    ver 20.12.1

DECLARE @StartDate datetime, @EndDate datetime
SELECT @StartDate = '01/01/2020', @EndDate = '01/04/2020'
*/
SELECT O.ixOrder -- 4,246
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
    , (ISNULL(TM.mEMITotalLaborCost,0)*(OL.iQuantity)) 'ExtEMILaborCost'
FROM vwEagleOrder O 
    LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
    LEFT JOIN vwEagleOrderLine OL ON OL.ixOrder = O.ixOrder  
                             AND OL.flgKitComponent = '0'   
    LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
    LEFT JOIN tblBOMTemplateMaster TM on TM.ixFinishedSKU = S.ixSKU
WHERE O.sOrderStatus = 'Shipped' 
  AND O.dtShippedDate BETWEEN @StartDate AND @EndDate 
  
  -- per Jerry Malcolm, use date shipped
/********
 -- removing so that ALL used source codes will be displayed
  AND (O.sSourceCodeGiven in (@SourceCode)
           OR
          O.sMatchbackSourceCode in (@SourceCode))
********/

UNION

SELECT O.ixOrder -- 4,773 COMBINED
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
    , (ISNULL(TM.mEMITotalLaborCost,0)*(OL.iQuantity)) 'ExtEMILaborCost'
FROM vwEagleOrderAdditionalRevenue O 
    LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
    LEFT JOIN vwEagleOrderLineAdditionalRevenue OL ON OL.ixOrder = O.ixOrder  
                             AND OL.flgKitComponent = '0'   
    LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
    LEFT JOIN tblBOMTemplateMaster TM on TM.ixFinishedSKU = S.ixSKU
WHERE O.sOrderStatus = 'Shipped' 
  AND O.dtShippedDate BETWEEN @StartDate AND @EndDate 
  AND ixFinishedSKU = '98622100.2'
ORDER BY O.dtShippedDate,
    O.ixOrder,
    OL.iOrdinality



select * from tblBOMTemplateDetail
where ixFinishedSKU = '98622100.2'

select * from tblSKU where ixSKU in ('94600-CUT','M3R.625D.065H')
