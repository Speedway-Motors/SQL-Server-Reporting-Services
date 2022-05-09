/***2008***/
-- drop view vwCustomers2008	

create view vwCustomers2008
as
 select OL.ixCustomer,OL.ixOrder,OL.mExtendedPrice,OL.mExtendedCost,OL.flgKitComponent,
    (case when OL.dtShippedDate > 1YRAGO THEN 'TY'
          when (OL.dtShippedDate <= 1YRAGO
            and OL.dtShippedDate > 2YRSAGO) THEN 'LY'
          else 'LY2'
     end) YRCat
 from tblOrder O 
    left join tblOrderLine OL   on OL.ixOrder = O.ixOrder --       122300
 where O.sOrderChannel <> 'INTERNAL'
   and O.sSourceCodeGiven <> 'INTERNAL'
   and O.sOrderType not in ('Internal','MRR','PRS')
   and O.mMerchandise > 0
   and O.ixCustomer not in ('888','118952')
   and O.sOrderStatus <> 'Cancelled'
   and OL.flgLineStatus = 'Shipped'
   and OL.dtShippedDate >= '01/01/2008' and OL.dtShippedDate < '01/01/2009'


alter view vwCustomers2009 -- 2008 Customers that also ordered in 2009
as
 select OL.ixCustomer,OL.ixOrder,OL.mExtendedPrice,OL.mExtendedCost,OL.flgKitComponent
 from tblOrder O 
    left join tblOrderLine OL   on OL.ixOrder = O.ixOrder --       122300
 where O.sOrderChannel <> 'INTERNAL'
   and O.sSourceCodeGiven <> 'INTERNAL'
   and O.sOrderType not in ('Internal','MRR','PRS')
   and O.mMerchandise > 0
   and O.ixCustomer not in ('888','118952')
   and O.sOrderStatus <> 'Cancelled'
   and OL.flgLineStatus = 'Shipped'
   and OL.dtShippedDate >= '01/01/2009' and OL.dtShippedDate < '01/01/2010'

alter view vwCustomers2010 -- 2008 Customers that also ordered in 2009 & 2010
as
 select OL.ixCustomer,OL.ixOrder,OL.mExtendedPrice,OL.mExtendedCost,OL.flgKitComponent
 from tblOrder O 
    left join tblOrderLine OL   on OL.ixOrder = O.ixOrder --       122300
 where O.sOrderChannel <> 'INTERNAL'
   and O.sSourceCodeGiven <> 'INTERNAL'
   and O.sOrderType not in ('Internal','MRR','PRS')
   and O.mMerchandise > 0
   and O.ixCustomer not in ('888','118952')
   and O.sOrderStatus <> 'Cancelled'
   and OL.flgLineStatus = 'Shipped'
   and OL.dtShippedDate >= '01/01/2010'


select * into PJC_2008_customers from vwCustomers2008

-- drop table PJC_2009_customers
select vw.* into PJC_2009_customers 
from vwCustomers2009 vw
    join PJC_2008_customers Cust on Cust.ixCustomer = vw.ixCustomer


select * into PJC_2010_customers from vwCustomers2010




select count(distinct ixCustomer) from PJC_2008_customers   -- B2= 122300
select count(distinct ixOrder) from PJC_2008_customers -- 276264 
select sum(mExtendedPrice) from PJC_2008_customers -- 49,900,463.049

select sum(mExtendedPrice)/count(distinct ixOrder)-- B5= 180.63
from PJC_2008_customers

select sum(mExtendedPrice)/count(distinct ixOrder)-- C5= 176.4221
from PJC_2009_customers

select sum(mExtendedPrice)/count(distinct ixOrder)-- D5= 173.9872
from PJC_2010_customers


select AVG(X.CustAvgOrd)
from (select ixCustomer, sum(mExtendedPrice)/count(distinct ixOrder) CustAvgOrd
      from PJC_2008_customers
      group by ixCustomer
     ) X

select AVG(X.CustAvgOrd)
from (select ixCustomer, sum(mExtendedPrice)/count(distinct ixOrder) CustAvgOrd
      from PJC_2009_customers
      group by ixCustomer
     ) X

select AVG(X.CustAvgOrd)
from (select ixCustomer, sum(mExtendedPrice)/count(distinct ixOrder) CustAvgOrd
      from PJC_2010_customers
      group by ixCustomer
     ) X


select ixCustomer, sum(mExtendedPrice)/count(distinct ixOrder) CustAvgOrd
      from PJC_2010_customers
      group by ixCustomer
      order by sum(mExtendedPrice)/count(distinct ixOrder)


SELECT MIN(sum(mExtendedPrice)/count(distinct ixOrder)) FROM
  (SELECT TOP 50 PERCENT sum(mExtendedPrice)/count(distinct ixOrder) FROM PJC_2010_customers ORDER BY sum(mExtendedPrice)/count(distinct ixOrder) DESC) X


