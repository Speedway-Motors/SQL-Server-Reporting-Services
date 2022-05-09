-- SMIHD-19364 - Create and Populate tblOrderCancellationReasonCode

USE [SMI Reporting]
GO
-- DROP TABLE tblOrderCancellationReasonCode
/****** Object:  Table [dbo].[tblOrderCancellationReasonCode]    Script Date: 11/17/2020 2:10:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblOrderCancellationReasonCode](
	[ixCancellationReasonCode] [int] NOT NULL,
	[sCancellationReasonCode] [varchar](30) NULL,
	[sDefinition] [varchar](256) NULL,
	[dtLastManualUpdate] [datetime] NULL,
 CONSTRAINT [PK_tblOrderCancellationReasonCode] PRIMARY KEY CLUSTERED 
(
	[ixCancellationReasonCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- select * from tblOrderCancellationReasonCode

-- exec sp_tblOrderCancellationReasonCode_InitialFeed_tblAwsQueueStage 'tblOrderCancellationReasonCode'



