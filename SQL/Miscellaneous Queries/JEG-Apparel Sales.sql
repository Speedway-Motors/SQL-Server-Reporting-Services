/*Apparel Sales*/
         
select
	  tblSKU.ixPGC,
	  tblOrderLine.ixSKU,
	  tblSKU.sDescription,
      sum(tblOrderLine.mExtendedPrice) as 'Revenue',
      sum(tblOrderLine.iQuantity) as 'Qty',
      sum(tblOrderLine.mCost) as 'Cost'
from
      tblOrderLine
      left join tblOrder on tblOrderLine.ixOrder = tblOrder.ixOrder
      left join tblSKU on tblOrderLine.ixSKU = tblSKU.ixSKU
      left join vwNewCustOrder on tblOrderLine.ixOrder = vwNewCustOrder.ixOrder
where
      (tblSKU.ixPGC like ('%A') or tblSKU.ixPGC like ('%P'))
      and
      (tblOrder.sOrderChannel <> 'INTERNAL' and tblOrder.sSourceCodeGiven not in ('INTERNAL','MRR','MRRWEB','PRS','PRSWEB','EMP','EMPR','EMPS'))
      and
      (((tblOrderLine.flgLineStatus = 'Shipped' or tblOrderLine.flgLineStatus = 'Open') and (tblOrder.sOrderStatus = 'Open' or tblOrder.sOrderStatus = 'Shipped'))
            or
      ((tblOrderLine.flgLineStatus = 'Open' or tblOrderLine.flgLineStatus = 'Backordered') and tblOrder.sOrderStatus = 'Backordered'))
      and
--      /*this year*/(tblOrderLine.dtOrderDate >= '01/01/11' and tblOrderLine.dtOrderDate <='09/18/11')
      /*last year*/(tblOrderLine.dtOrderDate >= '01/01/10' and tblOrderLine.dtOrderDate <='09/18/10')
      and
      tblOrderLine.mExtendedPrice > .25
      and
      (tblSKU.sDescription not like '%SUIT%' and tblSKU.sDescription not like '%GLOVES%' and
       tblSKU.sDescription not like '%HEAT SLEEVE%' and tblSKU.sDescription not like '%APRON%' and
       tblSKU.sDescription not like 'BOLT ON WEIGHT CLAMP' and tblSKU.sDescription not like '%LITHIUM%' and
       tblSKU.sDescription not like 'PINSTRIPE PAINT%' and tblSKU.sDescription not like 'WS FRAME 33-34 CLS CAR PLN' and
       tblSKU.sDescription not like '%GO-PRO%' and tblSKU.sDescription not like '%MOTORSPORT HERO%' and
       tblSKU.sDescription not like '%GOPRO%' and tblSKU.sDescription not like '%LENS FOR 408-5170%' and
       tblSKU.sDescription not like 'BELL APEX%' and tblSKU.sDescription not like 'BELL ENDURANCE%' and 
       tblSKU.sDescription not like 'BELL INNER X%' and tblSKU.sDescription not like 'BELL VISION%' and
       tblSKU.sDescription not like '62-65 409 CHEVY GASKET SET' and tblSKU.sDescription not like 'STEERING SHAFT & COMP')
group by
	  tblSKU.ixPGC,
	  tblSKU.sDescription,
      tblOrderLine.ixSKU

/*total customer count for Apparel Sales*/
select 
	(case  
	 when tblOrderLine.dtOrderDate >= '01/01/10' and tblOrderLine.dtOrderDate <= '09/18/10' then 'Yr2010'
	 when tblOrderLine.dtOrderDate >= '01/01/11' and tblOrderLine.dtOrderDate <= '09/18/11' then 'Yr2011'
	 else 'Other' end),
	count(distinct(tblOrderLine.ixCustomer)) as 'Customers',
	count(distinct(vwNewCustOrder.ixOrder)) as 'New Customers'
from
    tblOrderLine
    left join tblOrder on tblOrderLine.ixOrder = tblOrder.ixOrder
    left join tblSKU on tblOrderLine.ixSKU = tblSKU.ixSKU
    left join vwNewCustOrder on tblOrderLine.ixOrder = vwNewCustOrder.ixOrder
where
      (tblSKU.ixPGC like ('%A') or tblSKU.ixPGC like ('%P'))
      and
      (tblOrder.sOrderChannel <> 'INTERNAL' and tblOrder.sSourceCodeGiven not in ('INTERNAL','MRR','MRRWEB','PRS','PRSWEB','EMP','EMPR','EMPS'))
      and
      (((tblOrderLine.flgLineStatus = 'Shipped' or tblOrderLine.flgLineStatus = 'Open') and (tblOrder.sOrderStatus = 'Open' or tblOrder.sOrderStatus = 'Shipped'))
            or
      ((tblOrderLine.flgLineStatus = 'Open' or tblOrderLine.flgLineStatus = 'Backordered') and tblOrder.sOrderStatus = 'Backordered'))
      and
      (tblOrderLine.dtOrderDate >= '01/01/10' and tblOrderLine.dtOrderDate <='09/18/11')
      and
      tblOrderLine.mExtendedPrice > .25
      and
      (tblSKU.sDescription not like '%SUIT%' and tblSKU.sDescription not like '%GLOVES%' and
       tblSKU.sDescription not like '%HEAT SLEEVE%' and tblSKU.sDescription not like '%APRON%' and
       tblSKU.sDescription not like 'BOLT ON WEIGHT CLAMP' and tblSKU.sDescription not like '%LITHIUM%' and
       tblSKU.sDescription not like 'PINSTRIPE PAINT%' and tblSKU.sDescription not like 'WS FRAME 33-34 CLS CAR PLN' and
       tblSKU.sDescription not like '%GO-PRO%' and tblSKU.sDescription not like '%MOTORSPORT HERO%' and
       tblSKU.sDescription not like '%GOPRO%' and tblSKU.sDescription not like '%LENS FOR 408-5170%' and
       tblSKU.sDescription not like 'BELL APEX%' and tblSKU.sDescription not like 'BELL ENDURANCE%' and 
       tblSKU.sDescription not like 'BELL INNER X%' and tblSKU.sDescription not like 'BELL VISION%' and
       tblSKU.sDescription not like '62-65 409 CHEVY GASKET SET' and tblSKU.sDescription not like 'STEERING SHAFT & COMP')
group by
		(case  
	 when tblOrderLine.dtOrderDate >= '01/01/10' and tblOrderLine.dtOrderDate <= '09/18/10' then 'Yr2010'
	 when tblOrderLine.dtOrderDate >= '01/01/11' and tblOrderLine.dtOrderDate <= '09/18/11' then 'Yr2011'
	 else 'Other' end)