SELECT MIN(Value) FROM
  (SELECT TOP 50 PERCENT sum(mExtendedPrice)/count(distinct ixOrder) FROM (select ixCustomer, sum(mExtendedPrice)/count(distinct ixOrder) CustAvgOrd
      from PJC_2010_customers
      group by ixCustomer
     ) ORDER BY sum(mExtendedPrice)/count(distinct ixOrder) DESC)
   AS H2



SELECT MIN(CustAvgOrd) FROM -- B7= 105.086
  (SELECT TOP 50 PERCENT CustAvgOrd FROM (select ixCustomer, sum(mExtendedPrice)/count(distinct ixOrder) CustAvgOrd
                                      from PJC_2008_customers
                                      group by ixCustomer) X
  ORDER BY CustAvgOrd DESC) AS H2

SELECT MIN(CustAvgOrd) FROM -- C7= 104.91
  (SELECT TOP 50 PERCENT CustAvgOrd FROM (select ixCustomer, sum(mExtendedPrice)/count(distinct ixOrder) CustAvgOrd
                                      from PJC_2009_customers
                                      group by ixCustomer) X
  ORDER BY CustAvgOrd DESC) AS H2

SELECT MIN(CustAvgOrd) FROM -- D7= 102.9733
  (SELECT TOP 50 PERCENT CustAvgOrd FROM (select ixCustomer, sum(mExtendedPrice)/count(distinct ixOrder) CustAvgOrd
                                      from PJC_2010_customers
                                      group by ixCustomer) X
  ORDER BY CustAvgOrd DESC) AS H2

select sum(mExtendedPrice) from PJC_2008_customers -- B8= 49,900,463.049
select sum(mExtendedPrice) from PJC_2009_customers -- C8= 53,419,742.403
select sum(mExtendedPrice) from PJC_2010_customers -- D8= 50,988,001.608
/*
ixCustomer	ixOrder	OrdTotal   --> $196.63 AVG
1000302	3636116	265.44
1000302	3032909	92.46
1000302	3175824	232.98
*/

select 1 as value
into PJC_Meidan_test

insert into PJC_Meidan_test
select 3


select * from PJC_Meidan_test



select count(distinct ixCustomer) from PJC_2009_customers   -- B2= 134216
select count(distinct ixOrder) from PJC_2009_customers -- 302795 

select count(distinct ixCustomer) from PJC_2010_customers   -- B2= 134589
select count(distinct ixOrder) from PJC_2010_customers -- 293056 

select count(distinct A.ixCustomer) 
from PJC_2008_customers A
    JOIN PJC_2009_customers B on A.ixCustomer = B.ixCustomer-- C2= 53610

select count(distinct A.ixCustomer) 
from PJC_2008_customers A
    JOIN PJC_2009_customers B on A.ixCustomer = B.ixCustomer
    JOIN PJC_2010_customers C on A.ixCustomer = C.ixCustomer-- D2= 30074
  




select * from PJC_2008_customers



create view vwCustomers2010
as
 select OL.ixCustomer,OL.ixOrder,OL.mExtendedPrice,OL.mExtendedCost,OL.flgKitComponent
 from tblOrder O 
    left join tblOrderLine OL   on OL.ixOrder = O.ixOrder --       122300
 where O.sOrderChannel <> 'INTERNAL'
   and O.sSourceCodeGiven <> 'INTERNAL'
   and O.sOrderType not in ('Internal','MRR','PRS')
   and O.mMerchandise > 0
   and O.ixCustomer not in ('888','118952')
   and O.sOrderStatus <> 'Cancelled'
   and OL.flgLineStatus = 'Shipped'
   and OL.dtShippedDate >= '01/01/2008' and OL.dtShippedDate < '01/01/2009'

select
    count(distinct ixCustomer)  CustCount,
    count(distinct ixOrder)     OrderCount,
    count(distinct ixOrder)/count(distinct ixCustomer) AvgOrdsPerYr
-- SimpleAvgOrdAmt
-- AvgCustAvgOrdAmt
-- MedCustAvgOrderAmt
-- TotRev
-- TotRev*.1 CostFullfillment
from vwCustomers2008



select 
      sum(mMerchandise) as 'Merch08Sum',
      avg(mMerchandise) as 'Merch08Avg',
 	  sum(case when (flgIsBackorder = '1' and mShipping = 0) THEN 0 ELSE 1 END) as 'Orders08',
      sum(mMerchandiseCost) as 'COGS08'
from vwCust08a      

drop view vwCust08	






create view vwCust08
as
select
      ixCustomer as 'Customer08',
      sum(mMerchandise) as 'Merch08Sum',
      avg(mMerchandise) as 'Merch08Avg',
 	  sum(case when (flgIsBackorder = '1' and mShipping = 0) THEN 0 ELSE 1 END) as 'Orders08',
      sum(mMerchandiseCost) as 'COGS08'
