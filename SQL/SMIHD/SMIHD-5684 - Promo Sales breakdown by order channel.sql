-- SMIHD-5684 - Promo Sales breakdown by order channel
/*
DECLARE --@PromoId varchar(15),
       @StartDate datetime,
        @EndDate datetime

SELECT --@PromoId = '170',
      @StartDate = '10/09/2016',
       @EndDate = '10/17/2016'
*/
   
SELECT
  O.sOrderChannel,
  PL.ixPromoId, 
  PL.PromoDescription,
  sum(isnull(O.mMerchandise,0))                 as 'Sales', 
  count(distinct(SUBSTRING(O.ixOrder, 1, 7)))   as '#ofOrders', 
  'TBD' as 'AvgOrder',
  isnull(TPM.TotMerchDiscount,0)                as 'MerchDiscount',  
  isnull(TPS.TotShippingDiscount,0)             as 'SHDiscount',       
  sum(isnull(O.mMerchandiseCost,0))             as 'CoGS',  
  isnull(TPS.TotPrePromoSHCharge,0)             as 'TotPrePromoSHCharge',
  isnull(TPS.TotPostPromoSHCharge,0)            as 'TotPostPromoSHCharge', 
  'TBD' as 'EstFulfillmentCost', 
  'TBD' as 'CM$',
  'TBD' as 'CM%',
  'TBD' as '%NewBuyers',
   -- count(distinct(O.ixCustomer))                 as 'CountCustomers',
   (count(distinct(O.ixCustomer))- count(distinct(NewCust.ixCustomer)))  'ReturningCustomers',
   count(distinct(NewCust.ixCustomer))       as 'NewCustomers'
FROM -- Distinct List of the Promo IPromo List
     (select distinct ixPromoId, ixPromoCode, sDescription as 'PromoDescription'
      from tblPromoCodeMaster PCM
     -- where (ixPromoId is NOT NULL) -- !!remove after testing
      where ixPromoId in (1170, 1172, 1174, 1176) -- (1170, 1172, 1174, 1176) -- (@PromoId)   --/* !!add back in after testing
        and dtStartDate <= '10/17/2016' -- promo starts before date range ends
        and dtEndDate >='10/09/2016' --  @StartDate  -- promo ends after date range starts
      )PL
    left join tblOrderPromoCodeXref OPCXREF on PL.ixPromoId = OPCXREF.ixPromoId and PL.ixPromoCode = OPCXREF.ixPromoCode
    /*SubQuery to calc the TOTAL PROMO MERCH discount */
      left join (SELECT O.sOrderChannel, SP.ixPromoId as ixPromoId,
                   sum(case when SP.flgAddedToCart=1 then SP.mExtendedCost else SP.mExtendedPrePromoPrice end)-sum(SP.mExtendedPostPromoPrice) as 'TotMerchDiscount' --
                FROM tblSKUPromo SP 
                    left join tblOrder O on O.ixOrder = SP.ixOrder 
                WHERE O.dtOrderDate between '10/09/2016' and '10/17/2016' --  @StartDate and @EndDate    -- !!add back in after testing              
                     and O.sOrderStatus = 'Shipped'
                 --  and (SP.ixPromoId is NOT NULL)  -- !!remove after testing
                     and SP.ixPromoId in (1170, 1172, 1174, 1176) -- (1170, 1172, 1174, 1176) -- !!add back in after testing
                 GROUP BY O.sOrderChannel, SP.ixPromoId
                 ) TPM on TPM.ixPromoId = PL.ixPromoId
    /*SubQuery to calc the TOTAL PROMO SHIPPING discount */
      left join (SELECT O.sOrderChannel, SP.ixPromoId as ixPromoId,
                    sum(isnull(SP.mPrePromoShippingCharge,0)-(isnull(SP.mPostPromoShippingCharge,0)) )  as 'TotShippingDiscount',
                    sum(isnull(SP.mPrePromoShippingCharge,0)) as 'TotPrePromoSHCharge',
                    sum(isnull(SP.mPostPromoShippingCharge,0)) as 'TotPostPromoSHCharge'
                 FROM tblShippingPromo SP 
                    left join tblOrder O on O.ixOrder = SP.ixOrder 
                 WHERE O.dtOrderDate between '10/09/2016' and '10/17/2016' --  @StartDate and @EndDate    -- !!add back in after testing                     
                     and O.sOrderStatus = 'Shipped'
               --    and (SP.ixPromoId is NOT NULL) -- !!remove after testing
                     and SP.ixPromoId in (1170, 1172, 1174, 1176) -- (1170, 1172, 1174, 1176)  -- !!add back in after testing
                 GROUP BY O.sOrderChannel, SP.ixPromoId
                 ) TPS on TPS.ixPromoId = PL.ixPromoId
    left join tblOrder O on O.ixOrder = OPCXREF.ixOrder and TPM.sOrderChannel = O.sOrderChannel 
    -- CHECK the new customer logic
    left join (select ixCustomer
               from vwNewCustOrder
               where  
                   vwNewCustOrder.dtOrderDate >='10/09/2016' --  @StartDate and vwNewCustOrder.dtOrderDate <= @EndDate
               )NewCust on O.ixCustomer = NewCust.ixCustomer 
WHERE 
        O.dtOrderDate >='10/09/2016' --  @StartDate AND O.dtOrderDate <= @EndDate  -- !! add after testung
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
group by O.sOrderChannel, PL.ixPromoId,   PL.PromoDescription, isnull(TPM.TotMerchDiscount,0), isnull(TPS.TotShippingDiscount,0), isnull(TPS.TotPrePromoSHCharge,0), isnull(TPS.TotPostPromoSHCharge,0)
order by PL.ixPromoId
 
 
 
-- SELECT TOP 10 * FROM tblPromoCodeMaster 