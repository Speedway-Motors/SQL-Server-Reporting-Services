-- SMIHD-18190 - additional SKU info on video articles and other docs 

select * from tng.[tblcontentpage_section]
select * from tng.tblskuvariant sv
select * from tng.tblcontentpage_skubase 


select sv.ixSKUVariant, sv.ixSKUBase, cpsb.*, tbcp.*
from tng.tblskuvariant sv
    left join tng.tblcontentpage_skubase cpsb on cpsb.ixSKUBase = sv.ixSKUBase
    left join tng.tbltoolbox_featured_contentpage_key tbcp on tbcp.ixContentPageKey = cpsb.ixContentPage
WHERE sv.ixSOPSKU = '91064022'

SELECT SUBSTRING('SQL Tutorial', 1, 3) AS ExtractString;

-- DROP TABLE #TempBySEMACat
SELECT DISTINCT sv.ixSOPSKU, b.ixSOPSKUBase, S.sWebDescription 'SKUWebDescription', S.sSEMACategory 'Category', S.mPriceLevel1 'Price',
    cp.sTitle, cp.sArticleTitle, cp.sArticleSummary, cp.dtCreated 'CPCreated', cp.dtLastDeployed, 
    cpk.sKey, cpk.dtCreated, cpk.dtDeployDateUtc, cpk.dtFirstDeployDateUtc,cpk.dtDMSCreateUtc 'CPKeyDMSCreateUtc', cpk.dtDMSUpdateUtc 'CPKeyDMSUpdateUtc',
    cpt.sPageType, cpt.dtDMSCreateUtc, cpt.dtDMSUpdateUtc,
    (CASE WHEN sbv.ixSkuBaseVideo is NOT NULL THEN 'Y'
     ELSE 'N'
     END) AS 'Video', 
     sbv.dtCreateUtc, sbv.dtLastUpdateUtc, sbv.sCreateBy, sbv.sUpdateBy, sbv.sVideoTitle, 
     sbv.dtDMSCreateUtc, sbv.dtDMSUpdateUtc,
     ppt.sTitle, 
    (CASE WHEN ppt.sTextBlock LIKE '%.pdf%' THEN 'Y'
        ELSE 'N'
     END) AS 'PDF',
     SUBSTRING(ppt.sTextBlock, 1, 250) as 'TextBlock250char'
     /* */
--INTO #TempBySEMACat
FROM tng.tblcontentpage_skubase AS tps
  LEFT JOIN tng.tblskubase b ON tps.ixSKUBase = b.ixSKUBase
  LEFT JOIN tng.tblskuvariant sv ON sv.ixSKUBase = b.ixSKUBase
  LEFT JOIN dbo.tblSKU S on S.ixSKU = sv.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS
  LEFT JOIN tng.tblcontentpage AS cp ON tps.ixContentPage = cp.ixContentPage
  LEFT JOIN tng.tblcontentpage_key AS cpk ON cp.ixContentPage = cpk.ixDeployedContentPage
  LEFT JOIN tng.tblcontentpage_type cpt on cpk.ixContentPagetype = cpt.ixContentPagetype
  LEFT JOIN tng.tblproductpageskubase AS ppsb ON b.ixSKUBase = ppsb.ixSKUBase  
  LEFT JOIN tng.tblskubase_video AS sbv ON b.ixSKUBase = sbv.ixSkuBase
  LEFT JOIN tng.tblproductpagetab AS ppt ON ppsb.ixProductPage = ppt.ixProductPage
    WHERE sv.ixSOPSKU IN ('9180043','91064022','35519210009','91033047','5478394','910159-15') -- sample SKUs from multiple Categories
    -- ('917347-22','917347-24','917347-26','917347-28','917347-31','910159-11','910159-13','910159-15','9174023','91015770')
    --  S.sSEMACategory = 'Cooling and Heating'
        and cpk.ixDeployedContentPage is NOT NULL -- NULL = not currently available online
order by sv.ixSOPSKU, cpt.sPageType, cp.sArticleTitle


SELECT sVideoTitle
from tng.tblskubase_video
where sVideoTitle is NOT NULL

tng.tblskubase_video.sVideoTitle
-- 9180043 has 2 articles...no videos

select ixSOPSKU, count(*)
from #TempBySEMACat
group by ixSOPSKU
having count(*) > 1
order by count(*) desc

select * from tng.tblcontentpage_key.ixDeployedContentPage
where sGlobalCss is NOT NULL

ixDeployedContentPage
38854

select sSEMACategory, FORMAT(count(ixSKU),'###,###') 'SKUs'
from tblSKU
where flgDeletedFromSOP = 0
    and flgActive = 1
    and ixProductLifeCycleCode = 4 -- Mature
    and sWebDescription is NOT NULL
    and mPriceLevel1 > 100 
GROUP BY sSEMACategory
ORDER BY count(ixSKU) desc


Wheel and Tire
Cooling and Heating
Interior, Accessories and Trim
Air and Fuel Delivery
Exterior, Accessories and Trim

select * from tblProductLifeCycle

'ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription'

