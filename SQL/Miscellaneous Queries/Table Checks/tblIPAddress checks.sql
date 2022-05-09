-- tblIPAddress checks

-- IPs listed more than once 
--(probably should change the IP address to be a PK)
SELECT ixIP, count(*) from tblIPAddress
group by ixIP
having count(*) > 1



-- non-static IPs
select * from tblIPAddress
where ixIP like '%.174.%'



-- scans coming from non-static IPs (these need to become static IPs ASAP!)
select ixIP, count(*) ScanCount
from tblCounterOrderScans
where ixIP like '%.174.%'
group by ixIP
/*
ixIP	ScanCount
192.168.174.218	40
192.168.174.57	2
192.168.174.94	210
*/



select count(*) from tblIPAddress -- 56 @8-1-2013

select * from tblIPAddress
/*
ixIP	sDescription	sLocation	sGroup	dtLastManualUpdate
192.168.240.21	LNK-WH-19A	3rd Floor Battleship east end	Carousel	2013-08-01
192.168.240.45	3ABC	3rd Floor South	Carousel	2013-08-01
192.168.240.31	LNK-CTR-04	East center	Counter	2013-08-01
192.168.240.32	LNK-CTR-03	West center	Counter	2013-08-01
192.168.240.51	LNK-CTR-02	West Side	Counter	2013-08-01
192.168.240.52	LNK-CTR-01	East side	Counter	2013-08-01
192.168.240.54	LNK-CTR-07A	Unknown	Counter	2013-08-01
192.168.240.37	LNK-WH-28	CID Printer	Carousel	2013-08-01
192.168.240.41	4DEF:	Second floor North	Carousel	2013-08-01
192.168.240.42	5ABC:	Main floor South	Carousel	2013-08-01
192.168.254.63	ALB1	AL's Desktop	IT	2013-08-01
192.168.240.40	4ABC	Second floor South	Carousel	2013-08-01
192.168.174.94	LNK-WH-17A	Jason Korth's PC	Carousel	2013-08-01
192.168.240.16	LNK-WH-40A	Main floor North	Carousel	2013-08-01
192.168.174.121	LNK-07A	Pat's Desktop	IT	2013-08-01
192.168.174.218	no longer used	no longer used	Counter	2013-08-01
192.168.240.43	5DEF	Carousel 5DEF	Carousel	2013-08-01
192.168.240.10	LNK-WH-11A	Big Pack Truck Order Verification	Big Pack	2013-08-01
192.168.240.11	LNK-WH-13	Big Pack Verifing	Big Pack	2013-08-01
192.168.240.12	LNK-WH-42	Fiberglass receiving	Other	2013-08-01
192.168.240.13	LNK-WH-03A	Mr B's	Carousel	2013-08-01
192.168.240.14	LNK-WH-04A	Returns Computer	Counter	2013-08-01
192.168.240.15	LNK-WH-43A	Lois's computer	Big Pack	2013-08-01
192.168.240.152	LNK-WH-52A	Receiving computer (packing)	Other	2013-08-01
192.168.240.18	LNK-WH-18A	Battleship 2nd floor	Carousel	2013-08-01
192.168.240.20	LNK-WH-02A	Jackie's	Carousel	2013-08-01
192.168.240.26	LNK-WH-25A	South KC verify	Small Pack	2013-08-01
192.168.240.27	LNK-WH-24A	North KC verify	Small Pack	2013-08-01
192.168.240.28	LNK-WH-22A	SW verify	Small Pack	2013-08-01
192.168.240.29	LNK-WH-21A	Middle west verify	Small Pack	2013-08-01
192.168.240.33	LNK-WH-14	Big Pack north verify	Big Pack	2013-08-01
192.168.240.34	LNK-WH-12A	Big Pack Shipping	Big Pack	2013-08-01
192.168.240.35	LNK-WH-20A	NW verify	Small Pack	2013-08-01
192.168.240.36	LNK-WH-23A	Small Pack Shipping	Small Pack	2013-08-01
192.168.240.38	LNK-WH-10A	South Time Clock	Big Pack	2013-08-01
192.168.240.39	LNK-WH-09A	North Time Clock	Big Pack	2013-08-01
192.168.240.5	LNK-WH-05A	Receiving North island	Other	2013-08-01
192.168.240.50	LNK-WH-50	Receiving Middle Island	Other	2013-08-01
192.168.240.7	LNK-WH-08	Receiving BOM area East	Other	2013-08-01
192.168.240.8	LNK-WH-07	Receiving BOM area West	Other	2013-08-01
192.168.240.2	LNK-WH-01A	Brian H	Carousel	2013-08-01
192.168.174.16	LNK-WH-06A	Receiving South Island	Unknown	2013-08-01
192.168.175.29	LNK-WH-15A	Counter office	Counter	2013-08-01
192.168.174.108	LNK-WH-29A	Nick S	Other	2013-08-01
192.168.174.230	LNK-WH-30A	Gary L	Counter	2013-08-01
192.168.174.125	LNK-WH-31A	Returns Office	Counter	2013-08-01
192.168.174.12	LNK-WH-33A	Larkins	Other	2013-08-01
192.168.174.21	LNK-WH-34A	Seth	Other	2013-08-01
192.168.174.212	LNK-WH-38A	Returns Office	Other	2013-08-01
192.168.174.52	LNK-WH-39A	Tony I	Other	2013-08-01
192.168.174.199	LNK-WH-41A	Scott H	Big Pack	2013-08-01
192.168.174.13	LNK-WH-46A	Lynn	Big Pack	2013-08-01
192.168.174.57	LNK-WH-48	Taylor B	Small Pack	2013-08-01
192.168.174.24	LNK-WH-53A	Middle  Receiving Island	Other	2013-08-01
192.168.174.75	LNK-WH-54	North of Jackie	Carousel	2013-08-01
192.168.174.44	LNK-WH-55	Travis R	Big Pack	2013-08-01
*/

-- Scans from IPs not in tblIPAddress
select CO.* 
from tblCounterOrderScans CO
    left join tblIPAddress IP on CO.ixIP = IP.ixIP
where IP.ixIP is NULL



select * from tblIPAddress
where ixIP = '192.168.174.16'
    -- ixIP NOT like '192.168.240%'
    -- and ixIP NOT like '192.168.174%'

select sGroup, count(*) Qty
from tblIPAddress
group by sGroup
/*
sGroup	    Qty
Big Pack	10
Carousel	14
Counter	    10
IT	        2
Other	    12
Small Pack	7
Unknown	    1
*/





