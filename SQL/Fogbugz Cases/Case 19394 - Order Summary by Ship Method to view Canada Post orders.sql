-- Case 19394 - Order Summary by Ship Method to view Canada Post orders
select iShipMethod, count(*)
from tblOrder
where dtOrderDate = '07/25/2013'
group by iShipMethod




select * from tblOrder
where iShipMethod = 19



/*
Order ID, ship method, order amount, Order date, ship date,  
- maybe set a search date range so we don't search through everything

Canada Post is MOS 19
*/
-- Order Summary by Ship Method

DECLARE @StartDate datetime,
        @EndDate datetime,
        @ShipMethod int
        
SELECT 
       @StartDate = '07/25/2013',
       @EndDate = '07/30/2013',

    @ShipMethod = 18 -- 19 Canada Post
    
select O.ixOrder
    ,O.dtOrderDate+SUBSTRING(T.chTime,1,5) 'DateTimeOrdered'
    ,O.dtOrderDate 'Order Date'
    ,T.chTime 'Order Time'
    ,O.sOrderStatus
    ,O.mMerchandise 'Merchandise' 
    ,O.mShipping 'Shipping'
    ,O.dtShippedDate 'Shipped'
    ,O.sOrderChannel 'Order Channel'
    ,O.sShipToCountry 'ShipTo Country'
    ,O.sShipToCity  'ShipTo City'
    ,O.sShipToState 'ShipTo State'
    ,O.sShipToZip 'ShipTo Zip'
    ,SM.sDescription 'Ship Method'
from tblOrder O
    left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
    left join tblTime T on T.ixTime = O.ixOrderTime
where dtOrderDate between @StartDate and @EndDate -->= '07/01/2013' --'07/25/2013'
 --and iShipMethod = @ShipMethod
 and O.sShipToCountry = 'CANADA'
order by SM.sDescription 







select sOrderStatus, count(*)
from tblOrder
where dtOrderDate >= '01/01/2013'
group by sOrderStatus


select distinct iShipMethod
from tblOrder
order by iShipMethod 


select distinct ixShipMethod
from tblShipMethod