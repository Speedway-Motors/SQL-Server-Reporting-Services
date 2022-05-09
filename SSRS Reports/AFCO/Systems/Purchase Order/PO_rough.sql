/*
select top 100 * from tblPOMaster order by newid()
select * from tblPODetail
select top 10 * from tblVendor
select * from tblEmployee
*/
select
	   POM.ixPO				PONum,
	   --D.dtDate         	IssueDate,
	   POM.ixVendor			CustomerNum,
	   POM.ixIssuer 		IssuedBy,
	   --V.sName				Vendor,
	   --V.sAddress1			VAddr1,
	   --V.sAddress2			VAddr2,
	   --V.sCity+','+V.sState+'  '+V.sZip	VCSZ,
	   POM.sShipToName		ShipToName,
	   POM.sShipToAddress1	ShipToAddr1,
	   POM.sShipToAddress2  ShipToAddr2,	   
	   POM.sShipToCSZ		ShipToCSZ,
	   POM.sBillToName		BillToName,
	   POM.sBillToAddress1	BillToAddr1,
	   POM.sBillToAddress2	BillToAddr2,	   
	   POM.sBillToCSZ		BillToCSZ,	   
	   POM.sShipVia			ShipVia,
	   POM.sFreightTerms	FreightTerms,
	   POM.sPaymentTerms	PaymentTerms,
	   --D2.dtDate			PODExpDelDate,
	   POM.ixBuyer   		Buyer,
	 --  EMP.iphone			BuyerPhoneNum, --EMP.phoneNum
	   '888-888-8888'		Fax, --HARDCODE FOR NOW?
	   POM.sEmailAddress	Email,
	   POM.sMessage1+' '+POM.sMessage2+' '+POM.sMessage3+' '+POM.sMessage4+' '+POM.sMessage5 Notes,
	   /************* DETAIL *************/
	   POD.iOrdinality		Line,
	   POD.iQuantity		QTY,
	   POD.ixUnitofMeasurement	UnitMeas,
	   POD.ixSKU			PartNum,
	   --SKU.sDescription		SKUDescr,
	   POD.mCost			UnitCost,
	   POD.iQuantity*POD.mCost	TotalCost
from tblPOMaster POM
	right join tblPODetail POD	on POM.ixPO = POD.ixPO
	--right join tblVendor V		on POM.ixVendor = V.ixVendor
	--right join tblSKU SKU		on POD.ixSKU = SKU.ixSKU
	--right join tblDate D		on POM.ixPODate = D.ixDate	
	--right join tblDate D2		on POD.ixExpectedDeliveryDate = D2.ixDate
--	right join tblEmployee EMP  on POM.ixBuyer = EMP.ixEmployee
where POM.ixPO = '65369' 
--where POM.flgEmail = 1 -- 1 = ok to process
--	and POM.flgEmailSent = 0 -- will become flgProcessed 0 = SSRS has not generated PDF file yet
GROUP BY 
		POM.ixPO			,
	   --D.dtDate         	,
	   POM.ixVendor			,
	   POM.ixIssuer 		,
	   --V.sName				,
	   --V.sAddress1			,
	   --V.sAddress2			,
	   --V.sCity+','+V.sState+'  '+V.sZip	,
	   POM.sShipToName		,
	   POM.sShipToAddress1	,
	   POM.sShipToAddress2  ,	   
	   POM.sShipToCSZ		,
	   POM.sBillToName		,
	   POM.sBillToAddress1	,
	   POM.sBillToAddress2	,	   
	   POM.sBillToCSZ		,	   
	   POM.sShipVia			,
	   POM.sFreightTerms	,
	   POM.sPaymentTerms	,
	   --D2.dtDate			,
	   POM.ixBuyer   		,
	   --'EMP.PHONENUM'		, --EMP.phoneNum
	   --'888-888-8888'		, --HARDCODE FOR NOW?
	   POM.sEmailAddress	,
	   POM.sMessage1+' '+POM.sMessage2+' '+POM.sMessage3+' '+POM.sMessage4+' '+POM.sMessage5,
	   POD.iOrdinality		,
	   POD.iQuantity		,
	   POD.ixUnitofMeasurement	,
	   POD.ixSKU			,
	   --SKU.sDescription		,
	   POD.mCost			,
	   POD.iQuantity*POD.mCost	   
	 
order by POD.iOrdinality	




