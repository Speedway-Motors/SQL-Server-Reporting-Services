-- Sales from Deceased Mailing Status Exempt Customers
select SUM(mMerchandise) Sales
from tblOrder O
join tblCustomer C on O.ixCustomer = C.ixCustomer
where O.dtOrderDate 
    -- between '06/01/2013' and '06/01/2014' --  0-12 Mo
    -- between '06/01/2012' and '05/31/2013'
    -- between '06/01/2011' and '05/31/2012' -- 25-36 Mo
    -- between '06/01/2010' and '05/31/2011'
    -- between '06/01/2009' and '05/31/2010' -- 
    -- between '06/01/2008' and '05/31/2009' -- 61-72 Mo   
    between  '06/01/2008'  and '06/01/2014'  --  0-72 Mo Total        
    and sOrderStatus = 'Shipped'
    and C.flgDeceasedMailingStatusExempt = 1   
    and C.flgDeletedFromSOP = 0
/*
Sales History for 321 
"Deceased Mailing Status Exempt" Customers 

0-12 Mo = $111K
13-24 Mo = $159K
25-36 Mo = $106K
37-48 Mo = $ 99K
49-60 Mo = $ 63K
61-72 Mo = $ 65K
================
72 Mo Tot = $605K  
*/



