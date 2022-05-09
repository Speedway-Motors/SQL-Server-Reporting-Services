-- BOM Returns for Dave
SELECT DISTINCT  S.ixSKU, ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', 
    V.ixVendor 'PV#', V.sName 'PVName',
    SALES.QtySold12Mo '12MoQtySold',
    SUM(CMD.iQuantityCredited) '12MoQtyReturned' -- sometimes we credit them and they don't have to send them back because of high postage $
FROM tblSKU S
    LEFT JOIN tblVendorSKU VS on VS.ixSKU = S.ixSKU
                                    and VS.iOrdinality = 1
    LEFT JOIN tblVendor V on VS.ixVendor = V.ixVendor
    LEFT JOIN tblBOMTemplateMaster TM on S.ixSKU = TM.ixFinishedSKU
    LEFT JOIN tblCreditMemoDetail CMD on CMD.ixSKU = S.ixSKU
    LEFT JOIN tblCreditMemoMaster CMM on CMM.ixCreditMemo = CMD.ixCreditMemo
    LEFT JOIN (-- 12 Mo SALES & QTY SOLD
                SELECT OL.ixSKU,SUM(OL.iQuantity) AS 'QtySold12Mo', 
                    SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                FROM tblOrderLine OL 
                    LEFT JOIN tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                GROUP BY OL.ixSKU
                ) SALES on SALES.ixSKU = S.ixSKU  
WHERE S.flgDeletedFromSOP = 0
    and S.flgActive = 1
    and VS.ixVendor in ('0001','0940','0945','0916','0555','0950','0955')       -- 16,549
    and TM.ixFinishedSKU is NOT NULL -- only SKUs that are finished SKUs (BOMs) --  9,966
    and CMM.dtCreateDate between '10/27/2019' and '10/26/2020'
    and CMD.ixSKU is NOT NULL  -- have returns                                  
    and CMM.flgCanceled = 0                                                     --  1,367
    and TM.mSMIShopLabor > 0
GROUP BY S.ixSKU, ISNULL(S.sWebDescription, S.sDescription), 
    V.ixVendor, V.sName,
    SALES.QtySold12Mo
ORDER BY SALES.QtySold12Mo desc






