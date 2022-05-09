-- Eagle change to Eagle Motorsports Revenue via SMI SOP report
select * from vwEagleOrder -- 2:36 2,405 rows @07/06/2015


select * from vwEagleOrder 
where ixCustomer in ('1069864','771457','1765685','1158486')

       
         
         
-- WHAT MIKE WANTS TO ADD
select C.ixCustomer, C.sCustomerLastName, 
-- C.ixCustomerType, C.sCustomerType,
O.ixOrder, 
--O.sSourceCodeGiven, O.sMatchbackSourceCode, 
O.mMerchandise, 
O.dtOrderDate, O.dtShippedDate,
O.sOrderStatus
--sum(mMerchandise) -- 302k
from [SMI Reporting].dbo.tblOrder O
    left join tblCustomer C on C.ixCustomer = O.ixCustomer
where dtOrderDate between '03/01/2015' and '03/31/2015' -- @StartDate and @EndDate -->= '05/12/2014' -- 1st possible order date to speed queries
AND sOrderStatus = 'Shipped'
AND O.ixCustomer in ('1069864','771457','1765685','1158486')-- WHAT MIKE WANTS TO ADD
AND O.sOrderTaker in ('MAL','MAL2','MAL1','FWG','KAV','JTM')              -- WHAT MIKE WANTS TO ADD
AND O.ixOrder NOT IN (select ixOrder from vwEagleOrder)

-- AMOUNTS TO ONE ORDER for $36!?!   ixOrder = 6440801


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
    --, OL.iOrdinality
    --, OL.ixSKU
    --, S.ixBrand
    --, S.sDescription
    --, OL.iQuantity
    --, OL.mUnitPrice
    --, OL.mExtendedPrice
    --, OL.mExtendedCost
FROM tblOrder O 
    LEFT JOIN tblCustomer C ON C.ixCustomer = O.ixCustomer
    --LEFT JOIN tblOrderLine OL ON OL.ixOrder = O.ixOrder  
    --                         AND OL.flgKitComponent = '0'   
    --LEFT JOIN tblSKU S ON S.ixSKU = OL.ixSKU 
WHERE O.sOrderStatus = 'Shipped' 
  AND O.dtShippedDate BETWEEN '03/01/2015' and '03/31/2015' -- @StartDate AND @EndDate -- per Jerry Malcolm, use date shipped
    AND O.ixCustomer in ('1069864','771457','1765685','1158486') -- Specific customer accounts Mike wants to watch
    AND O.sOrderTaker in ('MAL','MAL2','MAL1','FWG','KAV','JTM') -- users specified by Mike Long     
ORDER BY O.ixCustomer, O.dtShippedDate




select * from tblCustomer where ixCustomer in ('1069864','771457','1765685','1158486')

/*
ixCustomer	sCustomerType	ixCustomerType
771457	PRS	30
1069864	PRS	30
1158486	Other	32
1765685	PRS	30
*/


select * from tblOrder where ixOrder in ('6330525')