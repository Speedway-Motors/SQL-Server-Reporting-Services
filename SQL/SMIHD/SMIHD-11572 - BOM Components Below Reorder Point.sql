-- SMIHD-11572 - BOM Components Below Reorder Point
SELECT distinct 
    TD.ixSKU, --.ixFinishedSKU,
    ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
    V.ixBuyer 'Buyer',
    VS.ixVendor 'PVNum', 
    V.sName 'PVName',
    SL.iQOS,
    SL.iQCB, -- QC Orders?
    SL.iQCBOM,
    SL.iQAV,
    ISNULL(SALES.QtySold12Mo,0) 'QtySold12Mo',
    ISNULL(BOMYTD.TotalQty,0) 'BOM12MoQty',
    ISNULL(BOMYTD.TotalQty,0) + ISNULL(SALES.QtySold12Mo,0) 'TotalConsumption12Mo',
    (ISNULL(BOMYTD.TotalQty,0) + ISNULL(SALES.QtySold12Mo,0))/365.0 'ConsumptionPerDay', -- min 4 decimal places needed
    S.iLeadTime 'LeadTime',
    ISNULL(PO.POQty,0) 'POQty', -- sum QTY ON all Pos PO
    (((ISNULL(BOMYTD.TotalQty,0) + ISNULL(SALES.QtySold12Mo,0))/365.0)*S.iLeadTime) 'ReorderPoint', -- REORDER POINT = (12MoTotalConsumption/365)*LeadTime
    --S.iRestockPoint 'RestockPointSOP'   ,                                                         
 -- ((  QAV   +       QtyOnPO)     *365) / (               Tot12MoConsumption                    ) <-- StockOutDays formula to use below
    ((SL.iQAV + ISNULL(PO.POQty,0))*365) / (ISNULL(BOMYTD.TotalQty,0)+ISNULL(SALES.QtySold12Mo,0)) 'StockOutDays' , 
    S.dtCreateDate 'SKUCreated'
FROM tblBOMTemplateDetail TD
    LEFT JOIN tblBOMTemplateMaster TM on TM.ixFinishedSKU = TD.ixFinishedSKU --  12,638 SKU components.... currently 4,500 of them have 0 QAV,QOS AND QCBOM
    LEFT JOIN tblSKULocation SL on TD.ixSKU = SL.ixSKU and SL.ixLocation = 99
    LEFT JOIN tblSKU S on TD.ixSKU = S.ixSKU
   -- LEFT JOIN tblSKU S2 on TD.ixFinishedSKU = S2.ixSKU
    LEFT JOIN(-- BOM USAGE 12 Months
          SELECT ST.ixSKU AS ixSKU
               , ISNULL(SUM(ST.iQty),0) * -1 AS TotalQty 
		  FROM tblSKUTransaction ST 
		  LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
		  WHERE D.dtDate BETWEEN DATEADD(yy, -1, GETDATE()) AND GETDATE()
		    AND ST.sTransactionType = 'BOM' 
			AND ST.iQty < 0
	      GROUP BY ST.ixSKU
	      ) BOMYTD ON BOMYTD.ixSKU  = TD.ixSKU
    LEFT JOIN (-- 12 Mo SALES & Quantity Sold
                SELECT OL.ixSKU
                    ,SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                FROM tblOrderLine OL 
                    join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                GROUP BY OL.ixSKU
                ) SALES on SALES.ixSKU = TD.ixSKU
    LEFT JOIN tblVendorSKU VS on VS.ixSKU = TD.ixSKU and VS.iOrdinality = 1
    LEFT JOIN tblVendor V on VS.ixVendor = V.ixVendor
    LEFT JOIN (SELECT POD.ixSKU, POM.ixPO 
                    , SUM(POD.iQuantity - ISNULL(POD.iQuantityReceivedPending,0) - ISNULL(POD.iQuantityPosted,0)) AS POQty -- outstanding PO Qty
                    , MIN(D.dtDate) AS ExpectedDelivery
                    , MIN(D2.dtDate) AS NotifyDate
		       FROM tblPODetail POD 
		       LEFT JOIN tblDate D ON D.ixDate = POD.ixExpectedDeliveryDate 
		       JOIN tblPOMaster POM ON POM.ixPO COLLATE SQL_Latin1_General_CP1_CS_AS = POD.ixPO COLLATE SQL_Latin1_General_CP1_CS_AS
                            AND POM.flgIssued = 1
                            AND POM.flgOpen = 1
		       LEFT JOIN tblDate D2 ON D2.ixDate = POM.ixNotifyDate  
               GROUP BY POD.ixSKU , POM.ixPO
               HAVING SUM(POD.iQuantity - ISNULL(POD.iQuantityReceivedPending,0) - ISNULL(POD.iQuantityPosted,0)) > 0 
               ) PO ON PO.ixSKU = TD.ixSKU  
