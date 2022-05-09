-- SMIHD-11010 - Slow Moving Inventory
/*   */
DECLARE @StartDate datetime,        @EndDate datetime,      @QtySoldLessThan int,   @ExcludeSKUsCreatedAfter datetime
SELECT  @StartDate = '07/05/17',    @EndDate = '07/04/18',  @QtySoldLessThan = 10,  @ExcludeSKUsCreatedAfter = '04/01/18'

SELECT SL.ixSKU
    , VS.sVendorSKU 'VendorSKU'
    , ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription'
    , S.ixBrand
    , B.sBrandDescription 'BrandDescription'
    , V.ixVendor 'PrimaryVendor'
    , V.sName 'PVName'
    , S.mPriceLevel1
    , FIFO.FIFOCost
    , FVBV.TotVendorFIFOCost
    , (FIFO.FIFOCost/NULLIF(FVBV.TotVendorFIFOCost,0)) 'PercentOfVendorFIFO'
    , S.dtCreateDate
    , S.dtDiscontinuedDate
    , S.flgActive
    , S.flgIntangible
    , S.flgUnitOfMeasure
    , S.flgIsKit
    , S.flgMadeToOrder
    , S.sSEMACategory 'SEMACategory'
    , S.sSEMASubCategory 'SEMASubCat'
    , S.sSEMAPart 'SEMAPart'
    ,(CASE WHEN DS.ixSKU is NOT NULL then 'Y'
      ELSE 'N'
      END) 'DropshipOnly'
    , ISNULL(SALES.QtySold12Mo,0) 'QtySold12Mo'  
    , ISNULL(BOMU.BOM12MoUsage,0) 'BOM12MoUsage'
    , LS.LastSold
    , SL.sPickingBin 'PickingBin'
    , ISNULL(vwQO.QTYOutstanding,0) 'OpenPOQtyExpected'
    , PO.FirstPOIssued
    , PO.LastPOIssued
    , (CASE WHEN GS.ixSKU IS NULL THEN 'N'
       ELSE 'Y'
       END) 'GSSKUBasedOnPGC'
    , S.ixCreator
    , S.ixProposer
    , S.ixAnalyst
    , S.ixMerchant
    , S.ixBuyer
    -- weights & volume
    , S.iLength
    , S.iWidth
    , S.iHeight
    , (S.iLength * S.iWidth * iHeight ) 'UnitCI' -- Cubic Inches
    , ((S.iLength * S.iWidth * iHeight )* SL.iQOS) 'ExtCI' -- Cubic Inches
    , ((S.iLength * S.iWidth * iHeight )* SL.iQOS)/1728 'TotalCubicFeet'-- Cubic Feet
    , S.dWeight
    , S.dDimWeight
    , SL.iQOS 'QtyOnShelf'
    , SL.iQAV 'QtvAvailableForSale'
    , ISNULL(QA.QtyInQA,0) 'QtyInQA'
    , SL.iQCB 'QtyCommittedToBackorders'
    , SL.iQCBOM 'QtyCommittedToBOMs'
    , (SL.iQOS-SL.iQAV-SL.iQCB-SL.iQCBOM-ISNULL(QA.QtyInQA,0)) 'QtyOtherStatus'
