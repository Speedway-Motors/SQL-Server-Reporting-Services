-- SMIHD-4835 - Package Fulfillment Status

select count(*) from tblOrder where flgGuaranteedDeliveryPromised is NOT NULL




    SELECT flgDeliveryPromiseMet 'PromMet', 
        count(*) 'Orders',
        CONVERT(VARCHAR, GETDATE(), 102)  AS 'As of'
    FROM [SMI Reporting].dbo.tblOrder 
    WHERE flgDeliveryPromiseMet is NOT NULL
    GROUP BY flgDeliveryPromiseMet
    ORDER BY flgDeliveryPromiseMet
/*
Prom
Met	Orders	As of
0	445	    2016.07.18
1	8,642	2016.07.18

0	 449	2016.07.26
1	8,683	2016.07.26
*/


    



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
    
    

SELECT O.ixOrder, O.dtGuaranteedDelivery, O.sOrderStatus, O.iShipMethod, 
    OL.ixSKU, SKU.sDescription, OL.iQuantity, OL.mUnitPrice, OL.flgLineStatus, OL.mCost, 
    OL.ixPrintedDate, OL.ixPrintedTime, O.dtShippedDate 'OrderShipDate', OL.sTrackingNumber, P.ixShipDate 'PkgShipDate'
    ,O.dtLastPackageDeliveryLocal 
FROM tblOrderLine OL
    join vwGuaranteedOrdersNoPromiseMetFlag NPM on OL.ixOrder = NPM.ixOrder -- 2183 orderlines
    join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    join tblOrder O on OL.ixOrder = O.ixOrder
    left join tblPackage P on OL.sTrackingNumber = P.sTrackingNumber
WHERE OL.flgLineStatus NOT IN ('Backordered','Backordered FS','Cancelled','Cancelled Quote','Quote','Lost')    
    and iShipMethod in (2,3,4,13,14,32)
    and SKU.flgIntangible = 0
    and P.ixShipDate is NULL
    and (P.flgCanceled is NULL OR P.flgCanceled = 0) -- 214 OrderLines
--TEMP RULES
--AND OL.sTrackingNumber is NULL    
ORDER BY O.dtGuaranteedDelivery, O.ixOrder





SELECT distinct(flgLineStatus)
from tblOrderLine


select sTrackingNumber, COUNT(*)
from tblPackage
group by sTrackingNumber
order by COUNT(*) desc


select sTrackingNumber, COUNT(*)
from tblPackage
where LEN(sTrackingNumber) < 10
group by sTrackingNumber
order by LEN(sTrackingNumber)


select * 
from tblPackage
where UPPER(sTrackingNumber) like '%SH%'


select O.sOrderStatus, OL.* 
from tblOrderLine OL
    join tblOrder O on OL.ixOrder = O.ixOrder
where ixSKU = 'HELP'
     and OL.ixOrderDate > 17685 -- between 17685 and 17714
    -- and flgLineStatus in ('Shipped','Open')
   -- and sTrackingNumber is NULL
    and O.sOrderStatus <> OL.flgLineStatus
order by sTrackingNumber
