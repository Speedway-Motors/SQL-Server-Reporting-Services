/*  SMIH-2289 Changes to Detailed Revenue by State report
  
1.)Credit memos starting with an "F-" are not included. These stand for free standing credits and are not identified 
    with a particular invoice record. Examples for August are F-425763, F-424084, F-425083
    
2.)Canceled credit memos are showing up on the download and need to be removed. A few examples are C-423219 for customer #1828457, 
    C-424076 for customer number 450953, C-425045 for customer number 1312071
    
3.)I need a quick way to see if any sales tax was levied for any states other than NE, IN, KY, or WA. 
    Not sure if we can tweak the existing report filter "State" and have a drop down box with each state listed and an 
    option for all states. Then I would need an option to select either summary or detail. Suggestions? X3261
*/
DECLARE
    @ShippingStartDate datetime,
    @ShippingEndDate datetime,
    @State varchar(2)

SELECT
    @ShippingStartDate = '08/01/15',
    @ShippingEndDate = '08/31/15',
    @State = 'WA'
--*/  

SELECT O.ixOrder,                           -- 2050
    O.dtShippedDate, 
    C.ixCustomer,
    C.sCustomerFirstName+' '+C.sCustomerLastName as 'Cust Name',
    O.sShipToCOLine, O.sShipToStreetAddress1, O.sShipToStreetAddress2, 
    O.sShipToCity,
    O.sShipToState,
    O.sShipToZip,
    C.ixCustomerType,
    C.sMailToCOLine,
    C.flgTaxable,
    O.mMerchandise,
    O.mShipping,
    O.mTax,
    O.mMerchandise+O.mShipping+O.mTax as 'Total',
    O.sSourceCodeGiven,
    O.ixAccountManager 'Acct Mgr',
    C.sCustomerType 'CurrentCustType',
    LTC.sLocalTaxCode,
    LTC.dTaxRate,
    SM.sDescription 'ShipMethod'
FROM tblOrder O---- 24,966 
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
    left join tblLocalTaxCode LTC on LTC.ixZipCode = O.sShipToZip
WHERE O.dtShippedDate between @ShippingStartDate and @ShippingEndDate -- '01/01/2007' 
    and O.sShipToCountry = 'US'
    and O.sShipToState = @State -- 'NE'
    and O.sOrderStatus = 'Shipped'
    and O.ixOrder NOT LIKE 'PC%'

UNION

-- Credit Memos
SELECT CMM.ixCreditMemo as 'ixOrder', -- O.ixOrder, -- 325
    CMM.dtCreateDate as 'dtShippedDate',
    --O.dtShippedDate, 
    C.ixCustomer,
    C.sCustomerFirstName+' '+C.sCustomerLastName as 'Cust Name',
    O.sShipToCOLine, O.sShipToStreetAddress1, O.sShipToStreetAddress2, 
    O.sShipToCity,
    O.sShipToState,
    O.sShipToZip,
    C.ixCustomerType,
    C.sMailToCOLine,
    C.flgTaxable,
    (CMM.mMerchandise *-1) mMerchandise,
    CMM.mShipping,
    CMM.mTax,
    (CMM.mMerchandise *-1)+CMM.mShipping+CMM.mTax as 'Total',
    O.sSourceCodeGiven,
    O.ixAccountManager 'Acct Mgr',
    C.sCustomerType 'CurrentCustType',
    LTC.sLocalTaxCode,
    LTC.dTaxRate,
    SM.sDescription 'ShipMethod'
FROM tblCreditMemoMaster CMM
    left join tblOrder O on CMM.ixOrder = O.ixOrder---- 24,966 
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
    left join tblLocalTaxCode LTC on LTC.ixZipCode = O.sShipToZip
    
WHERE CMM.dtCreateDate between @ShippingStartDate and @ShippingEndDate -- '01/01/2007' 
    and O.sShipToCountry = 'US'
    and O.sShipToState = @State -- 'NE'
    and O.sOrderStatus = 'Shipped'
    and O.ixOrder NOT LIKE 'PC%'
ORDER BY O.ixOrder



/* select * from tblCreditMemoMaster CMM where ixCreditMemo = 'F-425763'


*/