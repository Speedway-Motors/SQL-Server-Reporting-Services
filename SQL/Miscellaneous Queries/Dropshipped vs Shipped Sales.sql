-- Dropshipped vs Shipped Sales
select OL.flgLineStatus, SUM(OL.mExtendedPrice)  
from tblOrder O   
    join tblOrderLine OL on OL.ixOrder = O.ixOrder
where O.dtOrderDate between '01/01/2016' and '08/21/2016' -- >= '01/01/17'   
  and O.sOrderStatus = 'Shipped'
  and O.sOrderType <> 'Internal'                                            -- 3.8  
  and OL.flgLineStatus in ('Dropshipped','Shipped') -- 4,130,699.57
GROUP BY OL.flgLineStatus
/*
-- 1/1/17 to 8/21/17
Dropshipped	3,793k 4.4% of all Sales
Shipped	   82,186k
           =======
           85,979

-- 1/1/16 to 8/21/16
Dropshipped	2,941k 3.6% of all Sales
Shipped	   79,202k
           =======
           82,143

*/