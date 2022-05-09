/************************************************************************
 *****  THIS SECTION TO BE RUN ON [LNK-DWSTAGING1].[SMI Archive]   ******
 *****                                                              ***** 
 *****       suggest, every quarter, archive the oldest quarter     ***** 
 ************************************************************************/
 
-- 1st of each month in the year to be archived
select ixDate, CONVERT(VARCHAR, dtDate, 10)  AS 'Date'
    --,substring(CONVERT(VARCHAR, dtDate, 10),4,2) 'ParsedDate'
 from [SMI Reporting].dbo.tblDate
where ixDate between 15707 and 16071 -- 2011 date range
    and substring(CONVERT(VARCHAR, dtDate, 10),4,2) = '01'
/*
ixDate	Date
15707	01-01-11
15738	02-01-11
15766	03-01-11
15797	04-01-11
15827	05-01-11
15858	06-01-11
15888	07-01-11
15919	08-01-11
15950	09-01-11
15980	10-01-11
16011	11-01-11
above months ARCHIVED

16041	12-01-11 <-- archive after 1/1/14
IF SLOW, REMOVE PK, INSERT DATA, REAPPLY PK
*/

-- make a back-up to be deleted once all dates are archived AND TESTED
select *
into tblSnapshotSKUArchive_BU12032013 -- 9,237,404
from tblSnapshotSKUArchive

-- archive
-- archiving 4 months takes abut the same amount of time to archiving 2 weeks
-- suggest inserting 1 month first then 3-4 month blocks
insert into tblSnapshotSKUArchive
select * 
from [SMI Reporting].dbo.tblSnapshotSKU 
where ixDate between 16041 and 16071    --  

/*
between ixDates   Rows      Mins    Rec/Min Month(s)
===============   ========  ====    ======= ========
15707 and 15737   1,959,266 11      49K     Jan
15738 and 15765   1,995,930 11      181K    Feb
15766 and 15796   2,172,042 11      197K    Mar
15797 and 15826   2,204,668 11      200K    Apr
15827 and 15887   4,632,222 11.5    403K    May-Jun
15888 and 16010   9,825,463 13      756K    Jul-Oct
16011 and 16040   2,540,479 12      212K    Nov
16041 and 16071   2,661,467 24      110K    Dec
*/

SELECT COUNT(*) from [SMI Reporting].dbo.tblSnapshotSKU 
where ixDate between 16041 and 16071    -- 2,661,467
                                                                                 
SELECT COUNT(*) from tblSnapshotSKUArchive 
where ixDate between 16041 and 16071    -- 2,661,467  

/**************************************************************
 DELETING archived data from tblSnapshotSKU
 **************************************************************/

select COUNT(*)
 from [SMI Reporting].dbo.tblSnapshotSKU where ixDate < 16041  

DELETE FROM [SMI Reporting].dbo.tblSnapshotSKU
WHERE ixDate < 16072  -- 08-01-11
/*
Rows    Mins
====    ===
 70K     8 
 .2M     5 
1.6M    15
7.1M    28
2.6M    18


-- checking for invalid dupes
select ixSKU,ixDate, count(*)
from tblSnapshotSKUArchive
group by ixSKU,ixDate
having count(*) > 1
order by ixSKU,ixDate



