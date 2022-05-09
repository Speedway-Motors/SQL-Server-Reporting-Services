-- SMIHD-7010 - Add Ship to State to Orders that did not meet Guaranteed Delivery Date report
DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '01/01/17',    @EndDate = '03/19/17'  

SELECT O.sShipToState, COUNT(distinct OL.sTrackingNumber) 'PKGs'
/*
    O.dtGuaranteedDelivery, -- Gtd Del Date
    O.flgDeliveryPromiseMet,
    O.sShipToState,
    O.ixOrder, O.sOrderStatus, O.iShipMethod, O.dtLastPackageDeliveryLocal 'Last PkgDelivered', O.mShipping, O.dtOrderDate 'OrderDate',       -- Order level 
    D1.dtDate 'PkgShipDate', P.dtPackageDeliveredLocal 'PkgDelivered',                                                                               -- Pkg level
    OL.ixSKU, SKU.sDescription, OL.iQuantity, OL.flgLineStatus, OL.mCost, OL.ixPrintedDate, OL.ixPrintedTime, OL.sTrackingNumber,    -- OL level
SKU.flgIsKit,
D2.sDayOfWeek3Char
*/
FROM tblOrder O 
    -- join vwGuaranteedOrdersNoPromiseMetFlag NPM on OL.ixOrder = NPM.ixOrder -- 2183 orderlines
    left join tblOrderLine OL on OL.ixOrder = O.ixOrder
    left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join tblPackage P on OL.sTrackingNumber = P.sTrackingNumber
    left join tblDate D1 on D1.ixDate = P.ixShipDate
    left join tblDate D2 on D2.ixDate = O.ixGuaranteeDelivery
WHERE OL.flgLineStatus NOT IN ('Backordered','Backordered FS','Cancelled','Cancelled Quote','Quote','Lost')    
    and O.iShipMethod in (2,3,4,13,14,32)
    and SKU.flgIntangible = 0
    and O.sOrderStatus NOT IN ('Backordered','Cancelled','Cancelled Quote','Pick Ticket','Quote')
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.flgGuaranteedDeliveryPromised = 1      -- NOT POPULATED YET
    and O.flgDeliveryPromiseMet = 0
    and O.dtGuaranteedDelivery between @StartDate and @EndDate
    and SKU.flgIsKit = 0
GROUP BY O.sShipToState    
ORDER BY COUNT(distinct OL.sTrackingNumber) desc, O.sShipToState--, O.dtGuaranteedDelivery desc, O.ixOrder, P.sTrackingNumber, P.dtPackageDeliveredLocal