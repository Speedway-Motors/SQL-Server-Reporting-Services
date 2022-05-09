-- SMIHD-20092 - CARB data Pivot Table
/*
WHEN flgCARB = 0 THEN 'N'
            WHEN flgCARB = 1 THEN 'Y'
            WHEN flgCARB = 2 THEN 'Y w/EO'
            WHEN flgCARB = 3 THEN 'OEM'
            WHEN flgCARB = 4 THEN 'NS'
            WHEN flgCARB is NULL THEN 'Not Reviewed'
*/

-- CARB SKUs
SELECT ixSKU, flgCarb -- 82,944 SKUs but only 20,448 are active
INTO #CARBSKUs  -- DROP TABLE #CARBSKUs
FROM tblSKU
WHERE flgDeletedFromSOP = 0
    and flgCarb between 1 and 3
    -- and flgActive = 1    -- verify only ACTIVE SKUs


-- select * from tblBusinessUnit

SELECT (CASE WHEN CS.flgCARB = 1 THEN 'Y'
        WHEN CS.flgCARB = 2 THEN 'Y w/EO'
        WHEN CS.flgCARB = 3 THEN 'OEM'
        ELSE 'RUH ROH'
        END) 'CARB Type',
    BU.sBusinessUnit 'B. Unit'
    SUM(OL.iQuantity) AS 'CA 12Mo Qty Sold', 
    SUM(OL.mExtendedPrice) 'CA 12Mo Sales',
    SUM(OL.mExtendedCost) 'CA 12Mo CoGS',
    (SUM(OL.mExtendedPrice)-SUM(OL.mExtendedCost)) 'CA 12Mo GM$'
FROM tblOrderLine OL 
    left join tblOrder O on OL.ixOrder = O.ixOrder
    left join tblDate D on D.dtDate = OL.dtOrderDate 
    left join tblSKU S on CS.ixSKU = OL.ixSKU
        
    left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
WHERE  O.sShipToState = 'CA'
    and O.sOrderStatus = 'Shipped'
    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
    and OL.flgLineStatus IN ('Shipped','Dropshipped')
    and CS.flgCARB between 1 and 3
GROUP BY  BU.sBusinessUnit,
         (CASE WHEN CS.flgCARB = 1 THEN 'Y'
               WHEN CS.flgCARB = 2 THEN 'Y w/EO'
               WHEN CS.flgCARB = 3 THEN 'OEM'
            ELSE 'RUH ROH'
          END) --  $2,312,540   sales
ORDER BY (CASE WHEN CS.flgCARB = 1 THEN 'Y'
        WHEN CS.flgCARB = 2 THEN 'Y w/EO'
        WHEN CS.flgCARB = 3 THEN 'OEM'
        ELSE 'RUH ROH'
        END), BU.sBusinessUnit


-- rewrite without temp table
SELECT (CASE WHEN S.flgCARB = 1 THEN 'Y'
        WHEN S.flgCARB = 2 THEN 'Y w/EO'
        WHEN S.flgCARB = 3 THEN 'OEM'
        ELSE 'RUH ROH'
        END) 'CARB Type',
    BU.sBusinessUnit 'B. Unit',
    SUM(OL.iQuantity) AS 'CA 12Mo Qty Sold', 
    SUM(OL.mExtendedPrice) 'CA 12Mo Sales',
    SUM(OL.mExtendedCost) 'CA 12Mo CoGS',
    (SUM(OL.mExtendedPrice)-SUM(OL.mExtendedCost)) 'CA 12Mo GM$'
FROM tblOrderLine OL 
    left join tblOrder O on OL.ixOrder = O.ixOrder
    left join tblDate D on D.dtDate = OL.dtOrderDate 
    left join tblSKU S on S.ixSKU = OL.ixSKU
    left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
WHERE  O.sShipToState = 'CA'
    and O.sOrderStatus = 'Shipped'
    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
    and OL.flgLineStatus IN ('Shipped','Dropshipped')
    and S.flgCARB between 1 and 3
    and S.flgDeletedFromSOP = 0
GROUP BY  BU.sBusinessUnit,
         (CASE WHEN S.flgCARB = 1 THEN 'Y'
               WHEN S.flgCARB = 2 THEN 'Y w/EO'
               WHEN S.flgCARB = 3 THEN 'OEM'
            ELSE 'RUH ROH'
          END) --  $2,312,540   sales
ORDER BY (CASE WHEN S.flgCARB = 1 THEN 'Y'
        WHEN S.flgCARB = 2 THEN 'Y w/EO'
        WHEN S.flgCARB = 3 THEN 'OEM'
        ELSE 'RUH ROH'
        END), BU.sBusinessUnit


 SELECT O.ixBusinessUnit, OL.ixSKU,SUM(OL.iQuantity) AS 'QtySold12Mo', 
                        SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                    FROM tblOrderLine OL 
                        left join tblOrder O on OL.ixOrder = O.ixOrder
                        left join tblDate D on D.dtDate = OL.dtOrderDate 
                    WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                        and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                    GROUP BY O.ixBusinessUnit, OL.ixSKU
                        
                    ) SALES on SALES.ixSKU = CD.ixSKU  


 SELECT O.ixBusinessUnit,SUM(OL.iQuantity) AS 'QtySold12Mo', 
                        SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                    FROM tblOrderLine OL 
                        left join tblOrder O on OL.ixOrder = O.ixOrder
                        left join tblDate D on D.dtDate = OL.dtOrderDate 
                    WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                        and O.sShipToState = 'CA'
                        and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                    GROUP BY O.ixBusinessUnit
                    ) SALES on SALES.ixSKU = CD.ixSKU   -- $183m    16.1m CA





select distinct sOrderStatus 
from tblOrder 
where dtOrderDate >= '02/01/20' and ixBusinessUnit is NULL
and ixOrder Not LIKE 'Q%'
and ixOrder Not LIKE 'PC%'

