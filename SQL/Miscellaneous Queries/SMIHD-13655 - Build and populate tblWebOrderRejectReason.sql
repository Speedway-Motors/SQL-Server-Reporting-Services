-- SMIHD-13655 - Build and populate tblWebOrderRejectReason 


/*

FIELD                   DATA TYPE       NULLable    NOTES
===========             ===========     ========    =================================================
ixWebOrderRejectReason  int             NO          IDENTITY(1,1)    since each order can have muliple reject reasons, this will be the PK  
sWebOrderID             varchar(15)     NO
ixOrder                 varchar(15)     NO          some of these will be in tblOrder, but not all
sRejectReason           varchar(MAX)    NO
dtOrderDate             datetime        Yes
ixOrderTime             int             Yes
dtDateLastSOPUpdate     datetime        Yes         NOT passed from SOP. SQL will assign when record is created/updated
ixTimeLastSOPUpdate     ixTime          Yes         NOT passed from SOP. SQL will assign when record is created/updated


- can be multiple reject reasons per order
- what can we use for a PK?
*/


USE [SMI Reporting]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblWebOrderRejectReason](
    [ixWebOrderRejectReason] [int] IDENTITY(1,1) NOT NULL,
    [sWebOrderID] [varchar](15) NOT NULL,
    [ixOrder] [varchar](15) NOT NULL,
    [iSequence] [int] NOT NULL,
    [sRejectReason] [varchar](MAX) NOT NULL,
    [dtOrderDate] [datetime] NULL,
    [ixOrderTime] [int] NULL,
    [dtDateLastSOPUpdate] [datetime] NULL,
    [ixTimeLastSOPUpdate] [int] NULL
 CONSTRAINT [PK_tblWebOrderRejectReason] PRIMARY KEY CLUSTERED 
(
    [ixWebOrderRejectReason] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

--  an index to sWebOrderID, ixOrder. Maybe your standard date fields

-- DROP TABLE tblWebOrderRejectReason
SELECT * FROM tblWebOrderRejectReason
/*
ixWebOrderRejectReason	sWebOrderID	ixOrder	iSequence	sRejectReason	dtOrderDate	ixOrderTime	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
1	CA11386408	8327552	1001	No Shipto customer Last Name	1951-04-19 00:00:00.000	11635	2019-04-18 00:00:00.000	35581
2	CA11386408	8327552	1000	No Billto customer Last Name	1951-04-19 00:00:00.000	11635	2019-04-18 00:00:00.000	35678
3	E2435255	8331553	1002	Shipping charge difference (web $22.41 / calc $16.17)	1951-04-19 00:00:00.000	11690	2019-04-18 00:00:00.000	35796
4	E2435292	8341557	1003	Shipping charge difference (web $7.30 / calc $12.64)	1951-04-19 00:00:00.000	57527	2019-04-18 00:00:00.000	35797
5	E2435300	8343552	1004	Shipping charge difference (web $31.30 / calc $20.97)	1951-04-19 00:00:00.000	57797	2019-04-18 00:00:00.000	35797
6	E2435302	8343553	1005	Shipping charge difference (web $84.78 / calc $43.50)	1951-04-19 00:00:00.000	57826	2019-04-18 00:00:00.000	35798
*/

SELECT count(*) 'TotalReasons',
count(distinct sWebOrderID) 'WebOrders'
FROM tblWebOrderRejectReason


SELECT * FROM tblWebOrderRejectReason
order by sRejectReason


SELECT * FROM tblWebOrderRejectReason
order by dtOrderDate desc, ixOrderTime desc

select * from tblTime where ixTime = 37835




spUpdateWebOrderRejectReason




-- SELECT count(*) from tblCatalogDetailWork
select * from tblErrorCode where ixErrorType = 'SQLDB' 

select * from tblErrorLogMaster where ixErrorCode = 1226
and ixErrorID > 9754441

select * from tblErrorLogMaster 
where --ixErrorCode = 1226
 ixErrorID > 9750000
 order by ixErrorID desc

 select * from tblTime where ixTime IN (1699, 36404) --= 32804 -- 09:06:44  


select * from tblErrorLogMaster where dtDate = '04/18/2019' and ixErrorCode NOT IN (1000,1040,1059,1203)



select --ELM.*
    distinct ELM.ixErrorCode
From tblErrorLogMaster ELM
    LEFT JOIN tblErrorCode EC ON ELM.ixErrorCode = EC.ixErrorCode
where ELM.dtDate >= '01/01/2019'
and EC. ixErrorType = 'SQLDB'
ORDER BY ixErrorCode


-- Samples of Error messages
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1141
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1142
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1143
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1145
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1146
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1147
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1149
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1155
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1160
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1163
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1174
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1174
UNION
    select TOP 1 ixErrorID, FORMAT(dtDate,'yyyy.MM.dd')'Date', ixErrorCode, sError
    From tblErrorLogMaster ELM
    where ELM.dtDate >= '01/01/2019' and ELM.ixErrorCode = 1226

1141
1142
1143
1145
1146

1147
1149
1155
1160
1163
1174
1184
1226

