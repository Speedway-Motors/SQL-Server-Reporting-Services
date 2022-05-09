/** customers leaving 12 month file, total revenue **/
select
	count (distinct O.ixCustomer),
	count (distinct O.ixOrder),
	sum(O.mMerchandise)
from
	tblOrder O
	
where
	O.ixCustomer in 
		(select OLD.ixCustomer from tblOrder OLD where OLD.dtOrderDate >= '07/15/09' and OLD.dtOrderDate <= '07/15/10' and OLD.sOrderStatus = 'Shipped')
	and O.ixCustomer not in
		(select NEW.ixCustomer from tblOrder NEW where NEW.dtOrderDate >= '07/15/10'  and NEW.sOrderStatus = 'Shipped')


