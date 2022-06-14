-- SMIHD-25192 - FIFO Inventory Valuation based on Domestic vs Overseas


-- what is the 1/1/22 inv valuation when you use the most current costs (i.e. prime vendor cost).

/*
SELECT ixDate, FORMAT(dtDate,'yyyy.MM.dd') 'dtDate'
from tblDate
where dtDate in ('06/01/2020','01/01/2021','06/01/2021','01/01/2022','06/01/2022')
order by ixDate

	ixDate	dtDate
	======	==========
	19146	2020.06.01
	19360	2021.01.01
	19511	2021.06.01
	19725	2022.01.01
	19876	2022.06.01
*/


/* TEMP TABLES TO SPEED THIS MOTHER UP!
SELECT * into #FIFO_6_1_20	-- 244,810 @3:12
-- DROP TABLE #FIFO_6_1_20   
from tblFIFODetail
where ixDate = 19146 --	2020.06.01

SELECT * into #FIFO_1_1_21	-- 272,866 @1:23
-- DROP TABLE #FIFO_1_1_21   
from tblFIFODetail
where ixDate = 19360 --	2021.01.01

SELECT * into #FIFO_6_1_21	-- 308,487 @1:09
-- DROP TABLE #FIFO_6_1_21   
from tblFIFODetail
where ixDate = 19511 --	2021.06.01

SELECT * into #FIFO_1_1_22	-- 364,078 @1:20
-- DROP TABLE #FIFO_1_1_22   
from tblFIFODetail
where ixDate = 19725 --	2022.01.01

SELECT * into #FIFO_6_1_22	-- 363,622 @1:04
-- DROP TABLE #FIFO_6_1_22   
from tblFIFODetail
where ixDate = 19876 --	2022.06.01
*/



-- MAIN QUERY FOR SPREEDSHEET RESULTS
SELECT FORMAT(D.dtDate,'yyyy.MM.dd')AS 'Date',
	(CASE when V.flgOverseas = 1 then 'Overseas'
	 ELSE 'Domestic'
	 END
	 ) 'SKUSource',
	--FD.ixSKU as 'SKU',
	--SKU.sDescription as 'SKU Desc',
	--FD.iFIFOQuantity 'FIFO Qty',
	--FD.mFIFOCost as 'FIFO Unit Cost',

	-- PER CCC   If PV cost > 2(tblSKU.mAverageCost), use average cost.
	FORMAT(sum(cast (FD.iFIFOQuantity as money) * cast((CASE when VS.mCost > (2*SKU.mAverageCost) then SKU.mAverageCost
														 ELSE VS.mCost
														 END) as money)),'###,###,###') as 'PV Ext Cost',
	FORMAT(sum(cast (FD.iFIFOQuantity as money) * cast(FD.mFIFOCost as money)),'###,###,###') as 'FIFO Ext Cost',
	SUM(FD.iFIFOQuantity) 'TotQOS'
--	ABS(sum(cast (FD.iFIFOQuantity as money) * cast(FD.mFIFOCost as money)) - sum( cast (FD.iFIFOQuantity as money) * cast(VS.mCost as money))) 'DELTA' ,
--  ABS(	((sum(cast (FD.iFIFOQuantity as money) * cast(FD.mFIFOCost as money)) - sum( cast (FD.iFIFOQuantity as money) * cast(VS.mCost as money)))/ sum(cast (FD.iFIFOQuantity as money) * cast(FD.mFIFOCost as money)))   )  'DeltaPrcnt',	--cast(FD.mFIFOCost as money) 'FIFOUnitCost',
	--cast(VS.mCost as money) 'CurrentPVUnitCost',
	--ABS(cast(VS.mCost as money) - cast(FD.mFIFOCost as money)) 'UnitDelta',
	--VS.ixVendor

FROM #FIFO_6_1_22 FD -- tblFIFODetail FD			
	left join tblSKU SKU on FD.ixSKU collate SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU 
	left join tblDate D on FD.ixDate = D.ixDate
	left join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU and VS.iOrdinality = 1
	left join tblVendor V on VS.ixVendor = V.ixVendor
WHERE
	--D.dtDate = '06/01/2020' --in ('06/01/2020','01/01/2021','06/01/2021','01/01/2022','06/01/2022')
	SKU.flgActive = 1
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

