-- [SMI Reporting] DW1 Dropped Indexes

/****************************************************************
    the CREATE SCRIPTS to rebuild any indexes that were dropped
    grouped by date dropped, most recent first.
******************************************************************/

/****   Dropped 8-3-14   ****/
ALTER TABLE [dbo].[tblSnapshotSKU] ADD  CONSTRAINT [PK_tblSnapshotSKU] PRIMARY KEY NONCLUSTERED 
(	[ixSKU] ASC,	[ixDate] ASC )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

