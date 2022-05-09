-- STRING_AGG examples

SELECT CO.ixCustomer, STRING_AGG(SC.ixCatalog, ',') AS CatalogsReceived
FROM tblCustomerOffer CO 
		left join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
	where SC.sSourceCodeType = 'CAT-H'
		and CO.dtActiveStartDate >= '01/01/17'
GROUP BY CO.ixCustomer

-- Cusomters and the orders they placed in 2018 that contain a specific SKU
SELECT O.ixCustomer, STRING_AGG(O.ixOrder, ',') AS 'OrdersContainingSKU_EGIFT'
FROM tblOrder O
		left join tblOrderLine OL on O.ixOrder = OL.ixOrder
WHERE O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '01/01/2018' and '12/31/2018'
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and OL.ixSKU = 'EGIFT'
    and OL.flgLineStatus = 'Shipped'
GROUP BY O.ixCustomer


select ixSKU, count(*) 
from tblOrderLine where dtOrderDate > = '01/01/2018'
and ixOrder NOT LIKE 'Q%'
group by ixSKU
having count(*) > 1000
order by count(*) desc


