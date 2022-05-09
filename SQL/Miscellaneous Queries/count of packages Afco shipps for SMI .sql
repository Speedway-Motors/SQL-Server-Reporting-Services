-- count of packages Afco shipps for SMI               
SELECT P.sTrackingNumber 
FROM tblPackage P
    join tblOrder O on O.ixOrder = P.ixOrder
WHERE O.sOrderStatus = 'Shipped'
    and O.ixPrimaryShipLocation = 47
    and O.ixShippedDate between 17288 and 17318 -- May  1,533 orders
    and P.flgCanceled = 0                       --      1,631 Packages
    and P.flgReplaced = 0  