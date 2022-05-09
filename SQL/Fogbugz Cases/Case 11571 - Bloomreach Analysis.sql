
/* Query for Case 11571 */

SELECT sWebOrderID, 
       ixOrder,
       sOrderStatus,
       ixCustomer,
       sEmailAddress,
       dtOrderDate,
       dtFirstOrderDate,
       dtFirstWebDate,
       dtAccountCreateDate,
       ixOrdersPriorBR,
       ixOrdersAfterBR,
       mMerchandise,
       mMerchandiseCost,
       (100-(((mMerchandise)-(mMerchandiseCost))/(NULLIF (mMerchandise,0)) * 100)) as 'Margin',
       (CASE WHEN dtOrderDate <= dtFirstOrderDate THEN 'NEW'
             ELSE 'OLD' END) as 'Status',
       (CASE WHEN dtOrderDate > dtFirstWebDate THEN 'YES'
             ELSE 'NO' END) as 'PrevWebOrder'
             
FROM ASC_BloomreachWebOrders

ORDER BY 'Status', 
         dtOrderDate,
         'Margin' DESC
         
         
/* Query for Generating Margin Analysis by Market for CCC */ 
select
    PGC.ixMarket,
    sum(OL.mExtendedPrice) as 'Revenue',
    sum(OL.mExtendedCost) as 'Cost',
    (sum(OL.mExtendedPrice)-sum(OL.mExtendedCost)) /
(sum(OL.mExtendedPrice)) as 'Margin'
from
    tblOrderLine OL
    left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join tblPGC PGC on SKU.ixPGC = PGC.ixPGC
where
    OL.flgLineStatus in ('Shipped', 'Dropshipped')
    and    OL.ixOrder in (SELECT ixOrder from ASC_BloomreachWebOrders)
    and OL.flgKitComponent = '0'
    --query to grab all ixOrder#s for Bloomreach
    
group by
    PGC.ixMarket


--NOTES ON HOW THE TABLE USED WAS CREATED 

/* First I imported the web order IDs into a table. Remind me tomorrow 
and I'll show you how to do that. */

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

--sent by Pat to update table 

update BR -- 4544
set ixEmailCustCount = EC.QTY
from ASC_BloomreachWebOrders BR
          -- email count
    join (select sEmailAddress, count(*) QTY
          from tblCustomer
          group by sEmailAddress
          ) EC ON BR.sEmailAddress = EC.sEmailAddress
          
--column created to determine if the first order date the customer has under their account
--in the system matches the order date of the inquired about E#, if so = NEW, if not = OLD

update BR -- 4578
set dtFirstOrderDate = EC.FOD
from ASC_BloomreachWebOrders BR
    join (select ixCustomer, min(dtOrderDate) FOD
          from vwOrderAllHistory
          where sOrderStatus = 'Shipped'
            and sOrderType <> 'Internal'
            and sOrderChannel <> 'INTERNAL'
            and mMerchandise > '0'
          group by ixCustomer
          ) EC ON BR.ixCustomer = EC.ixCustomer
          
--column created to determine when the first web order date the customer has under their account
--(if any at all) is previous to the order date of the inquired about E#, if so = YES, if not = NO

update BR -- 4578(4522)
set dtFirstWebDate = EC.FWD
from ASC_BloomreachWebOrders BR
    join (select ixCustomer, min(dtOrderDate) FWD
          from vwOrderAllHistory
          where sOrderStatus = 'Shipped'
            and sOrderType <> 'Internal'
            and sOrderChannel = 'WEB'
            and sWebOrderID is NOT NULL
            and mMerchandise > '0'
          group by ixCustomer
          ) EC ON BR.ixCustomer = EC.ixCustomer

--column created to determine how many total orders the customer had placed prior to their BR order
--(if any at all) and provide a count

update BR -- 4578(4558)
set ixOrdersPriorBR = EC.OP
from ASC_BloomreachWebOrders BR
    join (select BR.ixCustomer,
          isnull(OrderPrior.PriorOrderCount,0) as OP
          from ASC_BloomreachWebOrders BR
          left join (SELECT BR.ixCustomer,
               count(distinct OAH.ixOrder) 'PriorOrderCount'
               FROM ASC_BloomreachWebOrders BR
               left join vwOrderAllHistory OAH on OAH.ixCustomer = BR.ixCustomer
               WHERE OAH.sOrderStatus = 'Shipped'
                 and OAH.sOrderType <> 'Internal'
                 and OAH.sOrderChannel <> 'INTERNAL'
                 and OAH.mMerchandise > '0'
                 and OAH.dtOrderDate < BR.dtOrderDate
               GROUP BY BR.ixCustomer
               ) OrderPrior on OrderPrior.ixCustomer = BR.ixCustomer
          ) EC ON BR.ixCustomer = EC.ixCustomer
          
--column created to determine how many total orders the customer had placed following their BR order
--(if any at all) and provide a count

update BR -- 4578(4558)
set ixOrdersAfterBR = EC.OA
from ASC_BloomreachWebOrders BR
    join (select BR.ixCustomer,
          isnull(OrderAfter.AfterOrderCount,0) as OA
          from ASC_BloomreachWebOrders BR
          left join (SELECT BR.ixCustomer,
               count(distinct OAH.ixOrder) 'AfterOrderCount'
               FROM ASC_BloomreachWebOrders BR
               left join vwOrderAllHistory OAH on OAH.ixCustomer = BR.ixCustomer
               WHERE OAH.sOrderStatus = 'Shipped'
                 and OAH.sOrderType <> 'Internal'
                 and OAH.sOrderChannel <> 'INTERNAL'
                 and OAH.mMerchandise > '0'
                 and OAH.dtOrderDate > BR.dtOrderDate
               GROUP BY BR.ixCustomer
               ) OrderAfter on OrderAfter.ixCustomer = BR.ixCustomer
          ) EC ON BR.ixCustomer = EC.ixCustomer
          
--column created to determine the order status of the Bloomreach web order being analyzed

update BR -- 4544
set sOrderStatus = EC.OS
from ASC_BloomreachWebOrders BR
   join (select sOrderStatus OS, ixOrder
          from vwOrderAllHistory
          group by sOrderStatus, ixOrder
          ) EC ON BR.ixOrder = EC.ixOrder  