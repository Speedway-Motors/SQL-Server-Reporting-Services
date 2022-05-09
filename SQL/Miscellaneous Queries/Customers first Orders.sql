SELECT count(FO.ixCustomer) CustCount,
    SC.sMatchbackSourceCode
FROM
/*** First Order ****/
    (select C.ixCustomer, min(O.ixOrderTime) ixOrderTime, min(O.dtOrderDate) FirstOrderDate -- 50565
    from tblOrder O
        join tblCustomer C on O.ixCustomer = C.ixCustomer
    where O.dtOrderDate >= '01/01/2010'
    and O.dtOrderDate < '01/01/2011'
    and O.mMerchandise > 0
    and O.sOrderStatus = 'Shipped'
    and C.dtAccountCreateDate >= '01/01/2010'
    and C.dtAccountCreateDate < '01/01/2011'
    group by C.ixCustomer
    ) FO
/*** Source Code ***/
join (select O.ixCustomer,O.sMatchbackSourceCode, O.dtOrderDate, O.ixOrderTime
      from tblOrder O
        join tblCustomer C on O.ixCustomer = C.ixCustomer
        where O.dtOrderDate >= '01/01/2010'
        and O.dtOrderDate < '01/01/2011'
        and O.mMerchandise > 0
        and O.sOrderStatus = 'Shipped'
        and C.dtAccountCreateDate >= '01/01/2010'
        and C.dtAccountCreateDate < '01/01/2011'
    ) SC on FO.ixCustomer = SC.ixCustomer 
        and FO.FirstOrderDate = SC.dtOrderDate
        and FO.ixOrderTime = SC.ixOrderTime

GROUP BY SC.sMatchbackSourceCode,SC.dtOrderDate
order by SC.dtOrderDate

select distinct O.ixCustomer -- 150K
from tblOrder O
where O.dtOrderDate >= '01/01/2010'
    and O.dtOrderDate < '01/01/2011'
    and O.mMerchandise > 0
    and O.sOrderStatus = 'Shipped'

select distinct ixCustomer
from tblCustomer C
where C.dtAccountCreateDate >= '01/01/2010'
    and C.dtAccountCreateDate < '01/01/2011'

O.sSourceCodeGiven, O.sMatchbackSourceCode

select distinct ixCustomer from tblOrder
where dtShippedDate > '01/01/2010'
  and ixCustomer not in (select ixCustomer from tblCustomer)

select O.ixCustomer
from tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
where O.dtShippedDate > '01/01/2010'
and C.dtAccountCreateDate is null


select distinct sOrderStatus from tblOrder

select top 10 * from tblCustomer


select top 10 * from tblOrder

select * from tblOrder
where dtOrderDate = '02/02/2011'
order by ixOrder