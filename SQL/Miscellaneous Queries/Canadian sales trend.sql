-- Canadian sales trend

/***** ORDERS to CANADA *******/
-- 2012
Select COUNT(ixOrder) OrdCount, SUM(mMerchandise) TotSales
from tblOrder
where dtOrderDate between '07/26/2012' and '12/15/2012'
and mMerchandise > 5 -- to exclude catalog only orders
and sShipToCountry = 'CANADA'
and sOrderStatus = 'Shipped'

-- 2013 matching range
Select COUNT(ixOrder) OrdCount, SUM(mMerchandise) TotSales
from tblOrder
where dtOrderDate between '07/25/2013' and '12/15/2013'
and mMerchandise > 5 -- to exclude catalog only orders
and sShipToCountry = 'CANADA'
and sOrderStatus = 'Shipped'



/***** ORDERS to everywhere else *******/
Select COUNT(ixOrder) OrdCount, SUM(mMerchandise) TotSales
from tblOrder
where dtOrderDate between '07/26/2012' and '08/21/2012'
and mMerchandise > 5 -- to exclude catalog only orders
and sShipToCountry <> 'CANADA'
and sOrderStatus = 'Shipped'

Select COUNT(ixOrder) OrdCount, SUM(mMerchandise) TotSales
from tblOrder
where dtOrderDate between '07/25/2013' and '08/20/2013'
and mMerchandise > 5 -- to exclude catalog only orders
and sShipToCountry <> 'CANADA'
and sOrderStatus = 'Shipped'




-- Credit Memos
select CMM.* 
from tblCreditMemoMaster CMM
where ixOrder in (Select ixOrder
                    from tblOrder
                    where dtOrderDate between '07/25/2013' and '08/20/2013'
                    and mMerchandise > 5 -- to exclude catalog only orders
                    and sShipToCountry = 'CANADA'
                    and sOrderStatus = 'Shipped'
                  )






