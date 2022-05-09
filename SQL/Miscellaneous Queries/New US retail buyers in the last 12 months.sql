-- New US retail buyers in the last 12 months

select COUNT(*) from vwCSTStartingPool 563K

SELECT O.ixCustomer, SUM(O.mMerchandise) Sales, COUNT(O.ixOrder) OrdCount
from tblOrder O
    join (select O.ixCustomer, MIN(O.dtShippedDate) 'FOdt'
            from tblOrder O
                join vwCSTStartingPool SP on O.ixCustomer = SP.ixCustomer  -- added join as a quick way to ID valid US retail customers
                join tblCustomer C on O.ixCustomer = C.ixCustomer                           
            where O.sOrderStatus = 'Shipped'                                                
                and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
                and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
                and O.mMerchandise > 0 -- > 1 if looking at non-US orders                  
            group by O.ixCustomer
            having MIN(O.dtShippedDate) between '10/29/2013' and '10/28/2014' 
            --order by MIN(O.dtShippedDate) desc
        ) NB on NB.ixCustomer = O.ixCustomer-- New buyers
where O.sOrderStatus = 'Shipped'                                                
   and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
   -- and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
   and O.mMerchandise > 0
group by O.ixCustomer   
order by SUM(O.mMerchandise) 
/* FOR THE ABOVE DATA SET

    $23.4M  total sales
    135,134 total orders (!!includes Backorders)
    $173.41 AOV (again that is including Backorders)
       1.57 Avg number of orders per cust 
    
*/    

-- 1.25% of the new accounts have been deleted (merged presumably)
select COUNT(*) 
from tblCustomer 
where dtAccountCreateDate between '10/29/2013' and '10/28/2014' -- 139,164
    and flgDeletedFromSOP = 1                                   --   1,752  