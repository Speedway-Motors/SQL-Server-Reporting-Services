-- SMIHD-13994 - Pull in orderline detail and change Weight Deviance to a drill-down report

/* Weight Deviance.rdl
    ver 19.20.1
*/
    DECLARE @InvoiceStartDate datetime,      @InvoiceEndDate datetime
    SELECT @InvoiceStartDate = '05/18/2019', @InvoiceEndDate= '05/18/2019' -- 5/18 25 orders with 36 total packages (25 pkgs exceed threshold)
/*
include ALL packages in the drill down. 
I would like something on the top level that can easily be scanned / sorted by to see just how large the package discrepancy is, 
off the top of my head maybe include the largest discrepancy value from the child packages on the order? 
*/

-- SQL proviced by CCC 5-15-19
SELECT distinct o.ixOrder,   -- 177 rec
       o.dtInvoiceDate 'InvoiceDate',
       SM.sDescription 'ShipMethod',
       p.sTrackingNumber 'TrackingNumber',
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
       )) as 'PkgDelta',
       OL.sTrackingNumber,
       OL.iOrdinality,
       S.ixSKU,
       ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription',
       S.dWeight 'Weight(Phys)',
       S.dDimWeight 'Weight(DIM)',
       S.iLength 'Length',
       S.iWidth 'Width',
       S.iHeight 'Height',
       S.flgIsKit, -- convert to Y/N
       S.flgIntangible, -- convert to Y/N
       S.sSEMACategory 'Category',
       S.sSEMASubCategory 'SubCat',
       S.sSEMAPart 'Part',
       S.flgShipAloneStatus,
       S.flgORMD
       /*
        SEMA category
        */
--into #LastWeeksOrderWtDeltas
FROM (-- Orders with 1 or more packages exceeding the delta threshold
SELECT distinct p.ixOrder   -- 233 orders
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
                                and ol1.flgLineStatus = 'Shipped'
                             )) > 5
) BORDS -- Bad Orders
    left join tblOrder o on o.ixOrder = BORDS.ixOrder
    left join tblPackage p on p.ixOrder = o.ixOrder
    left join tblShipMethod SM on o.iShipMethod = SM.ixShipMethod
    left join tblOrderLine OL on OL.ixOrder = o.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
    
WHERE o.dtInvoiceDate between @InvoiceStartDate and @InvoiceEndDate -- '05/12/2019' -- default to *yesterday*
    and o.iShipMethod NOT in (1,8) -- 
    and p.flgCanceled=0
    and S.flgIntangible = 0
  /*  and p.dActualWeight <> 0
    /*and abs(p.dActualWeight-(SELECT sum(s1.dWeight*ol1.iQuantity) 
                             FROM tblOrderLine ol1
                                left join tblSKU s1 on ol1.ixSKU = s1.ixSKU
                             WHERE ol1.sTrackingNumber = p.sTrackingNumber 
                                and ol1.ixOrder=p.ixOrder
                             )) > 5
                             */

*/
ORDER BY o.ixOrder -- 'Delta' DESC