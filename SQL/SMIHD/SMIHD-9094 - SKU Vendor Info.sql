-- SMIHD-9094 - SKU Vendor Info

select * from tblVendor

-- SKU count by Brand
select B.sBrandDescription, S.ixBrand, COUNT(*)
from tblSKU S
 left join tblBrand B on S.ixBrand = B.ixBrand  
where S.flgDeletedFromSOP = 0
and flgActive = 1
group by B.sBrandDescription, S.ixBrand
order by COUNT(*) desc

-- 
SELECT VS.ixSKU, ISNULL(S.sWebDescription,S.sDescription) 'SKUDescription'
    , S.ixBrand 'Brand'
    , B.sBrandDescription 'BrandDescription'
    , S.mPriceLevel1 PriceLvl1, S.mAverageCost -- , S.mLatestCost
    ,(CASE WHEN TNG.ixSOPSKU IS NOT NULL then 'Y'
      ELSE 'N'
      END
      ) as 'AvailableOnTheWeb' 
    , (CASE WHEN CABOM.ixSKU IS NOT NULL THEN 'Y'
       ELSE 'N'
       END
       ) AS 'CompntOfActiveBOM'
    , (CASE WHEN GS.ixSKU IS NOT NULL THEN 'Y'
       ELSE 'N'
       END
       ) AS 'GSSKU'            
    , COUNT(ixVendor) 'VendorCount'
FROM tblVendorSKU VS
    join tblSKU S on VS.ixSKU = S.ixSKU
    left join vwComponentSKUsOfActiveBOMs CABOM on CABOM.ixSKU = S.ixSKU      
    left join vwGarageSaleSKUs GS on S.ixSKU = GS.ixSKU 
    left join tblBrand B on S.ixBrand = B.ixBrand   
    left join (SELECT ixSOPSKU
               FROM openquery([TNGREADREPLICA], '
                            select s.ixSOPSKU 
                            from tblskubase AS b
                                inner JOIN tblskuvariant s ON b.ixSKUBase = s.ixSKUBase
                                inner JOIN tblproductpageskubase ppsb ON b.ixSKUBase = ppsb.ixSKUBase
                                inner JOIN tblproductpage AS pp ON ppsb.ixProductPage = pp.ixProductPage
                            WHERE b.flgWebPublish = 1
                                AND s.flgPublish = 1
                                AND pp.flgActive = 1
                                AND fn_isProductSaleable(s.flgFactoryShip, s.flgDiscontinued, s.flgBackorderable, s.iTotalQAV, s.flgMTO) = 1
                             '
                            ) WEB 
              ) TNG on S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = TNG.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE S.flgDeletedFromSOP = 0
    and S.flgActive = 1
    and flgIntangible = 0
GROUP BY VS.ixSKU, ISNULL(S.sWebDescription,S.sDescription) 
    , S.ixBrand 
    , B.sBrandDescription
    ,S.mPriceLevel1, S.mAverageCost -- , S.mLatestCost
    ,(CASE WHEN TNG.ixSOPSKU IS NOT NULL then 'Y'
      ELSE 'N'
      END
      )      
    ,(CASE WHEN CABOM.ixSKU IS NOT NULL THEN 'Y'
      ELSE 'N'
      END
      ) 
    ,(CASE WHEN GS.ixSKU IS NOT NULL THEN 'Y'
      ELSE 'N'
      END
      )
HAVING COUNT(ixVendor) > 2      
ORDER BY COUNT(ixVendor) desc





/* SKU Vendors
    ver 17.46.1
DECLARE @Brand varchar(40)
SELECT @Brand = 'No Brand Assigned'
*/

SELECT DISTINCT S.ixSKU 'SKU'
    , S.sBaseIndex 'BaseIndex'
    , ISNULL(S.sWebDescription,S.sDescription) 'SKUDescription'
    , S.ixBrand 'Brand'
    , B.sBrandDescription 'BrandDescription'
    , S.mPriceLevel1 PriceLvl1, S.mAverageCost 'AvgCost'
    , VS1.ixVendor 'V1Num'
    , V1.sName 'V1Name'
    , VS1.sVendorSKU 'V1VendorSKU'
    , VS2.ixVendor 'V2Num'
    , V2.sName 'V2Name'
    , VS2.sVendorSKU 'V2VendorSKU'    
    , VS3.ixVendor 'V3Num'
    , V3.sName 'V3Name'
    , VS3.sVendorSKU 'V3VendorSKU'        
    , VS4.ixVendor 'V4Num'
    , V4.sName 'V4Name'
    , VS4.sVendorSKU 'V4VendorSKU'            
    , VS5.ixVendor 'V5Num'
    , V5.sName 'V5Name'
    , VS5.sVendorSKU 'V5VendorSKU'                
    , VS6.ixVendor 'V6Num'
    , V6.sName 'V6Name'
    , VS6.sVendorSKU 'V6VendorSKU'                    
FROM tblSKU S 
    left join tblBrand B on S.ixBrand = B.ixBrand   
    left join tblVendorSKU VS1 on VS1.ixSKU = S.ixSKU and VS1.iOrdinality = 1
    left join tblVendorSKU VS2 on VS2.ixSKU = S.ixSKU and VS2.iOrdinality = 2
    left join tblVendorSKU VS3 on VS3.ixSKU = S.ixSKU and VS3.iOrdinality = 3
    left join tblVendorSKU VS4 on VS4.ixSKU = S.ixSKU and VS4.iOrdinality = 4
    left join tblVendorSKU VS5 on VS5.ixSKU = S.ixSKU and VS5.iOrdinality = 5
    left join tblVendorSKU VS6 on VS6.ixSKU = S.ixSKU and VS6.iOrdinality = 6     
    left join tblVendor V1 on VS1.ixVendor = V1.ixVendor               
    left join tblVendor V2 on VS2.ixVendor = V2.ixVendor
    left join tblVendor V3 on VS3.ixVendor = V3.ixVendor
    left join tblVendor V4 on VS4.ixVendor = V4.ixVendor               
    left join tblVendor V5 on VS5.ixVendor = V5.ixVendor
    left join tblVendor V6 on VS6.ixVendor = V6.ixVendor
WHERE S.flgDeletedFromSOP = 0
   -- and B.sBrandDescription = @Brand
    and S.flgActive = 1
    and flgIntangible = 0
    and S.ixSKU NOT LIKE 'UP%'
    and VS6.sVendorSKU is NOT NULL
ORDER BY S.ixBrand, S.ixSKU    


SELECT * from tblVendorSKU
where ixSKU = '1170808L'


SELECT ixVendor, sName
from tblVendor
where ixVendor in ('3895','2739','2602','1500','2304','1410')


select sBrandDescription as 'Brand'
from tblBrand
where flgDeletedFromSOP = 0
order by sBrandDescription