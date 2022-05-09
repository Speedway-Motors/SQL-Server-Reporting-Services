-- SMIHD-10583 - Open Counter Orders report not updating

SELECT  ixEmployee, T.chTime 'Scanned', ixOrder,
(ixTimeLastSOPUpdate-ixScanTime) 'LAG'   
FROM tblCounterOrderScans OS
join tblTime T on T.ixTime = OS.ixScanTime
WHERE ixOrder in ('7251386','7267386','7252386','7279380','7278387','7284381')
-- no records at 10:53, 10:57, 11:47
order by ixOrder


select ixEmployee, T.chTime 'Scanned', ixOrder,
(ixTimeLastSOPUpdate-ixScanTime) 'LAG'  
from tblCounterOrderScans OS
    join tblTime T on T.ixTime = OS.ixScanTime
where dtScanDate = '04/12/2018'
order by ixScanTime DESC
/*
Emp     Scanned	    ixOrder	    LAG
JAM3	10:07:17  	PC107562	0       -- 10:15

CNB	    10:33:21  	PC107563	9       -- 10:36
JAM3	10:28:49  	PC107563	1
GJL	    10:19:25  	7275382	    4

GJL	10:46:19  	PC107563	2           -- 10:50 
GJL	10:45:28  	PC107562	3
CNB	10:33:21  	PC107563	9
JAM3	10:28:49  	PC107563	1
GJL	10:19:25  	7275382	4
JAM3	10:07:17  	PC107562	0

BDW	10:56:20  	PC107564	5           -- 10:59
JAM3	10:54:13  	PC107565	1
RJF	10:49:45  	PC107564	6
GJL	10:46:19  	PC107563	2
GJL	10:45:28  	PC107562	3


2018-04-11 00:00:00.000	46653
select * from tblTime where ixTime = 46799
46901


Gary 1:00

*/
select distinct ixIP
from tblCounterOrderScans OS
    join tblTime T on T.ixTime = OS.ixScanTime
where dtScanDate = '04/11/2018'

select * from tblIPAddress
where ixIP in ('192.168.240.16','192.168.240.18','192.168.240.31','192.168.240.32','192.168.240.37','192.168.240.40','192.168.240.41','192.168.240.42','192.168.240.43','192.168.240.44','192.168.240.51','192.168.240.52','192.168.240.54')
and sGroup = 'Counter'



select ixEmployee,ixOrder, ixIP, count(*) 
from tblCounterOrderScans OS
    join tblTime T on T.ixTime = OS.ixScanTime
where dtScanDate = '04/12/2018'
and ixTime >= 50400 -- 14:00
group by ixEmployee,ixOrder,  ixIP

select * from tblTime


select * from tblTime where chTime = '12:00:00'
order by ixScanTime DESC


SELECT COUNT(*)
from tblCounterOrderScans OS
where dtScanDate = '04/13/2018'