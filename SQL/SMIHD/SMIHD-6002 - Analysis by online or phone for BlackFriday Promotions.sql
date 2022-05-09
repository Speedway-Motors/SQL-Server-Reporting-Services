-- SMIHD-6002 - Analysis by online or phone for BlackFriday Promotions

-- NEW 

DECLARE       @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '11/20/2016',   @EndDate = '11/28/2016'
       
SELECT
  O.dtOrderDate,
  (CASE when O.sOrderChannel = 'WEB' THEN 'WEB'
   ELSE 'NON-WEB'
   END) 'AdjChannel',
  PL.ixPromoId, 
  PL.PromoDescription,
  sum(isnull(O.mMerchandise,0))                 as 'MerchTotal', 
  sum(isnull(O.mMerchandiseCost,0))             as 'MerchCost',
--  isnull(TPM.TotMerchDiscount,0)                as 'TotMerchDiscount',  
  isnull(TPS.TotShippingDiscount,0)             as 'TotSHDiscount',     
  isnull(TPS.TotPrePromoSHCharge,0)             as 'TotPrePromoSHCharge',
--  isnull(TPS.TotPostPromoSHCharge,0)            as 'TotPostPromoSHCharge',  
  count(distinct(SUBSTRING(O.ixOrder, 1, 7)))   as 'CountOrders',
  count(distinct(O.ixCustomer))                 as 'CountCustomers',
  count(distinct(NewCust.ixCustomer))           as 'CountNewCustomers'
