-- SMIHD-3539 - SKU Counts and Sales by SEMA Categorization
DECLARE @Date Date

SELECT @Date = '2/14/16'

SELECT 
/*********** section 1 **********************/
     SKU.ixSKU AS SKU -- Our Part Number
--    , SKU.sDescription AS SKUDescription
    , RTRIM(SKU.sSEMACategory) AS sSEMACategory
    , RTRIM(SKU.sSEMASubCategory) AS sSEMASubCategory 
    , RTRIM(SKU.sSEMAPart) AS sSEMAPart
    , ISNULL(YTD.YTDSales,0) AS YTDSales
--    , ISNULL(YTD.YTDQTYSold,0) AS YTDQTYSold
--    , B.sBrandDescription AS Brand
--    , D.dtDate AS ItemCreationDate  
INTO [SMITemp].dbo.[PJC_SMIHD3539_SKUs12MoSales]
FROM tblSKU SKU
LEFT JOIN tblDate D ON D.ixDate = SKU.ixCreateDate
LEFT JOIN tblBrand B ON B.ixBrand = SKU.ixBrand
LEFT JOIN (SELECT AMS.ixSKU
				, SUM(AMS.AdjustedSales) AS	YTDSales
				, SUM(AMS.AdjustedNonKCSales) AS YTDNonKCSales -- New
				, SUM(AMS.KCSales) AS YTDKCSales -- New
				, SUM(AMS.AdjustedGP) AS YTDGP
				, SUM(AMS.AdjustedNonKCGP) AS YTDNonKCGP -- New 
				, SUM(AMS.KCGP) AS YTDKCGP -- New 
				, SUM(AMS.AdjustedQTYSold) AS YTDQTYSold
				, SUM(AMS.AdjustedNonKCQtySold) AS YTDNonKCQtySold -- New 
				, SUM(AMS.KCQtySold) AS YTDKCQtySold -- New 
				, AVG(AMS.AVGInvCost) AS AVGInvCost
		   FROM tblSnapAdjustedMonthlySKUSalesNEW AMS
           WHERE AMS.iYearMonth >= DATEADD(mm, DATEDIFF(mm,0,@Date)-12, 0)    -- 12 months ago
			 AND AMS.iYearMonth < @Date -- previous month
		   GROUP BY AMS.ixSKU
		  ) YTD ON YTD.ixSKU = SKU.ixSKU
WHERE 
  SKU.flgActive = 1
ORDER BY SKU.ixSKU


SELECT SUM(YTDSales)  -- $98,413,826
from [SMITemp].dbo.[PJC_SMIHD3539_SKUs12MoSales]


select sSEMAPart, COUNT(distinct sSEMACategory), COUNT(distinct sSEMASubCategory)
from tblSKU 
group by sSEMAPart
HAVING  COUNT(distinct sSEMACategory) > 1
or COUNT(distinct sSEMASubCategory) > 1
order by COUNT(distinct sSEMACategory) desc, COUNT(distinct sSEMASubCategory) desc


-- final data set to put into Excel
SELECT sSEMACategory, sSEMASubCategory, sSEMAPart, COUNT(SKU) SKUCount, SUM(YTDSales) Sales12Mo
FROM [SMITemp].dbo.[PJC_SMIHD3539_SKUs12MoSales]
GROUP BY sSEMACategory, sSEMASubCategory, sSEMAPart
HAVING COUNT(SKU) > 0