-- get database ID
SELECT name,dbid,crdate'Created'
FROM master..sysdatabases
/*
name	        dbid	Created
master	        1	    2003-04-08 09:13:36.390
tempdb	        2	    2014-06-27 14:50:49.217
model	        3	    2003-04-08 09:13:36.390
msdb	        4	    2005-10-14 01:54:05.240
SMI Reporting	5	    2014-04-22 06:09:58.320
AFCOReporting	6   	2012-05-12 09:15:13.817
WebInfo	        7	    2012-05-25 11:15:25.980
SMIArchive	    8	    2012-06-23 11:38:33.950
distribution	10	    2012-07-02 07:12:19.603
SMITemp	        11	    2012-11-13 09:36:52.370
SMI_360	        12	    2012-09-07 11:35:41.920
AFCOTemp	    13	    2012-11-12 14:54:47.587
SMISema	        14	    2013-05-31 09:00:14.177
ErrorLogging	15	    2014-01-17 11:55:54.650
*/


-- to find single DB ID by DB Name
select db_id('SMI Reporting')


