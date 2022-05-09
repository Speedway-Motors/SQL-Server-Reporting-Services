-- tblErrorLogMaster Checks

/**************** ERROR CODES & ERROR LOG history ***********************/
-- N/A since this is a manually populated table
/************************************************************************/

select * from tblErrorLogMaster

-- TABLE GROWTH
exec spGetTableGrowth tblErrorLogMaster
/*
DB          	TABLE       	Rows   	Date
SMI Reporting	tblErrorLogMaster	2,965,053	04-01-17 -- Archived approx 1m records
SMI Reporting	tblErrorLogMaster	3,936,770	01-01-17
SMI Reporting	tblErrorLogMaster	3,060,496	10-01-16
SMI Reporting	tblErrorLogMaster	2,024,962	07-01-16
SMI Reporting	tblErrorLogMaster	1,504,127	04-01-16
SMI Reporting	tblErrorLogMaster	1,407,481	01-01-16
SMI Reporting	tblErrorLogMaster	1,282,674	01-01-15
SMI Reporting	tblErrorLogMaster	441,667	    01-01-14
SMI Reporting	tblErrorLogMaster	418,013	    01-01-13
SMI Reporting	tblErrorLogMaster	188,057 	03-01-12
*/

select * from tblErrorLogMaster
where ixErrorCode = 1223
ORDER BY dtDate desc

select DB_NAME() AS 'DB          '
    , CONVERT(VARCHAR, dtDate, 102)  AS 'Date     '
    , COUNT(*) 'ErrorQty'
from tblErrorLogMaster
--where ixErrorCode = 1223
group by CONVERT(VARCHAR, dtDate, 102)
order by CONVERT(VARCHAR, dtDate, 102) desc
/*                          Error
DB          	Date     	Qty
SMI Reporting	2017.04.01	1
SMI Reporting	2017.03.31	2
SMI Reporting	2017.03.30	1
SMI Reporting	2017.03.29	8
SMI Reporting	2017.03.23	17
SMI Reporting	2017.03.22	3
SMI Reporting	2017.03.21	2
SMI Reporting	2017.03.20	4
SMI Reporting	2017.03.18	1
SMI Reporting	2017.03.17	1
SMI Reporting	2017.03.16	3
SMI Reporting	2017.03.13	2
SMI Reporting	2017.03.11	1
SMI Reporting	2017.03.09	1
SMI Reporting	2017.03.02	1
SMI Reporting	2017.02.28	1
SMI Reporting	2017.02.27	1
SMI Reporting	2017.02.24	1
SMI Reporting	2017.02.23	3
SMI Reporting	2017.02.22	1
SMI Reporting	2017.02.21	2
SMI Reporting	2017.02.20	1
SMI Reporting	2017.02.14	22
SMI Reporting	2017.02.13	3
SMI Reporting	2017.02.09	3
SMI Reporting	2017.02.07	1
SMI Reporting	2017.02.06	5
SMI Reporting	2017.01.31	7
SMI Reporting	2017.01.30	2
SMI Reporting	2017.01.26	1
SMI Reporting	2017.01.23	5
SMI Reporting	2017.01.22	2
SMI Reporting	2017.01.17	68
SMI Reporting	2017.01.13	1
SMI Reporting	2017.01.11	2
SMI Reporting	2017.01.06	1
SMI Reporting	2017.01.02	2
SMI Reporting	2016.12.31	2
SMI Reporting	2016.12.29	5
SMI Reporting	2016.12.27	1
SMI Reporting	2016.12.24	380
SMI Reporting	2016.12.22	2
SMI Reporting	2016.12.20	2
SMI Reporting	2016.12.19	1
SMI Reporting	2016.12.12	2
SMI Reporting	2016.12.01	2
SMI Reporting	2016.11.28	2
SMI Reporting	2016.11.27	2
SMI Reporting	2016.11.26	2
SMI Reporting	2016.11.24	2
SMI Reporting	2016.11.17	2
SMI Reporting	2016.11.14	4
SMI Reporting	2016.11.03	1
SMI Reporting	2016.10.29	1
SMI Reporting	2016.10.24	3
*/


select ixErrorCode, count(*)
from tblErrorLogMaster
where dtDate = '2018.05.25'
group by ixErrorCode

1000	1
1224	1
1203	15
1189	5

select * from tblErrorCode where ixErrorCode in (1000,1224,1203,1189)





