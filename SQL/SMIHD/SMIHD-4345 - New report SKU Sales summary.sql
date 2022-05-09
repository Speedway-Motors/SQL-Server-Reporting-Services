-- SMIHD-4345 - New report SKU Sales summary

DECLARE
    @P1StartDate datetime,
    @P1EndDate datetime,
    @P2StartDate datetime,
    @P2EndDate datetime,    
    @MinSales money

SELECT
    @P1StartDate = '06/01/14',
    @P1EndDate = '06/30/14',
    @P1StartDate = '06/01/15',
    @P1EndDate = '06/30/15',    
    @MinSales = 250


SELECT ISNULL(P1.SKU, P2.SKU) 'SKU',
        S.sDescription 'Description',
        S.sSEMACategory 'SEMACat', 
        S.sSEMASubCategory 'SEMASub-Cat', 
        S.sSEMAPart 'SEMAPart'

FROM        
    (SELECT OL.ixSKU 'SKU', 
        --S.sDescription 'Description',
        --S.sSEMACategory 'SEMACat', 
        --S.sSEMASubCategory 'SEMASub-Cat', 
        --S.sSEMAPart 'SEMAPart', 
        SUM(OL.iQuantity) 'QtySold', 
        SUM(OL.mExtendedPrice) 'Sales', 
        SUM(OL.mExtendedCost) 'Cost', 
        (SUM(OL.mExtendedPrice)-SUM(OL.mExtendedCost)) 'GP',
        (( SUM(OL.mExtendedPrice)-SUM(OL.mExtendedCost)) / SUM(OL.mExtendedPrice)) 'GP%'
    FROM tblOrder O
        left join tblOrderLine OL on O.ixOrder = OL.ixOrder
        left join tblSKU S on OL.ixSKU = S.ixSKU
    WHERE     O.sOrderStatus = 'Shipped'
        and O.dtShippedDate between @P1StartDate and @P1EndDate -- '05/01/2012' and '05/31/2016' -- '04/01/2015' and '04/30/2015'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- USUALLY filtered
        and OL.flgKitComponent = 0
        and OL.flgLineStatus in ('Dropshipped','Shipped')
        and O.sOrderType = 'Retail'
        --and S.flgActive = 1
    GROUP BY  OL.ixSKU--, S.sDescription, S.sSEMACategory, S.sSEMASubCategory, S.sSEMAPart
    HAVING SUM(OL.mExtendedPrice) > 0
        AND SUM(OL.mExtendedPrice) > @MinSales
    --ORDER BY   (( SUM(OL.mExtendedPrice)-SUM(OL.mExtendedCost)) / SUM(OL.mExtendedPrice))   
    ) P1
FULL OUTER JOIN
    (SELECT OL.ixSKU 'SKU', 
       -- S.sDescription 'Description',
      --  S.sSEMACategory 'SEMACat', 
      --  S.sSEMASubCategory 'SEMASub-Cat', 
     --   S.sSEMAPart 'SEMAPart', 
        SUM(OL.iQuantity) 'QtySold', 
        SUM(OL.mExtendedPrice) 'Sales', 
        SUM(OL.mExtendedCost) 'Cost', 
        (SUM(OL.mExtendedPrice)-SUM(OL.mExtendedCost)) 'GP',
        (( SUM(OL.mExtendedPrice)-SUM(OL.mExtendedCost)) / SUM(OL.mExtendedPrice)) 'GP%'
    FROM tblOrder O
        left join tblOrderLine OL on O.ixOrder = OL.ixOrder
        left join tblSKU S on OL.ixSKU = S.ixSKU
    WHERE     O.sOrderStatus = 'Shipped'
        and O.dtShippedDate between @P2StartDate and @P2EndDate -- '05/01/2012' and '05/31/2016' -- '04/01/2015' and '04/30/2015'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- USUALLY filtered
        and OL.flgKitComponent = 0
        and OL.flgLineStatus in ('Dropshipped','Shipped')
        and O.sOrderType = 'Retail'
        --and S.flgActive = 1
    GROUP BY  OL.ixSKU--, S.sDescription, S.sSEMACategory, S.sSEMASubCategory, S.sSEMAPart
    HAVING SUM(OL.mExtendedPrice) > 0
        AND SUM(OL.mExtendedPrice) > @MinSales
    --ORDER BY   (( SUM(OL.mExtendedPrice)-SUM(OL.mExtendedCost)) / SUM(OL.mExtendedPrice))   
    ) P2 ON P1.SKU = P2.SKU
JOIN tblSKU S on S.ixSKU =   ISNULL(P1.SKU, P2.SKU)   
/*
SELECT SUM(mMerchandise)
from tblOrder O
where sOrderStatus = 'Shipped'
and dtShippedDate between '04/01/2016' and '04/30/2016'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
       and O.sOrderType = 'Retail'
      
*/
ORDER BY ISNULL(P1.SKU, P2.SKU)