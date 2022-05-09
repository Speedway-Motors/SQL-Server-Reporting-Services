/*
NOTES:

MOST RULES FOR LIST PULLS ARE BASED ON
CUSTOMERS THAT ARE EITHER SINGLE OR MULTIPLE ORDERS PURCHASERS
TOTAL OF A CUSTOMERS PURCHASES IN LAST 12 MONTHS
TOTAL OF A CUSTOMERS PURCHASES LIFETIME

i think we can create two views that will accomodate most if not all of the list pulls.
1ST view... general starting pool - +
2ND view... Customer


select count(*) from tblOrder where sWebOrderID is not null --
513     13:32:20
3106    13:55:00
5559    14:20:00

select count(*) from tblOrder -- 1413029  

select top 100 * from tblCustomer
order by newid()

select sCustomerType, count(*) QTY
from tblCustomer
group by sCustomerType
order by sCustomerType
*/


-- TAKE THIS QUERY AND MAKE IT A VIEW... name it vwListPullStartingPool
SELECT ixCustomer 
FROM tblCustomer -- 340K
WHERE ixCustomerType < '90'
   and (sMailingStatus is NULL
        OR (sMailingStatus not in ('4','9'))
        )
   and (ixCustomerType NOT like '%.%' 
        OR ixCustomerType is NULL)
  and (ISNUMERIC(ixCustomerType) = 1 -- eliminates types with chars
      OR ixCustomerType is NULL)
  and sCustomerType = 'Retail'
  --  and sMarket <>''   -- customer market (street, race etc)      add 65.2 to tblCustomer
  and ixCustomer in (select distinct ixCustomer  -- checking to see if customer has placed an order
                     from vwOrderAllHistory
                     where sOrderStatus = 'Shipped'
                     and dtShippedDate >= DATEADD(yy, -6, getdate()) 
                     )  
                     -- 425K for past 72 months
                     -- 698K for entire Order History
                    
  and sMailToZip BETWEEN '01000' AND '99999'
  and (sMailToCountry = 'USA'    
       OR sMailToCountry is NULL) -- says USA only in SOP
  -- excluding special military zips     
  and sMailToZip not like '962%' -- APO/FPO AP
  and sMailToZip not like '963%' -- APO/FPO AP
  and sMailToZip not like '964%' -- APO/FPO AP
  and sMailToZip not like '965%' -- APO/FPO AP
  and sMailToZip not like '966%' -- FPO AP
  and sMailToZip not like '09%' -- ALL are APO/FPO, AE         
    

  --[vwCustomerOrderHistory]
  
  
  
  
  -- select DATEADD(MM, -1, getdate()) 
  
