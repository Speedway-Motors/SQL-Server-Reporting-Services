--Case 5628
--11/29/10 CCC

--find all shipped orders with a missin
select
	*
from 
	tblOrder O
where
	O.dtOrderDate >= '01/01/10' 
	and sMatchbackSourceCode is null
	and sOrderStatus = 'Shipped'