select  *
--	tblOrder.ixCustomer,
--	tblOrder.ixOrder,     
--      tblOrder.sMatchbackSourceCode,
--      count(distinct vwNewCustOrder.ixOrder) as '# New Custs',
--      count(distinct tblOrder.ixCustomer) as '# Customers',
--      sum(tblOrder.mMerchandise) as 'Merch Total',
--      sum(tblOrder.mMerchandiseCost) as 'Merch Cost',
--      sum(case when tblOrder.ixOrder like ('%-%') THEN 0 ELSE 1 END) as '# Orders'
from tblOrder       
      left join vwNewCustOrder on tblOrder.ixOrder = vwNewCustOrder.ixOrder
where      
    tblOrder.sOrderStatus not in ('Cancelled', 'Pick Ticket')
    and
--    (tblOrder.dtOrderDate >= '06/29/07' and tblOrder.dtOrderDate <= '08/29/07')	and tblOrder.sMatchbackSourceCode in ('250AM7')
--    (tblOrder.dtOrderDate >= '06/10/08' and tblOrder.dtOrderDate <= '08/10/08')	and tblOrder.sMatchbackSourceCode in ('259PT8','257PT8')
--    (tblOrder.dtOrderDate >= '05/29/09' and tblOrder.dtOrderDate <= '07/29/09')	and tblOrder.sMatchbackSourceCode in ('278HRN','274HRN')
--    (tblOrder.dtOrderDate >= '05/28/10' and tblOrder.dtOrderDate <= '07/28/10')	and tblOrder.sMatchbackSourceCode in ('293HRN','287HRN','291HRN')
--    (tblOrder.dtOrderDate >= '05/27/11' and tblOrder.dtOrderDate <= '07/11/11')	and tblOrder.sMatchbackSourceCode in ('318HRN','314HRN','312HRN','305HRN')
	(tblOrder.dtOrderDate >= '06/29/07' and tblOrder.dtOrderDate <= '07/11/11')	and	tblOrder.sMatchbackSourceCode in ('250AM7','259PT8','257PT8','278HRN','274HRN','293HRN','287HRN','291HRN','318HRN','314HRN','312HRN','305HRN','293HRN','287HRN','291HRN')
--group by
--	tblOrder.ixCustomer,
--	tblOrder.ixOrder,
--      tblOrder.sMatchbackSourceCode



