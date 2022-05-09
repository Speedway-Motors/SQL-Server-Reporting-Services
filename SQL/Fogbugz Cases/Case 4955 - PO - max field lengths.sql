select max(len(ixPO)) from tblPOMaster

select * from tblPOMaster where len(ixPO) = 9
order by ixPODate desc

select max(len(sShiptoName)) from tblPOMaster
select * from tblPOMaster where len(sShiptoName) = 32

select max(len(sShipToAddress1)) from tblPOMaster
select * from tblPOMaster where len(sShipToAddress1) = 28

select max(len(sShipToAddress2)) from tblPOMaster
select * from tblPOMaster where len(sShipToAddress2) = 24

select max(len(sShipToCSZ)) from tblPOMaster
select * from tblPOMaster where len(sShipToCSZ) = 28
/***********************************/
select max(len(sBillToName)) from tblPOMaster
select * from tblPOMaster where len(sBillToName) = 15 -- SPEEDWAY MOTORS

select max(len(sBillToAddress1)) from tblPOMaster
select * from tblPOMaster where len(sBillToAddress1) = -- PO BOX 81906

select max(len(sBillToAddress2)) from tblPOMaster
select * from tblPOMaster where len(sBillToAddress2) = 24 -- BLANK

select max(len(sBillToCSZ)) from tblPOMaster
select * from tblPOMaster where len(sBillToCSZ) = 17 -- LINCOLN, NE 68501
/***********************************/
select max(len(sName)) from tblVendor
select * from tblVendor where len(sName) = 30 -- NEBRASKA WORKFORCE DEVELOPMENT

select max(len(sAddress1)) from tblVendor
select * from tblVendor where len(sAddress1) = 30 -- 11422 MIRACLE HILLS DR STE 500

select max(len(sAddress2)) from tblVendor
select * from tblVendor where len(sAddress2) = 28 -- 11422 MIRACLE HILLS DR STE 500

select max(len(sCity+','+sState+'  '+sZip)) from tblVendor
select * from tblVendor where len(sCity+','+sState+'  '+sZip) = 32 -- TAIPEI, TAIWAN R.O.C.	TI	NANANA
/*************************************/


select max(len(sExternalCustomerNumber)) from tblVendor		--	10/12/2010
select * from tblVendor where len(sExternalCustomerNumber) = 14 -- SPEEDWAYMOTORS

select max(len(ixIssuer)) from tblPOMaster
select * from tblPOMaster where len(ixIssuer) = 3 -- CAJ2

/*************************************/
select max(len(sShipVia)) from tblPOMaster
select * from tblPOMaster where len(sShipVia) = 30 -- BEST WAY SINCE YOU PAY FREIGHT

select max(len(sFreightTerms)) from tblPOMaster
select * from tblPOMaster where len(sFreightTerms) = 26 -- COD COMPANY CHECK ACCEPTED

select max(len(sPaymentTerms)) from tblPOMaster
select * from tblPOMaster where len(sPaymentTerms) = 26 -- COD COMPANY CHECK ACCEPTED

/********** DETAIL ROWS ************/
select max(len(ixPO)) from tblPODetail
select * from tblPODetail where len(ixPO) = 10 -- 1234567890

select max(len(iOrdinality)) from tblPODetail -- 3
select * from tblPODetail where len(iOrdinality) = 3 

select max(len(iQuantity)) from tblPODetail
select * from tblPODetail where iQuantity > 20000 -- 55555
		and iOrdinality > 5

select * from tblPODetail where iQuantity > 20000 -- 55555
		and iOrdinality > 5


select max(len(ixUnitofMeasurement)) from tblPODetail
select * from tblPODetail where len(ixUnitofMeasurement) = 3 -- DOZ



select max(len(ixSKU)) from tblPODetail
select * from tblPODetail where len(ixSKU) = 25  -- 145CUSTOM PISTON*230576-1           SMI SKU

select len(ixSKU) LONG, count(*) QTY from tblPODetail -- 94% of the Vendor SKUs are 12 char or less
group by len(ixSKU)
order by len(ixSKU)


select len(sVendorSKU) LONG, count(*) QTY from tblVendorSKU -- 91% of the Vendor SKUs are 15 char or less
group by len(sVendorSKU)
order by len(sVendorSKU)

select len(sDescription) CHARS, count(*) QTY from tblSKU -- 96% of the Vendor SKUs are 27 char or less
group by len(sDescription)
order by len(sDescription) DESC




/************ FOOTER FIELDS *************/
select max(len(ixBuyer)) from tblPOMaster
select * from tblPOMaster where len(ixBuyer) = 20 -- RON-CUSTOMER SERVICE

select max(len(sphone)) from tblEmployee
select * from tblEmployee where len(sphone) = 10 -- (800)123-4567

	   '(800)323-3211'				BuyerFax, --HARDCODE FOR NOW

select max(len(sEmailAddress)) from tblPOMaster
select * from tblPOMaster where len(sEmailAddress) = 28 -- CAJOHNSON@SPEEDWAYMOTORS.COM

select max(len(sSalesRep)) from tblVendor
select * from tblVendor where len(sSalesRep) = 20 -- NICK MERCADO(INSIDE)

	   dbo.DisplayPhone(V.s800Number)	SellerPhoneNum, -- (800)123-4567
	   dbo.DisplayPhone(V.sFax)			SellerFaxNum,   --(402)323-3211
	   dbo.DisplayPhone(V.sPhone)	SellerSalesPhoneNum,-- (800)123-4567

'message01 Alpha Bravo Charlie Delta Echo Foxtrot Golf H message02 Alpha Bravo Charlie Delta Echo Foxtrot Golf H message03 Alpha Bravo Charlie Delta Echo Foxtrot Golf H message04 Alpha Bravo Charlie Delta Echo Foxtrot Golf H message05 Alpha Bravo Charlie Delta Echo Foxtrot Golf H' --




select max(len(sLastname)) from tblEmployee
select * from tblEmployee where len(sLastname) = 11 


select * from tblPOMaster where flgBlanket = 1

select * from tblPOMaster order by flgBlanket



select sVendorOnReport, count(*) QTY
from tblVendor
group by sVendorOnReport

V- Vendor
B- Both
O- Speedway

select * from tblPOMaster where ixPO = '88889'



select * from tblPOMaster
where ixPO = '88889'



select len(sEmailAddress) CHARS, count(*) QTY 
from tblCustomer -- 94% of are 24 char or less
group by len(sEmailAddress)
order by len(sEmailAddress) DESC

