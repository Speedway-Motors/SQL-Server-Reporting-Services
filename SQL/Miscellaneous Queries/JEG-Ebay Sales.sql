
/*Ebay Sales*/
         
select
	  count(distinct(tblOrder.ixCustomer)) as 'TotalCustomers', 
	  count(distinct(vwNewCustOrder.ixOrder)) as '# New Custs',
	  (case 
	      --when tblOrderLine.dtOrderDate >= '01/01/10' and tblOrderLine.dtOrderDate <= '01/31/10' then 'January'
	      --when tblOrderLine.dtOrderDate >= '02/01/10' and tblOrderLine.dtOrderDate <= '02/28/10' then 'February'
	      --when tblOrderLine.dtOrderDate >= '03/01/10' and tblOrderLine.dtOrderDate <= '03/31/10' then 'March'
	      --when tblOrderLine.dtOrderDate >= '04/01/10' and tblOrderLine.dtOrderDate <= '04/30/10' then 'April'
	      --when tblOrderLine.dtOrderDate >= '05/01/10' and tblOrderLine.dtOrderDate <= '05/31/10' then 'May'	  
	      --when tblOrderLine.dtOrderDate >= '06/01/10' and tblOrderLine.dtOrderDate <= '06/30/10' then 'June'
	      --when tblOrderLine.dtOrderDate >= '07/01/10' and tblOrderLine.dtOrderDate <= '07/31/10' then 'July'
	      --when tblOrderLine.dtOrderDate >= '08/01/10' and tblOrderLine.dtOrderDate <= '08/31/10' then 'August'
	      --when tblOrderLine.dtOrderDate >= '09/01/10' and tblOrderLine.dtOrderDate <= '09/30/10' then 'September'
   	      --when tblOrderLine.dtOrderDate >= '10/01/10' and tblOrderLine.dtOrderDate <= '10/31/10' then 'October'
   	      --when tblOrderLine.dtOrderDate >= '11/01/10' and tblOrderLine.dtOrderDate <= '11/30/10' then 'November'
   	      --when tblOrderLine.dtOrderDate >= '12/01/10' and tblOrderLine.dtOrderDate <= '12/31/10' then 'December'
--   	      when tblOrderLine.dtOrderDate >= '01/01/11' and tblOrderLine.dtOrderDate <= '01/31/11' then 'January'
--   	      when tblOrderLine.dtOrderDate >= '02/01/11' and tblOrderLine.dtOrderDate <= '02/28/11' then 'February'
--   	      when tblOrderLine.dtOrderDate >= '03/01/11' and tblOrderLine.dtOrderDate <= '03/31/11' then 'March'
--   	      when tblOrderLine.dtOrderDate >= '04/01/11' and tblOrderLine.dtOrderDate <= '04/30/11' then 'April'
--   	      when tblOrderLine.dtOrderDate >= '05/01/11' and tblOrderLine.dtOrderDate <= '05/31/11' then 'May'
--   	      when tblOrderLine.dtOrderDate >= '06/01/11' and tblOrderLine.dtOrderDate <= '06/30/11' then 'June'
--   	      when tblOrderLine.dtOrderDate >= '07/01/11' and tblOrderLine.dtOrderDate <= '07/31/11' then 'July'
   	      when tblOrderLine.dtOrderDate >= '08/01/11' and tblOrderLine.dtOrderDate <= '08/31/11' then 'August'
		  when tblOrderLine.dtOrderDate >= '09/01/11' and tblOrderLine.dtOrderDate <= '09/18/11' then 'September'

	   end) as 'Month',
      sum(tblOrderLine.mExtendedPrice) as 'Merch',
      sum(case when tblOrderLine.mExtendedPrice <> '0' THEN tblOrderLine.mExtendedCost END) as 'COGS',
      sum(case when tblOrderLine.mExtendedPrice <> '0' THEN tblOrderLine.iQuantity END) as 'Qty'
