-- use tngLive 

select CAT.sCategoryName
     , SUB.sSubCategoryName
     , SP.sSemaPartName
     , COUNT(DISTINCT SV.ixSOPSKU) AS SKUCount 
from tblsemacategorization SC 
left join tblsemacategory CAT on CAT.ixSemaCategory = SC.ixSemaCategory
left join tblsemasubcategory SUB on SUB.ixSemaSubCategory = SC.ixSemaSubCategory
left join tblsemapart SP on SP.ixSemaPart = SC.ixSemaPart
left join tblskuvariant SV ON SV.ixSemaPart = SC.ixSemaPart
group by CAT.sCategoryName, SUB.sSubCategoryName, SP.sSemaPartName
order by CAT.sCategoryName, SUB.sSubCategoryName, SP.sSemaPartName;