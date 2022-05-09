-- Shock Dept orders not credited to EMI


SELECT * 
FROM tblEmployee
where ixEmployee in ('AJE','KRV','MAK1')


SELECT O.ixOrder, O.dtShippedDate, O.ixCustomer, 
    C.sCustomerFirstName, C.sCustomerLastName, -- 'CustomerName',
    O.ixCustomerType,
    sSourceCodeGiven, sMatchbackSourceCode, sOrderTaker, mMerchandise
from tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
-- left join tblOrderLine OL on O.ixOrder = OL.ixOrder
where --ixOrder NOT in (select ixOrder from vwEagleOrder)
 sOrderTaker in ('AJE','KRV','MAK1')
    and O.dtShippedDate between '01/01/2016' and '01/31/2016'
    and O.ixOrder NOT LIKE 'Q%'
    and O.ixOrder NOT LIKE 'PC%' -- 28
    and sMatchbackSourceCode NOT IN ('EAGLE300', 'EAGLE340', 'EMI300', 'EMI340', 'PRS-EMI', 'EMP-EMI', 'CUST-SERV-EMI', 'MRR-EMI', 'EMI.DLR')
    and sSourceCodeGiven NOT IN ('EAGLE300', 'EAGLE340', 'EMI300', 'EMI340', 'PRS-EMI', 'EMP-EMI', 'CUST-SERV-EMI', 'MRR-EMI', 'EMI.DLR')
and O.ixOrder NOT in (select ixOrder from vwEagleOrder)   
order by O.dtShippedDate
--sMatchbackSourceCode
--and sOrderStatus 



