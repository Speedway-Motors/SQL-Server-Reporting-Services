-- SMIHD-15239 Add rules to Eagle Motorsports Revenue Report

/* Eagle Motorsports Sales Summary.rdl
     ver 19.41.1

DECLARE @StartDate datetime, @EndDate datetime
SELECT @StartDate = '05/10/2019', @EndDate = '10/08/2019'
*/

SELECT
    O.sSourceCodeGiven
    , COUNT(O.ixOrder) 'OrderCount'
    , ISNULL(SUM(O.mMerchandise),0) 'Merchandise'
    , ISNULL(SUM(O.mMerchandiseCost),0) 'MerchCost'
    , ISNULL(SUM(O.mShipping),0) 'SH'
    , ISNULL(SUM(O.mTax),0) 'Tax'
    , ISNULL(SUM(O.mCredits),0) 'Credits'
    , (SUM(ISNULL(O.mMerchandise,0)) + SUM(ISNULL(O.mShipping,0)) + SUM(ISNULL(O.mTax,0)) - SUM(ISNULL(O.mCredits,0))) AS 'Total'    
FROM (   SELECT
            O.sSourceCodeGiven
            , O.ixOrder
            , O.mMerchandise
            , O.mMerchandiseCost
            , O.mShipping
            , O.mTax
            , O.mCredits
        from vwEagleOrder O 
        where  O.dtShippedDate between @StartDate AND @EndDate  --'09/01/2019' AND '09/30/2019' -- '05/10/2019' AND '10/08/2019'
        and (O.sOrderStatus is NULL         
             OR O.sOrderStatus = 'Shipped') -- excludes 'Pick Tickets'

        UNION

        SELECT
            O.sSourceCodeGiven
            , O.ixOrder
            , O.mMerchandise
            , O.mMerchandiseCost
            , O.mShipping
            , O.mTax
            , O.mCredits 
        from vwEagleOrderAdditionalRevenue O 
        where  O.dtShippedDate between  @StartDate AND @EndDate  --'09/01/2019' AND '09/30/2019' -- '05/10/2019' AND '10/08/2019'
        and (O.sOrderStatus is NULL         
             OR O.sOrderStatus = 'Shipped') -- excludes 'Pick Tickets'

        ) O
GROUP BY O.sSourceCodeGiven
ORDER BY O.sSourceCodeGiven

