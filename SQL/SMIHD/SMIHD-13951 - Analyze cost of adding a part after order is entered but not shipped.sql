-- SMIHD-13951 - Analyze cost of adding a part after order is entered but not shipped

/*
Emily is looking to analyze what the cost is for those orders where parts are added on prior to shipping. 

FEB 2019 to present

I had previously sent screen shots to show examples of orders where this has come into play.
We would need to look at margin on the part being added, shipping cost of the part alone, shipping cost difference if it had been included in the original order (if possible).

Pat, we talked about this last week and I'm not sure I captured all the notes.

 2/1/19 - 5/31/19 = 18 weeks
 532 orders containing ADDPART SKU (avg = 30 orders/week)
 $4,340 estimated extra shipping
$12,998 GM of added items

 $24.40 Avg GM/Order
  $8.16 Avg est extra SH/Order
 ====== 
  $16.24 Avg est profit per package with ADD
*/

SELECT count(distinct ixOrder)
from tblOrderLine
where ixSKU = 'ADDPART'
and dtOrderDate >= '02/01/2019' and '05/31/2019' -- 559      2/1/19 - 5/31/19 = 18 weeks


SELECT count(distinct O.ixOrder) -- 509
from tblOrder O
where ixOrder in (select distinct ixOrder
                    from tblOrderLine
                    where ixSKU = 'ADDPART'
                    and dtOrderDate between '02/01/2019' and '05/31/2019'
                    )                   
and sOrderStatus = 'Shipped'
and mShipping = 0
and dtOrderDate between '02/01/2019' and '05/31/2019' 



-- TEMP table with applicable Orders
-- DROP table [SMITemp].dbo.PJC_SMIHD13951_ShippedOrdersWithADDPART
SELECT distinct O.ixOrder -- 507
into [SMITemp].dbo.PJC_SMIHD13951_ShippedOrdersWithADDPART
from tblOrder O
where ixOrder in (select distinct ixOrder
                    from tblOrderLine
                    where ixSKU = 'ADDPART'
                    and dtOrderDate between '02/01/2019' and '05/31/2019'
                    )                   
    and sOrderStatus = 'Shipped'
    and iShipMethod <> 1
    and mShipping = 0
    and dtOrderDate between '02/01/2019' and '05/31/2019' 

-- ADDON orders are being created separately 507 Orders have ADDON... for only 510 packages
SELECT distinct(sTrackingNumber) -- 510
from tblOrderLine OL
    join [SMITemp].dbo.PJC_SMIHD13951_ShippedOrdersWithADDPART WAP on OL.ixOrder = WAP.ixOrder


-- Output for spreadsheet
SELECT O.ixOrder,--mShipping,
     (mMerchandise+mShipping+mTax-mMerchandiseCost-mCredits-ISNULL(mPaymentProcessingFee,0)-ISNULL(mMarketplaceSellingFee,0)) 'Margin',
    SH.TotEstSHCost 'EstAdditionalSHCost', 
    ((mMerchandise+mShipping+mTax-mMerchandiseCost-mCredits-ISNULL(mPaymentProcessingFee,0)-ISNULL(mMarketplaceSellingFee,0)) - ISNULL(SH.TotEstSHCost,0)) 'AdjMargin',
    O.iShipMethod
FROM tblOrder O
    JOIN [SMITemp].dbo.PJC_SMIHD13951_ShippedOrdersWithADDPART WAP on O.ixOrder = WAP.ixOrder
    LEFT JOIN (select P.ixOrder, SUM(mSMIEstScaleShippingCost) TotEstSHCost
               from tblPackage P
                    JOIN [SMITemp].dbo.PJC_SMIHD13951_ShippedOrdersWithADDPART WAP on P.ixOrder = WAP.ixOrder
               WHERE P.flgCanceled = 0
               group by P.ixOrder) SH on O.ixOrder = SH.ixOrder
WHERE SH.TotEstSHCost is NOT NULL
order by 'AdjMargin'




SELECT * 
FROM tblPackage 
where ixShipDate >= 18629
and flgCanceled = 0
and mSMIEstScaleShippingCost is NULL



SELECT OL.ixOrder, OL.ixSKU, OL.iQuantity,  -- 1,492
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    OL.mExtendedPrice, OL.mExtendedCost, (OL.mExtendedPrice-OL.mExtendedCost) 'GM$',
    OL.flgLineStatus, OL.sTrackingNumber, 
    O.iShipMethod, 
    P.mSMIEstScaleShippingCost

FROM tblOrderLine OL
    left join [SMITemp].dbo.PJC_SMIHD13951_ShippedOrdersWithADDPART WAP on OL.ixOrder = WAP.ixOrder
    left join tblOrder O on OL.ixOrder = O.ixOrder
    left join tblSKU S on S.ixSKU = OL.ixSKU
    left join tblPackage P on P.ixOrder = O.ixOrder
                            and P.sTrackingNumber = OL.sTrackingNumber
where WAP.ixOrder is NOT NULL
   and OL.flgLineStatus = 'Shipped'
   and OL.ixSKU NOT in ('ADDPART') -- 960
   and OL.sTrackingNumber is NOT NULL
order by O.ixOrder, OL.sTrackingNumber --OL.mExtendedCost, OL.ixSKU --O.iShipMethod --OL.ixSKU --OL.flgLineStatus --ixOrder, iOrdinality






