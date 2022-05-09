SELECT
    SC.ixSourceCode,
    count(distinct O.ixOrder)       WindowOrderCount,
    count(distinct O.ixCustomer)    WindowCustCount,
    sum(O.mMerchandise)             WindowSalesCount
FROM
    tblOrder O
    join tblSourceCode SC on SC.ixSourceCode = isnull(O.sMatchbackSourceCode,O.sSourceCodeGiven)
WHERE SC.ixSourceCode = '28710'
    and O.sOrderType <> 'Internal'
    and O.sOrderStatus = 'Shipped' 
GROUP BY SC.ixSourceCode




/*
select * from tblSourceCode
where ixSourceCode IN ('28710','28712','28716','28720','28723','28728','28730','28740','28742','28748','28754','28762','28766')



select * from tblSourceCode where ixEndDate is not NULL order by ixStartDate
where ixStartDate > 15344



select * from tblOrder
where sMatchbackSourceCode is null
and ixOrderDate > 15344



select distinct(sOrderStatus)
from tblOrder
*/