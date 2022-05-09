-- SMIHD-9824 - Inventory by Vendor Report

/*
mimic a current SOP report.  Basically the CSV format it exports in does not play well with leading and trailing zeros which some of our vendor part numbers contain.

This report exports all SKUs in SOP based on a given vendor number. 
It then asks if you would like all SKUS on which this vendor # appears, 
or only SKUS where this V# is the prime vendor.

needs to include the following info:

SMI SKU
Description
Vendor Part Number
Primary V#
Primary Vendor Name
Primary Vendor Cost
Last Cost
Current Retail Price (Level 1 Inventory)
MAP price (If available)
12 mo Qty Sold
12 mo Sales $

If possible, it would also be nice to be able to enter multiple vendor numbers simultaneously 
as many vendors have a stocking and dropship account number.
*/
SELECT ixSKU, sum(iQuantity) FROM tblOrderLine
where ixShippedDate >= 18264
group by ixSKU
having  sum(iQuantity) > 100 


SELECT ixVendor, count(ixSKU)
from tblVendorSKU
where sVendorSKU like '0%'
group by ixVendor
having count(ixSKU) > 100


select count(*)
from tblSKU
where flgDeletedFromSOP = 0
	and flgActive = 1
	and mMAP is NOT NULL    -- 217k NULL    49k NOT NULL

select top 10* from tblSKULocation


/* SMIHD-9824 - Inventory by Vendor Report
	ver 18.5.1

DECLARE @Vendor varchar(500)
SELECT @Vendor = '0329' -- '0330'
*/
SELECT S.ixSKU,
	ISNULL(S.sWebDescription, S.sDescription) 'Description',
	PV.sVendorSKU	'PVSKU',
	PV.ixVendor		'PV',
	V.sName			'PVName',
	PV.mCost		'PVCost',
	S.mLatestCost	'LatestCost',
	S.mPriceLevel1  'RetailPrice',
	S.mMAP			'MAPPrice',
	SALES.QtySold12Mo, -- ISNULL(SALES.QtySold12Mo,0) 'QtySold12Mo',
	SALES.Sales12Mo,   -- ISNULL(SALES.Sales12Mo,0)   'Sales12Mo',
	ISNULL(SKULL.iQOS,0)			'QOS',
	ISNULL(vwQO.QTYOutstanding,0)	'OPO',
	ISNULL(SKULL.iQOS,0)+ISNULL(vwQO.QTYOutstanding,0) 'QOS+OPO',
	(CASE When S.flgActive = 1 then 'Y'
		ELSE 'N'
		END) 'Active'
FROM tblSKU S
	JOIN tblVendorSKU VS on S.ixSKU = VS.ixSKU --and iOrdinality = 1
	LEFT JOIN tblVendorSKU PV on S.ixSKU = PV.ixSKU and PV.iOrdinality = 1
	LEFT JOIN tblVendor V on PV.ixVendor = V.ixVendor
	LEFT JOIN (-- 12 Mo QTY SOLD
				SELECT OL.ixSKU
					,SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
				FROM tblOrderLine OL 
					join tblDate D on D.dtDate = OL.dtOrderDate 
				WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
					and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
				GROUP BY OL.ixSKU
				) SALES on SALES.ixSKU = S.ixSKU 
	LEFT JOIN vwSKULocalLocation AS SKULL ON SKULL.ixSKU = S.ixSKU
	LEFT JOIN vwSKUQuantityOutstanding vwQO on S.ixSKU = vwQO.ixSKU
WHERE S.flgDeletedFromSOP = 0
	and VS.ixVendor in (@Vendor) -- ('0329','0330')-- (@Vendor)
ORDER BY PV.ixVendor, S.ixSKU

/*   NOT NEEDED
UNION
	-- NON-Primary Vendor
	SELECT S.ixSKU,
		ISNULL(S.sWebDescription, S.sDescription) 'Description',
		VS.sVendorSKU 'VendorSKU',
		NULL AS 'PV',
		NULL AS 'PVName',
		--VS.ixVendor as 'NON-PVVendor',
		ISNULL(SKULL.iQOS,0) 'QOS',
		ISNULL(vwQO.QTYOutstanding,0) AS 'OPO',
		ISNULL(SKULL.iQOS,0)+ISNULL(vwQO.QTYOutstanding,0) 'QOS+OPO',
		VS.mCost'PVCost',
		S.mLatestCost,
		S.mPriceLevel1 'RetailPrice',
		S.mMAP 'MAPPrice',
		SALES.QtySold12Mo,
		SALES.Sales12Mo
	FROM tblSKU S
		JOIN tblVendorSKU VS on S.ixSKU = VS.ixSKU and iOrdinality > 1
		LEFT JOIN tblVendor V on VS.ixVendor = V.ixVendor
		LEFT JOIN (-- 12 Mo QTY SOLD
					SELECT OL.ixSKU
						,SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
					FROM tblOrderLine OL 
						join tblDate D on D.dtDate = OL.dtOrderDate 
					WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
						and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
					GROUP BY OL.ixSKU
					) SALES on SALES.ixSKU = S.ixSKU 
		LEFT JOIN vwSKULocalLocation AS SKULL ON SKULL.ixSKU = S.ixSKU
		LEFT JOIN vwSKUQuantityOutstanding vwQO on S.ixSKU = vwQO.ixSKU
	WHERE S.flgDeletedFromSOP = 0
		and VS.ixVendor in ('0329','0330')-- 20
*/
ORDER BY VS.sVendorSKU





