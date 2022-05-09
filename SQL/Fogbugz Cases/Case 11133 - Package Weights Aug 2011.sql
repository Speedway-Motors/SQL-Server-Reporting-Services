select P.sTrackingNumber 'PackageTrackingNumber', 
    --P.ixOrder,
    --O.dtShippedDate, 
    O.sShipToZip 'ZIP', 
    --P.dBillingWeight,
    P.dActualWeight 'ActualWeight'
from tblOrder O
    join tblPackage P on O.ixOrder = P.ixOrder
where   O.dtShippedDate between '08/01/2011' and '08/31/2011'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    --and O.mMerchandise > 0 
order by sTrackingNumber    
    
         
         
         
         
         