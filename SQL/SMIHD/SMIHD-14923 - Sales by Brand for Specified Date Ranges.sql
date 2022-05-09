/* SMIHD-14923 - Sales by Brand for Specified Date Ranges
    ver 19.36.1
   Based on code pulled from Inventory by Vendor.rdl
 
DECLARE @Vendor varchar(500), 
        @CPStartDate datetime,    @CPEndDate datetime,
        @PPStartDate datetime,    @PPEndDate datetime

SELECT @Vendor = '0425', -- '0330' -- '0330'
        @CPStartDate = '06/01/2019',   @CPEndDate = '06/30/2019',
        @PPStartDate = '06/01/2018',  @PPEndDate = '06/30/2018'
*/ 
SELECT DISTINCT S.ixSKU,
	ISNULL(S.sWebDescription, S.sDescription) 'Description',   -- 271 for vendor 0330
	PV.sVendorSKU	'PVSKU',
	PV.ixVendor		'PV',
	V.sName			'PVName',
	PV.mCost		'PVCost',
	S.mLatestCost	'LatestCost',
	S.mPriceLevel1  'RetailPrice',
	--S.mMAP			'MAPPrice',
	ISNULL(CPSales.QtySoldCP,0) 'QtySoldCP', 
	ISNULL(CPSales.SalesCP,0) 'SalesCP',   
    ISNULL(CPSales.CoGSCP,0) 'CoGSCP',   
	ISNULL(PPSales.QtySoldPP,0) 'QtySoldPP', 
	ISNULL(PPSales.SalesPP,0) 'SalesPP',  
    ISNULL(PPSales.CoGSPP,0) 'CoGSPP',   
    /*
    BOMU.BOM12MoUsage 'BOMUsage12Mo',
    BOMU2YR.BOM24MoUsage 'BOMUsage24Mo',
    */
    CONVERT(VARCHAR,S.dtCreateDate, 1) AS 'CreateDate' ,
	/*
    ISNULL(SKULL.iQOS,0)			'QOS',
	ISNULL(vwQO.QTYOutstanding,0)	'OPO',
	ISNULL(SKULL.iQOS,0)+ISNULL(vwQO.QTYOutstanding,0) 'QOS+OPO',
    */
	(CASE When S.flgActive = 1 then 'Y'
		ELSE 'N'
		END) 'Active',
    S.ixBrand,
    B.sBrandDescription,
    BS.sPickingBin,
    S.ixPGC,
    PGC.sDescription 'PGCDescription',
    S.sSEMACategory,
    S.sSEMASubCategory,
    S.sSEMAPart
FROM tblSKU S
	JOIN tblVendorSKU VS on S.ixSKU = VS.ixSKU --and iOrdinality = 1
	LEFT JOIN tblVendorSKU PV on S.ixSKU = PV.ixSKU and PV.iOrdinality = 1
	LEFT JOIN tblVendor V on PV.ixVendor = V.ixVendor
    LEFT JOIN tblBrand B on S.ixBrand = B.ixBrand
    LEFT JOIN tblBinSku BS on S.ixSKU = BS.ixSKU and BS.ixLocation = 99
    LEFT JOIN tblPGC PGC on S.ixPGC = PGC.ixPGC
	LEFT JOIN (-- Current Period Sales & Qty Sold
				SELECT OL.ixSKU
					,SUM(OL.iQuantity) AS 'QtySoldCP', SUM(OL.mExtendedPrice) 'SalesCP', SUM(OL.mExtendedCost) 'CoGSCP'
				FROM tblOrderLine OL 
					join tblDate D on D.dtDate = OL.dtOrderDate 
				WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
					and D.dtDate between @CPStartDate and @CPEndDate
				GROUP BY OL.ixSKU
				) CPSales on CPSales.ixSKU = S.ixSKU 
	LEFT JOIN (-- Previous Period Sales & Qty Sold
				SELECT OL.ixSKU
					,SUM(OL.iQuantity) AS 'QtySoldPP', SUM(OL.mExtendedPrice) 'SalesPP', SUM(OL.mExtendedCost) 'CoGSPP'
				FROM tblOrderLine OL 
					join tblDate D on D.dtDate = OL.dtOrderDate 
				WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
					and D.dtDate between @PPStartDate and @PPEndDate
				GROUP BY OL.ixSKU
				) PPSales on PPSales.ixSKU = S.ixSKU 
WHERE S.flgDeletedFromSOP = 0
--	and VS.ixVendor in (@Vendor) -- ('0325','0326')
ORDER BY PV.ixVendor, S.ixSKU