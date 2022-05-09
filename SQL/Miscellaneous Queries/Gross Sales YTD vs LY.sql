-- Gross Sales YTD vs LY

/************
 *** 2013 ***
 ************/
select sum(O.mMerchandise) 
from tblOrder O
where O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtOrderDate between '01/01/2013' and '01/31/2013'

select COUNT(*) Mondays2013 from tblDate 
where sDayOfWeek = 'MONDAY'
    and dtDate between '01/01/2013' and '01/31/2013'
    
    
/************
 *** 2014 ***
 ************/ 
select sum(O.mMerchandise) 
from tblOrder O
where O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtOrderDate between '01/01/2014' and '01/31/2014'    

select COUNT(*) Mondays2013 from tblDate 
where sDayOfWeek = 'MONDAY'
    and dtDate between '01/01/2014' and '01/31/2014'
    
    
    
/*          2013       2014     Delta   2013    2014
Through    Sales      Sales       %     Mondays Mondays
=======  =========  =========   ======  ======= =======
Jan 12   3,127,999  2,859,815   -8.57%  1       1
Jan 19   4,717,699  4,427,701   -6.15%  2       2
Jan 31   7,777,420  7,513,651    -3.3%  4       4
         7,743,474  7,369,277    -4.8%
*/




