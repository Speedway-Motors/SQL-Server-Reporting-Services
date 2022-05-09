-- SALES BY STATE
SELECT   O.sShipToState 'Ship to State',
         sum(O.mMerchandise)        Sales,
       count(distinct O.ixCustomer) CustCount,
       count(distinct O.ixOrder)    OrdCount
FROM  tblOrder O
WHERE  O.dtShippedDate >= '01/01/2010'
   and O.dtShippedDate < '01/01/2011'
   and ((O.sShipToCountry is NOT null OR O.sShipToCountry in ('US', 'USA'))  
        and O.sShipToState in (select ixState from tblStates))
   and O.sOrderStatus in ('Shipped')
GROUP BY O.sShipToState
ORDER BY O.sShipToState

-- FOREIGN ORDERS
SELECT  sum(O.mMerchandise)        Sales,    --
       count(distinct O.ixCustomer) CustCount,
       count(distinct O.ixOrder)    OrdCount
FROM  tblOrder O
WHERE  O.dtShippedDate >= '01/01/2010'
   and O.dtShippedDate < '01/01/2011'
   and O.sShipToCountry NOT in ('US', 'USA')
   and O.sShipToCountry is NOT null
   and O.sOrderStatus in ('Shipped')
/*
SPEEDWAY
Sales	      CustCount	OrdCount
2309800.68	2660	      5439

Afco
Sales	      CustCount	OrdCount
331406.87	153	      316

*/



-- RETURNS BY STATE
select CUST.sMailToState,
      SUM(CMM.mMerchandise) Returns
from    tblCreditMemoMaster CMM 
   join tblCustomer CUST on CUST.ixCustomer = CMM.ixCustomer
where  CMM.flgCanceled = 0
   and CMM.dtCreateDate >= '01/01/2010'
   and CMM.dtCreateDate <  '01/01/2011'
   and CUST.sMailToState in (select ixState from tblStates)
group by CUST.sMailToState
order by CUST.sMailToState

-- FOREIGN RETURNS
select SUM(CMM.mMerchandise) Returns   -- SMI 110163.41        Afco 48772.61
from    tblCreditMemoMaster CMM 
   join tblCustomer CUST on CUST.ixCustomer = CMM.ixCustomer
where  CMM.flgCanceled = 0
   and CMM.dtCreateDate >= '01/01/2010'
   and CMM.dtCreateDate <  '01/01/2011'
   and CUST.sMailToCountry is NOT null
   and CUST.sMailToCountry NOT in ('US', 'USA')



select distinct sMailToCountry, count(*) QTY
from tblCustomer
group by sMailToCountry

order by QTY desc