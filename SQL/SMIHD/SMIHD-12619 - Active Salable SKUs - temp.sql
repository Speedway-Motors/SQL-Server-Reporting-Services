-- SMIHD-12619 - Active Salable SKUs
SELECT S.ixSKU 'SKU',
        SS.SKUBase,
        S.sWebDescription 'Web Catalog Title (aka Web Description)',
        B.sBrandDescription 'Brand',
        PL.sTitle 'Product_Line',
        S.sSEMAPart 'Part_Type',
        (CASE WHEN VS.ixVendor = '0009' then 'Y'
              Else 'N'
         End) as 'Garage_Sale_Vendor',
         VS.ixVendor 'Primary_Vendor'
         -- (-- pseudo logic for Garage Sale based on market for Variant SKU OR Base SKU
         --  CASE WHEN SS.ixSOPSKU (ANY OF THE MARKETS) = 222 
         --              OR SS.SKUBase (ANY OF THE MARKETS) = 222 THEN 'Y'
         --  ELSE 'N'
         --  END) as 'Garage_Sale_Market'
FROM tblSKU S
    left join tblBrand B on S.ixBrand = B.ixBrand
    left join tblProductLine PL on S.ixProductLine = PL.ixProductLine
    left join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
    left join (-- SALEABLE SKUs
               SELECT DISTINCT t.ixSOPSKU AS 'ixSOPSKU', t.ixSKUBase 'SKUBase'  -- 168,191 SKUs
               FROM [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskuvariant t
                  INNER JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
                  INNER JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
                  INNER JOIN [DW.SPEEDWAY2.COM].TngRawData.tngLive.tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
                WHERE t.flgPublish = 1
                    AND t1.flgWebPublish = 1
                    AND t3.flgActive = 1
                    AND(t.iTotalQAV > 0 
                        OR t.flgBackorderable = 1)
               ) SS ON S.ixSKU = SS.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE S.flgDeletedFromSOP = 0
   and SS.ixSOPSKU is NOT NULL -- in the saleable SKU sub-query