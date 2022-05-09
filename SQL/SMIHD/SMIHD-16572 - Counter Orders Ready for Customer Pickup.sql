-- SMIHD-16572 - Counter Orders Ready for Customer Pickup

SELECT O.ixOrder 'Order', 
    (C.sCustomerFirstName + ' ' + C.sCustomerLastName) 'Customer',
    OS2.dtScanDate 'AtCounterSinceDate', 
    -- FORMAT(T.chTime, 'h:mm tt') as 'AtCounterSinceTime', 
    SUBSTRING(T.chTime, 1, 5) as 'AtCounterSinceTime', 
   'TBD' as 'PickUpEmailSent',
    O.sOrderStatus,
    -- O.ixShippedTime, 
    -- O.sSourceCodeGiven 'SourceCode',
    O.dtHoldUntilDate 'HoldUntil',
    C.sDayPhone
FROM tblOrder O
    LEFT JOIN tblCustomer C on O.ixCustomer = C.ixCustomer
 --   LEFT JOIN tblCounterOrderScans OS ON OS.ixOrder = O.ixOrder 
    LEFT JOIN (SELECT DISTINCT OS.ixOrder 
                , MAX(OS.dtScanDate) AS dtScanDate 
                , MAX(OS.ixScanTime) AS ixScanTime  
           FROM tblCounterOrderScans OS 
               LEFT JOIN tblIPAddress IP ON IP.ixIP = OS.ixIP 
           WHERE IP.sGroup = 'Counter'  
           GROUP BY OS.ixOrder
           ) OS2 ON OS2.ixOrder = O.ixOrder   
     LEFT JOIN tblTime T on OS2.ixScanTime = T.ixTime
WHERE iShipMethod = 1
    and sOrderStatus = 'Open'
    and OS2.dtScanDate is NOT NULL -- counter hasn't scanned yet
    and O.ixPrimaryShipLocation = 99 --@Location
ORDER BY OS2.dtScanDate, T.chTime


select count(*)
from tblOrder where sOrderStatus = 'Backordered'
