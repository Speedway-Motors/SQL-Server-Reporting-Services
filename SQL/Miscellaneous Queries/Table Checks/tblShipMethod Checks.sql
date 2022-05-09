-- tblShipMethod Checks

/*
    MANUAL TABLE
    There are NO SOP FEEDS that populate this table as of 9-21-16
*/  


-- Orders by Ship Method        
select O.iShipMethod, SM.sDescription,  
    count(*) 'Orders', 
    CONVERT(VARCHAR, MIN(O.dtShippedDate), 10)  'FirstShipped',
    CONVERT(VARCHAR, MAX(O.dtShippedDate), 10)  'LastShipped',
    CONVERT(VARCHAR, GETDATE(), 10) 'As of   '
from tblOrder O
    left join tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
where iShipMethod is NOT NULL
    and O.sOrderStatus = 'Shipped'
    -- and O.dtOrderDate >= '09/21/2016'
group by O.iShipMethod, SM.sDescription
-- HAVING MAX(O.dtOrderDate) < DATEADD(day, -7, GetDate()) -- 7 days ago
order by O.iShipMethod
    /*
    iShip                                       First       Last
    Method	sDescription	            Orders	Shipped	    Shipped	    As of   
    ======  ==========================  ======= =========   ========    ========
    1	    Counter	                    194,899	01-02-07	09-21-16	09-21-16
    2	    UPS Ground	                841,354	01-02-07	09-21-16	09-21-16
    3	    UPS 2 Day (Blue)	         44,312	01-02-07	09-21-16	09-21-16
    4	    UPS 1 Day (Red)	             19,327	01-02-07	09-21-16	09-21-16
    5	    UPS 3 Day	                      2 03-02-10	03-04-10	09-21-16    <-- only used by AFCO
    6	    USPS Priority	            188,774	01-03-07	09-21-16	09-21-16
    7	    USPS Express	                 60 02-01-07	06-04-12	09-21-16    <-- no longer in use
    8	    Best Way	                 98,737	01-02-07	09-21-16	09-21-16
    9	    SpeeDee	                    166,437	08-27-08	09-21-16	09-21-16    
    10	    UPS Worldwide Expedited	     16,184	01-14-11	09-21-16	09-21-16
    11	    UPS Worldwide Saver	          1,903	01-14-11	09-20-16	09-21-16
    12	    UPS Standard	              4,234	01-14-11	09-21-16	09-21-16
    13	    FedEx Ground	             35,915	10-19-11	09-21-16	09-21-16
    14	    FedEx Home Delivery	        186,803	10-19-11	09-21-16	09-21-16
    15	    FedEx SmartPost	             61,551	10-20-11	09-21-16	09-21-16
    
    
    18	    UPS SurePost	             34,892	02-01-12	09-21-16	09-21-16
    19	    Canada Post	                  3,681	07-25-13	11-12-15	09-21-16    <-- no longer in use
    20	    USPS First Class Mail	      3,381	08-25-16	09-21-16	09-21-16
    
    21	    DHL Parcel Priority	        DHL Global Mail	Air	        2016-09-21 09:57
    22	    DHL Parcel Direct	        DHL Global Mail	Air	        2016-09-21 09:57
    #23???  DHL Express Worldwide       DHL Express     Air         2016-09-21 15:10
    
    26	    USPS Priority International	  3,989	01-30-13	09-21-16	09-21-16
    27	    USPS Express International	    310 01-31-13	09-19-16	09-21-16    
    32	    UPS 2 Day Economy	        158,150	05-18-12	09-19-16	09-21-16    <-- no longer offered but there are a tiny amount of open backorders that may still ship this method
    */


        -- AFCO
        select O.iShipMethod, SM.sDescription,  
            count(*) 'Orders', 
            CONVERT(VARCHAR, MIN(O.dtShippedDate), 10)  'FirstShipped',
            CONVERT(VARCHAR, MAX(O.dtShippedDate), 10)  'LastShipped',
            CONVERT(VARCHAR, GETDATE(), 10) 'As of   '
        from [AFCOReporting].dbo.tblOrder O
            left join [AFCOReporting].dbo.tblShipMethod SM on O.iShipMethod = SM.ixShipMethod
        where iShipMethod is NOT NULL
            and O.sOrderStatus = 'Shipped'
           -- and O.dtOrderDate >= '01/01/2016'
        group by O.iShipMethod, SM.sDescription
        -- HAVING MAX(O.dtOrderDate) < DATEADD(day, -7, GetDate()) -- 7 days ago
        order by O.iShipMethod
        /*
        iShip                                       First       Last
        Method	sDescription	            Orders	Shipped	    Shipped	    As of   
        ======  ==========================  ======= =========   ========    ========
        1	    Counter	                      8,473	01-05-09	09-21-16	09-21-16
        2	    UPS Ground	                129,046	01-06-09	09-21-16	09-21-16
        3	    UPS 2 Day (Blue)	          1,891	01-07-09	09-21-16	09-21-16
        4	    UPS 1 Day (Red)	              3,105	01-08-09	09-21-16	09-21-16
        5	    UPS 3 Day	                    378	01-20-09	09-21-16	09-21-16    <-- SMI does not use
        6	    USPS Priority	                286	01-07-09	09-14-16	09-21-16
        7	    USPS Express	                  9	02-10-10	10-15-15	09-21-16    <-- no longer in use
        8	    Best Way	                131,836	01-06-09	09-21-16	09-21-16
        10	    UPS Worldwide Expedited	         56	04-11-12	08-15-16	09-21-16
        11	    UPS Worldwide Saver	             49	01-20-11	09-16-16	09-21-16
        12	    UPS Standard	                309	01-20-11	08-11-16	09-21-16
        13	    FedEx Ground	              3,892	10-19-11	09-20-16	09-21-16
        14	    FedEx Home Delivery	          5,786	10-20-11	09-21-16	09-21-16
        */




