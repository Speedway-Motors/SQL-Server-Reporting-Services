-- SMIHD-9659 - manually populate part of tblTNTbyCarrierZoneZip from  tblTrailerZipTNT

if you select all the rows from tblTrailerZipTNT where ixTrailer=KC

SELECT TOP 10 * FROM tblTrailerZipTNT where ixTrailer='KC'

SELECT (FORMAT (ixZipCode, '00000')) as ixDestination, -- reformat from INT to Varchar(5),
	'UPS' as sCarrier,
	'Twilight' as sSort,	
	 0 as iZone,  -- 0 is temp placeholder... will use  zone data from the UPS Lincoln Twilight Excel file once Zip Code formatting is fixed
	 iTNT,   
	'Lenexa' as sHub
FROM tblTrailerZipTNT
WHERE ixTrailer = 'KC'


SELECT DISTINCT ixZipCode , (FORMAT (ixZipCode, '00000'))
FROM tblTrailerZipTNT
ORDER BY FORMAT (ixZipCode, '00000')



-- CREATE TABLE IN SMITemp
GO

/****** Object:  Table [dbo].[tblTNTbyCarrierZoneZip]    Script Date: 1/11/2018 2:08:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- DROP TABLE  [dbo].[tblTNTbyCarrierZoneZip]
CREATE TABLE [dbo].[tblTNTbyCarrierZoneZip](
    [ixTNTbyCarrierZoneZip] int not null identity,  -- This value will always increment on its own
       [ixDestinationZip] [varchar] (5) NOT NULL,
       [sCarrier] [varchar](20) NOT NULL,
       [sSort] [varchar](40) NOT NULL,
       [iZone] tinyint NOT NULL,
       [iTNT] tinyint NOT NULL,
       [sHub] [varchar](30) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE CLUSTERED INDEX [UIX_tblTNTbyCarrierZoneZip_ixDestinationZip_sCarrier_sSort_sHub] ON [dbo].[tblTNTbyCarrierZoneZip]
(
       [ixDestinationZip] ASC,
       [sCarrier] ASC,
       [sSort] ASC,
	   [sHub] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO

ALTER TABLE dbo.tblTNTbyCarrierZoneZip ADD CONSTRAINT
       PK_tblTNTbyCarrierZoneZip PRIMARY KEY NONCLUSTERED 
       (
       ixTNTbyCarrierZoneZip
       ) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

-- Run this to truncate table and set counter back to 1
/* truncate table tblTNTbyCarrierZoneZip
dbcc checkident (tblTNTbyCarrierZoneZip, reseed,1)
*/


/***** INSERT DATA FROM tblTrailerZipTNT 
		for UPS Lenexa Twilight &  
*******/

SELECT * FROM [SMITemp].dbo.tblTNTbyCarrierZoneZip



SELECT sCarrier, sHub, sSort, count(*) RecCount
FROM [SMITemp].dbo.tblTNTbyCarrierZoneZip
WHERE iZone = 0
group by sCarrier, sHub, sSort

	SELECT sCarrier, count(*)
	FROM [SMITemp].dbo.tblTNTbyCarrierZoneZip
	GROUP BY  sCarrier
	/*
	UPS		191557
	OnTrac	11684
	*/

	SELECT sHub, count(*)
	FROM [SMITemp].dbo.tblTNTbyCarrierZoneZip
	GROUP BY  sHub
	ORDER BY sHub
	/*
	Commerce - CA	3894
	Commerce City	7017
	Lenexa	19996
	Lincoln	41130
	Phoenix	45033
	Seattle	41138
	Sparks	41138
	Vegas	3895
	*/

	SELECT sSort, count(*)
	FROM [SMITemp].dbo.tblTNTbyCarrierZoneZip
	GROUP BY  sSort
	/*
	Midnight	7017
	Twilight	196224
	*/

	SELECT iZone, count(*)
	FROM [SMITemp].dbo.tblTNTbyCarrierZoneZip
	GROUP BY  iZone
	ORDER BY iZone
	/*
	0	1001
	2	6064
	3	9263
	4	28413
	5	28961
	6	35539
	7	28428
	8	63096
	44	560
	45	704
	46	1212
	*/

	SELECT iTNT, count(*)
	FROM [SMITemp].dbo.tblTNTbyCarrierZoneZip
	GROUP BY  iTNT
	ORDER BY iTNT
	/*
	1	14405
	2	34468
	3	47786
	4	50087
	5	50585
	6	5518
	7	392
	*/

