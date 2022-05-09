-- Price Deviance

select sPriceDevianceReason, 
    ixPriceDevianceReasonCode 'PDReasonCode', FORMAT(count(OL.ixSKU),'###,###') 'OrderLines'
from tblOrderLine OL
where OL.flgLineStatus = 'Shipped'
    and OL.ixOrderDate between 19201 and 19230 -- 07/26/2020 and 08/24/2020
    and OL.flgKitComponent = 0
    and ixPriceDevianceReasonCode <> 99
group by sPriceDevianceReason, 
    ixPriceDevianceReasonCode
order by count(OL.ixSKU) desc

