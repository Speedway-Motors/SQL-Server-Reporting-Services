-- DW1 Blocking Issues


-- SELECT getdate()
/*
Alaina Started Tableau refresh @2016-02-05 14:10



Date        MAX
of          Replication
blocking    Lag             Cause           Notes
========    ==============  =============== ================================================================================================================================================
2-5-2016    15 mins 7 sec   Tableau refresh Alaina Started it @2016-02-05 14:10, Replication was blocked almost immediately and did not catch up until the refresh completed at approx 14:26

  

-- CTRL-F3
CurrentTime	SOPUpdated	TransTime	Delay(Sec)	ReplctnWindow	Today	    TransDate	SOPUpdateDate
14:23:37	14:11:08  	14:11:06  	2	        NO	            2/05/2016	02/05/2016	02/05/2016


select ixDate, MAX(ixTimeLastSOPUpdate-ixTime) 'Lag(seconds)'
from tblSKUTransaction
where ixDate = 17568
and ixTime between 28800 and 72000
GROUP BY ixDate

select * from tblTime where chTime like '%:00:00%'
/*
ixTime	chTime
28800	08:00:00  
32400	09:00:00  
36000	10:00:00  
39600	11:00:00  
43200	12:00:00  
46800	13:00:00  
50400	14:00:00  
54000	15:00:00  
57600	16:00:00  
61200	17:00:00  
64800	18:00:00  
68400	19:00:00  
72000	20:00:00  
*/


select * from tblOrd