INSERT INTO [SMITemp].dbo.tblTNTbyCarrierZoneZip -- 19,996
SELECT (FORMAT (ixZipCode, '00000')) as ixDestination, -- reformat from INT to Varchar(5),
	'UPS' as sCarrier,
	'Twilight' as sSort,	
	 0 as iZone,  -- 0 is temp placeholder... will use  zone data from the UPS Lincoln Twilight Excel file once Zip Code formatting is fixed
	 iTNT,   
	'Lenexa' as sHub
FROM tblTrailerZipTNT
WHERE ixTrailer = 'KC'

BEGIN TRAN
	UPDATE A
	SET iZone = B.iZone
	FROM  [SMITemp].dbo.tblTNTbyCarrierZoneZip A
		JOIN  [SMITemp].dbo.tblTNTbyCarrierZoneZip B on A.sCarrier = B.sCarrier
												and A.ixDestinationZip = B.ixDestinationZip
												and B.sHub = 'Lincoln' -- 'Sparks'
	WHERE A.sHub = 'Lenexa'
		and A.iZone = 0
ROLLBACK TRAN

SELECT * FROM tblTNTbyCarrierZoneZip WHERE iZone = 0 AND sHub = 'Lenexa' -- 735
											



INSERT INTO [SMITemp].dbo.tblTNTbyCarrierZoneZip -- 7,017
SELECT (FORMAT (ixZipCode, '00000')) as ixDestination, -- reformat from INT to Varchar(5),
	'UPS' as sCarrier,
	'Midnight' as sSort,	
	 0 as iZone,  -- 0 is temp placeholder... will use  zone data from the UPS Lincoln Twilight Excel file once Zip Code formatting is fixed
	 iTNT,   
	'Commerce City' as sHub
FROM tblTrailerZipTNT
WHERE ixTrailer = 'DEN'

BEGIN TRAN
	UPDATE A
	SET iZone = B.iZone
	FROM  [SMITemp].dbo.tblTNTbyCarrierZoneZip A
		JOIN  [SMITemp].dbo.tblTNTbyCarrierZoneZip B on A.sCarrier = B.sCarrier
												and A.ixDestinationZip = B.ixDestinationZip
												and A.sSort = 'Midnight'
												and B.sHub = 'Lincoln'
		and A.sCarrier = 'UPS'
		and A.iZone = 0
ROLLBACK TRAN

BEGIN TRAN
	UPDATE [SMITemp].dbo.tblTNTbyCarrierZoneZip
	SET sHub = 'Commerce City'
	WHERE sHub = 'Commerce - CA'
ROLLBACK TRAN

SELECT *
INTO [SMITemp].dbo.tblTNTbyCarrierZoneZip_BU
from [SMITemp].dbo.tblTNTbyCarrierZoneZip



SELECT * FROM tblTNTbyCarrierZoneZip WHERE iZone = 0


SELECT ixDestinationZip, COUNT(DISTINCT(iZone))
FROM tblTNTbyCarrierZoneZip
WHERE iZone <> 0
GROUP BY ixDestinationZip
order by COUNT(DISTINCT(iZone)) desc


DELETE FROM tblTNTbyCarrierZoneZip -- 7,017
where sSort = 'Midnight'
and sCarrier = 'UPS'

DELETE FROM tblTNTbyCarrierZoneZip -- 19,996
where sSort = 'Twilight'
and sCarrier = 'UPS'
and sHub = 'Lenexa'