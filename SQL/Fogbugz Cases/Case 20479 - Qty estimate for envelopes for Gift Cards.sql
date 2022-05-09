-- Case 20479 - Qty estimate for envelopes for Gift Cards

select * from tblSKU
where upper(ixSKU) like '%GIFT%'
and flgDeletedFromSOP = 0

SELECT SKU.ixSKU, SKU.sDescription,
    SUM(OL.iQuantity) QtySold
FROM tblSKU SKU
    left join tblOrderLine OL on OL.ixSKU = SKU.ixSKU
    left join tblOrder O on O.ixOrder = OL.ixOrder
WHERE upper(SKU.ixSKU) like '%GIFT%'
    and SKU.ixSKU <> 'EGIFT'
    and SKU.flgDeletedFromSOP = 0   
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '10/01/2012' and '01/15/2013'
GROUP BY  SKU.ixSKU, SKU.sDescription       

