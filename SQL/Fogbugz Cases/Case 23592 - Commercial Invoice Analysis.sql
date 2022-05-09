-- Case 23592 - Commercial Invoice Analysis
select COUNT(distinct O.ixOrder)
from tblOrder O
    JOIN tblOrderLine OL on O.ixOrder = OL.ixOrder -- 5308
where O.dtShippedDate > '01/01/2013'
    AND O.sOrderStatus = 'Shipped'
    AND OL.ixSKU = 'COMINVOICE'



-- current logic for printing a commerical invoice
select D.iYear, D.iISOWeek, COUNT(distinct O.ixOrder) OrderCnt
from tblOrder O
    JOIN tblOrderLine OL on O.ixOrder = OL.ixOrder -- 5308 current way 19017 new way
    JOIN tblDate D on D.ixDate = O.ixShippedDate
where O.dtShippedDate > '01/01/2013'
    AND O.sOrderStatus = 'Shipped'
    AND OL.ixSKU = 'COMINVOICE'
group by  D.iYear, D.iISOWeek  
order by D.iYear, D.iISOWeek

-- proposed logic for printing a commerical invoice
select D.iYear, D.iISOWeek, 
    COUNT(distinct O.ixOrder) OrderCnt
from tblOrder O
    JOIN tblDate D on D.ixDate = O.ixShippedDate
    JOIN tblCustomer C on C.ixCustomer = O.ixCustomer
where O.dtShippedDate > '01/01/2013'
    AND O.sOrderStatus = 'Shipped'
    AND (O.sShipToCountry <> 'US'
         OR
         (C.sMailToCountry <> 'USA' and C.sMailToCountry is NOT NULL)    -- 18835
        )
group by  D.iYear, D.iISOWeek  
order by D.iYear, D.iISOWeek




select COUNT(*) from tblCustomer C  where C.sMailToCountry <> 'USA' and C.sMailToCountry is NOT NULL -- 31800


select * from tblSKU where sDescription like '%INVOICE%'


select sShipToCountry, COUNT(*) Qty
from tblOrder O
where O.dtShippedDate > '01/01/2013'
    AND O.sOrderStatus = 'Shipped'
    --AND O.sShipToCountry 
group by   sShipToCountry
order by COUNT(*) desc  
/*
sShipToCountry	Qty
US	            797856
CANADA	        4363
AUSTRALIA	    2540
.
.
.
*/    
    
select C.sMailToCountry, COUNT(*)
from tblCustomer C
group by sMailToCountry
order by COUNT(*) desc  
/*
sMailToCountry	Qty
NULL	        976123
USA	            544205   <-- NOT "US" !!!
CANADA	        15986
AUSTRALIA	    5014
.
.
.
*/  


