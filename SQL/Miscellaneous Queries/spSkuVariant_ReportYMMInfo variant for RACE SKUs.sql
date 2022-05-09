USE [DW]
GO

/****** Object:  StoredProcedure [dbo].[spSkuVariant_ReportYMMInfo]    Script Date: 5/15/2018 3:47:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- add Category and Subcategory
CREATE PROCEDURE [dbo].[spSkuVariant_ReportYMMInfo](@pBrandName varchar(100) , @SemaCategory varchar(100) , @SemaSubCategory varchar(100) , @pSemaPart varchar(100) , @pProductLine varchar(100) , @pYear int , @pMake varchar(200) , @pModel varchar(200)  ) as
BEGIN
SET FMTONLY OFF

IF @pBrandName = '' 
begin
  SET @pBrandName = NULL ;
END;
IF @SemaCategory = '' 
begin
  SET @SemaCategory = NULL;
END;
IF @SemaSubCategory = '' 
begin
  SET @SemaSubCategory = NULL;
END;
IF @pSemaPart = '' 
begin
  SET @pSemaPart = NULL;
END;
IF @pProductLine = '' 
begin
  SET @pProductLine = NULL;
END;
IF @pYear = '' 
begin
  SET @pYear = NULL;
END;
IF @pMake = '' 
begin
  SET @pMake = NULL;
END;
IF @pModel = ''
begin
  SET @pModel = NULL;
END;

SELECT 
  DISTINCT 
  top 60000
  s.ixSOPSKU as SKU
  , c.sCategoryName AS Category, sc.sSubCategoryName AS Subcategory, p.sPartName as PartType, b.sName AS WebTitle, s.sSKUVariantName as SkuName, br.sBrandName  AS BrandName
  , pl.sTitle as ProductLine
  , vy.ixVehicleYear as Year
  ,vm.sVehicleMakeName as Make
  ,vmod.sVehicleModelName as Model
  , CASE 
      WHEN (s.flgPublish = 1 AND b.flgWebPublish = 1 AND pp.flgActive = 1) THEN 1
      ELSE 0
    END AS AvailableForSaleOnWeb
  , s.flgDiscontinued as Discountinued
  , s.iTotalQAV AS QAV, s.flgBackorderable AS Backorderable
  , SKU.ixSKU
  , V.ixVendor 'PVNum'
  , V.sName 'PVName'
  , VS.sVendorSKU as 'VendorSKU'
FROM tng.tblskuvariant s
    INNER JOIN tng.tblskubase b ON s.ixSKUBase = b.ixSKUBase
    INNER JOIN tng.tblproductpageskubase ppsb ON b.ixSKUBase = ppsb.ixSKUBase
    INNER JOIN tng.tblproductpage pp ON ppsb.ixProductPage = pp.ixProductPage
    LEFT JOIN tng.tblbrand br ON b.ixBrand = br.ixBrand
    LEFT JOIN tng.tblcategorization_part p ON b.ixCategorizationPart = p.ixCategorizationPart
    LEFT JOIN tng.tblcategorization cat ON p.[ixCanonicalCategorization] = cat.ixCategorization
    LEFT JOIN tng.tblcategorization_category c ON cat.ixcategorizationCategory = c.ixcategorizationCategory
    LEFT JOIN tng.tblcategorization_subcategory sc ON cat.ixcategorizationSubCategory = sc.ixcategorizationSubCategory
    LEFT JOIN tng.tblskuvariant_vehicle_base svb ON s.ixSKUVariant = svb.ixSkuVariant
    LEFT JOIN tng.tblvehicle_base vb ON svb.ixVehicleBase = vb.ixVehicleBase
    LEFT JOIN tng.tblvehicle_year vy ON vb.ixVehicleYear = vy.ixVehicleYear
    LEFT JOIN tng.tblvehicle_make vm ON vb.ixVehicleMake = vm.ixVehicleMake
    LEFT JOIN tng.tblvehicle_model vmod ON vb.ixVehicleModel = vmod.ixVehicleModel
    LEFT JOIN tng.tblproductline pl ON b.ixProductLine = pl.ixProductLine
        -- SMI Reporting joins
    LEFT JOIN [SmiReportingRawData].Transfer.tblSKU SKU on SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = s.ixSOPSKU
    LEFT JOIN [SmiReportingRawData].Transfer.tblVendorSKU VS on SKU.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    LEFT JOIN [SmiReportingRawData].Transfer.tblVendor V on VS.ixVendor = V.ixVendor

    --    joins for the Race market
    LEFT JOIN tngLive.tblskubase_universal_market bum ON bum.ixSkuBase = b.ixSKUBase
    LEFT JOIN tngLive.tblskuvariant_application_xref sax ON s.ixSKUVariant = sax.ixSKUVariant
    LEFT JOIN tngLive.tblmarket_application ma ON sax.ixApplication = ma.ixApplication
    LEFT JOIN tngLive.tblskuvariant_racetype_xref srx ON s.ixSKUVariant = srx.ixSkuVariant
    LEFT JOIN tngLive.tblracetype_market_xref rmx ON srx.ixRaceType = rmx.ixRaceType
    LEFT JOIN 
    ( SELECT DISTINCT svb.ixSkuVariant, vmx.ixMarket 
      FROM  tngLive.tblskuvariant_vehicle_base svb 
        inner JOIN tngLive.tblvehicle_base_market_xref vmx ON svb.ixVehicleBase = vmx.ixVehicleBase
        INNER JOIN tngLive.tblskuvariant s on svb.ixSkuVariant = s.ixSKUVariant
        INNER JOIN tngLive.tblskubase b ON s.ixSKUBase = b.ixSKUBase 
    ) as vmx on s.ixSKUVariant = vmx.ixSkuVariant
    LEFT JOIN tngLive.tblmarket m on bum.ixMarket = m.ixMarket
                        OR ma.ixMarket = m.ixMarket
                        OR rmx.ixMarket = m.ixMarket
                        OR vmx.ixMarket = m.ixMarket
WHERE m.ixMarket in (2,1775,1903) -- the three markets in the Race supermarket
/*
    AND (br.sBrandName = @pBrandName -- COLLATE latin1_general_ci
        OR @pBrandName is null  )
    AND (c.sCategoryName = @SemaCategory
        OR  @SemaCategory IS NULL )
    AND ( sc.sSubCategoryName = @SemaSubCategory
        OR @SemaSubCategory IS NULL  )
    AND ( p.sPartName = @pSemaPart
        OR @pSemaPart IS NULL  )
    AND ( pl.sTitle = @pProductLine
        OR @pProductLine IS NULL  )
    AND ( vy.ixVehicleYear = @pYear
        OR @pYear IS NULL  )
    AND ( vm.sVehicleMakeName = @pMake -- COLLATE latin1_general_ci
        OR @pMake IS NULL  )
    AND ( vmod.sVehicleModelName = @pModel -- COLLATE latin1_general_ci
         OR @pModel IS NULL )
    and ( svb.ixSkuVariantVehicleBase IS NOT NULL
         OR cat.ixCategorization IS NOT null  )
*/
 ORDER BY s.ixSOPSKU,  c.sCategoryName, sc.sSubCategoryName, p.sPartName DESC 
;

END

GO


-- EXEC spSkuVariant_ReportYMMInfo NULL, NULL, NULL, NULL, NULL, 1975, 'Chevy', 'Impala' 
