-- Package trailer info
select O.iShipMethod, P.* -- 2447 -- 72 
from tblPackage P
join tblOrder O  on P.ixOrder = O.ixOrder
where O.iShipMethod NOT IN (1, 6, 7, 8, 10, 11, 12, 26, 27)
--O.iShipMethod = 32
and O.dtShipped >= '06/10/2014'
and O.sOrderStatus = 'Shipped'

and P.ixTrailer is NULL
order by O.iShipMethod

select * from tblShipMethod
/*
Ship
Mth Description	ixCarrier	sTransportMethod
2	UPS Ground	            UPS	Ground
3	UPS 2 Day (Blue)	    UPS	Air
4	UPS 1 Day (Red)	        UPS	Air
5	UPS 3 Day	UPS	        Air
9	SpeeDee	SpeeDee	        Ground
13	FedEx Ground	        FedEx	Ground
14	FedEx Home Delivery	    FedEx	Ground
15	FedEx SmartPost	        FedEx	Ground
18	UPS SurePost	        UPS	Ground
19	Canada Post	            UPS	Ground
32	UPS 2 Day Economy	    UPS	Air/Ground

CAN NOT TRACK
Ship
Mth Description	ixCarrier	sTransportMethod
1	Counter	SMI	            Pickup
6	USPS Priority	        USPS	Ground
7	USPS Express	        USPS	Ground
8	Best Way	            Misc	Misc
10	UPS Worldwide           Expedited	UPS	Air
11	UPS Worldwide           Saver	UPS	Air
12	UPS Standard	        UPS	Air/Ground
26	USPS Priority International	USPS	Air
27	USPS Express International	USPS	Air
*/




select O.iShipMethod, count(P.sTrackingNumber) -- 2447 -- 72 
from tblPackage P
join tblOrder O  on P.ixOrder = O.ixOrder
where O.iShipMethod NOT IN (1, 6, 7, 8, 10, 11, 12, 26, 27)
--and O.iShipMethod = 32
and O.dtOrderDate = '06/10/2014'
and O.sOrderStatus = 'Shipped'
--and P.ixTrailer is NULL
group by O.iShipMethod
order by O.iShipMethod

iShip   Tot     Pkgs
Method	Pkgs    with no Trailer
2	1779
3	2
4	7
9	151
13	54
14	225
18	20
19	16
32	201


select P.*--O.iShipMethod, count(P.sTrackingNumber) -- 2447 -- 72 
from tblPackage P
join tblOrder O  on P.ixOrder = O.ixOrder
where O.iShipMethod NOT IN (1, 6, 7, 8, 10, 11, 12, 26, 27)
and O.iShipMethod = 18
and O.dtOrderDate = '06/10/2014'
and O.sOrderStatus = 'Shipped'