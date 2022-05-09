-- Orders missing from High Priority Order Fulfillment Status report
-- RUNS MUCH FASTER ON AWS!!!
SELECT O.ixOrder 'SOPOrderNum', O.sWebOrderID 'WebOrderID',  flgHighPriority, sOrderStatus 'OrderStatus', 
	sSourceCodeGiven 'SourceCode', BU.sBusinessUnit 'Bus.Unit',
	dtGuaranteedDelivery 'dtGtdDelivery', O.ixPrimaryShipLocation 'ShipLoc',
	O.dtOrderDate+SUBSTRING(T1.chTime,1,5) 'DateTimeEntered',
	    D3.dtDate+SUBSTRING(T3.chTime,1,5) 'DateTimeAvailableToPrint',
		D5.dtDate+SUBSTRING(T5.chTime,1,5) 'DateTimePrinted',
		D4.dtDate+SUBSTRING(T4.chTime,1,5) 'DateTimeVerified',
		CTSM.dtExpectedShipDate 'ExpectedShipDate',
		O.dtDateLastSOPUpdate+SUBSTRING(T6.chTime,1,5) 'DateTimeLastSOPUpdate'
FROM tblOrder O
	left join tblOrderRouting ORT on ORT.ixOrder = O.ixOrder
	left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
	left join tblDate D3 on D3.ixDate = ORT.ixAvailablePrintDate
	LEFT JOIN tblDate D5 on D5.ixDate = ORT.ixPrintDate
	LEFT JOIN tblDate D4 on D4.ixDate = ORT.ixVerifyDate
	left join tblTime T1 on T1.ixTime = O.ixOrderTime
	left join tblTime T3 on T3.ixTime = ORT.ixAvailablePrintTime
	left join tblTime T5 on T5.ixTime = ORT.ixPrintTime
	left join tblTime T4 on T4.ixTime = ORT.ixVerifyTime
	left join tblTime T6 on T6.ixTime = O.ixTimeLastSOPUpdate
	-- add [DW.SPEEDWAY2.COM]. before DW below if trying to run on LNK-SQL-Live-1
    left join DW.UserInfo.tblcheckout_transaction_shipment CTS ON CTS.ixSopWebOrderNumber = O.sWebOrderID COLLATE SQL_Latin1_General_CP1_CI_AS
    left join DW.UserInfo.tblcheckout_transaction_shippingmethod CTSM ON CTSM.ixTransactionGuid = CTS.ixTransactionGuid
                                                                        and CTSM.ixTransactionShipment = CTS.ixTransactionShipment -- handles split orders
                                                                        and CTSM.flgSelected = 1
where O.ixOrder in ('11441502') -- ('11614805','11676703','11680702')
order by O.ixOrder
/*
11535002
11549303
11567308
11572305
11584304
11584306
11595301
11501408
*/
select O.ixOrder, O.sSourceCodeGiven, BU.sBusinessUnit, O.flgHighPriority
from tblOrder O
	left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
where O.ixOrder = ('11637305')

