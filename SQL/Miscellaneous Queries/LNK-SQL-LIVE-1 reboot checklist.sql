-- LNK-SQL-LIVE-1 reboot checklist

SELECT @@SPID as 'Current SPID' -- 129 

/*
1 - send outage messages in Teams to "Data Puddle" and "SOP feeds to Reporting Services" teams.

2 - PAUSE SOP Feeds & notify Connie

3 - Check connection counts to see if server is back up
	*/
    SELECT (D.sDayOfWeek3Char + ' ' +FORMAT(getdate(),'MM/dd/yy HH:mm')) 'As Of             ', PC.cntr_value 'UserConnections'
    FROM sys.dm_os_performance_counters PC       Left join tblDate D on FORMAT(getdate(),'MM/dd/yyyy') = D.dtDate
    WHERE counter_name = 'User Connections'
	/*					User
	As Of             	Connections
	==================	===========
	FRI 04/22/22 09:58	18
	FRI 04/22/22 10:09	75

4 - verify Reporting Services is available again and run a fast report (Open Counter Tickets or eceiving On Dock Times are good)

5 - RESUME SOP Feeds

6 - check SOP feed queue

7 - send "all clear' messages in Teams to "Data Puddle" and "SOP feeds to Reporting Services" teams.


8 - check latest SKU Transaction and most recent orders on LNK-SQL-LIVE-1 and AWS to see how far the data is behind.

9 - Run "BiB" & "Daily Checks" to look for any hiccups

10 - Manually execute any report subscriptions that tried to run during downtime.

11 - Exhale

*/



