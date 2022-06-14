-- SMIHD-25239 - Update FedEx AZ TNT data

-- import file data into work table
select top 10 * from [DWTemp].[dbo].PJC_SMIHD25239_FedEx_AZ_TNT

select count(*) from [DWTemp].[dbo].PJC_SMIHD25239_FedEx_AZ_TNT -- 40,429v

select top 10 * from [DWTemp].[dbo].PJC_SMIHD25239_FedEx_AZ_TNT
/*
OriginZip	sPostalCode	sZone	iTimeInTransit
85353		64158		6		3
85353		46706		7		4
85353		70452		6		3
*/

SELECT DISTINCT OriginZip
from [DWTemp].[dbo].PJC_SMIHD25239_FedEx_AZ_TNT
-- all 85353

SELECT sZone, count(*) 
from [DWTemp].[dbo].PJC_SMIHD25239_FedEx_AZ_TNT 
group by sZone -- 2 to 8

SELECT MIN(iTimeInTransit) MinTNT, MAX(iTimeInTransit) MaxTNT 
from [DWTemp].[dbo].PJC_SMIHD25239_FedEx_AZ_TNT -- 1 to 5




-- when last updated?
select TOP 10 *
from [dbo].[tblZipTrailerTnt]
WHERE dtUploadDateTime > '01/01/2022'
ORDER BY dtUploadDatetime -- newid()


-- back up original data
SELECT *  -- 3,225,364
INTO [DWTemp].[dbo].BU_tblZipTrailerTnt_20220609 -- DROP TABLE [DWTemp].[dbo].BU_tblZipTrailerTnt_20220609
FROM [dbo].[tblZipTrailerTnt]


select sZone, COUNT(*) 'RecCount'
FROM [dbo].[tblZipTrailerTnt]
GROUP BY sZone
ORDER BY sZone
/*
sZone	RecCount
NULL	133502
2	140810
3	280070
4	728152
44	891
45	3168
46	6480
5	925490
6	578419
7	197575
8	230807
*/

select distinct sTrailerName
from [dbo].[tblZipTrailerTnt]
WHERE sTrailerName like 'FedEx%'
ORDER BY sTrailerName -- newid()
/*
sTrailerName
FedEx Boonville, IN Twilight
FedEx Bossier City, LA Twilight
FedEx Columbus, OH Twilight
FedEx Des Moines, IA Twilight
Fedex Greensboro, NC Twilight
FedEx Greesboro, NC Midnight
FedEx Ground Hutchins, TX Twilight
Fedex Hagerstown, MD Twilight
FedEx Harrisburg, PA Midnight
FedEx Lincoln Fri
FedEx Lincoln, NE Twilight
FedEx New Stanton PA Twilight
FedEx Winchester, VA Twilight
*/




 -- ixZipTrailerTnt	sTrailerName	sPostalCode	sZone	iTimeInTransit	dtUploadDatetime

/* UPDATE PRODUCTION TABLE */
BEGIN TRAN

	INSERT INTO [dbo].[tblZipTrailerTnt]
	SELECT
		-- 'TBD' AS ixZipTrailerTnt,
		'FedEx AZ' as sTrailerName,
		sPostalCode,
		sZone,
		iTimeInTransit, 
		getdate() as 'dtUploadDatetime'
	FROM [DWTemp].[dbo].PJC_SMIHD25239_FedEx_AZ_TNT

ROLLBACK TRAN

-- verify data loaded as expected
select * from [dbo].[tblZipTrailerTnt] -- 40,429v
where sTrailerName = 'FedEx AZ'

SELECT sZone, count(*) 
from [dbo].[tblZipTrailerTnt]
where sTrailerName = 'FedEx AZ'
group by sZone -- 2 to 8v

SELECT MIN(iTimeInTransit) MinTNT, MAX(iTimeInTransit) MaxTNT 
from [dbo].[tblZipTrailerTnt] -- 1 to 5v
where sTrailerName = 'FedEx AZ'