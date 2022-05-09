-- Case 18271 - Rebuild Promo Code Sales Report
SELECT
  PL.ixPromoId, 
  sum(isnull(O.mMerchandise,0))                 as 'Sales', 
  sum(isnull(O.mMerchandiseCost,0))             as 'MerchCost',
  isnull(TPM.TotMerchDiscount,0)                as 'TotMerchDiscount',
  isnull(TPS.TotShippingDiscount,0)             as 'TotSHDiscount',      
  count(distinct(SUBSTRING(O.ixOrder, 1, 7)))   as 'CountOrders',
  count(distinct(O.ixCustomer))                 as 'CountCustomers',
      count(distinct(NewCust.ixCustomer))       as 'CountNewCustomers'
FROM -- Distinct List of the Promo IPromo List
     (select distinct ixPromoId
      from tblPromoCodeMaster
  --    where (ixPromoId BETWEEN '147' AND '150' OR ixPromoId BETWEEN '172' AND '175') -- !!remove after testing
      --/* !!add back in after testing
      where ixPromoId in (@PromoId) and
      ((@StartDate >= dtStartDate OR
        @EndDate >= dtStartDate)
      and @StartDate <= dtEndDate)
     -- */
      )PL
    left join tblOrderPromoCodeXref OPCXREF on PL.ixPromoId = OPCXREF.ixPromoId
    /*SubQuery to calc the TOTAL PROMO MERCH discount */
      left join (SELECT SP.ixPromoId as ixPromoId,
              --      sum(isnull(SP.mExtendedPrePromoPrice,0)-(isnull(SP.mExtendedPostPromoPrice,0)) )  as 'TotMerchDiscount' -- !!remove after testing
                   sum(case when SP.flgAddedToCart=1 then SP.mExtendedCost else SP.mExtendedPrePromoPrice end)-sum(SP.mExtendedPostPromoPrice) as 'TotMerchDiscount' --
                FROM tblSKUPromo SP 
                    left join tblOrderPromoCodeXref OPCXREF on OPCXREF.ixOrder = SP.ixOrder
                    left join tblOrder O on O.ixOrder = OPCXREF.ixOrder 
                WHERE O.dtOrderDate between @StartDate and @EndDate    -- !!add back in after testing              
               -- WHERE O.dtOrderDate between '01/19/2013' and '04/19/2013'-- !!remove after testing
                     and O.sOrderStatus = 'Shipped'
                     and O.mMerchandise > 0
               --    and (OPCXREF.ixPromoId BETWEEN '147' AND '150' OR OPCXREF.ixPromoId BETWEEN '172' AND '175') -- !!remove after testing
                  -- /* !!add back in after testing
                     and SP.ixPromoId in (@PromoId) 
                     -- and ((@StartDate >= dtStartDate 
                     --       OR
                     --       @EndDate >= dtStartDate) 
                     -- and @StartDate <= dtEndDate)
                  -- */
                 GROUP BY SP.ixPromoId
                 ) TPM on TPM.ixPromoId = PL.ixPromoId
    /*SubQuery to calc the TOTAL PROMO SHIPPING discount */
      left join (SELECT SP.ixPromoId as ixPromoId,
                    sum(isnull(SP.mPrePromoShippingCharge,0)-(isnull(SP.mPostPromoShippingCharge,0)) )  as 'TotShippingDiscount'
                FROM tblShippingPromo SP 
                    left join tblOrderPromoCodeXref OPCXREF on OPCXREF.ixOrder = SP.ixOrder
                    left join tblOrder O on O.ixOrder = OPCXREF.ixOrder 
                WHERE O.dtOrderDate between @StartDate and @EndDate    -- !!add back in after testing                     
               -- WHERE O.dtOrderDate between '01/19/2013' and '04/19/2013'-- !!remove after testing
                     and O.sOrderStatus = 'Shipped'
                     and O.mMerchandise > 0
               --      and (SP.ixPromoId BETWEEN '147' AND '150' OR SP.ixPromoId BETWEEN '172' AND '175') -- !!remove after testing
               -- /* !!add back in after testing
                     and SP.ixPromoId in (@PromoId)
                     -- and ((@StartDate >= dtStartDate 
                     --       OR
                     --       @EndDate >= dtStartDate) 
                     -- and @StartDate <= dtEndDate)
                  -- */
                 GROUP BY SP.ixPromoId
                 ) TPS on TPS.ixPromoId = PL.ixPromoId
    left join tblOrder O on O.ixOrder = OPCXREF.ixOrder 
    -- CHECK the new customer logic
    left join (select ixCustomer
               from vwNewCustOrder
               where  
               vwNewCustOrder.dtOrderDate >= @StartDate and vwNewCustOrder.dtOrderDate <= @EndDate -- !! add after testung
             --  vwNewCustOrder.dtOrderDate between '01/19/2013' and '04/19/2013' -- !!remove after testing
               )NewCust on O.ixCustomer = NewCust.ixCustomer 
