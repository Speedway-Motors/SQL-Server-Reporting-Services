-- SMIHD-11170 -- Update Promo Code report to access new tiered promo data
select * from tng.tblpromotion -- the rollup value (in the UI this is the Promo Id).
select * from tng.tblpromotion_offer -- has the more detailed (in the UI this is the Reporting Promo Id).
  
--Because of the volume of the OTU codes those have not been pushed to the DW at this time.
tblpromotion.ixPromotion would be the rollup value (in the UI this is the Promo Id).
/*
Promo ID: 1561
Reporting Promo IDs: 1612, 1613, 1614
Promo vehicles: email, web, social, show handouts, counter
Promo details: $15 off $150 | $25 off $250 | $50 off $500
Promo code: THANKS
OTU Qty: n/a
Promo disclaimer: Enter promo code THANKS at checkout to receive discounts of $15 off $150, $25 off $250, or $50 off $500 in your prepaid, retail order. May not be combined with other offers. Offer valid 6/18/18-6/23/18.
*/

select * 
from tng.tblpromotion
where --sPromoCode = 'THANKS'
--ixPromotion in (1561)
ixPromotion in (1535)
--ixPromotion in (1606,1527,1534,1535)
   -- dtCreateUtc >= '06/01/2018'
order by dtCreateUtc desc
/*
ix
Promotion	sPromoCode	sPromoName
=========   ==========  ============================================
1565	    ONEXJAN19	One Time Buyer January $25 off $25 OTUs
1564	    ONEXDEC18	One Time Buyer December $25 off $25 OTUs
1563	    ONEXNOV18	One Time Buyer November $25 off $25 OTUs

                        One Time Buyer June $25 off $25 OTUs
1535	    ONEXJUN18	One Time Buyer June $25 off $25 OTUs
1534	    REQJUN18	Requestor June Send $25 off $25 OTUs
1527	    RACE417	    Race 417 Nurturers & Winbacks  $25 off $250
*/


select * from tng.tblpromotion_offer
where ixPromotion = 1561
ORDER by dtCreateUtc desc
/*
ixPromotion	ixPromotionOffer	iOrdinality
1565	    1618	            1
1564	    1617	            1
1563	    1616	            1
*/






/* Promo Sales.rdl
-- ver 17.34.1
*/
DECLARE @StartDate datetime,        @EndDate datetime,          @PromoId varchar(15)
SELECT  @StartDate = '06/11/2018',  @EndDate = '06/12/2018',    @PromoId = '1535'   -- 1412

SELECT
  PL.ixPromoId, 
  PL.PromoDescription,
  SUM(isnull(CPS.PrePromoMerchandise,0))        as 'PrePromoMerch',
  SUM(isnull(O.mMerchandise,0))                 as 'MerchTotal', 
  SUM(isnull(O.mMerchandiseCost,0))             as 'MerchCost',
  isnull(TPM.TotMerchDiscount,0)                as 'TotMerchDiscount',
  isnull(TPS.TotShippingDiscount,0)             as 'TotSHDiscount',     
  isnull(TPS.TotPrePromoSHCharge,0)             as 'TotPrePromoSHCharge',
  isnull(TPS.TotPostPromoSHCharge,0)            as 'TotPostPromoSHCharge',  
  COUNT(distinct(SUBSTRING(O.ixOrder, 1, 7)))   as 'CountOrders',
  COUNT(distinct(O.ixCustomer))                 as 'CountCustomers',
  SUM(case when FO.ixCustomer is NULL then 0
      else 1
      end) as 'CountNewCustomers'
FROM (-- Distinct List of Promo Ids
      SELECT distinct ixPromoId, 
        --ixPromoCode,  <-- this was causing a cartesian on a small # of PromoIDs e.g. PromoId 1410
         sDescription as 'PromoDescription'
      from tblPromoCodeMaster
      where ixPromoId in (@PromoId)
      )PL
    join tblOrderPromoCodeXref OPCXREF on PL.ixPromoId = OPCXREF.ixPromoId
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
    left join vwCustomerFirstOrderDate FO on FO.ixCustomer = O.ixCustomer AND O.ixOrderDate = FO.ixFirstOrderDate -- AND O.mMerchandise > 0-- merch > 0 is needed to avoid pulling in zero-shipped CRAP
WHERE   O.dtOrderDate between @StartDate AND @EndDate 
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'  
    and O.mMerchandise > 0     
GROUP BY PL.ixPromoId,   PL.PromoDescription, 
    isnull(TPM.TotMerchDiscount,0), 
    isnull(TPS.TotShippingDiscount,0), 
    isnull(TPS.TotPrePromoSHCharge,0), 
    isnull(TPS.TotPostPromoSHCharge,0)
ORDER BY PL.ixPromoId






-- EXAMPLE - pulling data from DW that come from multiple DBs
SELECT TOP 10 *
FROM tblOrder O
    inner join tng.tblorder tngo on O.ixOrder = tngo.ixSopWebOrderNumber COLLATE SQL_Latin1_General_CP1_CI_AS






-- REWRITE OF CORE QUERY FROM Promo Sales.rdl

DECLARE @StartDate datetime,        @EndDate datetime,          @PromoId varchar(15)
SELECT  @StartDate = '06/18/2018',  @EndDate = '06/19/2018',    @PromoId = '1561'   -- '1561' 175+ orders
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
      from tblPromoCodeMaster
      where ixPromoId in (@PromoId)
      )PL
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
--                      pulls from vwOrderLinePromoSummary & vwOrderShippingPromoSummary
--                                 (tblSKUPromo & tblOrder)  (tblShippingPromo & tblOrder)
    left join tblSKUPromo SKUP on SKUP.ixOrder = O.ixOrder
    left join tblShippingPromo SHP on SHP.ixOrder = O.ixOrder
    left join (-- First Order
                select ixCustomer, MIN(ixOrderDate) ixFirstOrderDate, MIN(dtOrderDate) dtFirstOrderDate, COUNT(O.ixOrder) OrderCnt
                from tblOrder O
                where O.sOrderStatus = 'Shipped'
                    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                    and O.sOrderType <> 'Internal'   -- USUALLY filtered
                GROUP BY ixCustomer) FO on FO.ixCustomer = O.ixCustomer AND O.ixOrderDate = FO.ixFirstOrderDate -- AND O.mMerchandise > 0-- merch > 0 is needed to avoid pulling in zero-shipped CRAP
    left join tng.tblpromotion TP on TP.ixPromotion = PL.ixPromoId-- the rollup value (in the UI this is the Promo Id).
    left join tng.tblpromotion_offer PO on PO.ixPromotion = TP.ixPromotion
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


SELECT TOP 10 * FROM tng.tblpromotion WHERE ixPromotion = '1561'
SELECT TOP 10 * FROM tng.tblpromotion_offer WHERE ixPromotionOffer = '1535'
SELECT TOP 10 * FROM tng.tblpromotion WHERE ixPromo = '1535'




SELECT TP.ixPromotion, PO.ixPromotionOffer
FROM tng.tblpromotion TP --on TP.ixPromotion = PL.ixPromoId-- the rollup value (in the UI this is the Promo Id).
    left join tng.tblpromotion_offer PO on PO.ixPromotion = TP.ixPromotion
WHERE PO.ixPromotion = '1561'
/*
ixPromotion	ixPromotionOffer
1561	    1612
1561	    1613
1561	    1614 
*/