/* SMI has MORE SHIP METHODS than AFCO and more fields */
SELECT SMI.*, AFCO.ixShipMethod 'AFCO_ixShipMethod', AFCO.sDescription 'AFCO_sDescription'
FROM [SMI Reporting].dbo.tblShipMethod SMI
    FULL OUTER JOIN [AFCOReporting].dbo.tblShipMethod AFCO ON SMI.ixShipMethod = AFCO.ixShipMethod
ORDER BY SMI.ixShipMethod, AFCO.ixShipMethod     


-- iShipMethod 32 is no longer offered but there are a tiny amount of backorders that may still ship via 32
SELECT ixOrder, sOrderStatus, iShipMethod, dtOrderDate, dtShippedDate
from tblOrder
where iShipMethod = 32
and sOrderStatus NOT IN ('Shipped', 'Cancelled', 'Cancelled Quote')
order by dtShippedDate
/*                          iShip   dtOrder
ixOrder	    sOrderStatus	Method	Date	    dtShippedDate
6382331-1	Backordered	    32	    2015-09-03  NULL
6268873-1	Backordered	    32	    2016-05-25  NULL
6498672-1	Backordered	    32	    2016-06-06  NULL
6172355-1	Backordered	    32	    2016-02-01  NULL
6178387-1	Backordered	    32	    2016-07-17  NULL
6110453-1	Backordered	    32	    2016-02-02  NULL
6111450-1	Backordered	    32	    2016-02-02  NULL
6415672-2	Backordered	    32	    2016-06-06  NULL
6827971-1	Backordered	    32	    2016-07-01  NULL
*/




select * from tblShipMethod
/*
ixShip                                              sTransport  dtLast
Method	sDescription	            ixCarrier	    Method	    ManualUpdate
======  =======================     =============== ==========  ================
1	    Counter	                    SMI	            Pickup	    2013-07-27 00:00
2	    UPS Ground	                UPS	            Ground	    2013-07-27 00:00
3	    UPS 2 Day (Blue)	        UPS	            Air	        2013-07-27 00:00
4	    UPS 1 Day (Red)	            UPS	            Air	        2013-07-27 00:00
5	    UPS 3 Day	                UPS	            Air	        2013-07-27 00:00
6	    USPS Priority	            USPS	        Ground	    2013-07-27 00:00
7	    USPS Express	            USPS	        Ground	    2013-07-27 00:00
8	    Best Way	                Misc	        Misc	    2013-07-27 00:00
9	    SpeeDee	                    SpeeDee	        Ground	    2013-07-27 00:00
10	    UPS Worldwide Expedited	    UPS	            Air	        2013-07-27 00:00
11	    UPS Worldwide Saver	        UPS	            Air	        2013-07-27 00:00
12	    UPS Standard	            UPS	            Air/Ground	2013-07-27 00:00
13	    FedEx Ground	            FedEx	        Ground	    2013-07-27 00:00
14	    FedEx Home Delivery	        FedEx	        Ground	    2013-07-27 00:00
15	    FedEx SmartPost	            FedEx	        Ground	    2013-07-27 00:00


18	    UPS SurePost	            UPS	            Ground	    2013-07-27 00:00
19	    Canada Post	                UPS	            Ground	    2013-07-27 00:00
20	    USPS First Class Mail	    USPS	        Air/Ground	2016-08-22 00:00
21	    DHL Parcel Priority	        DHL Global Mail	Air	        2016-09-21 09:57
22	    DHL Parcel Direct	        DHL Global Mail	Air	        2016-09-21 09:57
#23???  DHL Express Worldwide       DHL Express     Air         2016-09-21 15:10

26	    USPS Priority International	USPS	        Air	        2013-07-27 00:00
27	    USPS Express International	USPS	        Air	        2013-07-27 00:00

32	    UPS 2 Day Economy	        UPS	            Air/Ground	2013-07-27 00:00
*/


select distinct sTransportMethod from tblShipMethod
/*
Air
Air/Ground
Ground
Misc
Pickup
*/

