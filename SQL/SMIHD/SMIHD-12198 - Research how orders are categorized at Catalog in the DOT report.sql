-- SMIHD-12198 - Research how orders are categorized at Catalog in the DOT report

-- logic from vwDailyOrdersTaken
when OrderChannel = 'WEB' and (CustomerType not in ('MRR','PRS') or CustomerType is null) then (Case when O.flgDeviceType like 'MOBILE%' then 'WEB-Mobile'
                                                                                                                                         else 'WEB' end)   
when OrderChannel = 'COUNTER' and (CustomerType not in ('MRR','PRS') or CustomerType is null) then 'Counter'
when OrderChannel = 'AUCTION' and (CustomerType not in ('MRR','PRS') or CustomerType is null) then 'Ebay/Auction'
when OrderChannel = 'AMAZON' and ((CustomerType not in ('MRR','PRS') or CustomerType is null) and O.sSourceCodeGiven <> 'AMAZONPRIME' ) then 'Amazon'   
when OrderChannel = 'AMAZON' and ((CustomerType not in ('MRR','PRS') or CustomerType is null) and O.sSourceCodeGiven = 'AMAZONPRIME') then 'AmazonPrime'  
when OrderChannel = 'WALMART' and (CustomerType not in ('MRR','PRS') or CustomerType is null) then 'Walmart'                      
when CustomerType = 'MRR' then 'MRR'
when CustomerType = 'PRS' then 'PRS'
ELSE 'Catalog'


SELECT  count(*) 'OrdCnt', sOrderChannel
from tblOrder
where dtOrderDate = '10/22/2018' -->= '01/01/2018'
and sOrderChannel in ('E-MAIL','FAX','INTERNAL','MAIL','PHONE')
and sOrderStatus in ('Shipped','Open')
and ixOrder NOT LIKE 'Q%'
and ixOrder NOT LIKE 'P%'
and sOrderType NOT IN ('MRR','PRS')
group by sOrderChannel
/*
1461	E-MAIL
576	    FAX
4914	INTERNAL
6049	MAIL
170230	PHONE
*/

E-MAIL
FAX
INTERNAL
MAIL
PHONE

select distinct sOrderStatus
from tblOrder

select distinct sOrderType
from tblOrder

/*
    AMAZON
    AUCTION
    COUNTER
    E-MAIL \
    FAX     \
    INTERNAL > fall under CATALOG IF customers is NOT MRR OR PRS
    MAIL    /
    PHONE  /
    WALMART
    WEB
*/

-- examples of Internal channel and internal type orders
select ixOrder,  sOrderChannel, sOrderType, sOrderStatus, mMerchandise
from tblOrder 
where dtOrderDate between '10/01/2018' and '10/23/2018'
and(sOrderChannel = 'INTERNAL'
   or 
   sOrderType = 'Internal')
and sOrderStatus NOT in ('Recall','Pick Ticket','Cancelled','Quote','Cancelled Quote')
and UPPER(sOrderChannel) <> UPPER(sOrderType)