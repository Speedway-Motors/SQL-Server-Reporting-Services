-- SMIHD-9953 add and populate new user fields to tblSKU

SELECT count(*) 
FROM tblSKU -- 10,374 as of 2-14-18
WHERE flgDeletedFromSOP = 0
	--and ixCreateDate >= 18264--	01/01/2018    6,014
	and flgActive = 1
	and (ixProposer is NOT NULL
	OR ixAnalyst is NOT NULL
	OR ixMerchant is NOT NULL
	OR ixBuyer is NOT NULL
	)


	-- ixCreator
SELECT S.ixCreator 'Creator', 
	(E.sFirstname + ' ' + E.sLastname) 'Name',  count(S.ixSKU) 'SKUs'
FROM tblSKU S
	left join tblEmployee E on E.ixEmployee = S.ixCreator
WHERE S.flgDeletedFromSOP = 0
    and S.flgActive = 1
	and S.ixCreator is NOT NULL
	and ixCreateDate >= 18264--	01/01/2018     --17168	--	01/01/2015    6,014
group by ixCreator, E.sFirstname, E.sLastname
order by  count(S.ixSKU) desc






SELECT ixCreator, count(*) 'SKUcnt'
from tblSKU
where flgActive = 1
and ixCreateDate >= 18264
group by ixCreator
order by count(*) desc


	SELECT *
FROM tblSKU -- 10,374 as of 2-14-18
WHERE flgDeletedFromSOP = 0
	and ixCreateDate >= 18264--	01/01/2018
	and (ixProposer is NOT NULL
	OR ixAnalyst is NOT NULL
	OR ixMerchant is NOT NULL
	OR ixBuyer is NOT NULL
	)

-- Proposer
SELECT S.ixProposer 'Proposer', 
	(E.sFirstname + ' ' + E.sLastname) 'Name',  count(S.ixSKU) 'SKUs'
FROM tblSKU S
	left join tblEmployee E on E.ixEmployee = S.ixProposer
WHERE S.flgDeletedFromSOP = 0
	and ixProposer is NOT NULL
group by ixProposer, E.sFirstname, E.sLastname
order by  count(S.ixSKU) desc

-- Analyst
SELECT S.ixAnalyst 'Analyst', 
	(E.sFirstname + ' ' + E.sLastname) 'Name',  count(S.ixSKU) 'SKUs'
FROM tblSKU S
	left join tblEmployee E on E.ixEmployee = S.ixAnalyst
WHERE S.flgDeletedFromSOP = 0
	and ixAnalyst is NOT NULL
group by ixAnalyst, E.sFirstname, E.sLastname
order by  count(S.ixSKU) desc

-- Merchant
SELECT S.ixMerchant 'Merchant', 
	(E.sFirstname + ' ' + E.sLastname) 'Name',  count(S.ixSKU) 'SKUs'
FROM tblSKU S
	left join tblEmployee E on E.ixEmployee = S.ixMerchant
WHERE S.flgDeletedFromSOP = 0
	and ixMerchant is NOT NULL
group by ixMerchant, E.sFirstname, E.sLastname
order by  count(S.ixSKU) desc

-- Buyer
SELECT S.ixBuyer 'Buyer', 
	(E.sFirstname + ' ' + E.sLastname) 'Name',  count(S.ixSKU) 'SKUs'
FROM tblSKU S
	left join tblEmployee E on E.ixEmployee = S.ixBuyer
WHERE S.flgDeletedFromSOP = 0
	and ixBuyer is NOT NULL
group by ixBuyer, E.sFirstname, E.sLastname
order by  count(S.ixSKU) desc
/*
Pat Crews: Are there no SKUs with the Buyer field populated yet?
Connie While: Correct. It will only be populated as an override of the vendor buyer, so there should never be too many.
*/




SELECT * FROM [SMITemp].dbo.PJC_SMIHD10031_SKUsUserFields 
where ixSKU NOT IN(
						SELECT ixSKU FROM tblSKU
						where ixProposer is NOT NULL
						OR ixAnalyst is NOT NULL
						OR ixMerchant is NOT NULL
						OR ixBuyer is NOT NULL
						)

