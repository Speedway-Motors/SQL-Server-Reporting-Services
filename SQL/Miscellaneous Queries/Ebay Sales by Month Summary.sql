/*Ebay Sales*/
         
select
	  count(distinct(tblOrder.ixCustomer)) as 'TotalCustomers', 
	  count(distinct(vwNewCustOrder.ixOrder)) as '# New Custs',
	  (case 
             -- GET YEAR MONTH COMBO
	      when tblOrderLine.dtOrderDate >= '04/01/11' and tblOrderLine.dtOrderDate <= '04/30/11' then 'April'
	      when tblOrderLine.dtOrderDate >= '05/01/11' and tblOrderLine.dtOrderDate <= '05/31/11' then 'May'
	   end) as 'Month',
      sum(tblOrderLine.mExtendedPrice) as 'Merch',
      sum(case when tblOrderLine.mExtendedPrice <> '0' THEN tblOrderLine.mExtendedCost END) as 'COGS',
      sum(case when tblOrderLine.mExtendedPrice <> '0' THEN tblOrderLine.iQuantity END) as 'Qty'
from
      tblOrder
      left join tblOrderLine on tblOrder.ixOrder = tblOrderLine.ixOrder
      left join vwNewCustOrder on tblOrder.ixOrder = vwNewCustOrder.ixOrder           
where
	  (tblOrder.dtOrderDate >= '04/01/11' and tblOrder.dtOrderDate <= '05/31/11')
	  and
      tblOrder.sOrderChannel = 'AUCTION'
      and
      (((tblOrderLine.flgLineStatus = 'Shipped' or tblOrderLine.flgLineStatus = 'Open' or tblOrderLine.flgLineStatus = 'Dropshipped') and (tblOrder.sOrderStatus = 'Open' or tblOrder.sOrderStatus = 'Shipped'))
            or
      ((tblOrderLine.flgLineStatus = 'Open' or tblOrderLine.flgLineStatus = 'Backordered') and tblOrder.sOrderStatus = 'Backordered'))
group by
   (case 
   	      when tblOrderLine.dtOrderDate >= '04/01/11' and tblOrderLine.dtOrderDate <= '04/30/11' then 'April'
   	      when tblOrderLine.dtOrderDate >= '05/01/11' and tblOrderLine.dtOrderDate <= '05/31/11' then 'May'
	   end) 


select top 10 * from tblDate


select * from tblDate
where dtDate between '01/31/2011' and '03/01/2011'


TotalCustomers # New Custs Month                 Merch                  COGS         Qty
-------------- ----------- ----- --------------------- --------------------- -----------
          1341        1326 April             155,008.30             97480.714        1647
          1171        1156 May               135,657.40             85124.029        1462


select D.iYearMonth, D.sMonth,
     cast(count(distinct(NC.ixOrder)) as decimal(6,2))/cast(count(distinct(O.ixCustomer)) as decimal(6,2)) NewCustPercent,
     count(distinct(NC.ixOrder)) OrdCount,
     sum(OL.mExtendedPrice) as 'Merch',
     sum(case when OL.mExtendedPrice <> '0' THEN OL.mExtendedCost END) as 'COGS',
     sum(case when OL.mExtendedPrice <> '0' THEN OL.iQuantity END) as 'Qty'
FROM tblOrder O 
   join tblOrderLine OL on OL.ixOrder = O.ixOrder
   join tblDate D on O.ixOrderDate = D.ixDate
   left join vwNewCustOrder NC on O.ixOrder = NC.ixOrder  
WHERE O.sOrderChannel = 'AUCTION'
       and (O.sOrderStatus in ('Open','Shipped'))
group by D.iYearMonth, D.sMonth
order by D.iYearMonth, D.sMonth


/*
iYearMonth              sMonth                               Merch
----------------------- -------------------- ---------------------
2010-03-15 00:00:00.000 MARCH                              7567.15
2010-04-15 00:00:00.000 APRIL                             20024.53
2010-05-15 00:00:00.000 MAY                               11792.53
2010-06-15 00:00:00.000 JUNE                              11999.84
2010-07-15 00:00:00.000 JULY                              20016.41
2010-08-15 00:00:00.000 AUGUST                            26439.18
2010-09-15 00:00:00.000 SEPTEMBER                         40687.80
2010-10-15 00:00:00.000 OCTOBER                           41912.50
2010-11-15 00:00:00.000 NOVEMBER                          49532.32
2010-12-15 00:00:00.000 DECEMBER                          63418.39
2011-01-15 00:00:00.000 JANUARY                           79066.63
2011-02-15 00:00:00.000 FEBRUARY                         102573.63
2011-03-15 00:00:00.000 MARCH                            147893.68
2011-04-15 00:00:00.000 APRIL                            155008.30
2011-05-15 00:00:00.000 MAY                              135657.40
*/

 




select sMethodOfPayment, count(ixOrder)
from tblOrder
where sOrderChannel = 'AUCTION'
       and sOrderStatus in ('Open','Shipped')
group by sMethodOfPayment


select sOrderChannel, count(ixOrder)
from tblOrder
where dtShippedDate >'01/01/2011'
group by sOrderChannel


select * from tblEmployee where ixEmployee = 'JWM'



SELECT
    E.sFirstname,
    E.sLastname,
    E.ixEmployee, -- placeholder until Employee# is created
    E.sPayrollId,
    E.ixDepartment,
    CONVERT(VARCHAR(10), DE.dtEventTimeDate, 101) AS [MM/DD/YYYY],
    DE.sAction,
    (Case when (DE.dtEventTimeDate > '11/02/10' and  DE.dtEventTimeDate < '11/07/10')
          then dateadd(HH,-1,DE.dtEventTimeDate) 
          else DE.dtEventTimeDate
     End) EventTimeDate
FROM
    tblEmployee E
    left join tblCardUser CU on CU.ixEmployee = E.ixEmployee
    left join tblCard C on C.ixCardUser = CU.ixCardUser
    left join tblDoorEvent DE on DE.ixCardScanNum = C.ixCardScanNum
WHERE
        E.sPayrollId = '5000'
and DE.dtEventTimeDate >= '01/01/2011'
--and E.ixDepartment = 15
ORDER BY     E.sLastname,    DE.dtEventTimeDate