/* BIV-750 - AFCO Margin Analysis - Inter Company Sales

/*
-- ALL 5 prices levels are identical in catalog AFCO.21
select SUM(mPriceLevel1) SUMPL1,
	SUM(mPriceLevel2) SUMPL2,
	SUM(mPriceLevel3) SUMPL3,
	SUM(mPriceLevel4) SUMPL4,
	SUM(mPriceLevel5) SUMPL5
from tblCatalogDetail
where ixCatalog = 'AFCO.21'

SUMPL1		SUMPL2		SUMPL3		SUMPL4		SUMPL5
12015233.32	12015233.32	12015233.32	12015233.32	12015233.32
*/

SELECT FORMAT(COUNT(ixSKU),'###,###') 'SKUs' --  95,781
FROM tblCatalogDetail
where ixCatalog = 'AFCO.21'

*/
SELECT CD.ixSKU, 
	ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
	CD.mPriceLevel1 'AFCOCat21PL1', 
	S.mAverageCost, 
	S.mLatestCost,
	SP.dLandedCostMultiplier,
	((CD.mPriceLevel1-(CAST(S.mAverageCost*SP.dLandedCostMultiplier AS Money)))/NULLIF(CAST(CD.mPriceLevel1 AS Money),0)) 'GP%BasedOnAvgCost',
	(CD.mPriceLevel1-(CAST(S.mAverageCost*SP.dLandedCostMultiplier AS Money))) 'GP$BasedOnAvgCost',
	S.sSEMACategory,
	S.sSEMASubCategory,
	S.sSEMAPart
	--, SP.mAFCOAverageCost, SP.mAFCOLatestCost
FROM tblCatalogDetail CD
	LEFT join tblSKU S on CD.ixSKU = S.ixSKU
	LEFT JOIN tblSKUProfitabilityRollup SP ON SP.ixSKU = S.ixSKU
where CD.ixCatalog = 'AFCO.21'
	and CD.mPriceLevel1 > 0 -- 641 SKUs have no price and no cost
	--and SP.dLandedCostMultiplier > 1
order by 	((CD.mPriceLevel1-CAST(S.mAverageCost*SP.dLandedCostMultiplier AS Money))/NULLIF(CAST(CD.mPriceLevel1 AS Money),0))  --SP.dLandedCostMultiplier desc, CD.ixSKU


