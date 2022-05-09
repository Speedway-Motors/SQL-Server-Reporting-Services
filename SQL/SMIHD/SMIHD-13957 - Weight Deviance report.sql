-- SMIHD-13957 - Weight Deviance report

/* Weight Deviance.rdl
    ver 19.20.1
*/
    DECLARE @InvoiceStartDate datetime,      @InvoiceEndDate datetime
    SELECT @InvoiceStartDate = '05/14/2019', @InvoiceEndDate= '05/14/2019' 

-- SQL proviced by CCC 5-15-19
SELECT distinct p.ixOrder   -- 177 rec
       ,o.dtInvoiceDate 'InvoiceDate',
       ''+p.sTrackingNumber 'TrackingNumber',
       p.dActualWeight as 'ScaleWeight',
       (SELECT sum(s.dWeight*ol.iQuantity) 
        FROM tblOrderLine ol
            left join tblSKU s on ol.ixSKU = s.ixSKU
        WHERE ol.sTrackingNumber = p.sTrackingNumber 
            and ol.ixOrder=p.ixOrder
       ) as 'SumOfWeightOfSKUs',
       abs(p.dActualWeight-(
             SELECT sum(s.dWeight*ol.iQuantity) 
             FROM tblOrderLine ol
                left join tblSKU s on ol.ixSKU = s.ixSKU
             WHERE ol.sTrackingNumber = p.sTrackingNumber and ol.ixOrder=p.ixOrder
       )) as 'Delta'
--into #LastWeeksOrderWtDeltas
FROM tblPackage p
    left join tblOrder o on p.ixOrder = o.ixOrder
    
WHERE o.dtInvoiceDate between @InvoiceStartDate and @InvoiceEndDate -- '05/12/2019' -- default to *yesterday*
    and o.iShipMethod NOT in (1,8) -- 
    and p.flgCanceled=0
    and p.dActualWeight <> 0
    and abs(p.dActualWeight-(SELECT sum(s1.dWeight*ol1.iQuantity) 
                             FROM tblOrderLine ol1
                                left join tblSKU s1 on ol1.ixSKU = s1.ixSKU
                             WHERE ol1.sTrackingNumber = p.sTrackingNumber 
                                and ol1.ixOrder=p.ixOrder
                             )) > 5
