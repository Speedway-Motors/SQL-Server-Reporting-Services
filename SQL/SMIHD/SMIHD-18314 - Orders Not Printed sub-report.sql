-- SMIHD-18314 - Orders Not Printed sub-report 

-- Order #, Time Entered, Customer Name, Auth Status, Source Code
select O.ixOrder, 
    O.dtOrderDate, T.chTime 'OrderTime',
    O.dtOrderDate + SUBSTRING(T.chTime,1,5) AS 'DateTimeEntered',
    (ISNULL(C.sCustomerFirstName,'') + ' ' + ISNULL(C.sCustomerLastName,'')) 'Customer',
    O.ixAuthorizationStatus AS 'AuthStatus',
    O.sSourceCodeGiven 'SourceCode',  
    dbo.GetLatestOrderTimePrinted (O.ixOrder) 'Printed',
    ((DATEDIFF(mi,GETDATE(),(O.dtOrderDate + SUBSTRING(T.chTime,1,5)))*-1)) 'WaitTimeMins'
from tblOrder O
    left join tblCustomer C on O.ixCustomer = C.ixCustomer
    left join tblTime T on T.ixTime = O.ixOrderTime
    left join tblDate D on D.ixDate = O.ixOrderDate
WHERE O.sOrderStatus = 'Open' 
  --AND O.dtOrderDate >= DATEADD(dd, -1, GETDATE()) -- '05/27/13' --@OrderDate -- This would be a hidden parameter 	
  AND O.iShipMethod = '1' -- Counter orders only  		
  AND O.sOrderChannel <> 'COUNTER'
  --and ((DATEDIFF(mi,GETDATE(),(O.dtOrderDate + SUBSTRING(T.chTime,1,5)))*-1)) > 10 -- Order entered at least 10 minutes ago
  AND ( (dbo.GetLatestOrderTimePrinted (O.ixOrder)) is NULL
        OR ((DATEDIFF(mi,GETDATE(),(O.dtOrderDate + SUBSTRING(T.chTime,1,5)))*-1)) < 30 -- waiting less than 15 minutes   REMOVE AFTER TESTING
        )
  AND O.ixPrimaryShipLocation = 99 -- SMI ONLY 
ORDER BY ((DATEDIFF(mi,GETDATE(),(O.dtOrderDate + SUBSTRING(T.chTime,1,5)))*-1)) desc 
--O.dtOrderDate desc,T.chTime desc-- chdbo.GetLatestOrderTimePrinted (O.ixOrder) 