WHERE TD.flgDeletedFromSOP = 0
    and V.ixBuyer = 'KDL' -- @Buyer (default to all)
    and VS.ixVendor NOT IN ('0009','0012','0999','1352','2110','2231','2242') -- list provided by KDL (mostly/all? labor SKUS)
    and TM.flgDeletedFromSOP = 0
    and S.flgDeletedFromSOP = 0
    and S.flgActive = 1 -- 12,008
    and ISNULL(BOMYTD.TotalQty,0) + ISNULL(SALES.QtySold12Mo,0) > 0
    and SL.iQAV+ISNULL(PO.POQty,0) < (((ISNULL(BOMYTD.TotalQty,0) + ISNULL(SALES.QtySold12Mo,0))/365.0)*S.iLeadTime)*1.25
   -- and TD.ixSKU in ('91003915','91003914','91086012','91003937','100219','101-5/16')
--   and (SL.iQAV+ ISNULL(PO.POQty,0)) < (((ISNULL(BOMYTD.TotalQty,0) + ISNULL(SALES.QtySold12Mo,0))/365.0)*S.iLeadTime) --  2694 out of 8183
/*   
     and SL.iQAV = 0 -- 4,676
     and ISNULL(PO.POQty,0) = 0
    and SL.iQOS = 0 -- 5,091
    and SL.iQCBOM = 0
    and 
*/
ORDER BY VS.ixVendor, 
    ((SL.iQAV + ISNULL(PO.POQty,0))*365) / (ISNULL(BOMYTD.TotalQty,0)+ISNULL(SALES.QtySold12Mo,0)) -- stock out days
    -- S.iLeadTime --'TotalConsumption12Mo' desc
    -- BOMYTD.TotalQty
    -- YTD.YTDQTYSold

/*
4,500 of them have 0 QAV,QOS AND QCBOM
    OF THOSE:   2,900 have no 12 month BOM consumption
                4,300 have no 12 month sales (overlaps with above group)
        

SELECT * FROM vwAdjustedDailySKUSales
WHERE ixSKU = 'M2R1.75E01F'



SELECT *
FROM tblBOMTemplateMaster TM
WHERE flgDeletedFromSOP = 0
 and ixFinishedSKU IN (Select ixSKU FROM tblSKU WHERE flgDeletedFromSOP = 1)
ORDER BY dtDateLastSOPUpdate



*/

SELECT ixSKU, iQuantity, flgLineStatus, ixShippedDate
FROM tblOrderLine OL
WHERE ixSKU = 'M2R1.75E01F'
    and ixShippedDate > 18119


SELECT ixVendor, sName, iShortestLeadTime,	iLongestLeadTime,	iExpectedLeadTime
FROM tblVendor
WHERE iLeadTime is NOT NULL

SELECT ixSKU, iLeadTime, iRestockPoint
FROM tblSKU
WHERE flgDeletedFromSOP = 0
and flgActive = 1
ORDER BY iRestockPoint