WHERE O.dtOrderDate >= @StartDate AND O.dtOrderDate <= @EndDate  -- !! add after testung
     -- O.dtOrderDate between '01/19/2013' and '04/19/2013'-- !!remove after testing
     and O.sOrderStatus = 'Shipped'
     and O.mMerchandise > 0
     and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
     and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!     
group by PL.ixPromoId, isnull(TPM.TotMerchDiscount,0), isnull(TPS.TotShippingDiscount,0)  
order by PL.ixPromoId


select dtOrderDate from vwNewCustOrder
select dtOrderDate from tblOrder

/*
Promo   Merch 	    Merch   	TotMerch    TotSH            #       	#       	# New
Id	    Total	    Cost	    Discount    Discount	    Orders      Customers	Customers
147	    130700.03	67620.01	   0.00	    3843707.10	    345	        310	        107
148	     11847.13	 6001.638	 819.97	          0.00	    82	        75	        32
149	     15375.21	 8992.204	1260.36	          0.00	    51	        48	        22
150	      5346.72	 2553.771	 200.00	          0.00	    4	        4	        3
172	      5832.74	 2497.749	   0.00	       4258.08	    8	        8	        4
173	       423.81	  207.036	  20.00	          0.00	    2	        2	        0
174	       334.98	  149.006	  25.00	          0.00	    1	        1	        0
175	     42366.08	25166.584	2477.87	      19713.00	    50	        47	        25
*/


-- manual check to verify total merch in query above
select sum(O.mMerchandise)
from tblOrder O     
join tblOrderPromoCodeXref OPX on O.ixOrder = OPX.ixOrder
where (OPX.ixPromoId BETWEEN '147' AND '150' OR OPX.ixPromoId BETWEEN '172' AND '175')
     and      O.dtOrderDate between '01/19/2013' and '04/19/2013'
     and O.sOrderStatus = 'Shipped'
     and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
     and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
     
select PCM.ixPromoId              as 'Promo ID',
    PCM.ixPromoCode               as 'Promo Code',
    PCM.sDescription              as 'Description',
    (Case PCM.flgSiteWide = 1 then 'Y'
     else NULL
     end)                         as 'SiteWide',


select * from tblPromoCodeMaster where ixPromoId = '175'
select * from vwOrderCombinedPromoSummary  where ixPromoId = '175'
select * from tblOrderPromoCodeXref where ixPromoId = '175'
select * from tblOrderPromoCodeXref where ixPromoId = '205'
select * from tblPromoCodeMaster where ixPromoId = '205'
select * from tblShippingPromo  where ixPromoId = '205'
/*
ixOrder	ixPromoId	dtDateLastSOPUpdate	    ixTimeLastSOPUpdate
5630703	205	        2013-04-08 00:00:00.000	60524
*/

select * from tblOrder where ixOrder = '5630703'




select top 10 * from tblSKUPromo where ixPromoId = '175'
select top 10 * from tblShippingPromo where ixPromoId = '175'

select * from tblSKUPromo SKUP
join tblShippingPromo SHP on SKUP.ixPromoId = SHP.ixPromoId

select * from tblShippingPromo

SELECT name 
FROM sysobjects 
WHERE id IN ( SELECT id FROM syscolumns WHERE name = 'ixPromoId')
ORDER BY name

tblShippingPromo.ixPromoId
tblSKUPromo.ixPromoId
tblOrderPromoCodeXref.ixPromoId
tblPromoCodeMaster.ixPromoId

SELECT name 
FROM sysobjects 
WHERE id IN ( SELECT id FROM syscolumns WHERE name = 'ixPromoId')
ORDER BY name


/* per PRG add 
    Promo Discounts column, 
    Actual Shipping column,
    Published Shipping Column 
    right after Revenue/Sales column). 
*/

-- NOW NEED TO ADD the SUM of fields from vwOrderCombinedPromoSummary
-- altered view to include sMatchbackSourceCode

select top 10 * from vwOrderCombinedPromoSummary 

select O.ixOrder, ixPromoId, 
    sum(isNULL(TotalMerchandiseDiscount,0)) TotalMerchandiseDiscount,
    sum(isNULL(TotalShippingDiscount,0)) TotalShippingDiscount
   -- ""
   -- ""
from  tblOrderPromoCodeXref OPX
    join vwOrderCombinedPromoSummary COMBO on OPX.ixOrder = COMBO.ixOrder
    join tblOrder O on COMBO.ixOrder = O.ixOrder
where ixPromoId in ('175') -- remove after testing   
    and dtOrderDate between '01/19/2013' and '04/19/2013'
group by O.ixOrder, ixPromoId

   
select * from tblOrderPromoCodeXref
where ixOrder in ('5528208','5583104')

select * from vwOrderCombinedPromoSummary 
where ixOrder in ('5528208')

select * from tblOrder
where ixOrder in ('5528208')


(select ixPromoId, COUNT(*) from tblPromoCodeMaster
                   group by ixPromoId
                    having COUNT(*) > 1)
                    
                    
                    
                    select * from tblSKUPromo where ixPromoId in ('115','137','138','139','151','152','156','169','170','204','205')
                    
                    
select * from                     
tblPromoCodeMaster   

select distinct ixPromoId, sDescription
from   tblPromoCodeMaster




               