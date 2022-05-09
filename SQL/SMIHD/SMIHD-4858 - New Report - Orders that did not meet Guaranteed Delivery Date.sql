-- SMIHD-4858 - New Report - Orders that did not meet Guaranteed Delivery Date
-- ORDERS WITH A GuarnateedDeliveryDate that have no DeliverPromiseMet indicatory yet
CREATE VIEW vwGuaranteedOrdersNoPromiseMetFlag
as
select O.ixOrder--, O.dtOrderDate, O.dtGuaranteedDelivery, O.dtShippedDate 
-- into [SMITemp].dbo.PJC_GuaranteedOrdersNoPromiseMetFlag -- 2,353
from tblOrder O
where O.sOrderStatus NOT IN ('Backordered','Cancelled','Cancelled Quote','Pick Ticket','Quote')
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
 -- and O.flgGuaranteedDeliveryPromised = 1      -- NOT POPULATED YET
 --   and O.dtOrderDate> = '07/15/2016'
    and O.dtGuaranteedDelivery is NOT NULL
    and O.flgDeliveryPromiseMet is NULL
    
    

SELECT /*   */
    O.ixOrder, O.dtGuaranteedDelivery, O.sOrderStatus, O.iShipMethod, O.dtLastPackageDeliveryLocal 'Last PkgDelivered',
    OL.ixSKU, SKU.sDescription, OL.iQuantity, OL.mUnitPrice, OL.flgLineStatus, OL.mCost, 
    OL.ixPrintedDate, OL.ixPrintedTime, O.dtShippedDate 'OrderShipDate', OL.sTrackingNumber, P.ixShipDate 'PkgShipDate', P.dtPackageDeliveredLocal 'PkgDelivered'
    /*   */
FROM tblOrder O 
    -- join vwGuaranteedOrdersNoPromiseMetFlag NPM on OL.ixOrder = NPM.ixOrder -- 2183 orderlines
    left join tblOrderLine OL on OL.ixOrder = O.ixOrder
    left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join tblPackage P on OL.sTrackingNumber = P.sTrackingNumber
WHERE OL.flgLineStatus NOT IN ('Backordered','Backordered FS','Cancelled','Cancelled Quote','Quote','Lost')    
    and O.iShipMethod in (2,3,4,13,14,32)
    and SKU.flgIntangible = 0
    and O.sOrderStatus NOT IN ('Backordered','Cancelled','Cancelled Quote','Pick Ticket','Quote')
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.flgGuaranteedDeliveryPromised = 1      -- NOT POPULATED YET
    and O.dtGuaranteedDelivery is NOT NULL
    -- and O.flgDeliveryPromiseMet = 0
--TEMP RULES
--AND OL.sTrackingNumber is NULL    
ORDER BY O.dtGuaranteedDelivery, O.ixOrder, P.sTrackingNumber, P.dtPackageDeliveredLocal

select * from tblOrder
where 


select O.ixOrder--, O.dtOrderDate, O.dtGuaranteedDelivery, O.dtShippedDate 
-- into [SMITemp].dbo.PJC_GuaranteedOrdersNoPromiseMetFlag -- 2,353
from tblOrder O
where O.sOrderStatus NOT IN ('Backordered','Cancelled','Cancelled Quote','Pick Ticket','Quote')
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
 -- and O.flgGuaranteedDeliveryPromised = 1      -- NOT POPULATED YET
 --   and O.dtOrderDate> = '07/15/2016'
    and O.dtGuaranteedDelivery is NOT NULL
    and O.flgDeliveryPromiseMet = 0
