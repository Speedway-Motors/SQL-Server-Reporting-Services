-- SMIHD-11170 - New Promo report 11/13/18

/*    WHAT DO THESE FLAGS MEAN?
      flgPhone	
      flgWeb	
      flgStore	
      flgGlobal	
      flgEnabled

still to get
=============
  SUM(isnull(CPS.PrePromoMerchandise,0))        as 'PrePromoMerch',
  SUM(isnull(SKUP.mPrePromoUnitPrice,0)),
  ,SUM(case when FO.ixCustomer is NULL then 0
      else 1
      end) as 'CountNewCustomers'

  */

DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '08/12/18',    @EndDate = '11/12/18'  

SELECT -- PROMO LEVEL
    TP.ixPromotion 'PromoID', -- aka TopLevelPromoID
    --TP.dtCreateUtc, TP.dtLastUpdateUtc, TP.sCreateUser, TP.sUpdateUser, 
    TP.sPromoCode, 
    --TP.sPublicName, 
    CONVERT(VARCHAR,TP.dtStartDateTimeUtc, 1) 'StarDate', --'PromoOfferStart', 
    CONVERT(VARCHAR,TP.dtEndDateTimeUtc, 1) 'EndDate', -- 'PromoOfferEnd'
    --TP.dtStartDateTimeUtc, TP.iStartYear, TP.dtEndDateTimeUtc, TP.iEndYear, 
    --TP.sPrequalifiedMessage, 
    --TP.sAppliedMessage, 
    --TP.sMarketingMessage, 
    --TP.flgPhone, TP.flgWeb, TP.flgStore, TP.flgGlobal, TP.flgEnabled,
            -- PROMO OFFER LEVEL
    TP.ixPromotionOffer 'ReportingPromoID', -- switch to this as the source instead of PCM.ixPromoID after testing
    TP.sPromoName as 'PromoDescription', -- SIMILAR to PCM.sDescription
    --PO.iOrdinality, PO.flgDisabled, 
    --PO.ixPromotionOffer, PO.dtCreateUtc, PO.dtLastUpdateUtc, PO.sCreateUser, PO.sUpdateUser, PO.ixPromotion,     PO.StarDate, PO.EndDate
    --PCM.ixPromoID 'ReportingPromoID', -- pulling from tblpromotion_offer instead
    --LEN(ixPromoId),
    --CONVERT(VARCHAR,TP.dtStartDateTimeUtc, 1)  'TopLevelPromoStart', 
    --CONVERT(VARCHAR,TP.dtEndDateTimeUtc, 1)  'TopLevelPromoEnd',  
    --CONVERT(VARCHAR,PCM.dtStartDate, 1) 'StarDate', --'PromoOfferStart', 
    --CONVERT(VARCHAR,PCM.dtEndDate, 1) 'EndDate', -- 'PromoOfferEnd'
    -- tblPromoCodeMaster
    --PCM.ixPromoId, PCM.ixPromoCode, 
    --PCM.sDescription 
    --PCM.ixStartDate, PCM.ixStartTime, PCM.ixEndDate, PCM.ixEndTime, PCM.dtStartDate, PCM.dtEndDate, 
    --PCM.flgSiteWide, 
    --PCM.dtDateLastSOPUpdate, PCM.ixTimeLastSOPUpdate, 
    --PCM.mMinOrderAmount, PCM.mMaxOrderAmount
-- TRYING TO GET CRITERIA AND INCENTIVE VALUES
   -- ,     po.ixPromotion -- If you want to rollup up the reported Promotion
   -- , po.ixPromotionOffer -- Currently the reporting Promotion Offer
           -- , poc.* -- Criteria
           -- , poct.iOrdinality
           -- , poct.sPromotionOfferCriteriaTypeName -- Text for the type
           -- , poce.sPromotionOfferCriteriaEnteredValue -- The Values entered
    ISNULL(O.CountOrders,0) as 'CountOrders',
    ISNULL(O.CountCustomers,0) as 'CountCustomers',
    ISNULL(O.MerchTotal,0) as 'MerchTotal',
    ISNULL(O.MerchCost,0) as 'MerchCost',
    ISNULL(TPM.TotMerchDiscount,0) as 'TotMerchDiscount'
    /* NEED THE JOIN ISSUE RESOLVED!!! 
       tblShippingPromo.ixPromoId VARCHAR(15)  to  tng.tblpromotion_offer.ixPromotionOffer (INT)    
       'The conversion of the varchar value '''76376316531653''' overflowed an int column
    ISNULL(TPS.TotShippingDiscount,0)   as 'TotSHDiscount',     
    ISNULL(TPS.TotPrePromoSHCharge,0)   as 'TotPrePromoSHCharge',
    ISNULL(TPS.TotPostPromoSHCharge,0)  as 'TotPostPromoSHCharge', 
    */



