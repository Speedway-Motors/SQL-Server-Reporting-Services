/* SMIHD-24431 - SKU Price Changes by Merchant.rdl
	ver 20.1.22

CHANGE LOG
Version Ticket		by	Change
=======	=========== ===	=================================================
22.20.1 SMIHD-24431 PJC Created report

-- spSKUPriceChangeByMerchant -- could not use a stored proc because of the multi-select option needed for @Merchant


DECLARE	@ChangedOnOrAfter datetime2 = '04/01/2022',
		@ChangedOnOrBefore datetime2 = '04/05/2022',
		@Merchant varchar(10) = 'JAK' --  JAK CGN NA

*/

SELECT 
	S.ixMerchant 'Merchant', -- 571   @37-40 sec
	WSN.ixSOPSku 'SOPSKU',
	S.sWebDescription 'WebDescription', -- check for NULLS if there are use default description in tblSKU
	VS.sVendorSKU 'PVSKU',
	VS.ixVendor 'PVNum',
	V.sName 'PVName',
	WSN.dtStartEffectiveDate 'StartEffectiveDate',
	dtEndEffectiveDate 'EndEffectiveDate',
	-- Price changer - NOT stored anywhere as of 4-26-22
	-- GP$ = (PrevPrice-PrevCost)/PrevPrice
	-- Prev
	WSN.PreviousmPrimaryVendorCost  'PrevPVCost',
	WSN.PreviousmWebPrice 'PrevWebPrice',
	((WSN.PreviousmWebPrice-CAST(WSN.PreviousmPrimaryVendorCost AS Money))/NULLIF(CAST(WSN.PreviousmWebPrice AS Money),0)) 'PrevGPpercent',
	(WSN.PreviousmWebPrice-CAST(WSN.PreviousmPrimaryVendorCost AS Money)) 'PrevGP$',
	-- Current
	WSN.mPrimaryVendorCost 'CurrentPVCost', 
	WSN.mWebPrice 'CurrentWebPrice',
	((WSN.mWebPrice-CAST(WSN.mPrimaryVendorCost AS Money))/NULLIF(CAST(WSN.mWebPrice AS Money),0)) 'CurrentGPpercent',
	(WSN.mWebPrice-CAST(WSN.mPrimaryVendorCost AS Money)) 'CurrentGP$',
	-- GP% change	   	
	(((WSN.mWebPrice-CAST(WSN.mPrimaryVendorCost AS Money))/NULLIF(CAST(WSN.mWebPrice AS Money),0))
	- ((WSN.PreviousmWebPrice-CAST(WSN.PreviousmPrimaryVendorCost AS Money))/NULLIF(CAST(WSN.PreviousmWebPrice AS Money),0))
		)'GPpercentDelta',
	ABS(((WSN.mWebPrice-CAST(WSN.mPrimaryVendorCost AS Money))/NULLIF(CAST(WSN.mWebPrice AS Money),0))
		- ((WSN.PreviousmWebPrice-CAST(WSN.PreviousmPrimaryVendorCost AS Money))/NULLIF(CAST(WSN.PreviousmWebPrice AS Money),0))
		) 'GPpercentDeltaABS',
	((WSN.mWebPrice-CAST(WSN.mPrimaryVendorCost AS Money)) - (WSN.PreviousmWebPrice-CAST(WSN.PreviousmPrimaryVendorCost AS Money)) ) 'GP$Delta'
	-- ABS(ISNULL(WSN.mWebPrice,0) -ISNULL(WSN.PreviousmWebPrice,0)) 'Price DELTA',
	-- ABS(ISNULL(WSN.mPrimaryVendorCost,0) -ISNULL(WSN.PreviousmPrimaryVendorCost,0)) 'Cost DELTA'
FROM
	(-- Web Snapshot
	SELECT
		ixSkuVariantWebSnapshot, ixSOPSku, dtStartEffectiveDate, dtEndEffectiveDate
		,mWebPrice, mPrimaryVendorCost
		, lag (mWebPrice) over (partition by ixSOPSKU order by dtStartEffectiveDate) as 'PreviousmWebPrice'
		, lag (mPrimaryVendorCost) over (partition by ixSOPSKU order by dtStartEffectiveDate) as 'PreviousmPrimaryVendorCost'
	FROM tblSkuVariantWebSnapshot sSnap
	WHERE --(dtStartEffectiveDate >= @ChangedOnOrAfter)
		(dtStartEffectiveDate between @ChangedOnOrAfter and DATEADD(day, 1, @ChangedOnOrBefore))
	) WSN
	LEFT JOIN [DW].[Transfer].tblSKU S ON WSN.ixSOPSku = S.ixSKU
	LEFT JOIN [DW].[Transfer].tblVendorSKU VS ON VS.ixSKU = S.ixSKU
												and VS.iOrdinality = 1 -- Primary Vendor
	LEFT JOIN [DW].[Transfer].tblVendor V on VS.ixVendor = V.ixVendor
	LEFT JOIN (-- SALEABLE SKUs
                SELECT DISTINCT t.ixSOPSKU AS 'ixSOPSKU', t1.ixSOPSKUBase 'SOPSKUBase', t.ixSKUBase 'SKUBase'  -- 148,970 SKUs @40 seconds
                FROM tng.tblskuvariant t  -- IF RUNNING DIRECTLY ON DW REMOVE ->  
                    INNER JOIN tng.tblskubase t1 ON t.ixSKUBase = t1.ixSKUBase
                    INNER JOIN tng.tblproductpageskubase t2 ON t1.ixSKUBase = t2.ixSKUBase
                --     INNER JOIN tng.tblproductpage t3 ON t2.ixProductPage = t3.ixProductPage
                WHERE t.ixSOPSKU is NOT NULL
                    AND t.flgPublish = 1
                    AND t1.flgWebPublish = 1
                    -- AND t3.flgActive = 1   replaced with t1.flgWebActive = 1 check per SMIHD-17893
                    AND t1.flgWebActive = 1  
                    AND(t.iTotalQAV > 0 
                        OR t.flgBackorderable = 1)
               ) SS ON S.ixSKU = SS.ixSOPSKU --COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE S.ixMerchant in (@Merchant)
	and S.ixMerchant is NOT NULL
	and SS.ixSOPSKU is NOT NULL -- saleable SKUs

	--and dtStartEffectiveDate >= @ChangedOnOrAfter
	and (dtStartEffectiveDate between @ChangedOnOrAfter and DATEADD(day, 1, @ChangedOnOrBefore))
	and (
			 (WSN.PreviousmWebPrice is not null -- 24   -- they do not want "first time priced SKUs" on the report
			  and(WSN.mWebPrice <> WSN.PreviousmWebPrice
				  or WSN.PreviousmWebPrice is null)
			 )
		 OR
			(WSN.PreviousmPrimaryVendorCost is not null  -- they do not want "first time priced SKUs" on the report
			 and (WSN.mPrimaryVendorCost <> WSN.PreviousmPrimaryVendorCost -- 3,937
				  or
				  WSN.PreviousmPrimaryVendorCost is null)
			)
		)

ORDER BY 'GPpercentDeltaABS' DESC -- WSN.dtStartEffectiveDatex