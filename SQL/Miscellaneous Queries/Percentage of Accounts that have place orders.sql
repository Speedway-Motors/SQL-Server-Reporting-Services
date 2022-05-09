-- Percentage of Accounts that have place orders
select D.iYear, COUNT(distinct C.ixCustomer)
from tblCustomer C
    LEFT join tblDate D on C.ixAccountCreateDate = D.ixDate
    join tblOrder O on C.ixCustomer = O.ixCustomer -- to see how many have placed orders
WHERE C.flgDeletedFromSOP = 0
    and O.sOrderStatus in ( 'Shipped','Dropshipped')            -- \
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders   --  > to see how many have placed orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered        -- /
group by D.iYear
order by D.iYear