/*  High Priority Order Fulfillment Status.rdl
	ver 22.5.1

DECLARE @Location VARCHAR(10) = 99

SELECT DISTINCT
    O.sOrderStatus 'OrderStatus', 
    O.ixAuthorizationStatus 'AuthStatus',
    O.sMethodOfPayment,
    D2.dtDate+SUBSTRING(T2.chTime,1,5) 'DateTimeAuthorized',
    D3.dtDate+SUBSTRING(T3.chTime,1,5) 'DateTimeAvailableToPrint',
    (dbo.GetLatestOrderTimePrinted (O.ixOrder)) 'dtTimePrinted',
    O.dtOrderDate 'DateEntered', -- KEEP for cond. formatting
    SUBSTRING(T1.chTime,1,5) 'TimeEntered',-- KEEP for cond. formatting
    O.dtOrderDate+SUBSTRING(T1.chTime,1,5) 'DateTimeEntered',
    O.mMerchandise 'OrderTotal', 
    O.ixOrder 'OrderNum',
    O.sOrderTaker 'OrderTaker',
    (dbo.OrderLineHELP (O.ixOrder)) 'HelpOL',
    (dbo.PickBinSHOP (O.ixOrder)) 'PickBinSHOP',
    isnull(O.ixAccountManager,'Unassigned') ActMgr,
    O.iShipMethod ShipMethod,
    O.ixPrintPrimaryTrailer 'PreferredTrailer', -- This is to be used instead of ORT.ixCommitmentPrimaryTrailer now
    --ORT.ixCommitmentPrimaryTrailer, -- <-- using this as the "Authorization Primary Trailer" since we don't actually have one. Should be the same the vast majority of the time
    O.ixPrintSecondaryTrailer 'OptionalTrailer', -- This is to be used instead of ORT.ixVerifyPrimaryTrailer now
    ORT.ixVerifyPrimaryTrailer,
    (CASE WHEN ixVerifyDate is NOT NULL then 'Y'
     ELSE 'N'
     END) 'Verified',
    O.ixPrimaryShipLocation,
    O.sOrderType,
convert(varchar, O.dtGuaranteedDelivery, 101) as 'GuaranteedDeliveryDate',
flgGuaranteedDeliveryPromised,
    O.sSourceCodeGiven,
    (case when O.sSourceCodeGiven = 'AMAZONPRIME' THEN 'Y'
     else 'N'
     end) 'PRIME',
	(CASE WHEN flgHighPriority = 1 
               -- OR O.sSourceCodeGiven in ('EBAY','WALMART') -- removed per Teams meeting on 01/21/21
          then 'Y'
     ELSE NULL
     end) 'flgHighPriority' 
    , CTSM.dtExpectedShipDate
   -- , CTSM.ixTransactionGuid
    -- , FORMAT(CTSM.dtExpectedShipDate,'yyyy-MM-dd') 'dtExpectedShipDate'
FROM tblOrder O
    left join tblOrderRouting ORT on ORT.ixOrder = O.ixOrder
    left join tblTime T1 on T1.ixTime = O.ixOrderTime
    left join tblDate D2 on D2.ixDate = O.ixAuthorizationDate
    left join tblTime T2 on T2.ixTime = O.ixAuthorizationTime
    left join tblDate D3 on D3.ixDate = ORT.ixAvailablePrintDate
    left join tblTime T3 on T3.ixTime = ORT.ixAvailablePrintTime
    left join [DW.SPEEDWAY2.COM].DW.UserInfo.tblcheckout_transaction_shipment CTS ON CTS.ixSopWebOrderNumber = O.sWebOrderID COLLATE SQL_Latin1_General_CP1_CI_AS
    left join [DW.SPEEDWAY2.COM].DW.UserInfo.tblcheckout_transaction_shippingmethod CTSM ON CTSM.ixTransactionGuid = CTS.ixTransactionGuid
                                                                                          and CTSM.ixTransactionShipment = CTS.ixTransactionShipment -- handles split orders
                                                                                          and CTSM.flgSelected = 1
WHERE O.ixOrderDate > 18994 -- '01/01/2021'   periodically reset floor to reduce query time
   and O.ixPrimaryShipLocation = @Location 
   and (O.dtGuaranteedDelivery is NOT NULL 
         OR (O.sSourceCodeGiven in ('AMAZONPRIME','AMAZON','EBAY','WALMART')
		--	AND CTSM.dtExpectedShipDate <= CAST( DATEADD(day, 1, GetDate()) AS Date ) -- tomorrow's date
            AND CTSM.dtExpectedShipDate <= getdate() -- per Marketplaces Team they only want MP orders to appear if they expected to ship today or are past due
            )
         OR O.flgHighPriority = 1) 
   and O.sOrderStatus in ('Open','Backordered')
   and O.iShipMethod <> 1
  -- O.ixOrder = '10741899'
   and D3.dtDate+SUBSTRING(T3.chTime,1,5) is NOT NULL -- DateTimeAvailableToPrint
ORDER BY --O.ixOrder
-- flgHighPriority DESC,
    CTSM.dtExpectedShipDate
  --  DateEntered , TimeEntered

*/





