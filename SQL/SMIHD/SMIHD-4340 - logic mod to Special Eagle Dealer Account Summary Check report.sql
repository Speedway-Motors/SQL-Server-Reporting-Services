-- SMIHD-4340 - ORDERS TAKEN BY MIKES TEAM that ARE NOT CURRENTLY INCLUDED IN THEIR WHOLESALE SALES REPORT
/**** PAT'S TO DO
    Explain the change to Jerry prior to making the production change.
    If no objections, overwrite the code in the Special Eagle Dealer Account Summary Check report with code below:
 ****/   
/*
DECLARE
    @StartDate datetime,
    @EndDate datetime

SELECT
    @StartDate = '01/01/16',
    @EndDate = '07/31/16'  
*/
SELECT C.ixCustomer
    , C.ixCustomerType
    , C.sCustomerFirstName
    , C.sCustomerLastName
    , O.ixOrder
    , O.dtOrderDate
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
    , O.ixCustomerType
FROM tblOrder O 
    LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
WHERE O.sOrderStatus = 'Shipped' 
  AND O.dtOrderDate >= '05/12/2014'
  AND O.dtShippedDate between @StartDate AND @EndDate -- per Jerry Malcolm, use date shipped
  AND O.sOrderTaker in ('MAL','MAL2','MAL1','FWG','KAV','JTM')  -- specified by Mike Long  
  AND (O.ixCustomerType in (30,32)
       OR O.ixCustomer in 
                       ('173612','268354','312171','312681','321255','349517','378614','450094','771457','789073',
                       '995833','996446','996477','1030461','1069864','1105683','1109789','1110783','1114252','1158486',
                       '1290784','1694567','1707636','1765685','1837526') -- Specific customer accounts Mike wants to watch. Last updated 3-14-16
      )
ORDER BY O.ixCustomer, O.dtShippedDate


--112 


-- 156+112
-- 268