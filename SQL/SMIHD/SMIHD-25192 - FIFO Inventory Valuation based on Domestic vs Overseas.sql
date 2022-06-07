-- SMIHD-25192 - FIFO Inventory Valuation based on Domestic vs Overseas


-- what is the 1/1/22 inv valuation when you use the most current costs (i.e. prime vendor cost).


/* TEMP TABLE TO SPEED THIS MOTHER UP!
select * into #FIFO_1_1_22 -- DROP TABLE #FIFO_1_1_22   -- 364,078
from tblFIFODetail
where ixDate = 19725 --	01/01/2022
*/


-- DECLARE @Date date = '06/01/2020'--	 @Location int = 99   took this out since we want all locations and I created the above temp table

SELECT FORMAT(D.dtDate,'yyyy.MM.dd')AS 'Date',
	--SUM(FD.iFIFOQuantity) 'TotQOS',
	--FD.ixSKU as 'SKU',
	--SKU.sDescription as 'SKU Desc',
	--FD.iFIFOQuantity 'FIFO Qty',
	--FD.mFIFOCost as 'FIFO Unit Cost',
	--sum(FD.iFIFOQuantity*FD.mFIFOCost) as 'Extended Cost'
	(CASE when V.flgOverseas = 1 then 'Overseas'
	 ELSE 'Domestic'
	 END
	 ) 'SKUSource',
    FORMAT(sum(cast (FD.iFIFOQuantity as money) * cast(FD.mFIFOCost as money)),'###,###,###') as 'FIFO Ext Cost',
	-- PER CCC   If PV cost > 2(tblSKU.mAverageCost), use average cost.
	FORMAT(sum(cast (FD.iFIFOQuantity as money) * cast((CASE when VS.mCost > (2*SKU.mAverageCost) then SKU.mAverageCost
														 ELSE VS.mCost
														 END) as money)),'###,###,###') as 'PV Ext Cost'
--	ABS(sum(cast (FD.iFIFOQuantity as money) * cast(FD.mFIFOCost as money)) - sum( cast (FD.iFIFOQuantity as money) * cast(VS.mCost as money))) 'DELTA' ,
--  ABS(	((sum(cast (FD.iFIFOQuantity as money) * cast(FD.mFIFOCost as money)) - sum( cast (FD.iFIFOQuantity as money) * cast(VS.mCost as money)))/ sum(cast (FD.iFIFOQuantity as money) * cast(FD.mFIFOCost as money)))   )  'DeltaPrcnt',	--cast(FD.mFIFOCost as money) 'FIFOUnitCost',
	--cast(VS.mCost as money) 'CurrentPVUnitCost',
	--ABS(cast(VS.mCost as money) - cast(FD.mFIFOCost as money)) 'UnitDelta',
	--VS.ixVendor

FROM #FIFO_1_1_22 FD -- tblFIFODetail FD			
	left join tblSKU SKU on FD.ixSKU collate SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU 
	left join tblDate D on FD.ixDate = D.ixDate
	left join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU and VS.iOrdinality = 1
	left join tblVendor V on VS.ixVendor = V.ixVendor
WHERE
	D.dtDate = '01/01/2022' --in ('06/01/2020','01/01/2021','06/01/2021','01/01/2022','06/01/2022')
	AND SKU.flgActive = 1
	AND SKU.flgIntangible = 0	
	AND SKU.ixSKU NOT LIKE 'UP%' 
	AND SKU.ixSKU NOT LIKE 'AUP%'
	AND SKU.ixSKU NOT LIKE 'NS%'
	AND upper(SKU.sDescription) NOT LIKE '%LABOR%'	
	AND VS.ixVendor NOT IN ('9999','0999','0009')
GROUP BY D.dtDate,
	--FD.ixSKU,
	--SKU.sDescription,
	--VS.mCost,
	--FD.iFIFOQuantity 
	--FD.mFIFOCost,
	(CASE when V.flgOverseas = 1 then 'Overseas'
	 ELSE 'Domestic'
	 END) 
	-- VS.ixVendor
-- ORDER BY 'DELTA' desc --D.dtDate, 'SKUSource'