FROM (-- Distinct List of Promotion IDs and PromotionOffer IDs
                --DECLARE @StartDate datetime,        @EndDate datetime
                --SELECT  @StartDate = '08/12/18',    @EndDate = '11/12/18'  
      SELECT distinct TP.ixPromotion, PO.ixPromotionOffer,
       dtStartDateTimeUtc, dtEndDateTimeUtc,
       TP.sPromoCode,
       TP.sPromoName
        --ixPromoCode,  <-- this was causing a cartesian on a small # of PromoIDs e.g. PromoId 1410
      FROM tng.tblpromotion TP 
        left join tng.tblpromotion_offer PO on TP.ixPromotion = PO.ixPromotion
      where --TP.ixPromotion in (@PromoId)
            TP.dtStartDateTimeUtc <= @EndDate -- promo starts before date range ENDS       
            AND TP.dtEndDateTimeUtc >= @StartDate  -- promo ends after date range STARTS
      AND TP.ixPromotion NOT like 'Z%'
      AND TP.ixPromotion in (1580, 1601,1602)--(1601,1602) -- TESTING ONLY
      )TP
    /*SubQuery to calc the TOTAL PROMO MERCH discount */
      left join (SELECT SP.ixPromoId as 'ixPromoId',
                    sum(case when SP.flgAddedToCart=1 then SP.mExtendedCost else SP.mExtendedPrePromoPrice end)-sum(SP.mExtendedPostPromoPrice) as 'TotMerchDiscount'
                 FROM tblSKUPromo SP 
                    left join tblOrder O on O.ixOrder = SP.ixOrder  AND O.mMerchandise > 0 -- merch > 0 is needed to avoid pulling in zero-shipped CRAP
                 WHERE O.dtOrderDate between @StartDate and @EndDate               
                     and O.sOrderStatus = 'Shipped'
                     and O.mMerchandise > 0
                 GROUP BY SP.ixPromoId
                 ) TPM on TPM.ixPromoId = TP.ixPromotionOffer
    /* NEED THE JOIN ISSUE RESOLVED!!! 
    /*SubQuery to calc the TOTAL PROMO SHIPPING discount */
      left join (--DECLARE @StartDate datetime,        @EndDate datetime
                --SELECT  @StartDate = '08/12/18',    @EndDate = '11/12/18'  

                SELECT SP.ixPromoId as ixPromoId,
                    sum(isnull(SP.mPrePromoShippingCharge,0)-(isnull(SP.mPostPromoShippingCharge,0)) )  as 'TotShippingDiscount',
                    sum(isnull(SP.mPrePromoShippingCharge,0)) as 'TotPrePromoSHCharge',
                    sum(isnull(SP.mPostPromoShippingCharge,0)) as 'TotPostPromoSHCharge'
                 FROM tblShippingPromo SP 
                    left join tblOrder O on O.ixOrder = SP.ixOrder AND O.mMerchandise > 0 -- merch > 0 is needed to avoid pulling in zero-shipped CRAP
                 WHERE --SP.ixPromoId in (@PromoId) and 
                    O.dtOrderDate between @StartDate and @EndDate                     
                     and O.sOrderStatus = 'Shipped'
                 GROUP BY SP.ixPromoId
                 ) TPS on TPS.ixPromoId = TP.ixPromotionOffer
    */
 -- left join tng.tblpromotion_offer PO on PO.ixPromotion = TP.ixPromotion

