-- SMIHD-11170 - New Promo report

/*    WHAT DO THESE FLAGS MEAN?
      flgPhone	
      flgWeb	
      flgStore	
      flgGlobal	
      flgEnabled


fields to get
  PO.ixPromotionOffer,
  PL.PromoDescription,

  SUM(isnull(CPS.PrePromoMerchandise,0))        as 'PrePromoMerch',
  SUM(isnull(SKUP.mPrePromoUnitPrice,0)),
  SUM(isnull(O.mMerchandise,0))                 as 'MerchTotal', 
  SUM(isnull(O.mMerchandiseCost,0))             as 'MerchCost',
  isnull(TPM.TotMerchDiscount,0)                as 'TotMerchDiscount',
  isnull(TPS.TotShippingDiscount,0)             as 'TotSHDiscount',     
  isnull(TPS.TotPrePromoSHCharge,0)             as 'TotPrePromoSHCharge',
  isnull(TPS.TotPostPromoSHCharge,0)            as 'TotPostPromoSHCharge',  
  COUNT(distinct(SUBSTRING(O.ixOrder, 1, 7)))   as 'CountOrders',
  COUNT(distinct(O.ixCustomer))                 as 'CountCustomers'
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
    TP.sPromoName, 
    CONVERT(VARCHAR,TP.dtStartDateTimeUtc, 1) 'StarDate', --'PromoOfferStart', 
    CONVERT(VARCHAR,TP.dtEndDateTimeUtc, 1) 'EndDate', -- 'PromoOfferEnd'
    --TP.dtStartDateTimeUtc, TP.iStartYear, TP.dtEndDateTimeUtc, TP.iEndYear, 
    --TP.sPrequalifiedMessage, 
    --TP.sAppliedMessage, 
    --TP.sMarketingMessage, 
    --TP.flgPhone, TP.flgWeb, TP.flgStore, TP.flgGlobal, TP.flgEnabled,
            -- PROMO OFFER LEVEL
    PO.ixPromotionOffer 'ReportingPromoID', -- switch to this as the source instead of PCM.ixPromoID after testing
    PCM.sDescription as 'PromoDescription' -- SIMILAR to TP.sPromoName
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
from tng.tblpromotion TP
    left join tng.tblpromotion_offer PO on PO.ixPromotion = TP.ixPromotion
    left join tblPromoCodeMaster PCM on PO.ixPromotionOffer = PCM.ixPromoId-- the rollup value (in the UI this is the Promo Id).
   -- THESE 3 TABLES NEED TO BE ADDED LATER (sub-query or sub-report?) otherwise they'll cause multiple rows to return for each ReportingID
   -- inner join tng.tblpromotion_offer_criteria poc on po.ixPromotionOffer = poc.ixPromotionOffer
   -- inner join tng.tblpromotion_offer_criteria_type poct on poct.ixPromotionOfferCriteriaType = poc.ixPromotionOfferCriteriaType
   -- inner join tng.tblpromotion_offer_criteria_enteredvalue poce on poce.ixPromotionOfferCriteria = poc.ixPromotionOfferCriteria
    inner join tng.tblpromotion p on p.ixpromotion = po.ixPromotion
where -- read the next conditions closely. This can NOT be a BEETWEEN statement.  
      --we want to include promos that are at least partially active during the entered range.
    TP.dtStartDateTimeUtc <= @EndDate -- promo starts before date range ENDS       
       AND TP.dtEndDateTimeUtc >= @StartDate  -- promo ends after date range STARTS
       AND ixPromoId NOT like 'Z%'
AND TP.ixPromotion in (1580, 1601,1602)--(1601,1602) -- TESTING ONLY    2 Promos with 5 offers each
--AND TP.sPublicName <> TP.sPromoName
ORDER BY 'PromoID', --LEN(ixPromoId) DESC--, 
    'ReportingPromoID'
    --ixPromoId DESC 





/*


    select * from tblPromoCodeMaster where ixPromoId in ('1638','1639','1640','1641','1642')

    select top 10 * from tng.tblpromotion_offer_criteria



    */
