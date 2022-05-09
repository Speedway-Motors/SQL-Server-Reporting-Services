/* SMIHD-24431 - SKU Price Change History by Merchant


*/
select (EXEC dbo.spSKUPriceChangeByMerchant '04/21/2022','04/21/2022')
into #Temp 

DROP TABLE #SKUPriceAndCostChanges
SELECT * INTO #SKUPriceAndCostChanges
from dbo.fnSkuVariantWebSnapshotChanges ('PrimaryVendorCost','04/21/2022') -- 29,825				6,300 for the 25th

INSERT INTO #SKUPriceAndCostChanges
SELECT * FROM dbo.fnSkuVariantWebSnapshotChanges ('Web','04/21/2022') -- 25,912						6,300 for the 25th

select count(*) from #SKUPriceAndCostChanges -- 38984
select count(distinct ixSOPSKU) from #SKUPriceAndCostChanges -- 19074
/*
use 'AnyPrice' and it will return any rows where any price changed.

Then weed out what you don't want.

where
	mWebPrice <> PreviousmWebPrice
	or
	mPrimaryVendorCost <> PreviousmPrimaryVendorCost
*/
--DROP TABLE #SKUAnyPriceChanges
SELECT * INTO #SKUAnyPriceChanges
from dbo.fnSkuVariantWebSnapshotChanges ('AnyPrice','04/21/2022') -- 19544

select count(*) from #SKUAnyPriceChanges -- 19544
select count(distinct ixSOPSKU) from #SKUAnyPriceChanges -- 19074


select ixSOPSKU, count(*)
from #SKUPriceAndCostChanges
GROUP BY ixSOPSKU
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC

select * from #SKUPriceAndCostChanges
where ixSOPSKU = '10631994'

select top 10 * from #SKUPriceAndCostChanges

DECLARE @Merchant varchar(10) = 'CGN'



SELECT -- 540	-- taking about 60 sec to run
	S.ixMerchant 'Merchant',
	S.ixSKU 'SOPSKU',
	S.sWebDescription 'WebDescription', -- check for NULLS if there are use default description in tblSKU
--	SNWEB.dtStartEffectiveDate 'PriceDateChanged',
	VS.sVendorSKU 'PVSKU',
	VS.ixVendor 'PVNum',
	V.sName 'PVName',
	SNWEB.mWebPrice,
	SNWEB.PreviousmWebPrice,
	--SNPV.dtStartEffectiveDate 'PVCostDateChanged',
	--SNPV.mPrimaryVendorCost,
	--SNPV.PreviousmPrimaryVendorCost,
	-- Prev GP%
	-- New GP%	
	-- Delta GP%
	ABS(ISNULL(SNWEB.mWebPrice,0) -ISNULL(SNWEB.PreviousmWebPrice,0)) 'Price DELTA'
FROM [DW].[Transfer].tblSKU S
	LEFT JOIN [DW].[Transfer].tblVendorSKU VS ON VS.ixSKU = S.ixSKU
												and VS.iOrdinality = 1 -- Primary Vendor
	LEFT JOIN [DW].[Transfer].tblVendor V on VS.ixVendor = V.ixVendor

	INNER JOIN dbo.fnSkuVariantWebSnapshotChanges ('Web','04/21/2022') SNWEB on S.ixSKU = SNWEB.ixSOPSku
																				and SNWEB.PreviousmWebPrice is NOT NULL-- 22
	--INNER JOIN dbo.fnSkuVariantWebSnapshotChanges ('PrimaryVendorCost','04/20/2022') SNWEB on S.ixSKU = SNWEB.ixSOPSku -- 32,808
	LEFT JOIN (-- SALEABLE SKUs
               SELECT DISTINCT t.ixSOPSKU AS 'ixSOPSKU', t1.ixSOPSKUBase 'SOPSKUBase', t.ixSKUBase 'SKUBase', 
                    FORMAT((t1.dtDateFirstMadeWebActiveUtc AT TIME ZONE 'UTC'  AT TIME ZONE 'Central Standard Time'),'yyyy-MM-dd') 'SKUBaseFirstMadeWebActive'
               FROM DW.tngLive.tblskuvariant t
                  INNER JOIN DW.tngLive.tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
                  INNER JOIN DW.tngLive.tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
                  INNER JOIN DW.tngLive.tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
                WHERE t.ixSOPSKU is NOT NULL
                    AND t.flgPublish = 1
                    AND t1.flgWebPublish = 1
                    AND t3.flgActive = 1
                    AND(t.iTotalQAV > 0 
                        OR t.flgBackorderable = 1) 
				) SS ON SS.ixSOPSKU = S.ixSKU
WHERE -- S.ixSKU = '54541090' and 
	S.flgDeletedFromSOP = 0
	and S.ixMerchant is NOT NULL -- 828 for 4/14 on
	--and S.ixMerchant in (@Merchant) -- 702 for 4/14 on
	and SS.ixSOPSKU is NOT NULL -- SKU is Saleable
--	and SNWEB.PreviousmWebPrice is NOT NULL -- First time price assigned
	-- only if the prev price <> new price or prev cost <> new cost?

--ORDER BY SNWEB.PreviousmWebPrice --(ISNULL(SNWEB.mWebPrice,0) -ISNULL(SNWEB.PreviousmWebPrice,0))
--S.ixSKU


-- SELECT TOP 10 * FROM tblSkuVariantWebSnapshot

/* example from Ron

select s.ixSKU, sn.* 
from tblSKU s
	inner join dbo.fnSkuVariantWebSnapshotChanges ('WEB','04/21/2022') sn on s.ixSKU = sn.ixSOPSku
where ixSOPSku = '917347-22'

SELECT * 
FROM dbo.fnSkuVariantWebSnapshotChanges ('WEB','04/21/2022')

Fields in fnSkuVariantWebSnapshotChanges:

	ixSkuVariantWebSnapshot
	ixSOPSku
	dtStartEffectiveDate
	dtEndEffectiveDate
	*mWebPrice
	*PreviousmWebPrice
	iQAV
	PreviousiQAV
	ixBrand
	PreviousixBrand
	sBrandName
	PrevioussBrandName

	mLastCost
	PreviousmLastCost

	mAverageCost
	PreviousmAverageCost

	mPrimaryVendorCost
	PreviousmPrimaryVendorCost

	+ price change fields for Employee, Walmart, BDC, EBAY, EAGLE, MRR, PRS


-- SKU TRANSACTIONS to find who made the cost/price change

SELECT *
FROM tblSKUTransaction
where ixDate >= 19828 -- 04/15/2022
and ixSKU = '54541090'


*/