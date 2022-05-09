-- Orders with invoice date PRIOR to order date

SELECT FORMAT(dtInvoiceDate,'yyyy.MM.dd') 'INVOICED',
     FORMAT(count(*),'###,###') 'OrderCnt'
from tblOrder
where dtInvoiceDate >= '07/03/2020'
and sOrderStatus = 'Shipped'
group by dtInvoiceDate
order by dtInvoiceDate
/*
INVOICED	OrderCnt
2020.07.03	4,564

after fixes
2020.07.03	2,252
2020.07.04	8
2020.07.05	2,304

*/

SELECT dtShippedDate, count(*)
from tblOrder
where dtShippedDate >= '06/05/2020'
and sOrderStatus = 'Shipped'
group by dtShippedDate
order by dtShippedDate



SELECT RF.ixOrder, O.dtInvoiceDate, O.dtShippedDate, O.sOrderStatus
FROM [SMITemp].dbo.PJC_TEMP_OrdersToRefeed RF -- 10,289
LEFT join tblOrder O on RF.ixOrder = O.ixOrder
where --O.dtInvoiceDate is NOT NULL-- -- 139
 --O.dtInvoiceDate <> O.dtShippedDate
order by O.dtInvoiceDate


select ixOrder, sOrderStatus, dtOrderDate, dtInvoiceDate, dtShippedDate from tblOrder 
where dtInvoiceDate = '07/03/2020' -- 191
and dtOrderDate between '07/04/2020' and '07/05/2020'
order by dtOrderDate


-- 914 ordered on the 07/04



and dtOrderDate between '07/04/2020' and '07/05/2020'
order by dtOrderDate