FROM -- Distinct List of the Promo IPromo List
     (select distinct ixPromoId, ixPromoCode, sDescription as 'PromoDescription'
      from tblPromoCodeMaster
     -- where (ixPromoId is NOT NULL) -- !!remove after testing
      where ixPromoId in ('1204', '1205', '1206') --(@PromoId)   --/* !!add back in after testing
        and dtStartDate <= @EndDate -- promo starts before date range ends
        and dtEndDate >= @StartDate  -- promo ends after date range starts
      )PL
    left join tblOrderPromoCodeXref OPCXREF on PL.ixPromoId = OPCXREF.ixPromoId and PL.ixPromoCode = OPCXREF.ixPromoCode
    left join tblOrder O on O.ixOrder = OPCXREF.ixOrder 
    /*SubQuery to calc the TOTAL PROMO MERCH discount */
      left join (SELECT O.dtOrderDate, SP.ixPromoId as ixPromoId,
                   (CASE when O.sOrderChannel = 'WEB' THEN 'WEB'
                   ELSE 'NON-WEB'
                   END) 'AdjChannel',
                   sum(case when SP.flgAddedToCart=1 then SP.mExtendedCost else SP.mExtendedPrePromoPrice end)-sum(SP.mExtendedPostPromoPrice) as 'TotMerchDiscount' --
                FROM tblSKUPromo SP 
                    left join tblOrder O on O.ixOrder = SP.ixOrder 
                WHERE O.dtOrderDate between @StartDate and @EndDate    -- !!add back in after testing              
                     and O.sOrderStatus = 'Shipped'
                 --  and (SP.ixPromoId is NOT NULL)  -- !!remove after testing
                     and SP.ixPromoId in ('1204', '1205', '1206')  -- !!add back in after testing
                 GROUP BY O.dtOrderDate, SP.ixPromoId,
                 (CASE when O.sOrderChannel = 'WEB' THEN 'WEB'
                    ELSE 'NON-WEB'
                    END) 
                 ) TPM on TPM.ixPromoId = PL.ixPromoId 
                          and TPM.dtOrderDate = O.dtOrderDate
                          and TPM.AdjChannel = (CASE when O.sOrderChannel = 'WEB' THEN 'WEB'
                                               ELSE 'NON-WEB'
                                               END) 
    /*SubQuery to calc the TOTAL PROMO SHIPPING discount */
      left join (SELECT O.dtOrderDate, SP.ixPromoId as ixPromoId,
                       (CASE when O.sOrderChannel = 'WEB' THEN 'WEB'
                    ELSE 'NON-WEB'
                    END) 'AdjChannel',
                    sum(isnull(SP.mPrePromoShippingCharge,0)-(isnull(SP.mPostPromoShippingCharge,0)) )  as 'TotShippingDiscount',
                    sum(isnull(SP.mPrePromoShippingCharge,0)) as 'TotPrePromoSHCharge',
                    sum(isnull(SP.mPostPromoShippingCharge,0)) as 'TotPostPromoSHCharge'
                 FROM tblShippingPromo SP 
                    left join tblOrder O on O.ixOrder = SP.ixOrder 
                 WHERE O.dtOrderDate between @StartDate and @EndDate    -- !!add back in after testing                     
                     and O.sOrderStatus = 'Shipped'
               --    and (SP.ixPromoId is NOT NULL) -- !!remove after testing
                     and SP.ixPromoId in ('1204', '1205', '1206')  -- !!add back in after testing
                 GROUP BY O.dtOrderDate, SP.ixPromoId,
                               (CASE when O.sOrderChannel = 'WEB' THEN 'WEB'
                                ELSE 'NON-WEB'
                                END) 
                 ) TPS on TPS.ixPromoId = PL.ixPromoId
                    and TPS.dtOrderDate = O.dtOrderDate
                    and TPS.AdjChannel = (CASE when O.sOrderChannel = 'WEB' THEN 'WEB'
                                           ELSE 'NON-WEB'
                                           END) 

    -- CHECK the new customer logic
    left join (select ixCustomer
               from vwNewCustOrder
               where  
                   vwNewCustOrder.dtOrderDate >= @StartDate and vwNewCustOrder.dtOrderDate <= @EndDate
               )NewCust on O.ixCustomer = NewCust.ixCustomer 
WHERE 
        O.dtOrderDate >= @StartDate AND O.dtOrderDate <= @EndDate  -- !! add after testung
    and O.sOrderStatus in ('Shipped','Open')
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
  --  and O.sOrderChannel = 'WEB'
group by O.dtOrderDate, 
    PL.ixPromoId,   
    PL.PromoDescription
    , (CASE when O.sOrderChannel = 'WEB' THEN 'WEB'
       ELSE 'NON-WEB'
       END)
           
   ,isnull(TPM.TotMerchDiscount,0), isnull(TPS.TotShippingDiscount,0), isnull(TPS.TotPrePromoSHCharge,0), isnull(TPS.TotPostPromoSHCharge,0)
order by PL.ixPromoId, O.dtOrderDate
     ,(CASE when O.sOrderChannel = 'WEB' THEN 'WEB'
         ELSE 'NON-WEB'
         END) desc
 


-- ORIGINAL
/*
DECLARE  @StartDate datetime,        @EndDate datetime
SELECT @StartDate = '11/20/2016',   @EndDate = '11/28/2016'
       
SELECT
  PL.ixPromoId, 
  PL.PromoDescription,
  sum(isnull(O.mMerchandise,0))                 as 'MerchTotal', 
  sum(isnull(O.mMerchandiseCost,0))             as 'MerchCost',
--  isnull(TPM.TotMerchDiscount,0)                as 'TotMerchDiscount',
  isnull(TPS.TotShippingDiscount,0)             as 'TotSHDiscount',     
  isnull(TPS.TotPrePromoSHCharge,0)             as 'TotPrePromoSHCharge',
 -- isnull(TPS.TotPostPromoSHCharge,0)            as 'TotPostPromoSHCharge',  
  count(distinct(SUBSTRING(O.ixOrder, 1, 7)))   as 'CountOrders',
  count(distinct(O.ixCustomer))                 as 'CountCustomers',
  count(distinct(NewCust.ixCustomer))           as 'CountNewCustomers'
FROM -- Distinct List of the Promo IPromo List
     (select distinct ixPromoId, ixPromoCode, sDescription as 'PromoDescription'
      from tblPromoCodeMaster
     -- where (ixPromoId is NOT NULL) -- !!remove after testing
      where ixPromoId in ('1204', '1205', '1206') --(@PromoId)   --/* !!add back in after testing
        and dtStartDate <= @EndDate -- promo starts before date range ends
        and dtEndDate >= @StartDate  -- promo ends after date range starts
      )PL
    left join tblOrderPromoCodeXref OPCXREF on PL.ixPromoId = OPCXREF.ixPromoId and PL.ixPromoCode = OPCXREF.ixPromoCode
    left join tblOrder O on O.ixOrder = OPCXREF.ixOrder 
    /*SubQuery to calc the TOTAL PROMO MERCH discount */
      left join (SELECT SP.ixPromoId as ixPromoId,
                   sum(case when SP.flgAddedToCart=1 then SP.mExtendedCost else SP.mExtendedPrePromoPrice end)-sum(SP.mExtendedPostPromoPrice) as 'TotMerchDiscount' --
                FROM tblSKUPromo SP 
                    left join tblOrder O on O.ixOrder = SP.ixOrder 
                WHERE O.dtOrderDate between @StartDate and @EndDate    -- !!add back in after testing              
                     and O.sOrderStatus = 'Shipped'
                     and SP.ixPromoId in ('1204', '1205', '1206')  -- !!add back in after testing
                 GROUP BY SP.ixPromoId
                 ) TPM on TPM.ixPromoId = PL.ixPromoId 
    /*SubQuery to calc the TOTAL PROMO SHIPPING discount */
      left join (SELECT SP.ixPromoId as ixPromoId,
                    sum(isnull(SP.mPrePromoShippingCharge,0)-(isnull(SP.mPostPromoShippingCharge,0)) )  as 'TotShippingDiscount',
                    sum(isnull(SP.mPrePromoShippingCharge,0)) as 'TotPrePromoSHCharge',
                    sum(isnull(SP.mPostPromoShippingCharge,0)) as 'TotPostPromoSHCharge'
                 FROM tblShippingPromo SP 
                    left join tblOrder O on O.ixOrder = SP.ixOrder 
                 WHERE O.dtOrderDate between @StartDate and @EndDate    -- !!add back in after testing                     
                     and O.sOrderStatus = 'Shipped'
                     and SP.ixPromoId in ('1204', '1205', '1206')  -- !!add back in after testing
                 GROUP BY SP.ixPromoId
                 ) TPS on TPS.ixPromoId = PL.ixPromoId
         -- CHECK the new customer logic
    left join (select ixCustomer
               from vwNewCustOrder
               where  
                   vwNewCustOrder.dtOrderDate >= @StartDate and vwNewCustOrder.dtOrderDate <= @EndDate
               )NewCust on O.ixCustomer = NewCust.ixCustomer 
WHERE   O.dtOrderDate >= @StartDate AND O.dtOrderDate <= @EndDate  -- !! add after testung
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
  --  and O.sOrderChannel in ('WEB')
group by PL.ixPromoId,   PL.PromoDescription, isnull(TPM.TotMerchDiscount,0), isnull(TPS.TotShippingDiscount,0), isnull(TPS.TotPrePromoSHCharge,0), isnull(TPS.TotPostPromoSHCharge,0)
order by PL.ixPromoId
*/ 
 
 
 
 
 
 

 /*
 select distinct sOrderChannel
 from tblOrder
 where dtOrderDate >= '11/01/2016'
 
WEB
AMAZON
AUCTION
 
E-MAIL
PHONE
INTERNAL
FAX
MAIL
COUNTER 
*/
*/