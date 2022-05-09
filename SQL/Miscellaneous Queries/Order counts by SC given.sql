-- Order counts by SC given
select O.sSourceCodeGiven, SC.sDescription, count(O.ixOrder)  
from   tblOrder O  
    left join tblSourceCode SC on O.sSourceCodeGiven = SC.ixSourceCode 
where O.dtOrderDate between '01/01/2018' and '07/04/2018'
     and ixOrder NOT LIKE '%-%'
     and ixOrder NOT LIKE 'P%'   
     and ixOrder NOT LIKE 'Q%'
group by O.sSourceCodeGiven, SC.sDescription  
order by count(O.ixOrder) desc


2190
EBAY
EC
AMAZON
NET


select (CASE when O.sSourceCodeGiven in ('2190','EBAY','AMAZON','NET','AMAZONPRIME') THEN 'WEB' -- what are other WEB SCs?  Should we be looking at $ instead of # of orders?
        ELSE 'NON-WEB'
        END) SCGiven, 
        D.iYear,
 count(O.ixOrder)  
from   tblOrder O  
    left join tblSourceCode SC on O.sSourceCodeGiven = SC.ixSourceCode 
    left join tblDate D on O.ixOrderDate = D.ixDate
where D.iYear >= 2010
     and ixOrder NOT LIKE '%-%'
     and ixOrder NOT LIKE 'P%'   
     and ixOrder NOT LIKE 'Q%'

group by (CASE when O.sSourceCodeGiven in ('2190','EBAY','AMAZON','NET','AMAZONPRIME') THEN 'WEB'
        ELSE 'NON-WEB'
        END),
        D.iYear
order by D.iYear, 
    (CASE when O.sSourceCodeGiven in ('2190','EBAY','AMAZON','NET','AMAZONPRIME') THEN 'WEB'
        ELSE 'NON-WEB'
        END)
