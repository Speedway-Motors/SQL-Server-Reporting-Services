/**** Case 14144 - Source Code 33905 extremely low response rate */ 

select ixSourceCode, COUNT(*) QtySent
from tblCustomerOffer 
where ixSourceCode like '3390%'  
group by ixSourceCode
order by ixSourceCode


select *
from tblCustomerOffer 
where ixSourceCode = '33905'  -- 10,854 exact match to CST
--group by ixSourceCode
order by ixSourceCode



select sSourceCodeGiven 'SC Given', COUNT(*) 'SC Given QTY' -- 556
from tblOrder O
where sSourceCodeGiven like '3390%' 
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
GROUP BY sSourceCodeGiven
ORDER BY sSourceCodeGiven

select sMatchbackSourceCode 'MB SC', COUNT(*) 'MB SC QTY'
from tblOrder O
where sMatchbackSourceCode like '3390%'  -- 60
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
GROUP BY sMatchbackSourceCode
ORDER BY sMatchbackSourceCode

select * from tblSourceCode 
where ixSourceCode like '3390%'
order by ixSourceCode



select dtOrderDate, COUNT(*)
from tblOrder O
where sSourceCodeGiven = '33905' 
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
group by   dtOrderDate
order by dtOrderDate  