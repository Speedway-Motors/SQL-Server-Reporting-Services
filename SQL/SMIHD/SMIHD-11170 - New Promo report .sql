-- SMIHD-11170 - New Promo report 11/20/18

/*    WHAT DO THESE FLAGS MEAN?
      flgPhone	flgWeb	flgStore	flgGlobal	 flgEnabled

DECLARE @PromoID varchar(15) --@StartDate datetime,        @EndDate datetime
SELECT  @PromoID = '1580'--@StartDate = '08/12/18',    @EndDate = '11/12/18'  
 */

SELECT -- PROMO LEVEL
    TP.ixPromotion 'PromoID', -- aka TopLevelPromoID
    --TP.dtCreateUtc, TP.dtLastUpdateUtc, TP.sCreateUser, TP.sUpdateUser, TP.sPublicName, 
    TP.sPromoCode, 
    CONVERT(VARCHAR,TP.dtStartDateTimeUtc, 1) 'StarDate', --'PromoOfferStart', 
    CONVERT(VARCHAR,TP.dtEndDateTimeUtc, 1) 'EndDate', -- 'PromoOfferEnd'
    --TP.sPrequalifiedMessage, TP.sAppliedMessage, TP.sMarketingMessage, TP.flgPhone, TP.flgWeb, TP.flgStore, TP.flgGlobal, TP.flgEnabled,
            -- PROMO OFFER LEVEL
    TP.ixPromotionOffer 'ReportingPromoID', -- switch to this as the source instead of PCM.ixPromoID after testing
    TP.sPromoName as 'PromoName', -- SIMILAR to PCM.sDescription
    --PO.iOrdinality, PO.flgDisabled, 
    --PCM.flgSiteWide, PCM.mMinOrderAmount, PCM.mMaxOrderAmount
