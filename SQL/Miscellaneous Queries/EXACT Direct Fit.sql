-- EXACT Direct Fit
select svb.ixVehicleBase, 
        count(*) as 'EDFSkuCount', 
        SUM(SALES12Mo.Sales12Mo) 'Sales12Mo',
        SUM(SALES12Mo.QtySold12Mo) 'QtySold12Mo',
        SUM(SALES24Mo.Sales24Mo) 'Sales24Mo', -- 13-24Mo
        SUM(SALES24Mo.QtySold24Mo) 'QtySold24Mo' -- 13-24Mo
from tng.tblskuvariant_vehicle_base svb
    inner join tng.tblskuvariant s on s.ixSkuVariant = svb.ixSkuVariant
    -- driveline families
    left join tng.tblskuvariant_vehicle_base_rearaxle_xref svbrx on svbrx.ixSkuVariantVehicleBase = svb.ixSkuVariantVehicleBase
    left join tng.tblskuvariant_vehicle_base_enginesub_xref svbex on svbex.ixSkuVariantVehicleBase = svb.ixSkuVariantVehicleBase
    left join tng.tblskuvariant_vehicle_base_transmission_xref svbtx on svbtx.ixSkuVariantVehicleBase = svb.ixSkuVariantVehicleBase
    inner join #SalableSKUs ss ON ss.ixSOPSKU = s.ixSOPSKU
    LEFT JOIN -- 12 Mo SALES & QTY SOLD
            (SELECT OL.ixSKU,
                SUM(OL.iQuantity) AS 'QtySold12Mo', 
                SUM(OL.mExtendedPrice) 'Sales12Mo'
            FROM tblOrderLine OL 
                left join tblDate D on D.dtDate = OL.dtOrderDate 
                inner join #SalableSKUs ss ON ss.ixSOPSKU = OL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
            WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
            GROUP BY OL.ixSKU
            ) SALES12Mo ON SALES12Mo.ixSKU = s.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN -- 13-24 Mo SALES & QTY SOLD
            (SELECT OL.ixSKU,
                SUM(OL.iQuantity) AS 'QtySold24Mo', -- 13-24Mo
                SUM(OL.mExtendedPrice) 'Sales24Mo' -- 13-24Mo
            FROM tblOrderLine OL 
                left join tblDate D on D.dtDate = OL.dtOrderDate 
                inner join #SalableSKUs ss ON ss.ixSOPSKU = OL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
            WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                and D.dtDate between DATEADD(yy, -2, getdate()) and DATEADD(yy, -1, getdate()) -- 13-24 Mo AGO
            GROUP BY OL.ixSKU
            ) SALES24Mo ON SALES24Mo.ixSKU = s.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    where s.ixSkuBase not in (select ixSkuBase from tng.tblskubase_universal_market bum)
        and coalesce(svb.flgInclude,1) <> 0
        and svbrx.ixSkuVariantVehicleBase is null
        and svbex.ixSkuVariantVehicleBase is null
        and svbtx.ixSkuVariantVehicleBase is null
        --and svb.ixVehicleBase = 15830 -- TESTING
    group by svb.ixVehicleBase


-- get counts of driveline family
select svb.ixVehicleBase, count(*)
--        count(distinct svb.ixVehicleBase) 
from tng.tblskuvariant_vehicle_base svb
    inner join tng.tblskuvariant s on s.ixSkuVariant = svb.ixSkuVariant
    -- driveline families
    left join tng.tblskuvariant_vehicle_base_rearaxle_xref svbrx on svbrx.ixSkuVariantVehicleBase = svb.ixSkuVariantVehicleBase
    left join tng.tblskuvariant_vehicle_base_enginesub_xref svbex on svbex.ixSkuVariantVehicleBase = svb.ixSkuVariantVehicleBase
    left join tng.tblskuvariant_vehicle_base_transmission_xref svbtx on svbtx.ixSkuVariantVehicleBase = svb.ixSkuVariantVehicleBase
    inner join #SalableSKUs ss ON ss.ixSOPSKU = s.ixSOPSKU
    where s.ixSkuBase not in (select ixSkuBase from tng.tblskubase_universal_market bum)
        and Coalesce(svb.flgInclude,1) <> 0
        and svbrx.ixSkuVariantVehicleBase is NOT null -- 0 rearaxle
      --  and svbex.ixSkuVariantVehicleBase is NOT null -- 33 enginesub
       -- and svbtx.ixSkuVariantVehicleBase is NOT null -- 2 transmission
          and svb.ixVehicleBase = 1236  -- 1968 Chevy Camaro 
    group by svb.ixVehicleBase

    -- TESTING ixVehicleBase 1236 = 2001 Qvale Mangusta
    -- TESTING ixVehicleBase 14021 = 1968 Chevy Camaro 


    -- SALEABLE SKUS
SELECT DISTINCT t.ixSOPSKU AS 'ixSOPSKU', t.ixSKUVariant, t1.ixSOPSKUBase 'SOPSKUBase', t.ixSKUBase 'SKUBase'  -- 168,191 SKUs
INTO #SalableSKUs
FROM tng.tblskuvariant t
    INNER JOIN tng.tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
    INNER JOIN tng.tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
    INNER JOIN tng.tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
WHERE t.ixSOPSKU is NOT NULL
    AND t.flgPublish = 1
    AND t1.flgWebPublish = 1
    AND t3.flgActive = 1
    AND(t.iTotalQAV > 0 
        OR t.flgBackorderable = 1)