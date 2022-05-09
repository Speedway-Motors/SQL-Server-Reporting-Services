-- SMIHD-13253 - Orders Shipped From Monroe

SELECT * FROM tblSKU where ixSKU = 'MONROE'

SELECT distinct ixOrder FROM tblOrderLine 
where ixSKU = 'MONROE'
and flgLineStatus = 'Shipped'
and ixShippedDate >= 18687



-- SMIHD-13253 - Orders Shipped From Monroe
DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '02/28/19',    @EndDate = '03/04/19'  

SELECT OL.ixOrder 'Order', 
    OL.ixSKU 'SKU', 
    OL.iQuantity 'Qty', 
    SL.sPickingBin 'PickBin', 
    FORMAT(OL.dtOrderDate,'yyyy.MM.dd') 'OrderDate',  
    FORMAT(OL.dtShippedDate,'yyyy.MM.dd') 'ShippedDate'
FROM tblOrderLine OL
    left join tblSKULocation SL on OL.ixSKU = SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS AND SL.ixLocation = 99
    left join tblOrder O on O.ixOrder = OL.ixOrder
WHERE O.sOrderStatus = 'Shipped'
    and OL.ixOrder in (-- Orders with the MONROE SKU
                       SELECT distinct ixOrder 
                       FROM tblOrderLine OL
                       WHERE ixSKU = 'MONROE'
                            and flgLineStatus = 'Shipped'
                            and OL.dtShippedDate between @StartDate and @EndDate -- 3 shipped orders between 02/28 and 03/04
                       )
ORDER BY OL.ixOrder, OL.iOrdinality



856001