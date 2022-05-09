/* -- CARB SKUs shipped to CA
how many dealers we've shipped "CARB = NS" items to that are in California? can you break it down by year? since 2014?
*/


select distinct O.ixCustomer
FROM tblOrderLine OL
    left join tblOrder O on OL.ixOrder = O.ixOrder
    left join tblSKU S on S.ixSKU = OL.ixSKU
where O.sOrderStatus = 'Shipped'
    and O.dtShippedDate >= '01/01/2014' 
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and S.flgCARB = 1
    and OL.flgLineStatus in ('Shipped','Dropshipped')
    and O.sShipToState = 'CA'                   -- 54   20,615
    and O.ixCustomerType in ('30','32','40') --           167



    SELECT ixSKU, sBaseIndex
    FROM tblSKU
    where ixSKU = '910678'

        SELECT ixSKU, sBaseIndex
    FROM tblSKU
    where sBaseIndex like '910678%'
