-- Case 25885 - Open orders with SKU in bins containing SHOP
select O.ixOrder, O.dtOrderDate, O.sOrderStatus,
OL.ixSKU, S.sDescription, OL.iQuantity,
BS.ixBin, BS.sPickingBin
from tblOrder O
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblBinSku BS on OL.ixSKU = BS.ixSKU and BS.ixLocation = 99
    join tblSKU S on OL.ixSKU = S.ixSKU
where O.sOrderStatus = 'Open'
--and S.flgMadeToOrder = 1
and (UPPER(ixBin) like '%SHOP%'
    OR 
    UPPER(sPickingBin) like '%SHOP%'
    )


    
    