from
      tblOrder
      left join tblOrderLine on tblOrder.ixOrder = tblOrderLine.ixOrder
      left join vwNewCustOrder on tblOrder.ixOrder = vwNewCustOrder.ixOrder           
where
	  (tblOrder.dtOrderDate >= '08/01/11' and tblOrder.dtOrderDate <= '09/18/11')
	  and
      tblOrder.sOrderChannel = 'AUCTION'
      and
      (((tblOrderLine.flgLineStatus = 'Shipped' or tblOrderLine.flgLineStatus = 'Open' or tblOrderLine.flgLineStatus = 'Dropshipped') and (tblOrder.sOrderStatus = 'Open' or tblOrder.sOrderStatus = 'Shipped'))
            or
      ((tblOrderLine.flgLineStatus = 'Open' or tblOrderLine.flgLineStatus = 'Backordered') and tblOrder.sOrderStatus = 'Backordered'))
group by
   (case 
	      --when tblOrderLine.dtOrderDate >= '01/01/10' and tblOrderLine.dtOrderDate <= '01/31/10' then 'January'
	      --when tblOrderLine.dtOrderDate >= '02/01/10' and tblOrderLine.dtOrderDate <= '02/28/10' then 'February'
	      --when tblOrderLine.dtOrderDate >= '03/01/10' and tblOrderLine.dtOrderDate <= '03/31/10' then 'March'
	      --when tblOrderLine.dtOrderDate >= '04/01/10' and tblOrderLine.dtOrderDate <= '04/30/10' then 'April'
	      --when tblOrderLine.dtOrderDate >= '05/01/10' and tblOrderLine.dtOrderDate <= '05/31/10' then 'May'	  
	      --when tblOrderLine.dtOrderDate >= '06/01/10' and tblOrderLine.dtOrderDate <= '06/30/10' then 'June'
	      --when tblOrderLine.dtOrderDate >= '07/01/10' and tblOrderLine.dtOrderDate <= '07/31/10' then 'July'
	      --when tblOrderLine.dtOrderDate >= '08/01/10' and tblOrderLine.dtOrderDate <= '08/31/10' then 'August'
	      --when tblOrderLine.dtOrderDate >= '09/01/10' and tblOrderLine.dtOrderDate <= '09/30/10' then 'September'
   	      --when tblOrderLine.dtOrderDate >= '10/01/10' and tblOrderLine.dtOrderDate <= '10/31/10' then 'October'
   	      --when tblOrderLine.dtOrderDate >= '11/01/10' and tblOrderLine.dtOrderDate <= '11/30/10' then 'November'
   	      --when tblOrderLine.dtOrderDate >= '12/01/10' and tblOrderLine.dtOrderDate <= '12/31/10' then 'December'
--   	      when tblOrderLine.dtOrderDate >= '01/01/11' and tblOrderLine.dtOrderDate <= '01/31/11' then 'January'
--   	      when tblOrderLine.dtOrderDate >= '02/01/11' and tblOrderLine.dtOrderDate <= '02/28/11' then 'February'
--   	      when tblOrderLine.dtOrderDate >= '03/01/11' and tblOrderLine.dtOrderDate <= '03/31/11' then 'March'
--   	      when tblOrderLine.dtOrderDate >= '04/01/11' and tblOrderLine.dtOrderDate <= '04/30/11' then 'April'
--   	      when tblOrderLine.dtOrderDate >= '05/01/11' and tblOrderLine.dtOrderDate <= '05/31/11' then 'May'
--   	      when tblOrderLine.dtOrderDate >= '06/01/11' and tblOrderLine.dtOrderDate <= '06/30/11' then 'June'
--   	      when tblOrderLine.dtOrderDate >= '07/01/11' and tblOrderLine.dtOrderDate <= '07/31/11' then 'July'
   	      when tblOrderLine.dtOrderDate >= '08/01/11' and tblOrderLine.dtOrderDate <= '08/31/11' then 'August'
		  when tblOrderLine.dtOrderDate >= '09/01/11' and tblOrderLine.dtOrderDate <= '09/18/11' then 'September'

	   end) 