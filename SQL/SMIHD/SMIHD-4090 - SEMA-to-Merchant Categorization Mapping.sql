-- SMIHD-4090 - SEMA-to-Merchant Categorization Mapping


SELECT sCategoryName 'CategoryName',
    sSubCategoryName 'SubCategoryName',
    sSemaPartName 'SemaPartName',
    sGoogleMerchantCategorization 'GoogleMerchantCategorization',
    sBingMerchantCategorization 'BingMerchantCategorization'
FROM openquery([TNGREADREPLICA], '
        CALL spCategorization_GetTaxonomy;
       ')



