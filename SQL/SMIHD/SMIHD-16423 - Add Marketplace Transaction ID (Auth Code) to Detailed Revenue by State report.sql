-- SMIHD-16423 - Add Marketplace Transaction ID (Auth Code) to Detailed Revenue by State report

/*
 -- available in the DW
SELECT * FROM tng.tblcheckout_transaction AS tt
INNER JOIN tng.tblcheckout_transaction_shipment AS tts ON tt.ixTransactionGuid = tts.ixTransactionGuid
WHERE tt.sMarketplaceOrderId IS NOT NULL AND tt.sMarketplaceOrderId <> ''
and tts.ixSopWebOrderNumber = 'CA11478422'

select * from tng.tblorder

select sWebOrderID from tblOrder
where ixOrder = '8086691' -- CA11478422


select * --o.sPaypalTransactionID 
from tng.tblorder o
where o.ixSopOrderNumber = '8086691';

6XC0652376657132M

sPaypalTransactionID
6XC0652376657132M
*/



/* Detailed Revenue by State.rdl            2,391  @111 sec
    ver 20.4.1                              2,394  @  2 sec

DECLARE @ShippingStartDate datetime,    @ShippingEndDate datetime,
        @State varchar(2),              @SourceCode varchar(15)

SELECT  @ShippingStartDate = '11/01/19', @ShippingEndDate = '12/15/19',
        @State = 'AZ',                   @SourceCode = NULL-- 'EBAY'
*/
    -- Orders
    SELECT O.ixOrder,                           -- 2050
       O.dtOrderDate, -- O.dtDateLastSOPUpdate, 
        O.dtShippedDate, 
        C.ixCustomer,
        C.sCustomerFirstName+' '+C.sCustomerLastName as 'Cust Name',
        O.sShipToCOLine, O.sShipToStreetAddress1, O.sShipToStreetAddress2, 
        O.sShipToCity,
        O.sShipToState,
        O.sShipToZip,
        O.ixPrimaryShipLocation 'ShipLocation',
        C.ixCustomerType,
        C.sMailToCOLine,
        -- Price Level  N/A
        C.flgTaxable,
        O.mMerchandise,
        O.mShipping,
        O.mTax,
        O.mMerchandise+O.mShipping+O.mTax as 'Total',
        tngO.sPaypalTransactionID 'MarketplaceTransactionID',
        O.sSourceCodeGiven,
        O.ixAccountManager 'Acct Mgr',
        C.sCustomerType 'CurrentCustType',
        LTC.sLocalTaxCode,
        LTC.dTaxRate,
        SM.sDescription 'ShipMethod',
        O.mPublishedShipping 'PublishedShipping'
    FROM tblOrder O---- 24,966 
        left join tblCustomer C on O.ixCustomer = C.ixCustomer
        left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
        left join tblLocalTaxCode LTC on LTC.ixZipCode = O.sShipToZip
       -- left join tng.tblorder tngO on tngO.ixSOPWebOrderNumber = O.sWebOrderID COLLATE SQL_Latin1_General_CP1_CI_AS
        left join tblHackOrderID hack on hack.ixOrder = O.ixOrder                   -- \
        left join tng.tblorder tngO on tngO.ixSOPWebOrderNumber = hack.ixOrder_Ci   -- /  Hack table Ron build to avoid the massive slowdown from COALLATION
    WHERE O.dtShippedDate between @ShippingStartDate and @ShippingEndDate -- '01/01/2007' 
        and O.sShipToCountry = 'US'
        and O.sShipToState IN (@State) -- 'NE'
        and O.sOrderStatus = 'Shipped'
        and O.ixOrder NOT LIKE 'PC%'
        and (@SourceCode IS NULL 
             OR
             O.sSourceCodeGiven in  (@SourceCode)
             )
    --ORDER BY O.ixOrder