FROM tblSKULocation SL
    LEFT JOIN tblSKU S on SL.ixSKU = S.ixSKU
    LEFT JOIN tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    LEFT JOIN tblVendor V on VS.ixVendor = V.ixVendor
    LEFT JOIN vwDropshipOnlySKU DS on SL.ixSKU = DS.ixSKU
    LEFT JOIN tblBrand B on B.ixBrand = S.ixBrand
	LEFT JOIN (-- Sales & Qty Sold
                SELECT OL.ixSKU
	                ,SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                FROM tblOrderLine OL 
	                join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
	                and D.dtDate between @StartDate and @EndDate --DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                GROUP BY OL.ixSKU
                ) SALES on SALES.ixSKU = S.ixSKU 
    LEFT JOIN (-- 12 Month BOM USAGE
                SELECT BOMTD.ixSKU
                    , isnull(SUM(CAST(BOMTD.iQuantity AS INT)*CAST(BOMTM.iCompletedQuantity AS INT)),0) 'BOM12MoUsage' 
                FROM tblBOMTransferMaster BOMTM 
                    join tblBOMTransferDetail BOMTD on BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
                    join tblDate D on D.ixDate = BOMTM.ixCreateDate
                WHERE D.dtDate between @StartDate and @EndDate -- DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                    and BOMTM.flgReverseBOM = 0 -- exclude reverse BOMs
                GROUP BY BOMTD.ixSKU
                ) BOMU on BOMU.ixSKU = S.ixSKU
    LEFT JOIN (-- FIFO Value
               SELECT FD.ixSKU,sum(FD.iFIFOQuantity*convert(money,FD.mFIFOCost)) as 'FIFOCost'
               FROM tblFIFODetail FD
                   LEFT JOIN tblDate D on FD.ixDate = D.ixDate
               WHERE D.dtDate = DATEADD(d, -1, {fn CURRENT_DATE()}) -- Yesterday (the latest date in tblFifoDetail)  -- '05/31/2018'
               GROUP BY FD.ixSKU
               ) FIFO on S.ixSKU = FIFO.ixSKU
    LEFT JOIN (-- FIFO Value by Vendor
               SELECT VS.ixVendor,sum(FD.iFIFOQuantity*convert(money,FD.mFIFOCost)) as 'TotVendorFIFOCost'
               FROM tblFIFODetail FD
                   LEFT JOIN tblDate D on FD.ixDate = D.ixDate
                   LEFT join tblVendorSKU VS on VS.ixSKU = FD.ixSKU and VS.iOrdinality = 1
               WHERE D.dtDate = DATEADD(d, -1, {fn CURRENT_DATE()})
               GROUP BY VS.ixVendor
               ) FVBV on VS.ixVendor = FVBV.ixVendor
    LEFT JOIN vwSKUQuantityOutstanding vwQO on S.ixSKU = vwQO.ixSKU -- Qty expected on Open POs
    LEFT JOIN (-- First & last PO
               SELECT POD.ixSKU
                    ,MIN(D1.dtDate) 'FirstPOIssued'
                    ,MAX(D1.dtDate) 'LastPOIssued'
               FROM tblPODetail POD
	                left join tblPOMaster POM on POM.ixPO = POD.ixPO
                    left join tblDate D1 on D1.ixDate = POM.ixIssueDate
                WHERE POM.flgIssued = '1' 
                GROUP BY POD.ixSKU
                ) PO on PO.ixSKU = S.ixSKU
    LEFT JOIN vwGarageSaleSKUs GS on S.ixSKU = GS.ixSKU
    LEFT JOIN (-- Qty in QC
                SELECT ixSKU, SUM(BS.iSKUQuantity)'QtyInQA'
                FROM tblBinSku BS
                    left join tblBin B on BS.ixBin = B.ixBin
                where B.sBinType in ('QANC', 'QA')
                    and BS.ixLocation = 99
                group by BS.ixSKU
                ) QA ON QA.ixSKU = S.ixSKU
   	LEFT JOIN (-- LAST SOLD
                SELECT OL.ixSKU
	                ,MAX(dtOrderDate) 'LastSold'
                FROM tblOrderLine OL 
	                join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                GROUP BY OL.ixSKU
                ) LS on LS.ixSKU = S.ixSKU 
    --LEFT JOIN (-- Qty in LOST type bins
WHERE SL.ixLocation = 99
    and SL.iQOS > 0
    and S.flgDeletedFromSOP = 0                          
    and ISNULL(SALES.QtySold12Mo,0) < @QtySoldLessThan                  
    and ISNULL(BOMU.BOM12MoUsage,0) = 0                  -- 26,736
    and S.dtCreateDate <= @ExcludeSKUsCreatedAfter-- DATEADD(yy, -1, getdate())     -- 20,852
/* TEMP CONDITIONS FOR TESTING ONLY
   AND S.mPriceLevel1 > 0
   AND SL.sPickingBin <> 'BOM'
   AND S.flgActive = 1
*/
ORDER BY FIFO.FIFOCost DESC
    -- S.dtCreateDate -- 
    -- (SL.iQOS-SL.iQAV-SL.iQCB-SL.iQCBOM-ISNULL(QA.QtyInQA,0)) desc
    -- ISNULL(QA.QtyInQA,0) DESC


 /*
 SELECT * FROM tblKit
 where ixSKU in ('91032207-3','91032207-1','91032207-2','91034313.2-L','55099-1','91031025','91015592X-DRV','91050163','91050700-1','91007300-STL-1','91015592X-PASS','91668008.1','91032277-1')


select top 10 * from tblSKULocation
select top 10 * from tblBinSku
select top 10 * from tblFIFODetail
SELECT TOP 10 * FROM tblPOMaster

SELECT FD.ixSKU,sum(FD.iFIFOQuantity*convert(money,FD.mFIFOCost)) as 'FIFOCost'
-- *convert(money, SKU.mPriceLevel1
FROM tblFIFODetail FD
    LEFT JOIN tblDate D on FD.ixDate = D.ixDate
WHERE D.dtDate = '05/22/2018'
GROUP BY FD.ixSKU
-- FROM Inventory By Vendor.rdl
/* Inventory by Vendor.rdl
	ver 18.14.1 - SMIHD-9824

DECLARE @Vendor varchar(500)
SELECT @Vendor = '0416' -- '0330' -- '0330'
    */
SELECT DISTINCT S.ixSKU,
	ISNULL(S.sWebDescription, S.sDescription) 'Description',   -- 271 for vendor 0330
	PV.sVendorSKU	'PVSKU',
	PV.ixVendor		'PV',
	V.sName			'PVName',
	PV.mCost		'PVCost',
	S.mLatestCost	'LatestCost',
	S.mPriceLevel1  'RetailPrice',
	S.mMAP			'MAPPrice',
	SALES.QtySold12Mo, -- ISNULL(SALES.QtySold12Mo,0) 'QtySold12Mo',
	SALES.Sales12Mo,   -- ISNULL(SALES.Sales12Mo,0)   'Sales12Mo',
	SALES2YR.QtySold24Mo, -- ISNULL(SALES.QtySold12Mo,0) 'QtySold12Mo',
	SALES2YR.Sales24Mo,   -- ISNULL(SALES.Sales12Mo,0)   'Sales12Mo',
    BOMU.BOM12MoUsage 'BOMUsage12Mo',
    BOMU2YR.BOM24MoUsage 'BOMUsage24Mo',
    CONVERT(VARCHAR,S.dtCreateDate, 1) AS 'CreaeDate' ,
	ISNULL(SKULL.iQOS,0)			'QOS',
	ISNULL(vwQO.QTYOutstanding,0)	'OPO',
	ISNULL(SKULL.iQOS,0)+ISNULL(vwQO.QTYOutstanding,0) 'QOS+OPO',
	(CASE When S.flgActive = 1 then 'Y'
		ELSE 'N'
		END) 'Active',
    S.ixBrand,
    B.sBrandDescription
FROM tblSKU S
	JOIN tblVendorSKU VS on S.ixSKU = VS.ixSKU --and iOrdinality = 1
	LEFT JOIN tblVendorSKU PV on S.ixSKU = PV.ixSKU and PV.iOrdinality = 1
	LEFT JOIN tblVendor V on PV.ixVendor = V.ixVendor
    LEFT JOIN tblBrand B on S.ixBrand = B.ixBrand
	LEFT JOIN (-- 12 Mo Sales & Qty Sold
				SELECT OL.ixSKU
					,SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
				FROM tblOrderLine OL 
					join tblDate D on D.dtDate = OL.dtOrderDate 
				WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
					and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
				GROUP BY OL.ixSKU
				) SALES on SALES.ixSKU = S.ixSKU 
	LEFT JOIN (-- 13-24 Mo Sales & Qty Sold
				SELECT OL.ixSKU
					,SUM(OL.iQuantity) AS 'QtySold24Mo', SUM(OL.mExtendedPrice) 'Sales24Mo', SUM(OL.mExtendedCost) 'CoGS24Mo'
				FROM tblOrderLine OL 
					join tblDate D on D.dtDate = OL.dtOrderDate 
				WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
					and D.dtDate between DATEADD(yy, -2, getdate()) and DATEADD(yy, -1, getdate()) -- 2 YR AGO and 1 YR AGO
				GROUP BY OL.ixSKU
				) SALES2YR on SALES2YR.ixSKU = S.ixSKU 
    LEFT JOIN (-- 12 Month BOM USAGE
                SELECT BOMTD.ixSKU
                    , isnull(SUM(CAST(BOMTD.iQuantity AS INT)*CAST(BOMTM.iCompletedQuantity AS INT)),0) 'BOM12MoUsage' 
                FROM tblBOMTransferMaster BOMTM 
                    join tblBOMTransferDetail BOMTD on BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
                    join tblDate D on D.ixDate = BOMTM.ixCreateDate
                WHERE D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                    and BOMTM.flgReverseBOM = 0 -- exclude reverse BOMs
                GROUP BY BOMTD.ixSKU
                ) BOMU on BOMU.ixSKU = S.ixSKU
    LEFT JOIN (-- 13-24 Month BOM USAGE
                SELECT BOMTD.ixSKU
                    , isnull(SUM(CAST(BOMTD.iQuantity AS INT)*CAST(BOMTM.iCompletedQuantity AS INT)),0) 'BOM24MoUsage' 
                FROM tblBOMTransferMaster BOMTM 
                    join tblBOMTransferDetail BOMTD on BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
                    join tblDate D on D.ixDate = BOMTM.ixCreateDate
                WHERE D.dtDate between DATEADD(yy, -2, getdate()) and DATEADD(yy, -1, getdate()) -- 2 YR AGO and 1 YR AGO
                    and BOMTM.flgReverseBOM = 0 -- exclude reverse BOMs
                GROUP BY BOMTD.ixSKU
                ) BOMU2YR on BOMU2YR.ixSKU = S.ixSKU
	LEFT JOIN vwSKULocalLocation AS SKULL ON SKULL.ixSKU = S.ixSKU
	LEFT JOIN vwSKUQuantityOutstanding vwQO on S.ixSKU = vwQO.ixSKU
WHERE S.flgDeletedFromSOP = 0
	and VS.ixVendor in (@Vendor) -- ('0325','0326') 
ORDER BY PV.ixVendor, S.ixSKU


*/


