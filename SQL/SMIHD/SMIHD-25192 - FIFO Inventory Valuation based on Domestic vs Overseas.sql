/* SMIHD-25192 - FIFO Inventory Valuation based on Domestic vs Overseas


DECLARE @Date date = '06/01/2020'--	 @Location int = 99

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
    FORMAT(sum(cast (FD.iFIFOQuantity as money) * cast(FD.mFIFOCost as money)),'###,###,###') as 'Extended Cost'
     
FROM
	tblFIFODetail FD
	left join tblSKU SKU on FD.ixSKU collate SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU --collate SQL_Latin1_General_CP1_CS_AS
	left join tblDate D on FD.ixDate = D.ixDate
	left join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU and VS.iOrdinality = 1
	left join tblVendor V on VS.ixVendor = V.ixVendor
WHERE
	D.dtDate = @Date
	--and V.flgOverseas = 1
		--and FD.ixLocation = @Location
GROUP BY D.dtDate,
	(CASE when V.flgOverseas = 1 then 'Overseas'
	 ELSE 'Domestic'
	 END) 
ORDER BY 'SKUSource'

	/* 
	Date		SKUSource	Extended Cost
	==========	=========	==============
	2021.06.01	Domestic	45,148,287
	2021.06.01	Overseas	12,743,656

	2022.01.01	Domestic	57,213,395
	2022.01.01	Overseas	17,878,947

	2022.06.01	Domestic	58,740,122
	2022.06.01	Overseas	20,794,611
*/
*/




/* Looking at SKU QOS and filtering invalid SKUs

SELECT FORMAT(D.dtDate,'yyyy.MM.dd')AS 'Date',
	SUM(FD.iFIFOQuantity) 'TotQOS',
	--FD.ixSKU as 'SKU',
	--SKU.sDescription as 'SKU Desc',
	--FD.iFIFOQuantity 'FIFO Qty',
	--FD.mFIFOCost as 'FIFO Unit Cost',
	--sum(FD.iFIFOQuantity*FD.mFIFOCost) as 'Extended Cost'
	(CASE when V.flgOverseas = 1 then 'Overseas'
	 ELSE 'Domestic'
	 END
	 ) 'SKUSource',
    FORMAT(sum(cast (FD.iFIFOQuantity as money) * cast(FD.mFIFOCost as money)),'###,###,###') as 'Extended Cost'
     
FROM
	tblFIFODetail FD
	left join tblSKU SKU on FD.ixSKU collate SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU --collate SQL_Latin1_General_CP1_CS_AS
	left join tblDate D on FD.ixDate = D.ixDate
	left join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU and VS.iOrdinality = 1
	left join tblVendor V on VS.ixVendor = V.ixVendor
WHERE
	D.dtDate in ('06/01/2020','01/01/2021','06/01/2021','01/01/2022','06/01/2022')
	AND FD.ixSKU NOT LIKE 'NS%'
	AND upper(SKU.sDescription) NOT LIKE '%LABOR%'
	AND SKU.ixSKU NOT LIKE 'UP%' 
	AND SKU.ixSKU NOT LIKE 'AUP%'
	AND SKU.flgIntangible = 0

GROUP BY D.dtDate,
	(CASE when V.flgOverseas = 1 then 'Overseas'
	 ELSE 'Domestic'
	 END) 
ORDER BY D.dtDate, 'SKUSource'
*/



-- looking at recent SKUs with the highest valuation to see if there are any other obvious filters needed.
SELECT FORMAT(D.dtDate,'yyyy.MM.dd')AS 'Date',
	SUM(FD.iFIFOQuantity) 'TotQOS',
	FD.ixSKU as 'SKU',
	ISNULL(SKU.sWebDescription, SKU.sDescription) 'SKUDescription',
	--SKU.sDescription as 'SKU Desc',
	--FD.iFIFOQuantity 'FIFO Qty',
	--FD.mFIFOCost as 'FIFO Unit Cost',
	--sum(FD.iFIFOQuantity*FD.mFIFOCost) as 'Extended Cost'
	(CASE when V.flgOverseas = 1 then 'Overseas'
	 ELSE 'Domestic'
	 END
	 ) 'SKUSource',
    FORMAT(sum(cast (FD.iFIFOQuantity as money) * cast(FD.mFIFOCost as money)),'###,###,###') as 'Extended Cost'
     
FROM
	tblFIFODetail FD
	left join tblSKU SKU on FD.ixSKU collate SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU --collate SQL_Latin1_General_CP1_CS_AS
	left join tblDate D on FD.ixDate = D.ixDate
	left join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU and VS.iOrdinality = 1
	left join tblVendor V on VS.ixVendor = V.ixVendor
WHERE
	D.dtDate = '06/05/2022' -- ('06/01/2020','01/01/2021','06/01/2021','01/01/2022','06/01/2022')
	AND FD.ixSKU NOT LIKE 'NS%'
	AND upper(SKU.sDescription) NOT LIKE '%LABOR%'
	AND SKU.ixSKU NOT LIKE 'UP%' 
	AND SKU.ixSKU NOT LIKE 'AUP%'
	AND SKU.flgIntangible = 0

