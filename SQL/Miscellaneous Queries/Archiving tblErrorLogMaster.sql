-- Archiving tblErrorLogMaster

SELECT min(ELM.ixDate) 'ixDateStart', min(CONVERT(VARCHAR, D.dtDate, 102))  'Oldest'
    ,COUNT(*) 'RecCount', CONVERT(VARCHAR, GETDATE(), 102)  AS 'As of'
from [SMI Reporting].dbo.tblErrorLogMaster ELM
join [SMI Reporting].dbo.tblDate D on ELM.ixDate = D.ixDate
group by D.dtDate
/*
ixDate
Start	Oldest	    RecCount	As of
17168	2015.01.01	2,963,125	2017.03.29
*/

SELECT min(ixDate) 'Oldest', max(ixDate) 'Newest', 
COUNT(*) 'RecCount', CONVERT(VARCHAR, GETDATE(), 102)  AS 'As of'
from [SMIArchive].dbo.tblErrorLogMasterArchive 
/*
Oldest	Newest	RecCount	As of
16590	17167	1,282,675	2017.03.29
*/

select ixDate,  CONVERT(VARCHAR, dtDate, 102) 'Date' 
from [SMI Reporting].dbo.tblDate 
where ixDate in (16438, 16803, 17168, 17533)
/*
ixDate	Date
16438	2013.01.01
16803	2014.01.01
17168	2015.01.01
17533	2016.01.01
*/


select COUNT(*) from tblErrorLogMaster --4,245,726



/**************     any missing error IDs?  (they are sequential)       **************/
    select (select isnull(max(ixErrorID)+1,1) 
          from [SMI Reporting].dbo.tblErrorLogMaster 
          where ixErrorID < md.ixErrorID
          ) 'From',
          md.ixErrorID - 1 'To'
    from [SMI Reporting].dbo.tblErrorLogMaster md
    where md.ixErrorID != 1 
      and not exists (select 1 
                      from [SMI Reporting].dbo.tblErrorLogMaster md2 
                      where md2.ixErrorID = md.ixErrorID - 1)           
    /*
    from	to
    1	    3004305
    3296793	3296793   -- 2016-04-18
    */      

    SELECT MIN(ixErrorID) 'FirstErrorID', MAX(ixErrorID) 'LastErrorID'
    FROM [SMI Reporting].dbo.tblErrorLogMaster 
    /*
    First   Last
    ErrorID	ErrorID
    3004306	5967456
    */

    SELECT * from [SMI Reporting].dbo.tblErrorLogMaster 
    WHERE  ixErrorID = 3296794

/************************************************************************************/

-- add records to Archive table
insert into [SMIArchive].dbo.tblErrorLogMasterArchive  -- 442,571 + 840,104
select *
FROM [SMI Reporting].dbo.tblErrorLogMaster
WHERE ixDate < 17168 -- 1/1/15 


-- DELETE ONLY FROM LNK-DWSTAGING1 and only in small batches of 10k or less
set rowcount 10000 --  --10000

select count(*)
-- DELETE 
FROM [SMI Reporting].dbo.tblErrorLogMaster
WHERE ixDate < 17168 -- 1/1/15 

select count(*)
-- delete 
from [SMIArchive].dbo.tblErrorLogMasterArchive
where ixDate between 16803 and 17167