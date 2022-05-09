-- SMIHD-11105 - Open Web Orders report

/*
similar to the Call Center Open Orders Report

The report will need to automatically be sent each day to sales@speedwaymotors.com. 
The time it is sent can be shortly after Midnight each day. 

1)	Only show orders with an OEO of WEB.  -- verifying no other order channels should be included
2)	Do not show orders that have an Auth Status of VA or AD.
3)	Do not list any order that was submitted after 8pm the day prior to the day the report is being run (about 4 hours prior to when the report is scheduled to auto-run around 12:00am, per my request/recommendation).
4)	Do not list any order that has a “Dated” designation.-- verifying that is the same thing as "hold until" date field
    5)	We don’t need Column A, Order Status, (they should all be an OPEN status).
    6)	We don’t need Column N, Account Manager.
    7)	We don’t need Column L, Order Amount.
    8)	We don’t need Column J, Date/Time Available to Print.
    9)	We don’t need Column H, Method of Payment.
    10)	Add empty column labled notes after "Date/Time Entered". 2 inch width
11)	ORDER BY "Date/Time Entered” ascending


*/

select count(ixOrder) 'Orders-MTD', sOrderChannel 'Channel'
from tblOrder
where dtOrderDate >= '06/01/2018'
    and ixOrder NOT LIKE 'P%'
    and ixOrder NOT LIKE 'Q%'
    and ixOrder NOT LIKE '%-%'
    and sOrderChannel not in ('PHONE')
    and sOrderStatus <> 'Cancelled'
group by sOrderChannel
order by count(ixOrder) desc

SELECT ixOrder
FROM tblOrder
where dtHoldUntilDate is NOT NULL
    and dtOrderDate >= '06/01/2018'
    and ixOrder NOT LIKE 'P%'
    and ixOrder NOT LIKE 'Q%'
    and ixOrder NOT LIKE '%-%'
    and sOrderChannel not in ('PHONE')




SELECT O.sOrderStatus 'OrderStatus', 
    O.ixAuthorizationStatus  'AuthStatus',
    O.sMethodOfPayment,
    D2.dtDate+SUBSTRING(T2.chTime,1,5) 'DateTimeAuthorized',
    D3.dtDate+SUBSTRING(T3.chTime,1,5) 'DateTimeAvailableToPrint',
    (dbo.GetLatestOrderTimePrinted (O.ixOrder)) 'dtTimePrinted',
    O.dtOrderDate 'DateEntered',         -- KEEP for cond. formatting
    SUBSTRING(T1.chTime,1,5) 'TimeEntered',-- KEEP for cond. formatting
    O.dtOrderDate+SUBSTRING(T1.chTime,1,5) 'DateTimeEntered',
    O.mMerchandise  'OrderTotal',    
    O.ixOrder       'OrderNum',
    O.sOrderTaker   'OrderTaker',
    (dbo.OrderLineHELP (O.ixOrder)) 'HelpOL',
    (dbo.PickBinSHOP (O.ixOrder))   'PickBinSHOP',
    isnull(O.ixAccountManager,'Unassigned') 'ActMgr',
    O.iShipMethod                   'ShipMethod',
    (Case when O.dtHoldUntilDate IS NULL THEN ''
            else 'Y'
        end) AS 'Dated'
FROM tblOrder O
    left join tblOrderRouting ORT   on ORT.ixOrder = O.ixOrder
    left join tblTime T1            on T1.ixTime = O.ixOrderTime
    left join tblDate D2            on D2.ixDate = O.ixAuthorizationDate
    left join tblTime T2            on T2.ixTime = O.ixAuthorizationTime
    left join tblDate D3            on D3.ixDate = ORT.ixAvailablePrintDate
    left join tblTime T3            on T3.ixTime = ORT.ixAvailablePrintTime
WHERE O.ixOrderDate >= 18183 -- '10/12/2017'
    -- and O.dtHoldUntilDate is NULL
      and O.sOrderStatus = 'Open' -- in (@OrderStatus)
      and O.ixAuthorizationStatus NOT IN ('VA','AD')
      and (O.dtOrderDate + T1.chTime) < dateadd(hour,20, cast(cast(dateadd(day,-1,getdate()) as date) as datetime2)) -- order placed before 8PM previous day
ORDER BY DateEntered, TimeEntered



select GETDATE()

select O.ixOrder, O.dtOrderDate, T.chTime, (O.dtOrderDate + T.chTime) 'dtTime'
from tblOrder O
    left join tblTime T on T.ixTime = O.ixOrderTime
where sOrderStatus = 'Open'
    and (O.dtOrderDate + T.chTime) < dateadd(hour,20, cast(cast(dateadd(day,-1,getdate()) as date) as datetime2))
    -- and DATETIME ORDERED < 8PM previous day
order by O.dtOrderDate desc, T.chTime desc -- 588 total rows    177 before cutoff


select  dateadd(hour,20, cast(cast(dateadd(day,-1,getdate()) as date) as datetime2))
