-- SMIHD-8165 - P0 and QOH Reconciliation Report

-- MOCK-UP example      PO# 123309
/*                                                          Qty         12 Mo.  Inventory
Line	Qty	Unit	Part #	    Description	                Avaiable	Sale    Left (Mo.)
1	    50	EA	    917-340-22	SPEEDWAY DBL.PASS -CHEVY	X	        Y	    9
2	    150	EA	    917-340-24	SPEEDWAY DBL.PASS RADIATOR			    4
3	    250	EA	    917-340-26	SPEEDWAY DBL.PASS RADIATOR			    4
*/

SELECT * from tblPOMaster where ixPO = '123309'
/*
ixPO	ixPODate	ixIssueDate	ixIssuer	ixBuyer	ixVendor	sShipToName	sShipToAddress1	sShipToAddress2	sShipToCSZ	sShipVia	sPaymentTerms	sFreightTerms	sNotes	flgBlanket	sBillToName	sBillToAddress1	sBillToAddress2	sBillToCSZ	sMessage1	sMessage2	sMessage3	sMessage4	sMessage5	sEmailAddress	flgIssued	flgOpen	ixVendorConfirmDate	ixVendorConfirmEmployee	ixNotifyDate	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
123309	18089	18089	JDS	JDS	2895	SPEEDWAY MOTORS, INC.	340 VICTORY LANE	NULL	LINCOLN, NEBRASKA 68528	OCEAN	PrePayment Required	PrePayment Required	NULL	0	SPEEDWAY MOTORS	PO BOX 81906	NULL	LINCOLN, NE 68501	NULL	NULL	NULL	NULL	NULL	JDSMITH@speedwaymotors.com	1	1	18089	JDS	NULL	2017-09-29 00:00:00.000	35146
*/



/* PO QAV Reconciliation.rdl
    ver 17.40.1

DECLARE @PO varchar(10)
SELECT  @PO = '123309'  
 */   
SELECT POM.ixPO 'PO'
    ,CONVERT(VARCHAR,D.dtDate, 101) AS 'IssueDate'
    ,POM.ixVendor 'Vendor'
    , V.sName 'VendorName'
    ,POD.iOrdinality 'Line'
    ,POD.iQuantity 'QtyOrdered'
    ,POD.ixUnitofMeasurement 'Unit'
    ,POD.ixSKU
    ,S.sDescription 'SKUDescription'
    ,SKUM.iQAV 'QtyAv'
    ,ISNULL(SALES.QtySold12Mo,0) '12MoQtySold'
    ,ISNULL(BOMU.BOM12MoUsage,0) '12MoBOMUsage'
    ,(ISNULL(SALES.QtySold12Mo,0)+ISNULL(BOMU.BOM12MoUsage,0)) '12MoCombinedQty'
    ,(SKUM.iQAV/((ISNULL(SALES.QtySold12Mo,0)+ISNULL(BOMU.BOM12MoUsage,0))/12.0))as 'Inv Left (Mo.)'
    ,POD.iQuantityReceivedPending 'QtyRcvdPending'
    ,POD.iQuantityPosted 'QtyPosted'
    ,(POD.iQuantity-POD.iQuantityReceivedPending-POD.iQuantityPosted) 'QtyLeftOnPO' -- verify this calc is correct
    --, POD.mCost 'UnitCost'                --  Jiaqi says hide for now
    --, (POD.mCost*POD.iQuantity) 'ExtCost' --  Jiaqi says hide for now
FROM tblPOMaster POM
    left join tblPODetail POD on POM.ixPO = POD.ixPO
    left join tblSKU S on POD.ixSKU = S.ixSKU
    left join tblVendor V on POM.ixVendor = V.ixVendor
    left join vwSKUMultiLocation SKUM on SKUM.ixSKU = POD.ixSKU
    left join (-- 12 Month BOM USAGE
                SELECT BOMTD.ixSKU
                    , isnull(SUM(CAST(BOMTD.iQuantity AS INT)*CAST(BOMTM.iCompletedQuantity AS INT)),0) 'BOM12MoUsage' 
                FROM tblBOMTransferMaster BOMTM 
                    join tblBOMTransferDetail BOMTD on BOMTD.ixTransferNumber = BOMTM.ixTransferNumber
                    join tblDate D on D.ixDate = BOMTM.ixCreateDate
                WHERE D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                    and BOMTM.flgReverseBOM = 0 -- exclude reverse BOMs
                GROUP BY BOMTD.ixSKU) BOMU on BOMU.ixSKU = POD.ixSKU
    left join (-- 12 Mo QTY SOLD
                SELECT OL.ixSKU
                    ,SUM(OL.iQuantity) AS 'QtySold12Mo', SUM(OL.mExtendedPrice) 'Sales12Mo', SUM(OL.mExtendedCost) 'CoGS12Mo'
                FROM tblOrderLine OL 
                    join tblDate D on D.dtDate = OL.dtOrderDate 
                WHERE  OL.flgLineStatus IN ('Shipped','Dropshipped')
                    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
                GROUP BY OL.ixSKU) SALES on SALES.ixSKU = ####.ixSKU       
    left join tblDate D on D.ixDate = POM.ixIssueDate                 
WHERE POM.ixPO = @PO -- '123309'
ORDER BY POM.ixPO, POD.iOrdinality



SELECT * from tblPODetail where ixPO = '123309'


(-- 12 Mo Qty Sold
    OL.ixSKU
    ,SUM(OL.iQuantity) AS QTYSold
from tblOrderLine OL 
    join tblDate D on D.dtDate = OL.dtOrderDate 
where  OL.flgLineStatus IN ('Shipped','Dropshipped')
    and D.dtDate between DATEADD(yy, -1, getdate()) and getdate() -- 1 YR AGO and TODAY
group by OL.ixSKU
)
