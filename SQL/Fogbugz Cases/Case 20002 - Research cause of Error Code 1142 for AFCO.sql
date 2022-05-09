-- Case 20002 - Research cause of Error Code 1142 for AFCO

[USE AFCOReporting]

select * from tblErrorCode
where ixErrorCode = 1142
-- 1142	Failure to update tblOrderLine

select sError, count(*) 'Error Count'
from tblErrorLogMaster
where ixErrorCode = 1142
--and dtDate >= '01/01/2013'
group by sError
/*
sError	Error Count
Order 675683	4416
Order 674201	2172
Order 672328	4368
Order 673207	4344
Order 706858-1	182
Order 667232	2172
Order 674456	4344
Order 673207-1	4344
Order 675604	4416
*/

select * 
from tblOrderLine where ixOrder in 
    ('672328')

select * from tblOrderLine where ixOrder in
    ('675604','675683','667232','672328','673207','673207-1','674201','674456','706858-1')

select * from tblOrder where ixOrder in
    ('675604','675683','667232','672328','673207','673207-1','674201','674456','706858-1')
    
select dtOrderDate, ixOrder, ixCustomer from tblOrder where ixOrder in
    ('675604','675683','667232','672328','673207','673207-1','674201','674456','706858-1')    


/*
dtOrderDate	ixOrder	ixCustomer
2011-12-27 667232	10403
2012-02-17 672328	10403 <-- only 2 Kits
2012-02-24 673207	10403
2012-02-24 673207-1	10403
2012-03-05 674201	10403
2012-03-07 674456	10403
2012-03-15 675604	10403
2012-03-16 675683	10890
2013-03-27 706858-1	10164
*/
select * from tblCustomer where ixCustomer in ('10403','10890','10164')

select ixOrder from tblOrderLine
where ixSKU in ('1660SKIT')--('1670SKIT')--,'1660SKIT')
and  ixOrder in    ('675604','675683','667232','672328','673207','673207-1','674201','674456','706858-1')




select * from tblSKU
where ixSKU in ('1670SKIT','1660SKIT')

-- LATEST UPDATES
select ixSKU,dtDateLastSOPUpdate,ixTimeLastSOPUpdate
from tblSKU
where ixSKU in ('1670SKIT','1660SKIT')

select ixSKU,dtDateLastSOPUpdate,ixTimeLastSOPUpdate
from tblSKU
where ixSKU in (select ixSKU from tblKit where ixKitSKU in ('1670SKIT','1660SKIT'))
order by dtDateLastSOPUpdate
/*
ixSKU	    dtDateLastSOPUpdate	ixTimeLastSOPUpdate
1070X-1	    2013-08-01	32660
1081X	    2013-09-13	25733
A550070137X	2013-09-19	25741

149110P	    2013-09-25	25376
A550010316X	2013-09-25	25505
A550010317X	2013-09-25	25569
A550070136X	2013-09-25	25401
SK1006-6	2013-09-25	25553
SK1006-6	2013-09-25	25532

120X5	    2013-09-30	25774
150X4	    2013-09-30	25763
A550010320X	2013-09-30	25763
A550090220X	2013-09-30	25772
A550100139X	2013-09-30	25764
SK1004	    2013-09-30	25773
*/

select ixKitSKU, ixSKU
from tblKit 
where ixKitSKU in ('1670SKIT','1660SKIT')
order by ixKitSKU, ixSKU




select distinct ixSKU from tblKit where ixKitSKU in ('1670SKIT','1660SKIT')
and ixSKU IN (select ixSKU from tblSKU)

select * from tblOrderLine where ixOrder in
    ('672328')

select * from tblKit
where ixKitSKU in ('1670SKIT','1660SKIT')
and ixSKU in (select ixSKU from tblSKU where flgDeletedFromSOP = 1)


-- HAVE ALL GIVE OUTPUT TO TEST proc manually

EXEC spUpdateOrderLine 
    (
	   '',         --@ixOrder varchar(10),
	   '',         --@ixCustomer varchar(10),
	   '',         --@ixSKU varchar(30),
	   ,         --@ixShippedDate smallint,
	   ,         --@ixOrderDate smallint,
	   ,         --@iQuantity smallint,
	   ,         --@mUnitPrice money,
	   ,         --@mExtendedPrice money,
	   '',         --@flgLineStatus varchar(12),
	            --@dtOrderDate datetime,
	            --@dtShippedDate datetime,
	   ,         --@mCost money,
	   ,         --@mExtendedCost money,
	   ,         --@flgKitComponent tinyint,
	   ,         --@iOrdinality smallint,
	   ,         --@iKitOrdinality smallint,
	   ,         --@ixPrintedDate int,
	   ,         --@ixPrintedTime int,
	   ,         --@mSystemUnitPrice money,
	   ,         --@mExtendedSystemPrice money,
	   '',         --@ixPriceDevianceReasonCode varchar(10),
	   '',         --@sPriceDevianceReason varchar(100),
	   '',         --@ixPicker varchar(10) 
	   )

