-- SMIHD-20120 - SKU Transactions updates are getting missed in AFCO Reporting
SELECT ixDate, 
    FORMAT(count(1),'###,###') 'Records', 
    FORMAT(max(iSeq)+1,'###,###') 'MaxSeq+1', 'SMI' 'Where',
    (count(1)-(max(iSeq)+1)) 'MissingTrans'
from tblSKUTransaction
where ixDate >= 19463 -- 04/14/2021                     MON 03/08/2021 new change went live
group by ixDate
--order by ixDate desc

UNION

SELECT  ixDate, 
    FORMAT(count(1),'###,###') 'Records', 
    FORMAT(max(iSeq)+1,'###,###') 'MaxSeq+1', 'AFCO' 'Where',
    (count(1)-(max(iSeq)+1)) 'MissingTrans'
from [AFCOReporting].dbo.tblSKUTransaction
where ixDate >= 19463 -- 04/14/2021                      MON 03/08/2021 new change went live
group by ixDate
order by ixDate desc, [Where] desc

/*              Max             Missing
ixDate  Records	Seq+1   Where   SKU Trans
=====   ======= ======= =====   =========
19464	16,666	16,666	SMI	    0
19464	7,975	7,975	AFCO	0
19463	152,591	152,591	SMI	    0
19463	21,677	21,677	AFCO	0
19462	128,488	128,488	SMI	    0
19462	21,773	21,773	AFCO	0
19461	158,848	158,848	SMI	    0
19461	16,992	16,992	AFCO	0
19460	63,054	63,054	SMI	    0
19460	12	    12	    AFCO	0



select ixDate, iSeq, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblSKUTransaction
where ixDate = 19427
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate --   24670-24871

select * from tblTime where ixTime in (24670,24871)


*/

select iSeq, ST.ixTime, T.chTime
from tblSKUTransaction ST
    left join tblTime T on ST.ixTime = T.ixTime -- 1,508 SKU Trans missing from 07:17:38   to 08:10:04  
where ixDate = 19427 
order by iSeq

select * from tblTime where ixTime = 26258 -- 07:17:38  
*/

select ST.ixDate, FORMAT(D.dtDate,'yyyy.MM.dd') 'Date',
  count(iSeq)'RecCnt', max(iSeq) 'MaxSeq',
  max(iSeq)-count(iSeq)+1 'Delta',
  max(T.chTime) 'LastTransLogged'
from tblSKUTransaction ST
    left join tblDate D on ST.ixDate = D.ixDate
    left join tblTime T on ST.ixTime = T.ixTime
where ST.ixDate >= 19421--	03/03/2021
group by ST.ixDate, dtDate
order by(max(iSeq)-count(iSeq)+1) desc, ST.ixDate desc
/*
ixDate	Date	    RecCnt	MaxSeq	Delta	LastTransLogged
19421	2021.03.03	73368	74566	1199	08:37:21  
19414	2021.02.24	12585	12584	0	    09:33:33  
19413	2021.02.23	87987	87986	0	    23:59:51  
19412	2021.02.22	140555	140554	0	    23:53:29  
19411	2021.02.21	40025	40024	0	    23:59:53  

19366	2021.01.07	19016	19015	0	    11:17:35  
19365	2021.01.06	91236	91235	0	    23:59:44  
19364	2021.01.05	89271	89270	0	    23:58:08  
19363	2021.01.04	152389	152388	0	    23:58:42  
19362	2021.01.03	53703	53702	0	    23:58:17  
19361	2021.01.02	33556	33555	0	    23:59:27  
19360	2021.01.01	5090	5089	0	    23:59:34  
*/


select ixDate, iSeq, T.chTime, ST.ixTime, ixSKU 
from tblSKUTransaction ST
    left join tblTime T on ST.ixTime = T.ixTime
where ST.ixDate = 19421 
    --and ixTime < 28800
    --and iSeq between 3960 and 3992 -- The missing sequence numbers 3961-3991
order by iSeq

/*
ixDate	iSeq	chTime	    ixTime	    ixSKU
19367	3960	07:02:39  	25359	9102021002
19367	3992	07:11:21  	25881	1115.0100

select * from tblTime where chTime LIKE '08:00:00%'
*/

