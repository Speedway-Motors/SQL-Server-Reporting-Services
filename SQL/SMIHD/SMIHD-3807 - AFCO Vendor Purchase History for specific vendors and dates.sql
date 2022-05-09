-- SMIHD-3807 - AFCO Vendor Purchase History for specific vendors and dates

/*
I'm needing the following vendors for the dates listed by each:

Competition Suspension Vendor # 5982 2/20/15 - 01/01/16
DeWitts Radiator Vendor # 5749 09/03/15 - 01/01/16
*/

select 
	POM.ixVendor						VendorNum,
	V.sName								VendorName,
	COUNT(Distinct POM.ixPO)			NumPO,
	COUNT(Distinct(POD.ixSKU))			NumSKUs,
	SUM(POD.iQuantityPosted)			NumUnits,
	SUM(POD.iQuantityPosted * POD.mCost)	Dollars
from tblPODetail POD
	left join tblPOMaster POM	on POM.ixPO = POD.ixPO
	left join tblDate D			on D.ixDate = POD.ixFirstReceivedDate
	left join tblVendor V		on V.ixVendor = POM.ixVendor
WHERE V.ixVendor = '5749' -- '5982'
and D.dtDate between '09/03/15' and '01/01/16' --'2/20/15' and '01/01/16'
group by datepart(Year,D.dtDate),
		POM.ixVendor,
		V.sName
/*
VendorNum	VendorName	            NumPO   NumSKUs	NumUnits	Dollars
5982	    DEWITTS RADIATOR LLC	38	    19	    1649	    92397.16
5749                                NONE
*/					

-- 2nd vendor number doesn't appear to be accurate		
select * from tblVendor where ixVendor = '5749'			
--5749	COMPETITION SUSPENSION INC.		
					