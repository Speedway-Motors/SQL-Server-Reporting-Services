-- SMIHD-19092 - YMM Part Types Sorted by Revenue

--      see also  SMIHD-15482 - NEW REPORT - Sales Summary by YMM


-- base code from SMIHD-15482 - NEW REPORT - Sales Summary by YMM


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



SELECT vy.ixVehicleYear         -- UF Universal Fit    DF = Direct Fit     EDF = Exact Direct Fit
    , vm.sVehicleMakeName
    , vmod.sVehicleModelName
    , vtype.sVehicleModelTypeName
    , vb.ixVehicleBase
    , m.sMarketName
    , ISNULL(DF.SkuCount,0) 'DFSkuCount'
    , ISNULL(CategoryCount.CategoryCount,0) 'DFCategoryCount'
    , ISNULL(CategoryCount.CategoryPartCount,0) 'DFPartTypeCount'
    , ISNULL(DF.QtySold12Mo,0) 'DFUnitsSold12Mo'
    , ISNULL(DF.Sales12Mo,0) 'DFSales12Mo'
FROM tng.tblvehicle_base vb
    inner join tng.tblvehicle_year vy on vy.ixVehicleYear = vb.ixVehicleYear
    inner join tng.tblvehicle_make vm on vm.ixVehicleMake = vb.ixVehicleMake
    inner join tng.tblvehicle_model vmod on vb.ixVehicleModel = vmod.ixVehicleModel
    inner join tng.tblvehicle_model_type vtype on vtype.ixVehicleModelType = vmod.ixVehicleModelType
    left join tng.tblvehicle_base_market_xref vbm on vb.ixVehicleBase = vbm.ixVehicleBase
    left join tng.tblmarket m on m.ixMarket = vbm.ixMarket
    left join (-- Direct Fit SKU count & 12 Month Sales
               select svb.ixVehicleBase, 
                        count(*) as 'SkuCount', 
                        SUM(SALES12Mo.Sales12Mo) 'Sales12Mo',
                        SUM(SALES12Mo.QtySold12Mo) 'QtySold12Mo'
                from tng.tblskuvariant_vehicle_base svb
                    inner join tng.tblskuvariant s on s.ixSkuVariant = svb.ixSkuVariant
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
                    where s.ixSkuBase not in (select ixSkuBase from tng.tblskubase_universal_market bum)
                       and coalesce(svb.flgInclude,1) <> 0
                        --and svb.ixVehicleBase = 15830 -- TESTING
                    group by svb.ixVehicleBase
                ) DF on DF.ixVehicleBase = vb.ixVehicleBase
/*
select count(distinct ss.ixSkuVariant) as SkuItCanFit
from #SalableSKUs  ss
    inner join tng.tblskuvariant_vehicle_base svb on svb.ixSkuVariant = ss.ixSkuVariant
    inner join tng.tblskuvariant s on s.ixSkuVariant = svb.ixSkuVariant
    left join  tng.tblvehicle_base vb on svb.ixVehicleBase = vb.ixVehicleBase
where coalesce(svb.flgInclude,1) <> 0
 AND s.ixSkuBase not in (select ixSkuBase from tng.tblskubase_universal_market bum)
*/
    left join(select svb.ixVehicleBase, 
                    count(distinct c.ixCategorizationCategory ) as 'CategoryCount', 
                    count(distinct c.ixCategorizationPart ) as 'CategoryPartCount'
              from tng.tblskuvariant_vehicle_base svb
                inner join tng.tblskuvariant s on s.ixSkuVariant = svb.ixSkuVariant
                inner join tng.tblskubase b on s.ixSkubase = b.ixSkubase
                inner join tng.tblcategorization_part cp on b.ixCategorizationPart = cp.ixCategorizationPart
                inner join tng.tblCategorization c on c.ixCategorizationPart = cp.ixCategorizationpart
                inner join #SalableSKUs ss ON ss.ixSOPSKU = s.ixSOPSKU
              where s.ixSkuBase not in
                                (select ixSkuBase from tng.tblskubase_universal_market bum) 
              group by svb.ixVehicleBase
              ) CategoryCount on  CategoryCount.ixVehicleBase = vb.ixVehicleBase
WHERE 
--(-- must have some sales in the past 24 months
--       ISNULL(DF.Sales12Mo,0) > 0
--       ORISNULL(DF.Sales24Mo,0) > 0
-- )
     (vy.ixVehicleYear = 1972 and sVehicleMakeName = 'Jensen' and sVehicleModelName = 'Interceptor') --and sVehicleModelTypeName = 'Car'
   -- OR (vy.ixVehicleYear = 1972 and sVehicleMakeName = 'Jensen' and sVehicleModelName = 'Interceptor') --Direct Fit SKU Count 304
   -- OR (vy.ixVehicleYear = 1932 and sVehicleMakeName = 'Ford' and sVehicleModelName = 'Model 18') --Direct Fit SKU Count 360
    OR (vy.ixVehicleYear = 1964 and sVehicleMakeName = 'Ford' and sVehicleModelName = 'Mustang') --Direct Fit SKU Count 899
   -- OR (vy.ixVehicleYear = 1975 and sVehicleMakeName = 'Ford' and sVehicleModelName = 'Bronco' ) --Direct Fit SKU Count 167
order by-- CategoryCount.CategoryCount desc
         vy.ixVehicleYear
        , vm.sVehicleMakeName
        , vmod.sVehicleModelName
        , vtype.sVehicleModelTypeName
        , sMarketName