/* 
INSERT MAX(LENGTH) VALUES FOR EACH FIELD INTO TABLES. 
88888889 & AAAAAZ format
   
select max (len(ixPO))) from   tblPOMaster -- 10
select max (len(ixVendor)) from   tblPOMaster -- 4
select max (len(ixIssuer)) from   tblPOMaster -- 10
select max (len(sShipToName)) from   tblPOMaster -- 24
select max (len(sShipToAddress1)) from   tblPOMaster -- 26
select max (len(sShipToAddress2)) from   tblPOMaster  -- 24
select max (len(sShipToCSZ)) from   tblPOMaster --	26

select max (len(sBillToName)) from   tblPOMaster -- 15
select max (len(sBillToAddress1)) from   tblPOMaster -- 12
select max (len(sBillToAddress2)) from   tblPOMaster -- NULL
select max (len(sBillToCSZ)) from   tblPOMaster -- 16

select max (len(sName)) from tblVendor -- 30
select max (len(sAddress1)) from tblVendor -- 30
select max (len(sAddress2)) from tblVendor -- 28 
select max (len(sCity+','+sState+' '+sZip)) from tblVendor -- 31
	   
select max (len(sShipVia)) from   tblPOMaster -- 24
select max (len(sFreightTerms)) from   tblPOMaster -- 25
select max (len(sPaymentTerms)) from   tblPOMaster -- 26

select max (len(iOrdinality)) from tblPODetail -- 3
select max (len(iQuantity)) from tblPODetail -- 5
select max (len(ixUnitofMeasurement)) from tblPODetail -- 2
select max (len(ixSKU)) from tblPODetail -- 22

select max (len(sDescription)) from tblSKU -- 65
select max (len(mCost)) from tblPODetail -- 9

select max (len(ixBuyer)) from   tblPOMaster -- 20

select distinct ixUnitofMeasurement from tblPODetail -- all 2 char vals

select max (len(sEmailAddress)) from   tblPOMaster -- 28
select max (len(sMessage1)) from   tblPOMaster -- 55
select max (len(sMessage2)) from   tblPOMaster -- 55 
select max (len(sMessage3)) from   tblPOMaster -- 55 
select max (len(sMessage4)) from   tblPOMaster -- 55 
select max (len(sMessage5)) from   tblPOMaster -- 55 

select DISTINCT (len(sDescription)), COUNT(*) QTY from tblSKU -- 65
GROUP BY (len(sDescription))
ORDER BY (len(sDescription))

SELECT MAX(iOrdinality)from tblPODetail -- 250
SELECT AVG(iOrdinality)from tblPODetail -- 13

SELECT IXPO, MAX(iOrdinality)
from tblPODetail              -- AT 20 ITEMS/PAGE 96% OF OUR PO's will fit on a single page
GROUP BY IXPO
ORDER BY MAX(iOrdinality) desc





('65198','65981','65338') -- CHILDREN PO'S USED FOR TESTING
*/

select * from tblPOMaster
and ixPO = '65958'

insert into tblPOMaster
SELECT
'88889',15536,15536,NULL,'JOHN MOSS','1311','SPEEDWAY MOTORS, INC.','340 VICTORY LANE',NULL,'LINCOLN, NEBRASKA 68528','UPS GRND/LTLtrk','NET 10 DAYS','COLLECT FREIGHT: FOB',NULL,NULL,0,NULL,'SPEEDWAY MOTORS','PO BOX 81906',NULL,'LINCOLN NE 68501','SHIP AT YOUR CONVENIENCE SO YOU CAN SHIP IN FULL','PALLETS WITH OR WITHOUT OTHER ORDERS. THE GOAL IS ','OPTIMAL PRODUCTION AND SHIPPING','LOTS AND LOTS OF NOTES HERE','AND YET EVEN MORE NOTES.. THIS IS THE END OF SMESSAGE5','BUYEREMAILADDRESS@SPEEDWAYMOTORS.COM'



SELECT * FROM tblPOMaster
WHERE IXPO = '88889'

SELECT * FROM tblPODetail 
where ixPO in ('65198','65981','65338') -- CHILDREN PO'S USED FOR TESTING


select '@'ixPO,''


SELECT ixPO, count(iOrdinality) QTY
FROM tblPODetail 
group by ixPO
having count(iOrdinality) = 1
order by ixPO desc