select
      C.ixCustomer as 'Customer#',
      C.sCustomerLastName as 'Last Name',
      C.sCustomerFirstName as 'First Name',
      --OL.ixSKU as 'SKU',
      --sum(OL.iQuantity) as 'Qty',
      --sum(OL.mExtendedPrice) as 'Revenue',
      sum(O.mMerchandise) as 'Merchandise Total'
      count(distinct O.ixOrders) as '# of Dropshipped Orders'
from  tblOrder O
      --left join tblOrderLine OL on OL.ixOrder = O.ixOrder
      left join tblCustomer C on C.ixCustomer = OL.ixCustomer
where
      O.sOrderStatus = 'Shipped'
      and O.dtShippedDate >= '01/01/11'
      and O.dtShippedDate < '08/20/11'
      and O.ixOrder in -- sub query to find out which orders had a line item like 'DROP%'
                        (select disinct ixOrder
                        from tblOrderLine
                        where ixSKU like 'DROP%'
                          and flgLineStatus in ('Shipped','Dropshipped')
                         )
group by
      C.ixCustomer,
      C.sCustomerLastName,
      C.sCustomerFirstName





/*****************************
 ************ CHECKS *********
 *****************************/
select distinct ixSKU, count(*)
from tblOrderLine
where ixSKU like 'DROP%'
group by ixSKU
/*
ixSKU	         QTY
DROPSHIP	      5279
DROPSHIP-FEE	1
*/

select sOrderStatus, count(*) QTY
from tblOrder
group by sOrderStatus
/*
QTY	   sOrderStatus
903	   Backordered
53443	   Cancelled
477	   Open
3229	   Pick Ticket
1294809	Shipped
*/

select flgLineStatus, count(*) QTY
from tblOrderLine
group by flgLineStatus
/*
QTY	   flgLineStatus
179475	Backordered
216351	Cancelled
6337	   Dropshipped
357	   fail
48008	   Lost
2580	   Open
5265570	Shipped
9006	   unknown
*/




