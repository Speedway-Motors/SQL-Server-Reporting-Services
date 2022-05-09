-- First I imported the web order IDs into a table. Remind me tomorrow and I'll show you how to do that.

-- Next, i did a quick check to see if there were any dupes
SELECT COUNT(*) QTYAllRows,
       COUNT(distinct sWebOrderID) QTYDistinct
from ASC_BloomreachWebOrders               
/*
QTYAllRows	QTYDistinct
4581	    4579
*/


--Identifying the dupe records
select sWebOrderID, count(*) QTY
from ASC_BloomreachWebOrders
group by sWebOrderID
HAVING count(*) > 1
/*
sWebOrderID	QTY
E661372	    2
E694241	    2
*/

-- deduping
set rowcount 1 -- only allows 1 row of the data to be deleted
delete from ASC_BloomreachWebOrders where sWebOrderID = 'E661372'
delete from ASC_BloomreachWebOrders where sWebOrderID = 'E694241'
set rowcount 0 --

/* when I created the table it only had 1 column.
  I manually added the columns ixCustomer and ixOrder to make the SQL a bit easier later on.
  (be sure to use the same data type and length as the tables your going to populate the data from.
  e.g. tblOrder.ixOrder is a varchar(10) so I'm making that the same in the new table.
  Next I need to populate those two fields with data from our production tables
*/

update BR -- 4579
set ixOrder = O.ixOrder
from ASC_BloomreachWebOrders BR
    join tblOrder O on BR.sWebOrderID = O.sWebOrderID

update BR -- 4544
set ixCustomer = O.ixCustomer
from ASC_BloomreachWebOrders BR
    join tblOrder O on BR.sWebOrderID = O.sWebOrderID
-- If it's useful you can add some more columns such as totalMerch, Mech cost, etc.

-- looks like we didn't find matches for all the web orders
select * from ASC_BloomreachWebOrders
where ixOrder is NULL
  or ixCustomer is NULL
  
-- I spot checked some of the missing ones and they don't come up in SOP.
-- be sure to mention on the ticket that two orders were listed twice and the is no record of 34 of them.

-- junk 
delete from  ASC_BloomreachWebOrders where sWebOrderID = '(blank)' 


-- AT THIS POINT, GO AHEAD AND TRY TO PULL IN SOME OF THE OTHER INFO CHRIS IS ASKING FOR
-- WHEN YOU GET TO THE CUSTOMERS THAT YOU IDENTIFY AS 'NEW', pull over their email address and see if it matches 
-- one for an existing customer account (if so, I think we can assume that they were existing customers and their
-- account will eventually get merged to the older one)




select * from ASC_BloomreachWebOrders




update BR -- 4544
set ixEmailCustCount = EC.QTY
from ASC_BloomreachWebOrders BR
          -- email count
    join (select sEmailAddress, count(*) QTY
          from tblCustomer
          group by sEmailAddress
          ) EC BR.sEmailAddress = EC.sEmailAddress
