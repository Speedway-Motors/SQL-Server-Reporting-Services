-- SMIHD-4769 EMI - Pick Ticket SKU review


select * from tblDate where ixDate = 16451


SELECT OL.*
from tblOrderLine OL
    join vwEaglePickTickets EPC on OL.ixOrder = EPC.ixOrder -- 6,332 line items
where OL.ixOrderDate >= 17168 -- 1/1/2015    





SELECT OL.ixSKU, SKU.sDescription 'Description', count(EPC.ixOrder) 'TimesPulled', SUM(OL.iQuantity) 'TotQtyPulled'
from tblOrderLine OL
    join vwEaglePickTickets EPC on OL.ixOrder = EPC.ixOrder -- 6,332 line items
    join tblSKU SKU on OL.ixSKU = SKU.ixSKU
where OL.ixOrderDate >= 17168 -- 1/1/2015  
    and SKU.flgDeletedFromSOP = 0
    and SKU.flgIntangible = 0
group by OL.ixSKU, SKU.sDescription
order by count(EPC.ixOrder) desc

