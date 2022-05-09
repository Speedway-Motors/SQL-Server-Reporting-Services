-- testing Pause and Resume functionality for SOP Feeds 
select C.ixCustomer, C.dtDateLastSOPUpdate, C.ixTimeLastSOPUpdate, T.chTime
from tblCustomer C
join tblTime T on C.ixTimeLastSOPUpdate = T.ixTime
where C.dtDateLastSOPUpdate = '11/3/14'
    and C. ixTimeLastSOPUpdate > 44600
order by  C.ixTimeLastSOPUpdate desc

/*
ixCustomer	dtDateLastSOPUpdate	ixTimeLastSOPUpdate	chTime
SMI
2028749	2014-11-03 00:00:00.000	44623	12:23:43  
551880	2014-11-03 00:00:00.000	44622	12:23:42  
                                RESUMED 12:23
546370	2014-11-03 00:00:00.000	44046	12:14:06  
1590147	2014-11-03 00:00:00.000	44046	12:14:06  



AFCO
17627	2014-11-03 00:00:00.000	45063	12:31:03  
                                RESUMED 12:30
                                PAUSED  12:26
31173	2014-11-03 00:00:00.000	44763	12:26:03    
*/


select C.ixBin, C.dtDateLastSOPUpdate, C.ixTimeLastSOPUpdate, T.chTime
from tblBinSku C
join tblTime T on C.ixTimeLastSOPUpdate = T.ixTime
where C.dtDateLastSOPUpdate = '11/3/14'
    and C. ixTimeLastSOPUpdate > 44668
order by  C.ixTimeLastSOPUpdate desc
/*
ixBin	dtDateLastSOPUpdate	ixTimeLastSOPUpdate	chTime
SMI
BM36G1	2014-11-03 00:00:00.000	44641	12:24:01  
5A33B1	2014-11-03 00:00:00.000	44641	12:24:01  
                                RESUMED 12:23
4B08E2	2014-11-03 00:00:00.000	43977	12:12:57  
AH22A1	2014-11-03 00:00:00.000	43977	12:12:57  



AFCO
G02D1A	2014-11-03 00:00:00.000	45077	12:31:17  
                                RESUMED 12:30
                                PAUSED  12:26
G42A5B	2014-11-03 00:00:00.000	44669	12:24:29  
*/