--  left join tblOrderPromoCodeXref OPCXREF on OPCXREF.ixPromoId = TP.ixPromotionOffer
--  left join tblOrder O on O.ixOrder = OPCXREF.ixOrder 
                        --AND OPCXREF.ixPromoId = TP.ixPromotionOffer 
                        --AND O.mMerchandise > 0 -- me-rch > 0 is needed to avoid pulling in zero-shipped CRAP
                        --AND O.dtOrderDate between @StartDate AND @EndDate 
    LEFT JOIN( -- ORDER SUMMARY BY Promo Offer
                             --DECLARE @StartDate datetime,        @EndDate datetime
                              --SELECT  @StartDate = '08/12/18',    @EndDate = '11/12/18'  
                SELECT PO.ixPromotionOffer,
                    COUNT(distinct(SUBSTRING(O.ixOrder, 1, 7)))   as 'CountOrders',
                    COUNT(distinct(O.ixCustomer))                 as 'CountCustomers',
                    SUM(isnull(O.mMerchandise,0))                 as 'MerchTotal', 
                    SUM(isnull(O.mMerchandiseCost,0))             as 'MerchCost'
                FROM tng.tblpromotion_offer PO
                    LEFT JOIN tblOrderPromoCodeXref OPCXREF on OPCXREF.ixPromoID = PO.ixPromotionOffer
                    LEFT join tblOrder O on O.ixOrder = OPCXREF.ixOrder
                                          and O.dtOrderDate between @StartDate and @EndDate
                GROUP BY PO.ixPromotionOffer
                ) O ON O.ixPromotionOffer = TP.ixPromotionOffer
                      
   -- THESE 3 TABLES NEED TO BE ADDED LATER (sub-query or sub-report?) otherwise they'll cause multiple rows to return for each ReportingID
   -- inner join tng.tblpromotion_offer_criteria poc on po.ixPromotionOffer = poc.ixPromotionOffer
   -- inner join tng.tblpromotion_offer_criteria_type poct on poct.ixPromotionOfferCriteriaType = poc.ixPromotionOfferCriteriaType
   -- inner join tng.tblpromotion_offer_criteria_enteredvalue poce on poce.ixPromotionOfferCriteria = poc.ixPromotionOfferCriteria
   -- inner join tng.tblpromotion p on p.ixpromotion = po.ixPromotion  ALREADY JOIN TO THIS TABLE
--WHERE 
        -- read the next conditions closely. This can NOT be a BEETWEEN statement.  
        --we want to include promos that are at least partially active during the entered range.
   --     TP.dtStartDateTimeUtc <= @EndDate -- promo starts before date range ENDS       
  --      AND TP.dtEndDateTimeUtc >= @StartDate  -- promo ends after date range STARTS
--AND TP.ixPromotion in (1580, 1601,1602)--(1601,1602) -- TESTING ONLY    2 Promos with 5 offers each
--AND TP.sPublicName <> TP.sPromoName
ORDER BY TP.ixPromotion, TP.ixPromotionOffer




/*
                        

--tng.tblpromotion TP
*/

/*
-- ORDER Using the test PROMOs
select * from tblOrderPromoCodeXref
where ixPromoId in (1638,1639,1640,1641,1642)
order by ixPromoId


Promo
Offer                               Merch
Id	    ixOrder ixCust      Merch   Cost
====    ======= =======     ======  ========
1638	8852304 578660      184.99	 75.00

1639	8860306 3016003     537.97	364.32
1639	8863301 3016003     374.99	225.25
1639	8852302 3016003     304.99	195.426

1640	8821306  387266     374.99	197.98

1641    0 orders
1642    0 orders
====    ========           ======= ========
TOTALS  5 total  3 Custs   1,777.93 1,057.98 <-- actual
                           8,889.65 5259.88  <-- cureent query

SELECT ixOrder, ixCustomer, mMerchandise, mMerchandiseCost
from tblOrder
where ixOrder in ('8852304','8860306','8863301','8852302','8821306')

SELECT *
from tblOrderPromoCodeXref
where ixOrder in ('8852304','8860306','8863301','8852302','8821306')
*/

/*

select * from tblShippingPromo
where 
    --len(ixPromoId) = 14
    len(ixPromoId) between 5 and 13
order by len(ixPromoId) desc

select * from tng.tblpromotion TP 
where len(ixPromotion) > 4



tng.tblpromotion -- longest lenght ixPromotion = 4 chars
tblShippingPromo -- longest lenght ixPromoId = 14 chars



*/