from
      vwCust08a
group by
	  ixCustomer
	  
	  
select * from vwCust08	  
	
/***2009***/
drop view vwCust09a	

create view vwCust09a
as
select * from tblOrder
where 
      (O.dtOrderDate >='08/01/08' and O.dtOrderDate <='07/31/09')
	  and O.sOrderType not in ('Internal','MRR','PRS')
      and O.sOrderChannel <> 'INTERNAL' and O.sSourceCodeGiven <> 'INTERNAL'
      and O.sOrderStatus <> 'Cancelled'
      and O.ixCustomer <> '888'
      and O.mMerchandise > 0


drop view vwCust09	

create view vwCust09
as
select
      ixCustomer as 'Customer09',
      sum(mMerchandise) as 'Merch09Sum',
      avg(mMerchandise) as 'Merch09Avg',
 	  sum(case when (flgIsBackorder = '1' and mShipping = 0) THEN 0 ELSE 1 END) as 'Orders09',
      sum(mMerchandiseCost) as 'COGS09'
from
      vwCust09a
group by
	  ixCustomer
	  
	  
/***2010***/	  
drop view vwCust10a	

create view vwCust10a
as
select * from tblOrder
where 
      (O.dtOrderDate >='08/01/09' and O.dtOrderDate <='07/31/10')
	  and O.sOrderType not in ('Internal','MRR','PRS')
      and O.sOrderChannel <> 'INTERNAL' and O.sSourceCodeGiven <> 'INTERNAL'
      and O.sOrderStatus <> 'Cancelled'
      and O.ixCustomer <> '888'
      and O.mMerchandise > 0


drop view vwCust10	

create view vwCust10
as
select
      ixCustomer as 'Customer10',
      sum(mMerchandise) as 'Merch10Sum',
      avg(mMerchandise) as 'Merch10Avg',
 	  sum(case when (flgIsBackorder = '1' and mShipping = 0) THEN 0 ELSE 1 END) as 'Orders10',
      sum(mMerchandiseCost) as 'COGS10'
from
      vwCust10a
group by
	  ixCustomer	  


/***merge 3 years***/	  
drop view vwTemp1

create view vwTemp1
as	
select 
	A.Customer08, 
	A.Merch08Sum,
	A.Merch08Avg, 
	A.Orders08,
	A.COGS08,
	B.Customer09,
	B.Merch09Sum,
	B.Merch09Avg,
	B.Orders09,
	B.COGS09
from
	vwCust08 as A
		left join vwCust09 as B
		on A.Customer08 = B.Customer09

drop view vwLTVcalc
create view vwLTVcalc
as		
select 
	A.Customer08, 
	A.Merch08Sum, 
	A.Merch08Avg,
	A.Orders08,
	A.COGS08,
	A.Customer09,
	A.Merch09Sum,
	A.Merch09Avg,
	A.Orders09,
	A.COGS09,
	B.Customer10,
	B.Merch10Sum,
	B.Merch10Avg,
	B.Orders10,
	B.COGS10
from
	vwTemp1 as A
		left join vwCust10 as B
		on A.Customer09 = B.Customer10	
		
select * from vwLTVcalc	  




/**fix for missing order counts**/
select *
from tblOrder
where 
  (O.dtOrderDate >='08/01/07' and O.dtOrderDate <='07/31/08')
  and
  O.sOrderStatus <> 'Cancelled'
  and
  O.ixCustomer in 
('859755',
'344422',
'964536',
'806658',
'455727',
'902033',
'740909',
'967305',
'955873',
'947801',
'462060',
'870071',
'201983',
'676286',
'962872',
'972965',
'886213',
'472763',
'394910',
'511687',
'859641',
'952920',
'750925',
'1135204',
'199849',
'979710',
'661460',
'952388',
'960257',
'1074103',
'953482',
'967196',
'969220',
'972879',
'118952',
'776303',
'1235506',
'1339104',
'724756',
'733255',
'957868',
'427313',
'960230',
'933094',
'959357',
'1021329',
'979847',
'805005',
'978381',
'983628',
'955819',
'150414',
'981310',
'958590',
'969199',
'919338',
'991231',
'962217',
'960231',
'938222',
'1057509',
'885558',
'440069',
'950622',
'960280',
'902476',
'874278',
'592939',
'957807',
'839665',
'543685',
'966598',
'914905',
'813225',
'1055208',
'1016697',
'461295',
'872249',
'965694',
'958164',
'440547',
'344501',
'915801',
'956128',
'809393',
'584122',
'337045',
'904921',
'956543',
'935338',
'969496',
'958098',
'1277004',
'1217107',
'718577',
'979942',
'948438',
'857555',
'939997',
'1195800',
'989117',
'308635',
'893855',
'1098901',
'757900',
'957413')

