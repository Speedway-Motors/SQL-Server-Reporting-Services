-- NEW DHL SHIP METHODS

SELECT * FROM tblShipMethod where ixShipMethod between 21 and 23
/*
ixShip
Method	sDescription
======  ======================
21	    DHL Parcel Priority
22	    DHL Parcel Direct
23	    DHL Express Worldwide
*/

-- SUMMARY BY SHIP METHOD
SELECT iShipMethod, sOrderStatus, COUNT(*) 'OrdCnt', CONVERT(VARCHAR,GETDATE(), 22) 'AS of'
FROM tblOrder
where iShipMethod between 21 and 23
and sOrderStatus NOT IN ('Cancelled', 'Cancelled Quote','Quote')
GROUP BY iShipMethod, sOrderStatus 
order by iShipMethod, sOrderStatus 
/*
iShip   sOrder  Ord
Method	Status	Cnt	    AS of
21	    Open	3	10/06/16 12:16:55 PM
22	    Open	5	10/06/16 12:16:55 PM
22	    Shipped	1	10/06/16 12:16:55 PM

22	    Open	17	10/10/16 11:42:27 AM
21	    Shipped	4	10/10/16 11:42:27 AM
22	    Shipped	22	10/10/16 11:42:27 AM

21	    Open	1	10/12/16 10:33:38 AM
21	    Shipped	10	10/12/16 10:33:38 AM
22	    Backordered	1	10/12/16 10:33:38 AM
22	    Open	7	10/12/16 10:33:38 AM
22	    Shipped	55	10/12/16 10:33:38 AM

21	    Open	1	10/19/16  4:16:13 PM
21	    Shipped	38	10/19/16  4:16:13 PM
22	    Backordered	3	10/19/16  4:16:13 PM
22	    Open	1	10/19/16  4:16:13 PM
22	    Shipped	126	10/19/16  4:16:13 PM
*/


select ixTrailer, COUNT(*)
from tblPackage
where ixTrailer like 'DH%'
group by ixTrailer



-- DETAILS
SELECT * 
FROM tblOrder
where iShipMethod between 21 and 23



