-- Who pulled or mispulled for Flowrack from batch X

-- IF ONLY A BATCH NUMBER IS PROVIDED, AL OR CAROL CAN TELL US WHICH ORDERS IT CONTAINED
select OL.ixOrder, OL.ixSKU, SKU.sDescription, 
    OL.ixPicker, OL.iQuantity, OL.iMispullQuantity,
    PB.sPickingBin as 'PickBin' -- B-side SKUs have Pick Bins starting with "B"
from tblOrderLine OL
    join tblOrder O on O.ixOrder = OL.ixOrder
    left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join -- Getting Picking Bin
        (Select distinct ixSKU, sPickingBin
         from tblBinSku where ixLocation = '99'
         ) PB on SKU.ixSKU = PB.ixSKU    
where O.ixOrder in 
        ('5409596','5484590','5414593')
    --AND  O.sOrderStatus = 'Shipped'
    --AND OL.flgLineStatus = 'Shipped'   
    --AND SKU.flgIntangible = 0  
    --AND O.dtShippedDate = '08/26/2014'     
    --AND OL.iMispullQuantity > 0
    --AND PB.sPickingBin like 'X%'
    --AND PB.sPickingBin like 'Y%'
    --AND SKU.ixSKU in ('258521-BLK-2','91073072-POL')
order by PB.sPickingBin --O.ixOrder,