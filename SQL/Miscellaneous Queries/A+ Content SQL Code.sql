SELECT
    [ixSOPSKU]
    ,[ixSOPSKUBase]
    ,b.[sName]
    ,[sBrandName]
    ,sa.[sTitle]
    ,sa.[ixSkuAttribute]
    ,[sAttributeValue]
    ,cat.[sCategoryName]
    ,scat.[sSubCategoryName]
    ,part.[sPartName]
FROM    tng.[tblskuvariant] s 
    inner join    tng.[tblskubase] b on    b.ixskubase = s.ixSkuBase
    inner join    tng.[tblcategorization_part] part on    part.ixCategorizationPart = b.ixCategorizationPart
    inner join    tng.[tblcategorization] a on    part.ixCanonicalCategorization = a.ixCategorization
    inner join    tng.[tblcategorization_category] cat on    cat.ixCategorizationCategory = a.ixCategorizationCategory
    inner join    tng.[tblcategorization_subcategory] scat on    scat.ixCategorizationSubCategory = a.ixCategorizationSubCategory
    inner join    tng.[tblbrand] bra on    b.ixBrand = bra.ixBrand
    inner join    tng.[tblskuvariant_skuattribute_value] ssav on    ssav.ixSkuVariant = s.ixSkuVariant
    inner join    tng.[tblskuattribute_value] sav on    sav.ixSkuAttributeValue = ssav.ixSkuAttributeValue
    inner join    tng.[tblskuattribute] sa on    sa.ixSkuAttribute = sav.ixSkuAttribute
WHERE sa.[ixSkuAttribute] = 2798