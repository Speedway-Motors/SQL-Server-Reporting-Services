-- Missing Clustered Indexes
-- To correct : on the server with the tables missing clustered index(s) run 
exec Util.dbo.sp_Util_FindMissingClusteredIndex -- 45

Then determine which method to fix the issue is correct
1. Create a clusteredindex/ cluster an existing index 
2. Put an exclusion in the table Util.dbo.[tblExclude_MissingClusteredIndex] 
   - This can be done at the database or table level 

/* rows */

SELECT COUNT(*) FROM tblDropship

	Ron Desimone·12:33 PM
I usually just go through the UI and change that index from non clustered to clustered.
In this case the script it created was the following:

BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCanadianProvince
DROP CONSTRAINT PK_tblCanadianProvince
GO
ALTER TABLE dbo.tblCanadianProvince ADD CONSTRAINT
PK_tblCanadianProvince PRIMARY KEY CLUSTERED 
(
ixProvince
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT


/****** Object:  Index [PK_tblCanadianProvince]    Script Date: 08/01/2016 12:37:43 ******/
ALTER TABLE [dbo].[tblCanadianProvince] ADD  CONSTRAINT [PK_tblCanadianProvince] PRIMARY KEY NONCLUSTERED 
(
	[ixProvince] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


SELECT COUNT(*) FROM tblCounterOrderScans


select distinct ixCustomer, OrderRank  from tblCustomerTwoMostRecentOrders_Rollup -- 1,164,066