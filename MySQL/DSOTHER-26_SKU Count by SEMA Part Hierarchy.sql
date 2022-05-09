SELECT SCAT.sCategoryName
     , SSC.sSubCategoryName
     , SP.sSemaPartName
     , COUNT(DISTINCT ixSKUVariant) AS SKUCnt
FROM tblsemacategorization SC 
LEFT JOIN tblsemacategory SCAT ON SCAT.ixSemaCategory = SC.ixSemaCategory
LEFT JOIN tblsemasubcategory SSC ON SSC.ixSemaSubCategory = SC.ixSemaSubCategory
LEFT JOIN tblsemapart SP ON SP.ixSemaPart = SC.ixSemaPart
LEFT JOIN tblskuvariant SV ON SV.ixSemaPart = SC.ixSemaPart
GROUP BY SCAT.sCategoryName
       , SSC.sSubCategoryName
       , SP.sSemaPartName
ORDER BY COUNT(DISTINCT SV.ixSKUVariant) DESC        