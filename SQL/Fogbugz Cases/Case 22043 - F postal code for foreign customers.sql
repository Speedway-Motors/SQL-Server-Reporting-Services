-- Case 22043 - F postal code for foreign customers

-- Mailing Postal Codes
select count(*) from tblCustomer
where sMailToZip = 'F'
and dtAccountCreateDate >= '01/01/2014'

select count(ixCustomer) CustQty, ixSourceCode 
from tblCustomer
where sMailToZip = 'F'
and dtAccountCreateDate >= '01/01/2014'
group by ixSourceCode
order by count(ixCustomer) desc

select count(ixCustomer) CustQty, sMailToCountry 
from tblCustomer
where sMailToZip = 'F'
and dtAccountCreateDate >= '01/01/2014'
group by sMailToCountry
order by count(ixCustomer) desc

select ixCustomer, ixOrder
select ixCustomer 
from tblCustomer
where sMailToZip = 'F'
and dtAccountCreateDate >= '01/01/2014'
group by ixSourceCode


-- Shipped Orders YTD with F for a ZipCode
select ixOrder, sOrderTaker, 
    CONVERT(VARCHAR, dtOrderDate, 110) AS 'OrderDate', sShipToCountry
from tblOrder
where sShipToZip =  'F'
and dtOrderDate >= '01/01/2014'
order by sOrderTaker, dtOrderDate
 
ixOrder sOrderTaker OrderDate sShipToCountry
5578759 LEF           03-18-2014 URUGUAY
5690152 LEF           03-20-2014 BELGIUM
5487459 LLA           03-10-2014 CANADA
5717049 PWO         01-13-2014 AUSTRIA
5644157 PWO         03-20-2014 FINLAND
5750541 TDJ          01-17-2014 CANADA