-- TRYING TO GET CRITERIA AND INCENTIVE VALUES
   -- ,     po.ixPromotion -- If you want to rollup up the reported Promotion
   -- , po.ixPromotionOffer -- Currently the reporting Promotion Offer
           -- , poc.* -- Criteria
           -- , poct.iOrdinality
           -- , poct.sPromotionOfferCriteriaTypeName -- Text for the type
           -- , poce.sPromotionOfferCriteriaEnteredValue -- The Values entered
    O.PrePromoMerch,
    ISNULL(TPM.TotMerchDiscount,0) as 'MerchDiscount',
    ISNULL(O.MerchTotal,0) as 'Sales', 
    ISNULL(O.CountOrders,0) as 'CountOrders',
    ISNULL(TPS.TotShippingDiscount,0)   as 'TotSHDiscount', -- ShippingDiscount    
    ISNULL(TPS.TotPrePromoSHCharge,0)   as 'TotPrePromoSHCharge',
    ISNULL(TPS.TotPostPromoSHCharge,0)  as 'TotPostPromoSHCharge', 
    -- CM$ = (Sales	- COGS  - Est Fulfillment Cost - (mPrePromoShippingCharge * .7) + mPostPromoShippingCharge
    -- CM% = =Iif((MerchTotal)=0,"N/A",((MerchTotal-MerchCost-(PrePromoMerch*.1)-(TotPrePromoSHCharge*.7)+TotPostPromoSHCharge)/(MerchTotal+TotPostPromoSHCharge)))
    ISNULL(O.MerchCost,0) as 'MerchCost',
    ISNULL(O.CountCustomers,0) as 'CountCustomers',
    O.PrePromoUnitPrice,
    O.CountNewCustomers,
    'TBD' AS 'Offfer Criteria data',
    'TBD' AS 'Offer Incentive data'
FROM (-- Distinct List of Promotion IDs and PromotionOffer IDs
      SELECT distinct TP.ixPromotion, PO.ixPromotionOffer,
        dtStartDateTimeUtc, dtEndDateTimeUtc,
        TP.sPromoCode,
        TP.sPromoName
        --ixPromoCode,  <-- this was causing a cartesian on a small # of PromoIDs e.g. PromoId 1410
      FROM tng.tblpromotion TP 
        left join tng.tblpromotion_offer PO on TP.ixPromotion = PO.ixPromotion
      WHERE TP.ixPromotion in (@PromoID)
            --and TP.dtStartDateTimeUtc <= @EndDate -- promo starts before date range ENDS       
            --AND TP.dtEndDateTimeUtc >= @StartDate  -- promo ends after date range STARTS
      AND TP.ixPromotion NOT like 'Z%'
     -- AND TP.ixPromotion in (1580, 1601,1602)--(1601,1602) -- TESTING ONLY
      )TP
      LEFT JOIN(-- calc the TOTAL PROMO MERCH discount
                SELECT SP.ixPromoId as 'ixPromoId',
                    sum(case when SP.flgAddedToCart=1 then SP.mExtendedCost else SP.mExtendedPrePromoPrice end)-sum(SP.mExtendedPostPromoPrice) as 'TotMerchDiscount'
                 FROM tblSKUPromo SP 
                    left join tblOrder O on O.ixOrder = SP.ixOrder  AND O.mMerchandise > 0 -- merch > 0 is needed to avoid pulling in zero-shipped CRAP
                 WHERE O.dtOrderDate between @StartDate and @EndDate               
                     and O.sOrderStatus = 'Shipped'
                     and O.mMerchandise > 0
                 GROUP BY SP.ixPromoId
                 ) TPM on TPM.ixPromoId = TP.ixPromotionOffer
    /* NEED THE JOIN ISSUE RESOLVED!!! 
       tblShippingPromo.ixPromoId VARCHAR(15)  to  tng.tblpromotion_offer.ixPromotionOffer (INT)    
       'The conversion of the varchar value '''76376316531653''' overflowed an int column */
      left join ( --SubQuery to calc the TOTAL PROMO SHIPPING discount
                --DECLARE @StartDate datetime,        @EndDate datetime
                --SELECT  @StartDate = '08/12/18',    @EndDate = '11/12/18'  
                SELECT SP.ixPromoId as ixPromoId,
                    sum(isnull(SP.mPrePromoShippingCharge,0)-(isnull(SP.mPostPromoShippingCharge,0)) )  as 'TotShippingDiscount',
                    sum(isnull(SP.mPrePromoShippingCharge,0)) as 'TotPrePromoSHCharge',
                    sum(isnull(SP.mPostPromoShippingCharge,0)) as 'TotPostPromoSHCharge'
                 FROM tblShippingPromo SP 
                    left join tblOrder O on O.ixOrder = SP.ixOrder AND O.mMerchandise > 0 -- merch > 0 is needed to avoid pulling in zero-shipped CRAP
                 WHERE SP.ixPromoId in (@PromoID)  
                    and O.dtOrderDate between @StartDate and @EndDate                     
                     and O.sOrderStatus = 'Shipped'
                 GROUP BY SP.ixPromoId
                 ) TPS on TPS.ixPromoId = TP.ixPromotionOffer
    LEFT JOIN( -- ORDER SUMMARY BY Promo Offer
                SELECT PO.ixPromotionOffer,
                    COUNT(distinct(SUBSTRING(O.ixOrder, 1, 7)))   as 'CountOrders',
                    COUNT(distinct(O.ixCustomer))                 as 'CountCustomers',
                    SUM(isnull(O.mMerchandise,0))                 as 'MerchTotal', 
                    SUM(isnull(O.mMerchandiseCost,0))             as 'MerchCost',
                    SUM(isnull(CPS.PrePromoMerchandise,0))        as 'PrePromoMerch',
                    SUM(isnull(SKUP.mPrePromoUnitPrice,0))        as 'PrePromoUnitPrice',
                    SUM(case when FO.ixCustomer is NULL then 0
                       else 1 end)                                as 'CountNewCustomers'
                FROM tng.tblpromotion_offer PO
                    LEFT JOIN tblOrderPromoCodeXref OPCXREF on OPCXREF.ixPromoID = PO.ixPromotionOffer
                    LEFT JOIN tblOrder O on O.ixOrder = OPCXREF.ixOrder
                                          and O.dtOrderDate between @StartDate and @EndDate
                    LEFT JOIN vwOrderCombinedPromoSummary CPS on O.ixOrder = CPS.ixOrder AND O.mMerchandise > 0 -- merch > 0 is needed to avoid pulling in zero-shipped CRAP
--                      pulls FROM vwOrderLinePromoSummary & vwOrderShippingPromoSummary
--                                 (tblSKUPromo & tblOrder)  (tblShippingPromo & tblOrder)
                    LEFT JOIN tblSKUPromo SKUP on SKUP.ixOrder = O.ixOrder
                    LEFT JOIN  (-- First Order
                                SELECT ixCustomer, MIN(ixOrderDate) ixFirstOrderDate, MIN(dtOrderDate) dtFirstOrderDate, COUNT(O.ixOrder) OrderCnt
                                FROM tblOrder O
                                WHERE O.sOrderStatus = 'Shipped'
                                    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                                    and O.sOrderType <> 'Internal'   -- USUALLY filtered
                                GROUP BY ixCustomer) FO on FO.ixCustomer = O.ixCustomer AND O.ixOrderDate = FO.ixFirstOrderDate -- AND O.mMerchandise > 0-- merch > 0 is needed to avoid pulling in zero-shipped CRAP

                GROUP BY PO.ixPromotionOffer
                ) O ON O.ixPromotionOffer = TP.ixPromotionOffer
   -- THESE 3 TABLES NEED TO BE ADDED LATER (sub-query or sub-report?) otherwise they'll cause multiple rows to return for each ReportingID
   -- inner join tng.tblpromotion_offer_criteria poc on po.ixPromotionOffer = poc.ixPromotionOffer
   -- inner join tng.tblpromotion_offer_criteria_type poct on poct.ixPromotionOfferCriteriaType = poc.ixPromotionOfferCriteriaType
   -- inner join tng.tblpromotion_offer_criteria_enteredvalue poce on poce.ixPromotionOfferCriteria = poc.ixPromotionOfferCriteria
   -- inner join tng.tblpromotion p on p.ixpromotion = po.ixPromotion  ALREADY JOIN TO THIS TABLE
--WHERE 
ORDER BY TP.ixPromotion, TP.ixPromotionOffer