-- SMIHD-2438 New Customer web accounts created during Founders Days promo

-- per CCC, count the # of new accounts create via Web (SC = 2190)
select D.iYear, D.iISOWeek  
    , MIN(D2.dtDate) 'Start'
    , MAX(D2.dtDate) 'End'
    , COUNT(Distinct C.ixCustomer)  NewAccountsCreated
from tblDate D
join tblCustomer C on D.ixDate =  C.ixAccountCreateDate
join (select D.iYear, D.iISOWeek, D.dtDate
      from tblDate D 
      where D.iYear between 2013 and 2015
      ) D2 on D.iYear = D2.iYear and D.iISOWeek = D2.iISOWeek
where C.dtAccountCreateDate >= '09/20/2013'
    and C.flgDeletedFromSOP = 0
    and C.ixSourceCode = '2190'
group by D.iYear, D.iISOWeek
order by D.iYear, D.iISOWeek

