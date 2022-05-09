-- SMIHD-21376 - DeWitts Order Status Details
--  ver 21.28.1
SELECT distinct ixOrder -- 1032
INTO #DEWITTSORDERS -- drop table #DEWITTSORDERS
FROM tblOrderLine
WHERE dtOrderDate between @StartDate and @EndDate
    and ixSKU like '32-%' -- Detwitts SKUs
    and ixOrder NOT LIKE 'Q%';

SELECT O.ixOrder, -- 1,485
    O.ixCustomer, 
    C.sCustomerFirstName 'CustFirstName',
    C.sCustomerLastName 'CustLastName',
    C.iPriceLevel 'CustPriceLevel', 
    -- Customer Type	
    C.sCustomerType 'CustType',  
    C.ixCustomerType 'CustType2', 
    CT.sDescription 'CustTypeDescription',
    C.ixAccountManager 'AccountManager',
    OL.ixSKU,
    -- SKU Description?
    OL.iQuantity,
    OL.mUnitPrice 'UnitPrice',
    OL.mExtendedPrice 'ExtPrice',
    OL.mCost 'UnitCost',
    OL.mExtendedCost 'ExtCost',
    O.sOrderStatus 'OrderStatus',
    OL.flgLineStatus 'LineStatus',
    O.dtOrderDate 'OrderDate',
    O.dtShippedDate 'ShippedDate',
    dbo.fn_CountWeekDays (O.dtOrderDate,O.dtShippedDate)-1 'TotDaysToShip', -- subtract 1 day per Mike's response.  Function excludes weekends.
    O.sOrderTaker 'OrderTaker'
FROM #DEWITTSORDERS D
    left join tblOrder O on D.ixOrder = O.ixOrder
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join tblCustomerType CT on C.ixCustomerType = CT.ixCustomerType
WHERE OL.ixSKU like '32-%'
ORDER BY O.ixOrder;

DROP TABLE #DEWITTSORDERS




/*
-- AFCO Dewitts Backorders
select distinct ixOrder
into #DewittsBackorders
from tblOrder
where sOrderStatus = 'Backordered'
        AND ixOrder in (select distinct ixOrder 
                        from tblOrderLine 
                        where ixSKU like '32-%'
                        and flgLineStatus= 'Backordered')

SELECT -- 403
    isnull(O.ixAccountManager,'Unassigned')    ActMgr,
    isnull(C.ixAccountManager2,'Unassigned')    ActMgr2,
    isnull(C.sMailToCountry,'US') MailToCountry,
    O.dtOrderDate         DateEntered,
    SUBSTRING(T.chTime,1,5) TimeEntered,
    O.dtOrderDate+SUBSTRING(T.chTime,1,5) DateTimeEntered,
    D3.dtDate+SUBSTRING(T3.chTime,1,5) 'DateTimeAvailableToPrint',
    (dbo.GetLatestOrderTimePrinted (O.ixOrder)) 'dtTimePrinted',
    O.ixCustomer          CustNum,
    (isnull(C.sCustomerFirstName, '')+ ' ' + isnull(C.sCustomerLastName, ''))   CustName,
    O.sOrderTaker         OrderTaker,
    O.ixOrder                 OrderNum,
    O.mMerchandise        Merch,
    S.ixSKU,
    S.sDescription SKUDescription,
    S.ixABCCode 'ABCCode',
    S.sCycleCode 'CycleCode',
    OL.mExtendedPrice          OLMerch,
    OL.iQuantity,
--    SKU.iQAV,
   (isnull(SKULL.iQAV,0)+isnull(SKULL.iQCB,0)) AdjQAV,
   (isnull(SKUM.iQAV,0)+isnull(SKUM.iQCB,0)) AdjQAVMulti,   
    SKULL.iQOS,
    SKUM.iQOS 'iQOSMulti',
    SC.ixCatalog
FROM tblOrder O
    left join #DewittsBackorders DBO on O.ixOrder = DBO.ixOrder
    left join tblOrderRouting ORT on ORT.ixOrder COLLATE SQL_Latin1_General_CP1_CI_AS  = O.ixOrder
    left join tblTime T on T.ixTime = O.ixOrderTime  
    left join tblDate D3 on D3.ixDate = ORT.ixAvailablePrintDate
    left join tblTime T3 on T3.ixTime = ORT.ixAvailablePrintTime
    left join tblCustomer C on C.ixCustomer = O.ixCustomer
    left join tblShipMethod SM on SM.ixShipMethod = O.iShipMethod 
    left join tblOrderLine OL on OL.ixOrder = O.ixOrder
    left join tblSKU S on OL.ixSKU = S.ixSKU
    left join tblSKULocation SKULL on SKULL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = OL.ixSKU  
                                    and SKULL.ixLocation = 99 
    left join vwSKUMultiLocation SKUM on SKUM.ixSKU = OL.ixSKU
   	left join tblSourceCode SC on O.sSourceCodeGiven = SC.ixSourceCode
WHERE O.sOrderStatus = 'Backordered'
    and DBO.ixOrder is NOT NULL -- order is a DeWitts order
---AND ORT.ixOrder is NOT NULL
--and O.ixOrder = '732753-1'
ORDER BY DateTimeEntered, AdjQAV

GO

DROP TABLE #DewittsBackorders

*/