GROUP BY D.dtDate,
	(CASE when V.flgOverseas = 1 then 'Overseas'
	 ELSE 'Domestic'
	 END),
	 	FD.ixSKU,
	ISNULL(SKU.sWebDescription, SKU.sDescription)
ORDER BY sum(cast (FD.iFIFOQuantity as money) * cast(FD.mFIFOCost as money)) desc



-- what is the 1/1/22 inv valuation when you use the most current costs (i.e. use prime vendor cost).
SELECT FORMAT(D.dtDate,'yyyy.MM.dd')AS 'Date',
	SUM(FD.iFIFOQuantity) 'TotQOS',
	FD.ixSKU as 'SKU',
	SKU.sDescription as 'SKU Desc',
	--FD.iFIFOQuantity 'FIFO Qty',
	--FD.mFIFOCost as 'FIFO Unit Cost',
	--sum(FD.iFIFOQuantity*FD.mFIFOCost) as 'Extended Cost'
	(CASE when V.flgOverseas = 1 then 'Overseas'
	 ELSE 'Domestic'
	 END
	 ) 'SKUSource',
    FORMAT(sum(cast (FD.iFIFOQuantity as money) * cast(FD.mFIFOCost as money)),'###,###,###') as 'FIFO Ext Cost',
	FORMAT(sum(cast (FD.iFIFOQuantity as money) * cast(VS.mCost as money)),'###,###,###') as 'PV Ext Cost',
	--ABS(sum(cast (FD.iFIFOQuantity as money) * cast(FD.mFIFOCost as money)) - sum( cast (FD.iFIFOQuantity as money) * cast(VS.mCost as money))) 'DELTA' 
	cast(FD.mFIFOCost as money) 'FIFOUnitCost',
	cast(VS.mCost as money) 'CurrentPVUnitCost',
	ABS(cast(VS.mCost as money) - cast(FD.mFIFOCost as money)) 'DELTA'

FROM
	tblFIFODetail FD
	left join tblSKU SKU on FD.ixSKU collate SQL_Latin1_General_CP1_CS_AS = SKU.ixSKU --collate SQL_Latin1_General_CP1_CS_AS
	left join tblDate D on FD.ixDate = D.ixDate
	left join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU and VS.iOrdinality = 1
	left join tblVendor V on VS.ixVendor = V.ixVendor
WHERE
	D.dtDate = '01/01/2022' --in ('06/01/2020','01/01/2021','06/01/2021','01/01/2022','06/01/2022')
	AND FD.ixSKU NOT LIKE 'NS%'
	AND upper(SKU.sDescription) NOT LIKE '%LABOR%'
	AND SKU.ixSKU NOT LIKE 'UP%' 
	AND SKU.ixSKU NOT LIKE 'AUP%'
	AND SKU.flgIntangible = 0

GROUP BY D.dtDate,
VS.mCost,
FD.mFIFOCost,
FD.ixSKU,
	SKU.sDescription,
	(CASE when V.flgOverseas = 1 then 'Overseas'
	 ELSE 'Domestic'
	 END) 
ORDER BY 'DELTA' desc --D.dtDate, 'SKUSource'


select * from tblVendorSKU
 
-- the 10 SKUs with the biggest Delta for 1/1/22 FIFO value vs current PV Cost
SELECT S.ixSKU, 
ISNULL(S.sWebDescription, S.sDescription),
S.sSEMACategory,
S.ixMerchant,
S.mPriceLevel1, S.mAverageCost, S.mLatestCost, VS.mCost 'PVCost', VS.ixVendor
from tblSKU S
	left join tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
WHERE S.ixSKU in ('M4T0.05N01Q','M2R1.63H03N','M2N1.50R01N','M4R1.00N03F','932001','35519417619','35588869604','91657090','5741001','35519431602')


-- SKUs with Price Level 1 lower than PV cost
select S.ixSKU, S.mPriceLevel1, VS.ixVendor, VS.mCost 'PVCost'
from tblSKU S
	left join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
where S.flgDeletedFromSOP = 0
	and S.mPriceLevel1 < VS.mCost 
	and S.mPriceLevel1 > 0 
	and VS.ixVendor NOT IN ('9999','0999','0009')
	and S.ixSKU NOT LIKE 'UP%'
	and S.ixSKU NOT LIKE 'AUP%' -- 127
	and S.flgActive = 1
ORDER BY VS.ixVendor




select * from tblVendor where ixVendor = '0002'


select S.ixSKU, S.mPriceLevel1, VS.ixVendor, VS.mCost 'PVCost'
from tblSKU S
	left join tblVendorSKU VS on VS.ixSKU = S.ixSKU and VS.iOrdinality = 1
where S.flgDeletedFromSOP = 0
	--and S.mPriceLevel1 < VS.mCost 
	--and S.mPriceLevel1 > 0 
	and VS.ixVendor IN ('9999','0999','0009')



