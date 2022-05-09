-- tblSKUTransaction Archive and Clean-up

-- ARCHIVE table (NOT replicated)
    select MIN(STA.ixDate) 'Date','-' AS ' ' ,MAX(STA.ixDate) 'Range',  
        count(*) 'Rows     ', CONVERT(VARCHAR, GETDATE(), 101) AS 'as of'
    from [SMIArchive].dbo.tblSKUTransactionArchive STA
    /*
    ixDates	        Date Ranges      Rows   	as of
    15185-16802 07/28/10-12/31/13    61,686,070 03/29/2016
    */

-- PRODUCTION table 
    select MIN(ST.ixDate) 'Date','-' AS ' ' ,MAX(ST.ixDate) 'Range',  
        count(*) 'Rows     ', CONVERT(VARCHAR, GETDATE(), 101) AS 'as of'
    from [SMI Reporting].dbo.tblSKUTransaction ST
    /*
    ixDates	        Date Ranges         Rows   	    as of
    16501-17616     03/05/13-03/24/16   39,253,809  03/24/2016
    16579-17621	    05/22/13-03/29/16   36,019,304	03/29/2016
    */

select ixDate, CONVERT(VARCHAR(10), dtDate, 101) 'dtDate'
from tblDate 
where ixDate in (15185,15342,
                 16500,16501,16579,16600,16802,16803,
                 17168,17621)
order by ixDate 
/*
ixDate	dtDate
15185	07/28/2009
15342	01/01/2010
16500	03/04/2013
16501	03/05/2013
16579	05/22/2013 <-- Archived up to this date

16600	06/12/2013
16802	12/31/2013
16803	01/01/2014
17168	01/01/2015
17621	03/29/2016
*/

-- copy data into ARCHIVE table
BEGIN TRAN 

    insert into [SMIArchive].dbo.tblSKUTransactionArchive
    SELECT * FROM [SMI Reporting].dbo.tblSKUTransaction 
    WHERE ixDate between 16700 and 16802 -- 16802

-- COMMIT TRAN
ROLLBACK TRAN

                                                              
                                                                                 
select count(*) from [SMI Reporting].dbo.tblSKUTransaction  WHERE ixDate between 16571 and 16600        -- 2701865
select count(*) from [SMIArchive].dbo.tblSKUTransactionArchive  WHERE ixDate between 16571 and 16600    -- 2701865   

-- ONLY DELETE DATA FROM DW-STAGING1 
-- or Replication will BREAK!!!!!!
-- ARCHIVE THRU 16803 12/31/2013
BEGIN TRAN 
-- SET ROWCOUNT 50000 -- 50k MAX or replication will lag
    DELETE FROM [SMI Reporting].dbo.tblSKUTransaction WHERE ixDate <= 16600 
    SELECT CONVERT(VARCHAR, GETDATE(), 8)    AS 'Date'
-- COMMIT TRAN
ROLLBACK TRAN

-- select count(*) from [SMI Reporting].dbo.tblSKUTransaction  WHERE ixDate <= 16600 -- 1,045K


select ixShippedDate, ixOrderDate, ixShipeedDate-ixOrderDate as DaysToShip
from tblOrder
where dtOrderDate > = '03/22/2015'





select * -- 19.6m
into PJC_ST_keep
from tblSKUTransaction -- 5.8m -- 1.3m
where sTransactionType in ('R','T')
    -- these lists will need to be added to if new bins are added to the "Parts Not Returned" reports
  OR (sBin in ('5A00A1','CLAIM','COUNTER','CUST-RTN','GOOD-WILL','IT','LOST','LOSTNC','NO-PART','RCV','RETURN','REVIEW','SHOWRM','X00A1','Y00A1','Z00A1') -- 5.8m 5.835337
        OR sBin like 'IO%')      
  OR (sToBin in ('5A00A1','CLAIM','COUNTER','CUST-RTN','GOOD-WILL','IT','LOST','LOSTNC','NO-PART','RCV','RETURN','REVIEW','SHOWRM','X00A1','Y00A1','Z00A1') -- 5.8m 5.835337
        OR sToBin like 'IO%')    


select * from PJC_ST_keep                             --1334367
select distinct iSeq, ixDate, ixTime from PJC_ST_keep --1334367
-- drop table PJC_ST_keep



--truncate table tblSKUTransaction
insert into tblSKUTransaction
select *
from PJC_ST_keep

select count(*) from tblSKUTransaction

SELECT COUNT(*)
FROM tblSKUTransaction
   where (sTransactionType NOT in ('R','T') OR sTransactionType is NULL)
     AND sBin NOT in ('5A00A1','CLAIM','COUNTER','CUST-RTN','GOOD-WILL','IT','LOST','LOSTNC','NO-PART','RCV','RETURN','REVIEW','SHOWRM','X00A1','Y00A1','Z00A1') -- 5.8m 5.835337
     AND sBin NOT like 'IO%'
     AND sToBin NOT in ('5A00A1','CLAIM','COUNTER','CUST-RTN','GOOD-WILL','IT','LOST','LOSTNC','NO-PART','RCV','RETURN','REVIEW','SHOWRM','X00A1','Y00A1','Z00A1') -- 5.8m 5.835337
         AND sToBin NOT like 'IO%'


select count(*) -- 19.6m
from tblSKUTransaction -- 5.8m -- 1.3m
where sTransactionType in ('R','T')
    -- these lists will need to be added to if new bins are added to the "Parts Not Returned" reports
  OR (sBin in ('5A00A1','CLAIM','COUNTER','CUST-RTN','GOOD-WILL','IT','LOST','LOSTNC','NO-PART','RCV','RETURN','REVIEW','SHOWRM','X00A1','Y00A1','Z00A1') -- 5.8m 5.835337
        OR sBin like 'IO%')      
  OR (sToBin in ('5A00A1','CLAIM','COUNTER','CUST-RTN','GOOD-WILL','IT','LOST','LOSTNC','NO-PART','RCV','RETURN','REVIEW','SHOWRM','X00A1','Y00A1','Z00A1') -- 5.8m 5.835337
        OR sToBin like 'IO%')    


select ixDate, ixTime, iSeq, count(*)
from tblSKUTransaction
group by ixDate, ixTime, iSeq
having count(*) > 1


select count(*) from tblOrderLine                     -- 5709110
select distinct ixOrder, iOrdinality from tblOrderLine-- 5709087 

select ixOrder, iOrdinality, count(*)
from tblOrderLine
group by ixOrder, iOrdinality
having count(*) > 1

select * from tblOrderLine where ixOrder = '3241684-1'