-- Case 25994 - AFCO: filter overridden SKUs from the Weekly Fill Rate Analysis report
select distinct flgLineStatus
from tblOrderLine
/*
flgLineStatus
Backordered
Backordered FS
Cancelled
Cancelled Quote
fail
Lost
Open
Quote
Shipped
*/

-- DO WE WANT TO START PASSING 'OR' for the "Overridden" SKUs?



