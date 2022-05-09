-- TO ALTER COLLATION


-- 1) RENAME ORIGINAL TABLE and drop contraints

-- USE SCRIPT (sample below) to rebuild table with correct COLLATION

-- re-apply constraints

-- insert data into new table from orignal table

CREATE TABLE [dbo].[tblSKUTransaction] (
    [ixDate]              SMALLINT      NOT NULL,
    [ixTime]              INT           NOT NULL,
    [sUser]               VARCHAR (10)  COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
    [iSeq]                INT           NOT NULL,
    [sTransactionType]    VARCHAR (20)  COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
    [ixSKU]               VARCHAR (30)  COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
    [iQty]                INT           NULL,
    [mAverageCost]        MONEY         NULL,
    [sLocation]           VARCHAR (5)   COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
    [sToLocation]         VARCHAR (5)   COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
    [sWarehouse]          VARCHAR (15)  COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
    [sToWarehouse]        VARCHAR (15)  COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
    [sBin]                VARCHAR (20)  COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
    [sToBin]              VARCHAR (20)  COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
    [sCID]                VARCHAR (15)  COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
    [sToCID]              VARCHAR (15)  COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
    [sGID]                VARCHAR (15)  COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
    [sToGID]              VARCHAR (15)  COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
    [ixReceiver]          VARCHAR (10)  COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
    [ixJob]               VARCHAR (50)  NULL,
    [flgBinScanned]       TINYINT       NULL,
    [sTransactionInfo]    VARCHAR (100) NULL,
    [dtDateLastSOPUpdate] DATETIME      NULL,
    [ixTimeLastSOPUpdate] INT           NULL,
    CONSTRAINT [PK_tblSKUTransaction] PRIMARY KEY NONCLUSTERED ([ixDate] ASC, [ixTime] ASC, [iSeq] ASC)
);
GO

CREATE CLUSTERED INDEX [_dta_index_tblSKUTransaction_c_11_1694629080__K1_K4]
    ON [dbo].[tblSKUTransaction]([ixDate] ASC, [iSeq] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_tblSKUTransaction_ixDate_iSeq]
    ON [dbo].[tblSKUTransaction]([ixDate] ASC, [iSeq] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_tblSKUTransaction_ixSKU]
    ON [dbo].[tblSKUTransaction]([ixSKU] ASC)
    INCLUDE([ixDate], [sBin], [sToBin]);
GO


