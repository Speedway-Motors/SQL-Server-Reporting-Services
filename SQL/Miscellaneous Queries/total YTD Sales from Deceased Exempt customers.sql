-- total YTD Sales from Deceased Exempt customers



-- total YTD Sales from Deceased Exempt customers
SELECT C.ixCustomer, sum(O.mMerchandise) Sales -- $128K as of 10-13-2013 !?!
from [SMI Reporting].dbo.tblOrder O
    join [SMI Reporting].dbo.tblCustomer C on O.ixCustomer = C.ixCustomer
    join [SMITemp].dbo.PJC_19014_CustsDeceasedFlgCleared ALIVE on C.ixCustomer = ALIVE.ixCustomer
where C.flgDeletedFromSOP = 0  
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate >= '01/01/2013'
group by  C.ixCustomer   



