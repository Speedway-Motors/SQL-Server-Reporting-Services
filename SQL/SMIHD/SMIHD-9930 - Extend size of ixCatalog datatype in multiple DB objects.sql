-- SMIHD-9930 - Extend size of ixCatalog datatype in multiple DB objects
/*
tblCatalogMaster
tblCatalogDetail

tblSourceCode -- updated
*/



BEGIN TRAN
	ALTER TABLE tblCatalogMaster
	ALTER COLUMN ixCatalog varchar(15) null
ROLLBACK TRAN


/*******	alter tblCatalogDetail	********/

		/****** Object:  Index [PK_tblCatalogDetail]    Script Date: 2/6/2018 11:45:05 AM ******/
		-- drop PK
		ALTER TABLE [dbo].[tblCatalogDetail] DROP CONSTRAINT [PK_tblCatalogDetail] WITH ( ONLINE = OFF )
		GO

		-- drop FK
		ALTER TABLE [dbo].[tblCatalogDetail] DROP CONSTRAINT [FK_ixCatalog_tblCatalogDetail]
		GO

		ALTER TABLE [dbo].[tblCatalogDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_ixCatalog_tblCatalogDetail] FOREIGN KEY([ixCatalog])
		REFERENCES [dbo].[tblCatalogMaster] ([ixCatalog])
		GO

		ALTER TABLE [dbo].[tblCatalogDetail] CHECK CONSTRAINT [FK_ixCatalog_tblCatalogDetail]
		GO

		-- ALTER COLUMN
			ALTER TABLE tblCatalogDetail
			ALTER COLUMN ixCatalog varchar(15) NOT NULL


		SET ANSI_PADDING ON
		GO


		/****** Object:  Index [PK_tblCatalogDetail]    Script Date: 2/6/2018 11:45:05 AM ******/
		ALTER TABLE [dbo].[tblCatalogDetail] ADD  CONSTRAINT [PK_tblCatalogDetail] PRIMARY KEY CLUSTERED 
		(
			[ixCatalog] ASC,
			[ixSKU] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		GO




/*******	alter tblCatalogMaster		********/
-- 			ixCatalog is part of PK

	USE [SMI Reporting]
	GO

BEGIN TRAN
	-- DROP PK
	/****** Object:  Index [PK__tblCatalogMaster__70DDC3D8]    Script Date: 2/6/2018 11:21:53 AM ******/
		ALTER TABLE [dbo].[tblCatalogMaster] DROP CONSTRAINT [PK__tblCatalogMaster__70DDC3D8] WITH ( ONLINE = OFF )
		GO

		SET ANSI_PADDING ON
		GO

	-- ALTER COLUMN
		-- BEGIN TRAN
			ALTER TABLE tblCatalogMaster
			ALTER COLUMN ixCatalog varchar(15) NOT NULL
		-- ROLLBACK TRAN

	-- CREATE PK
		/****** Object:  Index [PK__tblCatalogMaster__70DDC3D8]    Script Date: 2/6/2018 11:21:53 AM ******/
		ALTER TABLE [dbo].[tblCatalogMaster] ADD PRIMARY KEY CLUSTERED 
		(
			[ixCatalog] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		GO
ROLLBACK TRAN








-- alter tblSourceCode			ixCatalog is part of PK
-- ixCatalog is part of PK
BEGIN TRAN

	ALTER TABLE tblCatalogDetail
	ALTER COLUMN ixCatalog varchar(15) null

ROLLBACK TRAN