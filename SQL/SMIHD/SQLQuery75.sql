-- WHY IS QUERY SHOWING HIGHER Mech & Merch Cost totals?

DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '08/12/18',    @EndDate = '11/12/18'  

SELECT -- PROMO LEVEL
    TP.ixPromotion 'PromoID', -- aka TopLevelPromoID
    TP.sPromoCode, 
    CONVERT(VARCHAR,TP.dtStartDateTimeUtc, 1) 'StarDate', --'PromoOfferStart', 
    CONVERT(VARCHAR,TP.dtEndDateTimeUtc, 1) 'EndDate', -- 'PromoOfferEnd'
    TP.ixPromotionOffer 'ReportingPromoID', -- switch to this as the source instead of PCM.ixPromoID after testing
    TP.sPromoName as 'PromoDescription', -- SIMILAR to PCM.sDescription
    COUNT(distinct(SUBSTRING(O.ixOrder, 1, 7)))   as 'CountOrders',
    COUNT(distinct(O.ixCustomer))                 as 'CountCustomers',
    SUM(isnull(O.mMerchandise,0))                 as 'MerchTotal', 
    SUM(isnull(O.mMerchandiseCost,0))             as 'MerchCost'
FROM (-- Distinct List of Promotion IDs and PromotionOffer IDs
        --DECLARE @StartDate datetime,        @EndDate datetime
        --SELECT  @StartDate = '08/12/18',    @EndDate = '11/12/18' 
      SELECT distinct TP.ixPromotion, PO.ixPromotionOffer,
        dtStartDateTimeUtc, dtEndDateTimeUtc,
        TP.sPromoCode,
        TP.sPromoName
      from tng.tblpromotion TP 
        left join tng.tblpromotion_offer PO on TP.ixPromotion = PO.ixPromotion
      where TP.dtStartDateTimeUtc <= @EndDate -- promo starts before date range ENDS       
        AND TP.dtEndDateTimeUtc >= @StartDate  -- promo ends after date range STARTS
        AND TP.ixPromotion NOT like 'Z%'
        AND TP.ixPromotion in (1580) -- 1601,1602) -- TESTING ONLY
      )TP
  left join tng.tblpromotion_offer PO on PO.ixPromotion = TP.ixPromotion
  left join tblOrderPromoCodeXref OPCXREF on OPCXREF.ixPromoId = TP.ixPromotionOffer
  left join tblOrder O on O.ixOrder = OPCXREF.ixOrder 
                            AND O.mMerchandise > 0 -- me-rch > 0 is needed to avoid pulling in zero-shipped CRAP
                            AND O.dtOrderDate between @StartDate AND @EndDate 
                            AND OPCXREF.ixPromoId = TP.ixPromotionOffer
GROUP BY 
    TP.ixPromotion,
    TP.sPromoCode, 
    TP.sPromoName, 
    CONVERT(VARCHAR,TP.dtStartDateTimeUtc, 1),
    CONVERT(VARCHAR,TP.dtEndDateTimeUtc, 1),
    TP.ixPromotionOffer
ORDER BY 'PromoID', --LEN(ixPromoId) DESC--, 
    'ReportingPromoID'


--
DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '08/12/18',    @EndDate = '11/12/18'  
SELECT OPCXREF.ixPromoId,
     COUNT(distinct(SUBSTRING(O.ixOrder, 1, 7)))   as 'CountOrders',
    COUNT(distinct(O.ixCustomer))                 as 'CountCustomers',
    SUM(isnull(O.mMerchandise,0))                 as 'MerchTotal', 
    SUM(isnull(O.mMerchandiseCost,0))             as 'MerchCost'
FROM tblOrderPromoCodeXref OPCXREF
    LEFT join tblOrder O on O.ixOrder = OPCXREF.ixOrder
WHERE ixPromoId in (
                    -- DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '08/12/18',    @EndDate = '11/12/18'  
                    SELECT DISTINCT PO.ixPromotionOffer 
                    FROM tng.tblpromotion TP
                    left join tng.tblpromotion_offer PO on PO.ixPromotion = TP.ixPromotion
                    WHERE -- read the next conditions closely. This can NOT be a BEETWEEN statement.  
                          --we want to include promos that are at least partially active during the entered range.
                        TP.dtStartDateTimeUtc <= @EndDate -- promo starts before date range ENDS       
                           AND TP.dtEndDateTimeUtc >= @StartDate  -- promo ends after date range STARTS
                           and TP.ixPromotion = 1580
                           )
GROUP BY OPCXREF.ixPromoId
