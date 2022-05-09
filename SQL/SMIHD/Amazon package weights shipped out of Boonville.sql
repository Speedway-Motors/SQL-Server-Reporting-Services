-- Amazon package weights shipped out of Boonville
select O.ixOrder, O.dtOrderDate, O.dtShippedDate, O.sSourceCodeGiven, P.sTrackingNumber, P.dActualWeight
    --, P.flgCanceled, P.flgReplaced
from tblOrder O
    left join tblPackage P on O.ixOrder = P.ixOrder
where sSourceCodeGiven in ('AMAZON','AMAZON PRIME')
    and O.dtShippedDate between '09/1/2020' and '09/7/2020'
    and O.ixPrimaryShipLocation = 47
    and O.sOrderStatus = 'Shipped'
    and P.flgCanceled = 0 
    and P.flgReplaced = 0
order by O.ixOrder, P.sTrackingNumber





-- AFCO’s Warehouse Manager, containing the package weight of all Amazon orders shipping from their DC.

-- Order#, Order Date, Shipped date, 
--package #s, individual pkg weights