-- tblSnapshotSKU Checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblSnapshotSKU%'
--  ixErrorCode	sDescription
--  1153	failure to update tblSnapshotSKU (no longer used see error 1184)
--  1184	Failure to update tblSnapshotSKU.

-- ERROR COUNTS by Day
SELECT DB_NAME() AS DataBaseName,
CONVERT(VARCHAR(10), dtDate, 10) AS 'Date      '
    ,FORMAT(count(*),'##,##0') AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1184'
  and dtDate >=  DATEADD(month, -3, getdate())  -- past 3 months
GROUP BY dtDate, CONVERT(VARCHAR(10), dtDate, 10)  
--HAVING count(*) > 10
ORDER BY dtDate Desc
/*
DataBaseName	Date      	ErrorQty
SMI Reporting	03-24-18	159,832
SMI Reporting	01-27-18	163,229
SMI Reporting	12-02-17	237,098
SMI Reporting	11-04-17	238,295
SMI Reporting	10-25-17	366,497
SMI Reporting	10-07-17	247,542
SMI Reporting	09-04-17	173,649
SMI Reporting	08-12-17	155,168
SMI Reporting	06-24-17	177,224
SMI Reporting	06-08-17	10,206
SMI Reporting	04-22-17	182,757
SMI Reporting	02-11-17	152,764
SMI Reporting	01-07-17	135,004

AFCOReporting	10-13-16	24,737
************************************************************************/

-- Distinct list of Orders with erros
select distinct 
    sError,
    SUBSTRING(sError,7,15) 'ixOrder'
from tblErrorLogMaster
where ixErrorCode = '1184'
  and dtDate >='05/27/2014'
order by sError  

            
-- Counts by day
select ixDate,
    FORMAT(COUNT(*),'##,##0') 'RecCount',
    MIN(ixTimeLastSOPUpdate) 'FirstUpdate',
    MAX(ixTimeLastSOPUpdate) 'LastUpdate',
    FORMAT((MAX(ixTimeLastSOPUpdate)-MIN(ixTimeLastSOPUpdate)),'##,##0') 'TotSec',
    COUNT(*)/(MAX(ixTimeLastSOPUpdate)-MIN(ixTimeLastSOPUpdate)) 'Rec/Sec'
from tblSnapshotSKU
where ixDate >= 18364
group by ixDate
--having MAX(ixTimeLastSOPUpdate) > 27634 -- finishes by 08:00 most of the time
order by ixDate desc
/*      Rec     First   Last    Tot
ixDate	Count	Update	Update	Sec	    Rec/Sec
======  ======= ======  ======  ======  =======
18371	402,603	22069	23592	1,523	264     -- 06:07:49  to 06:33:12    Al manually kicked it off after a reboot
18370	402,577	6620	20730	14,110	28      TUESDAY
18369	402,423	6622	20890	14,268	28
18368	402,423	6621	18872	12,251	32
18367	402,423	21866	23569	1,703	236     SATURDAY -- probable reboot
18366	402,327	6635	20192	13,557	29
18365	402,248	6619	13607	6,988	57
18364	402,200	6622	21569	14,947	26
18363	402,120	6621	20801	14,180	28      TUESDAY
18362	402,023	6622	11115	4,493	89
18361	402,023	6620	17843	11,223	35
18360	402,023	6620	24535	17,915	22      SATURDAY
18359	401,980	6623	19648	13,025	30
18358	401,914	6619	20619	14,000	28
18357	401,857	20023	23608	3,585	112 -- probable reboot
18356	401,759	6621	17906	11,285	35  TUESDAY
18355	401,569	6621	19498	12,877	31
18354	401,569	6622	20927	14,305	28
18353	401,569	6622	27634	21,012	19  SATURDAY
18352	401,498	6622	25024	18,402	21
18351	401,350	6624	17542	10,918	36
18350	401,261	19908	21775	1,867	214 -- probable reboot
18349	401,200	6622	15385	8,763	45  TUESDAY
18348	400,855	6622	24157	17,535	22
18347	400,855	6622	19811	13,189	30
18346	400,836	6619	22684	16,065	24  SATURDAY
18345	400,799	6621	22684	16,063	24
18344	400,659	6622	15870	9,248	43
18343	400,574	6621	16738	10,117	39
18342	400,266	6639	24202	17,563	22  TUESDAY
18341	400,128	6620	14298	7,678	52
18340	400,128	6619	19777	13,158	30
18339	400,128	6621	16893	10,272	38  SATURDAY
18338	400,044	6622	23137	16,515	24
18337	394,352	6619	21266	14,647	26
18336	394,278	6619	20684	14,065	28
18335	394,155	6620	16767	10,147	38  TUESDAY
18334	393,994	6630	20399	13,769	28
*/

select ixTime, chTime from tblTime where ixTime in (11115,17843,20619,22069,23592, 24535,27000,27634,28800,30600,36000,39600,41889)
/*
ixTime	chTime
11115	03:05:15  
17843	04:57:23  
20619	05:43:39  
24535	06:48:55  
27000	07:30:00  
27634	07:40:34  
28800	08:00:00  
30600	08:30:00  
36000	10:00:00  
39600	11:00:00  
41889	11:38:09  
*/

/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblSnapshotSKU
/*
DB          	Rows   	    Date
SMI Reporting	262,315,880	04-01-18
SMI Reporting	358,190,882	03-01-18

SMI Reporting	338,966,785	01-01-18
SMI Reporting	214,885,427	01-01-17
SMI Reporting	143,925,021	01-01-16
SMI Reporting	163,011,688	01-01-15
SMI Reporting	 95,065,811	01-01-14
SMI Reporting	 74,122,911	01-01-13
SMI Reporting	 42,660,167	03-01-12

AFCOReporting	76,611,738	03-01-18

AFCOReporting	72,645,953	01-01-18
AFCOReporting	49,127,371	01-01-17
AFCOReporting	74,959,591	01-01-16
AFCOReporting	56,233,305	01-01-15
AFCOReporting	38,615,492	01-01-14
AFCOReporting	34,378,045	10-01-13
*/      





