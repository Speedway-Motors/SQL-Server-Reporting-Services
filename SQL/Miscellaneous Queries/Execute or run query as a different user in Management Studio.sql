-- Execute or run query as a different user in Management Studio

/*
From: Ronald M. Desimone 

In SQL Management studio after you open a query window you can change the context of that window to be running under a different user.
*/

-- example:

-- (switches to jmroberts and try and select from a database she does not have permissions for):
use [AFCOReporting];
execute as user = 'SPEEDWAYMOTORS\jmroberts'

select top 20 * from [AFCOReporting].dbo.[tblOrder] -- should work

select top 20 * from [SMI Reporting].dbo.[tblOrder] -- should fail

select * from [RonTest].[dbo].[TestTable] -- should fail







use [SMI Reporting];
execute as user = 'SPEEDWAYMOTORS\mike'
exec spExecPOReport '101375', '101375'
/*
To get back to your user type and execute 

REVERT





Obviously there are limitations to this.
Only users with enough permissions can do that.
I have not been able to switch it back to my user, but have not spent a lot of time figuring out.

But we may be able to do this to figure out some security issues.
*/