UNION

    SELECT CMM.ixCreditMemo as 'ixOrder', -- O.ixOrder, -- 325
        O.dtOrderDate, -- O.dtDateLastSOPUpdate, 
        CMM.dtCreateDate as 'dtShippedDate',
        --O.dtShippedDate, 
        C.ixCustomer,
        C.sCustomerFirstName+' '+C.sCustomerLastName as 'Cust Name',
        O.sShipToCOLine, O.sShipToStreetAddress1, O.sShipToStreetAddress2, 
        O.sShipToCity,
        O.sShipToState,
        O.sShipToZip,
        O.ixPrimaryShipLocation 'ShipLocation',
        C.ixCustomerType,
        C.sMailToCOLine,
        -- Price Level  N/A
        C.flgTaxable,
        (CMM.mMerchandise *-1) mMerchandise,
        CMM.mShipping,
        CMM.mTax,
        (CMM.mMerchandise *-1)+CMM.mShipping+CMM.mTax as 'Total',
        tngO.sPaypalTransactionID 'MarketplaceTransactionID',
        O.sSourceCodeGiven,
        O.ixAccountManager 'Acct Mgr',
        C.sCustomerType 'CurrentCustType',
        LTC.sLocalTaxCode,
        LTC.dTaxRate,
        SM.sDescription 'ShipMethod',
        O.mPublishedShipping 'PublishedShipping'
    FROM tblCreditMemoMaster CMM
             join tblOrder O on CMM.ixOrder = O.ixOrder---- 24,966 
        left join tblCustomer C on O.ixCustomer = C.ixCustomer
        left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
        left join tblLocalTaxCode LTC on LTC.ixZipCode = O.sShipToZip
       -- left join tng.tblorder tngO on tngO.ixSOPWebOrderNumber = O.sWebOrderID COLLATE SQL_Latin1_General_CP1_CI_AS
        left join tblHackOrderID hack on hack.ixOrder = O.ixOrder                   -- \
        left join tng.tblorder tngO on tngO.ixSOPWebOrderNumber = hack.ixOrder_Ci   -- /  Hack table Ron build to avoid the massive slowdown from COALLATION
    WHERE CMM.dtCreateDate between @ShippingStartDate and @ShippingEndDate -- '01/01/2007' 
        and O.sShipToCountry = 'US'
        and O.sShipToState in (@State)
        and O.sOrderStatus = 'Shipped'
        and O.ixOrder NOT LIKE 'PC%'
        and (@SourceCode IS NULL 
             OR
             O.sSourceCodeGiven in  (@SourceCode)
             )
        and CMM.flgCanceled = 0

UNION

    -- Credit Memos

    -- F Credit Memos
    SELECT CMM.ixCreditMemo as 'ixOrder', -- O.ixOrder, -- 325
        NULL,
        CMM.dtCreateDate as 'dtShippedDate',
        C.ixCustomer,
        C.sCustomerFirstName+' '+C.sCustomerLastName as 'Cust Name',
        C.sMailToCOLine, C.sMailToStreetAddress1, C.sMailToStreetAddress2,
        C.sMailToCity 'sShipToCity',
        C.sMailToState 'sShipToState',
        C.sMailToZip 'sShipToZip',
        NULL  'ShipLocation',
        C.ixCustomerType,
        C.sMailToCOLine,
        C.flgTaxable,
        (CMM.mMerchandise *-1) mMerchandise,
        CMM.mShipping,
        CMM.mTax,
        (CMM.mMerchandise *-1)+CMM.mShipping+CMM.mTax as 'Total',
        'n/a' as 'MarketplaceTransactionID',
        'n/a' as 'sSourceCodeGiven',
        C.ixAccountManager 'Acct Mgr',
        C.sCustomerType 'CurrentCustType',
        LTC.sLocalTaxCode,
        LTC.dTaxRate,
        'n/a' as 'ShipMethod',
        NULL as 'PublishedShipping'
    FROM tblCreditMemoMaster CMM
        left join tblCustomer C on CMM.ixCustomer = C.ixCustomer
        left join tblLocalTaxCode LTC on LTC.ixZipCode = C.sMailToZip
    WHERE CMM.dtCreateDate between @ShippingStartDate and @ShippingEndDate -- '01/01/2007' 
        AND CMM.ixOrder = 'FSCR'
        and CMM.flgCanceled = 0
        --and O.sShipToCountry = 'US'
        and C.sMailToState in (@State) -- .sShipToState 

ORDER BY ixOrder

