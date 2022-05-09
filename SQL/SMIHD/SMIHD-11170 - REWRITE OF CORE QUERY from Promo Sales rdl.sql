-- REWRITE OF CORE QUERY FROM Promo Sales.rdl

DECLARE @StartDate datetime,        @EndDate datetime,          @PromoId varchar(15)
SELECT  @StartDate = '08/12/18',    @EndDate = '11/12/18',    @PromoId = '1561'   -- '1561' 175+ orders
SELECT
  PL.ixPromoId, 
  PO.ixPromotionOffer,
  PL.PromoDescription,
  TP.sPromoCode,
  PL.dtStartDate, 
  PL.dtEndDate,
  /* POSSIBLE fields to add:
          TP.sPromoCode,
          TP.sPublicName,
          TP.sPrequalifiedMessage,
          TP.sAppliedMessage,
          TP.sMarketingMessage,
    
    WHAT DO THESE FLAGS MEAN?
      flgPhone	
      flgWeb	
      flgStore	
      flgGlobal	
      flgEnabled
  */
  SUM(isnull(CPS.PrePromoMerchandise,0))        as 'PrePromoMerch',
  SUM(isnull(SKUP.mPrePromoUnitPrice,0)),--SUM(isnull(SHP.mPrePromoUnitPrice,0)),
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
FROM (-- Distinct List of Promo Ids
      SELECT distinct ixPromoId, dtStartDate, dtEndDate,
        --ixPromoCode,  <-- this was causing a cartesian on a small # of PromoIDs e.g. PromoId 1410
         sDescription as 'PromoDescription'
      FROM tblPromoCodeMaster
      WHERE ixPromoId in (@PromoId)
      )PL
    left join tng.tblpromotion TP on TP.ixPromotion = PL.ixPromoId-- the rollup value (in the UI this is the Promo Id).
    left join tng.tblpromotion_offer PO on PO.ixPromotion = TP.ixPromotion
    left join tblOrderPromoCodeXref OPCXREF on PL.ixPromoId = OPCXREF.ixPromoId
    /*SubQuery to calc the TOTAL PROMO MERCH discount */
      left join (SELECT SP.ixPromoId as ixPromoId,
                   sum(case when SP.flgAddedToCart=1 then SP.mExtendedCost else SP.mExtendedPrePromoPrice end)-sum(SP.mExtendedPostPromoPrice) as 'TotMerchDiscount' --
                FROM tblSKUPromo SP 
                    left join tblOrder O on O.ixOrder = SP.ixOrder  AND O.mMerchandise > 0 -- merch > 0 is needed to avoid pulling in zero-shipped CRAP
                WHERE SP.ixPromoId in (@PromoId) 
                     and O.dtOrderDate between @StartDate and @EndDate               
                     and O.sOrderStatus = 'Shipped'
                     and O.mMerchandise > 0
                GROUP BY SP.ixPromoId
                 ) TPM on TPM.ixPromoId = PL.ixPromoId
    /*SubQuery to calc the TOTAL PROMO SHIPPING discount */
      left join (SELECT SP.ixPromoId as ixPromoId,
                    sum(isnull(SP.mPrePromoShippingCharge,0)-(isnull(SP.mPostPromoShippingCharge,0)) )  as 'TotShippingDiscount',
                    sum(isnull(SP.mPrePromoShippingCharge,0)) as 'TotPrePromoSHCharge',
                    sum(isnull(SP.mPostPromoShippingCharge,0)) as 'TotPostPromoSHCharge'
                 FROM tblShippingPromo SP 
                    left join tblOrder O on O.ixOrder = SP.ixOrder AND O.mMerchandise > 0 -- merch > 0 is needed to avoid pulling in zero-shipped CRAP
                 WHERE SP.ixPromoId in (@PromoId) 
                     and O.dtOrderDate between @StartDate and @EndDate                     
                     and O.sOrderStatus = 'Shipped'
                 GROUP BY SP.ixPromoId
                 ) TPS on TPS.ixPromoId = PL.ixPromoId
    left join tblOrder O on O.ixOrder = OPCXREF.ixOrder AND O.mMerchandise > 0 -- merch > 0 is needed to avoid pulling in zero-shipped CRAP
    left join vwOrderCombinedPromoSummary CPS on O.ixOrder = CPS.ixOrder AND O.mMerchandise > 0 -- merch > 0 is needed to avoid pulling in zero-shipped CRAP
--                      pulls FROM vwOrderLinePromoSummary & vwOrderShippingPromoSummary
--                                 (tblSKUPromo & tblOrder)  (tblShippingPromo & tblOrder)
    left join tblSKUPromo SKUP on SKUP.ixOrder = O.ixOrder
    left join tblShippingPromo SHP on SHP.ixOrder = O.ixOrder
    left join (-- First Order
                SELECT ixCustomer, MIN(ixOrderDate) ixFirstOrderDate, MIN(dtOrderDate) dtFirstOrderDate, COUNT(O.ixOrder) OrderCnt
                FROM tblOrder O
                WHERE O.sOrderStatus = 'Shipped'
                    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                    and O.sOrderType <> 'Internal'   -- USUALLY filtered
                GROUP BY ixCustomer) FO on FO.ixCustomer = O.ixCustomer AND O.ixOrderDate = FO.ixFirstOrderDate -- AND O.mMerchandise > 0-- merch > 0 is needed to avoid pulling in zero-shipped CRAP

WHERE   O.dtOrderDate between @StartDate AND @EndDate 
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'  
    and O.mMerchandise > 0   
   -- and (SKUP.ixOrder is NOT NULL OR SHP.ixOrder is NOT NULL)
GROUP BY PL.ixPromoId,   
    PO.ixPromotionOffer,
    PL.PromoDescription, 
    PL.dtStartDate, 
    PL.dtEndDate,
    TP.sPromoCode,
    isnull(TPM.TotMerchDiscount,0), 
    isnull(TPS.TotShippingDiscount,0), 
    isnull(TPS.TotPrePromoSHCharge,0), 
    isnull(TPS.TotPostPromoSHCharge,0)
ORDER BY PL.ixPromoId


select ixPromotionOffer from tng.tblpromotion_offer
where len(ixPromotionOffer) > 4