/*
91602011
91602012
91602013
91602014
9162002
9162003
9162005
9162007
9162008
9162014

All have proposer=SJA, analyst=SJA, merchant=BJB and buyer=null.

*/
SELECT ixSKU, ixProposer, ixAnalyst, ixMerchant, ixBuyer, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblSKU
WHERE ixSKU in ('91602011','91602012','91602013','91602014','9162002','9162003','9162005','9162007','9162008','9162014')
order by ixSKU
/*  BEFORE
ixSKU		ixProposer	ixAnalyst	ixMerchant	ixBuyer	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
91602011	NULL	NULL	NULL	NULL	2018-02-11 00:00:00.000	26229
91602012	NULL	NULL	NULL	NULL	2018-02-11 00:00:00.000	26342
91602013	NULL	NULL	NULL	NULL	2018-02-11 00:00:00.000	26443
91602014	NULL	NULL	NULL	NULL	2018-02-11 00:00:00.000	26542
9162002	NULL	NULL	NULL	NULL	2018-02-12 00:00:00.000	25344
9162003	NULL	NULL	NULL	NULL	2018-02-11 00:00:00.000	25902
9162005	NULL	NULL	NULL	NULL	2018-02-11 00:00:00.000	26073
9162007	NULL	NULL	NULL	NULL	2018-02-11 00:00:00.000	26307
9162008	NULL	NULL	NULL	NULL	2018-02-13 00:00:00.000	25744
9162014	NULL	NULL	NULL	NULL	2018-02-11 00:00:00.000	26906


   AFTER
ixSKU	ixProposer	ixAnalyst	ixMerchant	ixBuyer	dtDateLastSOPUpdate	ixTimeLastSOPUpdate

*/

select ixSKU, ixProposer, ixAnalyst, ixMerchant, ixBuyer, dtDateLastSOPUpdate, ixTimeLastSOPUpdate 
from tblSKU where dtDateLastSOPUpdate = '02/13/2018' AND ixTimeLastSOPUpdate > 42892

select chTime
from tblTime where ixTime in (14993,15170)


04:09:53  - 04:12:50  -- 84,000 SKU Tansactions updated between 04:09:53  - 04:12:50


select SUM(iAwsBatchSize) 'TotRecords', SUM (iTransferTimeInMS) 'TotTimeMS'
from tblAwsBatch b 
inner join tblAwsQueueTypeReference r on b.ixAwsQueueTypeReference = r.ixAwsQueueTypeReference
where b.dtAwsBatchDateTimeUtc between '02-13-2018 04:00:00.000' and '02-13-2018 05:00:00.000'
order by b.dtAwsBatchDateTimeUtc
	--b.iTransferTimeInMS desc

SELECT chTime from tblTime where ixTime = 33306

select r.sTableName, SUM (b.iAwsBatchSize) TotUpdates
from tblAwsBatch b 
inner join tblAwsQueueTypeReference r on b.ixAwsQueueTypeReference = r.ixAwsQueueTypeReference
where b.dtAwsBatchDateTimeUtc > '02-13-2018'
group by r.sTableName
order by SUM (b.iAwsBatchSize) desc


select SUM (b.iAwsBatchSize) TotUpdates -- 6.3m @13:35
from tblAwsBatch b 
inner join tblAwsQueueTypeReference r on b.ixAwsQueueTypeReference = r.ixAwsQueueTypeReference
where b.dtAwsBatchDateTimeUtc > '02-13-2018'
group by r.sTableName
order by SUM (b.iAwsBatchSize) desc


select r.sTableName, CAST(b.dtAwsBatchDateTimeUtc AS date) --,     b.* 
from tblAwsBatch b 
inner join tblAwsQueueTypeReference r on b.ixAwsQueueTypeReference = r.ixAwsQueueTypeReference
where b.dtAwsBatchDateTimeUtc > '02-13-2018'



-- CAST(b.dtAwsBatchDateTimeUtc AS date)

-- ALL updates BY DAY
select CAST(b.dtAwsBatchDateTimeUtc AS date), SUM (b.iAwsBatchSize) 'TotUpdates'
from tblAwsBatch b 
inner join tblAwsQueueTypeReference r on b.ixAwsQueueTypeReference = r.ixAwsQueueTypeReference
where b.dtAwsBatchDateTimeUtc > '02-14-2018'
group by CAST(b.dtAwsBatchDateTimeUtc AS date)
order by CAST(b.dtAwsBatchDateTimeUtc AS date)

-- TABLE updates BY DAY
select CAST(b.dtAwsBatchDateTimeUtc AS date), r.sTableName, SUM (b.iAwsBatchSize) 'TotUpdates'
from tblAwsBatch b 
inner join tblAwsQueueTypeReference r on b.ixAwsQueueTypeReference = r.ixAwsQueueTypeReference
where b.dtAwsBatchDateTimeUtc > '02-01-2018'
group by CAST(b.dtAwsBatchDateTimeUtc AS date), r.sTableName
order by r.sTableName, CAST(b.dtAwsBatchDateTimeUtc AS date)

SELECT * FROM tblOrder where ixOrder = '7944566'


SELECT * FROM tblSKU where ixSKU = 'UP89910'