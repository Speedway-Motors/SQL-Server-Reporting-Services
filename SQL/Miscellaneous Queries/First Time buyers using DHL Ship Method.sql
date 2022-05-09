-- First Time buyers using DHL Ship Method

SELECT ixOrder, ixCustomer, iShipMethod, sOrderStatus
FROM tblOrder
where iShipMethod between 21 and 23
and sOrderStatus = 'Shipped'
order by iShipMethod, sOrderStatus -- 164 orders from 151 Customer

SELECT Distinct ixCustomer, MIN(dtOrderDate) FirstDHLOrderDate, NULL as 'FirstSMIOrderDate'  -- ixOrder, ixCustomer, iShipMethod, sOrderStatus
into [SMITemp].dbo.PJC_TEMP_DHLCustomers
FROM tblOrder
where iShipMethod between 21 and 23
and sOrderStatus = 'Shipped'
GROUP BY ixCustomer
order by iShipMethod, sOrderStatus -- 164 orders


SELECT * FROM [SMITemp].dbo.PJC_TEMP_DHLCustomers


/*
update A 
set COLUMN = B.COLUMN,
   NEXTCOLUMN = B.NEXTCOLUMN
from FIRSTTABLE A
 join SECONDTABLE B on A.XXX = B.XXX

*/

update A 
set FirstSMIOrderDate = B.FirstSMIOrderDate
from [SMITemp].dbo.PJC_TEMP_DHLCustomers A
 join (-- Customers first NON-DHL order
       SELECT O.ixCustomer, MIN(dtOrderDate) 'FirstSMIOrderDate'
       FROM tblOrder O
        join [SMITemp].dbo.PJC_TEMP_DHLCustomers DHL on O.ixCustomer = DHL.ixCustomer
       WHERE O.sOrderStatus = 'Shipped'
        and O.mMerchandise > 0 -- > 1 if looking at non-US orders
        and O.sOrderType <> 'Internal'   -- USUALLY filtered
        and iShipMethod NOT between 21 and 23
       GROUP BY O.ixCustomer
       ) B on A.ixCustomer = B.ixCustomer
       
SELECT ixCustomer, FirstSMIOrderDate,FirstDHLOrderDate, DATEDIFF(DD,FirstSMIOrderDate,FirstDHLOrderDate)
FROM [SMITemp].dbo.PJC_TEMP_DHLCustomers       
ORDER BY FirstSMIOrderDate DESC
       
       
out of the 149 customer that have been sent DHL orders,
 64 of them were first time customers (40%)
 