-- Percent of Orders with non-generic Source Code Given

select COUNT(*) Orders, sOrderChannel
from tblOrder O
WHERE O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '05/23/2016' and '05/22/2017'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
GROUP BY sOrderChannel
ORDER BY sOrderChannel
/*      sOrder
Orders	Channel
2123	AMAZON
55833	AUCTION
16477	COUNTER
1448	E-MAIL
1085	FAX
457	    INTERNAL
16352	MAIL
198316	PHONE
258706	WEB
*/


select COUNT(*) Orders, sOrderChannel, sSourceCodeGiven
from tblOrder O
WHERE O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '05/23/2016' and '05/22/2017'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.sOrderChannel IN ('PHONE' )--NOT IN ('AMAZON','AUCTION','COUNTER','E-MAIL','FAX','INTERNAL','MAIL','WEB')
GROUP BY sOrderChannel, sSourceCodeGiven 
ORDER BY sOrderChannel, COUNT(*) desc


select COUNT(*) Orders  -- 198,316          Matchback = SC Given 74% of the time for PHONE orders
from tblOrder O
WHERE O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '05/23/2016' and '05/22/2017'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.sOrderChannel IN ('PHONE' )--NOT IN ('AMAZON','AUCTION','COUNTER','E-MAIL','FAX','INTERNAL','MAIL','WEB')
    and O.sSourceCodeGiven = O.sMatchbackSourceCode -- 145,980  
    
select COUNT(*) Orders  -- 258,706       Matchback = SC Given 42% of the time for PHONE orders
from tblOrder O
WHERE O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '05/23/2016' and '05/22/2017'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.sOrderChannel IN ('WEB' )--NOT IN ('AMAZON','AUCTION','COUNTER','E-MAIL','FAX','INTERNAL','MAIL','WEB')
    and O.sSourceCodeGiven = O.sMatchbackSourceCode -- 109,269     


