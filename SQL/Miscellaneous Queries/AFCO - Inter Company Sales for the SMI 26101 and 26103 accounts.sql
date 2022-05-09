-- AFCO - Inter Company Sales for the SMI 26101 and 26103 accounts

select isnull(O.ixCustomer,OL.ixCustomer) ixCustomer, count(distinct O.ixOrder) ICSOrders, count(OL.ixOrder) ICS_OLines
from [AFCOReporting].dbo.tblOrder O
    full outer join [AFCOReporting].dbo.tblOrderLine OL on O.ixOrder = OL.ixOrder
where O.ixCustomer in ('26103')
OR OL.ixCustomer in ('26103')
group by isnull(O.ixCustomer,OL.ixCustomer)
order by isnull(O.ixCustomer,OL.ixCustomer)
/*
ixCustomer	ICSOrders	ICS_OLines
26101	     5,461	     6,854
26103	    43,254	    54,347
*/

select CONVERT(VARCHAR(10), getdate(), 101) AS 'Date    ',count(distinct O.ixOrder) ICS_Orders, count(OL.ixOrder) ICS_OLines
from [AFCOReporting].dbo.tblOrder O
    full outer join [AFCOReporting].dbo.tblOrderLine OL on O.ixOrder = OL.ixOrder
where O.ixCustomer in ('26101','26103')
OR OL.ixCustomer in ('26101','26103')
/*
Date    	ICS_Orders	ICS_OLines
06/02/2014	48,715	    61,201
*/



select ixOrder, dtDateLastSOPUpdate, ixTimeLastSOPUpdate, flgOverride
from [AFCOReporting].dbo.tblOrderLine
where ixOrder in ('4978737I','4098544I','4067749I')

4978737I
4098544I
4067749I

ixOrder	dtDateLastSOPUpdate	ixTimeLastSOPUpdate	flgOverride
4098544I	2015-05-27 00:00:00.000	8776	NULL
4978737I	2015-05-27 00:00:00.000	8806	NULL
4067749I	2015-05-27 00:00:00.000	8783	NULL


SELECT ixOrder, max(iOrdinality)
from tblOrderLine
where dtOrderDate > '01/01/2016'
group by ixOrder
order by max(iOrdinality) desc


-- TRANSFER OF OWNERSHIP FOR Mechandise when Dual DC was disabled on 5-6-2016
SELECT * from tblOrderLine where ixOrder between '775376' and '775386'


