-- SMIHD-11968 - SKU CARB Information
-- ver 18.39.1
                                    
-- LAST RUN, RESULTS WERE PLACED IN "" 
SELECT SL.ixSKU
    , VS.sVendorSKU 'VendorSKU'
    , S.ixOriginalPart
    , ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription'
    , S.ixBrand
    , B.sBrandDescription 'BrandDescription'
    , V.ixVendor 'PrimaryVendor'
    , V.sName 'PVName'
    , S.mPriceLevel1
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
   -- , ISNULL(SALES.Sales12Mo,0) 'Sales12Mo'  
    , ISNULL(SALES.QtySold12Mo,0) 'QtySold12Mo'  
    --, ISNULL(BOMU.BOM12MoUsage,0) 'BOM12MoUsage'
    , SL.sPickingBin 'PickingBin'
    , ISNULL(vwQO.QTYOutstanding,0) 'OpenPOQtyExpected'
    , PO.FirstPOIssued
    , PO.LastPOIssued
    , (CASE WHEN BT.ixFinishedSKU IS NOT NULL THEN 'Y'
       ELSE 'N'
       END) 'BOMFinishedSKU'
    , (CASE WHEN GS.ixSKU IS NULL THEN 'N'
       ELSE 'Y'
       END) 'GSSKUBasedOnPGC'
    , (S.iLength * S.iWidth * iHeight ) 'UnitCI' -- Cubic Inches
    , SL.iQOS 'QtyOnShelf'
    , SL.iQAV 'QtvAvailableForSale'
    , ISNULL(QA.QtyInQA,0) 'QtyInQA'
    , SL.iQCB 'QtyCommittedToBackorders'
    , SL.iQCBOM 'QtyCommittedToBOMs'
    , (SL.iQOS-SL.iQAV-SL.iQCB-SL.iQCBOM-ISNULL(QA.QtyInQA,0)) 'QtyOtherStatus'
    , (CASE WHEN S.flgProp65 IS NULL THEN NULL
        WHEN S.flgProp65 = 1 THEN 'Y'
        WHEN S.flgProp65 = 0 THEN 'N'
        ELSE 'UK'
        END) 'flgProp65'
FROM tblSKULocation SL
    LEFT JOIN tblSKU S on SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU
    LEFT JOIN tblVendorSKU VS on S.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    LEFT JOIN tblVendor V on VS.ixVendor = V.ixVendor
    LEFT JOIN vwDropshipOnlySKU DS on SL.ixSKU = DS.ixSKU
    LEFT JOIN tblBrand B on B.ixBrand = S.ixBrand
	LEFT JOIN (-- 12 Mo Sales & Qty Sold
                SELECT OL.ixSKU
	                ,SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                FROM tblOrderLine OL 
	                join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
	                and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                GROUP BY OL.ixSKU
                ) SALES on SALES.ixSKU = S.ixSKU 
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
    LEFT JOIN (-- FIFO Value
               SELECT FD.ixSKU,sum(FD.iFIFOQuantity*convert(money,FD.mFIFOCost)) as 'FIFOCost'
               FROM tblFIFODetail FD
                   LEFT JOIN tblDate D on FD.ixDate = D.ixDate
               WHERE D.dtDate = DATEADD(d, -1, {fn CURRENT_DATE()}) -- Yesterday (the latest date in tblFifoDetail)  -- '06/30/2018'
               GROUP BY FD.ixSKU
               ) FIFO on S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = FIFO.ixSKU
    LEFT JOIN (-- FIFO Value by Vendor
               SELECT VS.ixVendor,sum(FD.iFIFOQuantity*convert(money,FD.mFIFOCost)) as 'TotVendorFIFOCost'
               FROM tblFIFODetail FD
                   LEFT JOIN tblDate D on FD.ixDate = D.ixDate
                   LEFT join tblVendorSKU VS on VS.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = FD.ixSKU and VS.iOrdinality = 1
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
    LEFT JOIN tblBOMTemplateMaster BT on BT.ixFinishedSKU = S.ixSKU
    LEFT JOIN (-- Qty in QC
                SELECT ixSKU, SUM(BS.iSKUQuantity)'QtyInQA'
                FROM tblBinSku BS
                    left join tblBin B on BS.ixBin = B.ixBin
                where B.sBinType in ('QANC', 'QA')
                    and BS.ixLocation = 99
                group by BS.ixSKU
                ) QA ON QA.ixSKU = S.ixSKU
WHERE SL.ixLocation = 99
  --  and SL.iQOS > 0
  and S.flgDeletedFromSOP = 0                          
  --  and ISNULL(SALES.QtySold12Mo,0) > 0                  
   -- and ISNULL(BOMU.BOM12MoUsage,0) = 0                  -- 26,736
/* TEMP CONDITIONS FOR TESTING ONLY
   AND S.mPriceLevel1 > 0
   AND SL.sPickingBin <> 'BOM'
   AND S.flgActive = 1
*/
 -- AND V.ixVendor <= '2095'
 AND V.ixVendor > '2095'
  -- AND S.flgProp65 IS NULL -- EXCLUDING SKUS that already have a Prop65 value
ORDER BY V.ixVendor, S.ixSKU 