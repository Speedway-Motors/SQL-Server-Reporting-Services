-- tblSKUTransaction checks
/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblSKUTransaction%'
--  ixErrorCode	sDescription
--  1151	Failure to update tblSKUTransaction

-- ERROR COUNTS by Day
SELECT dtDate, DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1151'
  and dtDate >=  DATEADD(month, -12, getdate()) -- past X months
GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
--HAVING count(*) > 10
ORDER BY dtDate desc
/*
DB          	Date    	ErrorQty
SMI Reporting	04/20/2021	56545
SMI Reporting	02/11/2021	721



AFCOReporting	01/22/2014	744
AFCOReporting	01/21/2014	437
AFCOReporting	01/20/2014	133
AFCOReporting	01/17/2014	221
AFCOReporting	01/16/2014	312
AFCOReporting	01/15/2014	316
*/


                         
/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblSKUTransaction                                

/*
DB          	TABLE       	    Rows   	    Date
SMI Reporting	tblSKUTransaction	50,923,600	2021.05.01

SMI Reporting	tblSKUTransaction	43,226,576	2021.02.01
SMI Reporting	tblSKUTransaction	55,921,708	2021.01.01

SMI Reporting	tblSKUTransaction	45,059,094	2020.07.01

SMI Reporting	tblSKUTransaction	38,060,892	2020.01.01
SMI Reporting	tblSKUTransaction	32,907,805	2019.01.01
SMI Reporting	tblSKUTransaction	31,182,733	2018.01.01
SMI Reporting	tblSKUTransaction	28,219,381	2017.01.01
SMI Reporting	tblSKUTransaction	38,520,302	2016.01.01
SMI Reporting	tblSKUTransaction	37,354,783	2015.01.01
SMI Reporting	tblSKUTransaction	25,044,601	2014.01.01
SMI Reporting	tblSKUTransaction	33,914,665	2013.01.01
SMI Reporting	tblSKUTransaction	12,818,319	2012.03.01

AFCOReporting	tblSKUTransaction	16,936,237	10-01-15
AFCOReporting	tblSKUTransaction	16,054,799	07-01-15
AFCOReporting	tblSKUTransaction	14,962,767	04-01-15
AFCOReporting	tblSKUTransaction	14,045,722	01-01-15
AFCOReporting	tblSKUTransaction	13,397,710	10-01-14
AFCOReporting	tblSKUTransaction	12,559,622	07-01-14
AFCOReporting	tblSKUTransaction	11,710,807	04-01-14
AFCOReporting	tblSKUTransaction	10,968,873	01-01-14
AFCOReporting	tblSKUTransaction	10,407,987	10-01-13
AFCOReporting   tblSKUTransaction      852,493  6/1/14-8/31/14 v
AFCOReporting   tblSKUTransaction      199,773  9/1/14-9/23/14 v                      
*/                                    
select distinct sError from tblErrorLogMaster
where ixErrorCode = 1151
and dtDate >= '01/24/2015'



SELECT ixDate, FORMAT(count(*),'###,###') SKUTransCnt
from tblSKUTransaction
where ixDate >= 19339-- 05/27/2014
group by ixDate
order by ixDate desc
/*
ixDate	Qty
19356	17,447
19355	34,420
19354	29,679
19353	2,456  -- Xmas

19352	25,984
19351	78,057
19350	54,400
19349	73,063
19348	30,171
19347	23,311
19346	45,789

19345	60,560
19344	69,438
19343	70,242
19342	85,142
19341	35,329
19340	22,187
19339	52,552
*/

select * from tblDate
where ixDate = 19353
 
