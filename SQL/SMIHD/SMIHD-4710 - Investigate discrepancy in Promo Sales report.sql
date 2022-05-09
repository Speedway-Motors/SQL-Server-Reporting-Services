-- SMIHD-4710 - Investigate discrepancy in Promo Sales report

-- SQL from rdl file
SELECT DISTINCT O.ixOrder
/*
  PL.ixPromoId, 
  PL.PromoDescription,
  sum(isnull(O.mMerchandise,0))                 as 'MerchTotal', 
  sum(isnull(O.mMerchandiseCost,0))             as 'MerchCost',
  isnull(TPM.TotMerchDiscount,0)                as 'TotMerchDiscount',
  count(distinct(SUBSTRING(O.ixOrder, 1, 7)))   as 'CountOrders',
  count(O.ixOrder)   as 'CountOrders2',  
  count(OPCXREF.ixOrder)   as 'CountOrders3',    
  count(distinct(O.ixCustomer))                 as 'CountCustomers'
*/  
FROM -- Distinct List of the Promo IPromo List
     (select 
     distinct ixPromoId, ixPromoCode, sDescription as 'PromoDescription'
      from tblPromoCodeMaster
      where ixPromoId in ('846') -- (@PromoId)   --/* !!add back in after testing
        and dtStartDate <= '05/30/2016' -- promo starts before date range ends
        and dtEndDate >= '11/01/2015'  -- promo ends after date range starts
      )PL
    left join tblOrderPromoCodeXref OPCXREF on PL.ixPromoId = OPCXREF.ixPromoId and PL.ixPromoCode = OPCXREF.ixPromoCode
    
    /*SubQuery to calc the TOTAL PROMO MERCH discount */
      left join (SELECT SP.ixPromoId as ixPromoId, -- 12 distinct orders
                   sum(case when SP.flgAddedToCart=1 then SP.mExtendedCost else SP.mExtendedPrePromoPrice end)-sum(SP.mExtendedPostPromoPrice) as 'TotMerchDiscount', --
                   count(distinct O.ixOrder) TEMPOrdCnt -- 12
                FROM tblSKUPromo SP 
                    left join tblOrder O on O.ixOrder = SP.ixOrder 
                WHERE O.dtOrderDate between '11/01/2015' and '05/30/2016'    -- !!add back in after testing              
                     and O.sOrderStatus = 'Shipped'
                 --  and (SP.ixPromoId is NOT NULL)  -- !!remove after testing
                     and SP.ixPromoId in ('846') -- (@PromoId) -- !!add back in after testing
                 GROUP BY SP.ixPromoId
                 ) TPM on TPM.ixPromoId = PL.ixPromoId
    /*SubQuery to calc the TOTAL PROMO SHIPPING discount */
    
   left join tblOrder O on O.ixOrder = OPCXREF.ixOrder 
WHERE 
        O.dtOrderDate between '11/01/2015' and  '05/30/2016'  -- !! add after testung
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType = 'Internal'   -- verify if these should be filtered!
group by PL.ixPromoId,   PL.PromoDescription, isnull(TPM.TotMerchDiscount,0) --, isnull(TPS.TotShippingDiscount,0), isnull(TPS.TotPrePromoSHCharge,0), isnull(TPS.TotPostPromoSHCharge,0)
order by PL.ixPromoId
 
 
 
select distinct OPCXREF.ixOrder
FROM -- Distinct List of the Promo IPromo List
     (select 
     distinct ixPromoId, ixPromoCode, sDescription as 'PromoDescription'
      from tblPromoCodeMaster
      where ixPromoId in ('846') -- (@PromoId)   --/* !!add back in after testing
        and dtStartDate <= '05/30/2016' -- promo starts before date range ends
        and dtEndDate >= '11/01/2015'  -- promo ends after date range starts
      )PL
    join tblOrderPromoCodeXref OPCXREF on PL.ixPromoId = OPCXREF.ixPromoId and PL.ixPromoCode = OPCXREF.ixPromoCode
    
    /*SubQuery to calc the TOTAL PROMO MERCH discount */
      join (SELECT SP.ixPromoId as ixPromoId, -- 12 distinct orders
                   sum(case when SP.flgAddedToCart=1 then SP.mExtendedCost else SP.mExtendedPrePromoPrice end)-sum(SP.mExtendedPostPromoPrice) as 'TotMerchDiscount', --
                   count(distinct O.ixOrder) TEMPOrdCnt -- 12
                FROM tblSKUPromo SP 
                    left join tblOrder O on O.ixOrder = SP.ixOrder 
                WHERE O.dtOrderDate between '11/01/2015' and '05/30/2016'    -- !!add back in after testing              
                     and O.sOrderStatus = 'Shipped'
                 --  and (SP.ixPromoId is NOT NULL)  -- !!remove after testing
                     and SP.ixPromoId in ('846') -- (@PromoId) -- !!add back in after testing
                 GROUP BY SP.ixPromoId
                 ) TPM on TPM.ixPromoId = PL.ixPromoId
   join tblOrder O on O.ixOrder = OPCXREF.ixOrder      
WHERE 
        O.dtOrderDate between '11/01/2015' and  '05/30/2016'  -- !! add after testung
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!               
    
    


SELECT * FROM tblOrder where ixOrder = '6923543'    
select * from tblCustomer where ixCustomer = '124555'

select * from tblCustomerType


