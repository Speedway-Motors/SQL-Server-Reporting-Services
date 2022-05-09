-- Orderline Detail
--  ver 21.28.1
    -- SMIHD-12952 - Orderline dataset for AFCO
SELECT OL.ixCustomer 'CustomerNum',
    C.sCustomerFirstName 'CustFirstName',
    C.sCustomerLastName 'CustLastName',
    C.sMailToCity 'MailToCity',
    C.sMailToState 'MailToState',
    C.sMailToZip 'MailToZip',
    O.sShipToCity 'ShipToCity',
    O.sShipToState 'ShipToState', 
    O.sShipToZip 'ShipToZip',
    O.sShipToCountry 'ShipToCountry',
    OL.ixOrder 'OrderNum', 
    OL.ixSKU 'SKU',
    OL.iQuantity 'QtyOrdeered',
    OL.mUnitPrice 'UnitPrice',
    OL.mCost 'UnitCost',
    OL.mExtendedPrice 'ExtendedPrice',
    OL.mExtendedCost 'ExtendedCost',
    OL.flgLineStatus 'LineStatus',
    (CASE WHEN OL.flgKitComponent = 1 THEN 'Y'
     ELSE 'N'
     END) AS 'KitComponent',
    OL.iOrdinality 'Ordinality',
    OL.dtOrderDate 'OrderDate',
    (CASE WHEN S.flgIsKit = 1 THEN 'Y'
     ELSE 'N'
     END) 'IsKit',
    OL.dtShippedDate 'ShipDate',
    O.sOrderStatus 'OrderStatus'
FROM tblOrderLine OL
    left join tblOrder O on OL.ixOrder = O.ixOrder
    left join tblCustomer C on C.ixCustomer = OL.ixCustomer
    left join tblSKU S on OL.ixSKU = S.ixSKU
WHERE OL.dtOrderDate between  @OrderStartDate and @OrderEndDate -- '1/1/2020' and '12/31/2020' -- 3,135         --'12/31/2020' -- 229,589
