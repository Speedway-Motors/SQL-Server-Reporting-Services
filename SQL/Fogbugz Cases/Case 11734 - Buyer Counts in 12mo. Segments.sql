SELECT (
    CASE 
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 12 THEN '0-12'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 24 then '13-24'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 36 then '25-36'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 48 then '37-48'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 60 then '49-60'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 72 then '61-72'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) > 72 then '72+'
       ELSE 'NO ORDERS'
     END
     ) AS 'Age Segment',
     COUNT (*) as '# of Customers'

FROM vwCustomerOrderHistory COH

GROUP BY (
    CASE 
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 12 THEN '0-12'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 24 then '13-24'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 36 then '25-36'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 48 then '37-48'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 60 then '49-60'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 72 then '61-72'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) > 72 then '72+'
       ELSE 'NO ORDERS'
     END
     ) 

ORDER BY 'Age Segment'



/* Adding to the query ... SUBSELECT 1 = # of orders per segment period */

SELECT count(distinct OAH.ixOrder) as 'Order Count',
       (
    CASE 
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 12 THEN '0-12'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 24 then '13-24'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 36 then '25-36'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 48 then '37-48'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 60 then '49-60'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 72 then '61-72'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) > 72 then '72+'
       ELSE 'NO ORDERS'
     END
     ) AS 'Age Segment'
FROM vwOrderAllHistory OAH 
LEFT JOIN vwCustomerOrderHistory COH on COH.ixCustomer = OAH.ixCustomer
WHERE OAH.sOrderStatus = 'Shipped'
      and OAH.sOrderType <> 'Internal'
      and OAH.sOrderChannel <> 'INTERNAL'
      and OAH.mMerchandise > '0'
      and OAH.ixOrder NOT LIKE '%-%'
GROUP BY (
    CASE 
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 12 THEN '0-12'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 24 then '13-24'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 36 then '25-36'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 48 then '37-48'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 60 then '49-60'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 72 then '61-72'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) > 72 then '72+'
       ELSE 'NO ORDERS'
    END
         ) 

ORDER BY 'Age Segment'


/* Adding to the query ... SUBSELECT 2 = $ generated per segment period */

SELECT sum(OAH.mMerchandise) as 'Merch Totals',
       (
    CASE 
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 12 THEN '0-12'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 24 then '13-24'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 36 then '25-36'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 48 then '37-48'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 60 then '49-60'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 72 then '61-72'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) > 72 then '72+'
       ELSE 'NO ORDERS'
     END
     ) AS 'Age Segment'
FROM vwOrderAllHistory OAH 
LEFT JOIN vwCustomerOrderHistory COH on COH.ixCustomer = OAH.ixCustomer
WHERE OAH.sOrderStatus = 'Shipped'
      and OAH.sOrderType <> 'Internal'
      and OAH.sOrderChannel <> 'INTERNAL'
      and OAH.mMerchandise > '0'
GROUP BY (
    CASE 
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 12 THEN '0-12'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 24 then '13-24'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 36 then '25-36'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 48 then '37-48'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 60 then '49-60'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) <= 72 then '61-72'
       WHEN DATEDIFF(m, COH.dtMostRecentOrder, getdate()) > 72 then '72+'
       ELSE 'NO ORDERS'
    END
         ) 

ORDER BY 'Age Segment'


 /*******  CHECKS 
1,189,035 - total customers from tblCustomer
1,188,744 - sum of # of Buyers from query results
          
3,625,983 - # of orders (EXCLUDING BACKORDERS) per vwOrderAllHistory
3,740,773 - sum of # of Orders (EXCLUDING BACKORDERS) from query results
          
$688,153,786 - mMerchandise total per vwOrderAllHistory
$686,091,535 - Merch total from query results          
       
select COUNT(*) FROM tblCustomer
          
select COUNT(ixOrder)
from vwOrderAllHistory O
where O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    and O.ixOrder NOT like '%-%'

select sum(mMerchandise)
from vwOrderAllHistory O
where O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
*******/   
