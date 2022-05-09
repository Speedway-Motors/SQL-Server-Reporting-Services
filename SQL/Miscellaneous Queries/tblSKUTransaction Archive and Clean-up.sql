-- tblSKUTransaction Archive and Clean-up

-- SELECT @@SPID as 'Current SPID' -- 128      

-- DATES
    SELECT ixDate, CONVERT(VARCHAR(10), dtDate, 101) 'dtDate'
    FROM tblDate 
    WHERE ixDate in (17899, 18264, 18628, 18748, 18993, 18994)
    order by ixDate 
    /*
    ixDate	dtDate
    ======  ==========
    17899	01/01/2017
    18264	01/01/2018
    18628	12/31/2018  
    18748	04/30/2019 <-- Archived up to and including this date
    18993   12/31/2019
    18994	01/01/2020
    */   

-- ARCHIVE table 
-- (NOT replicated as of Jan 2021)
    SELECT MIN(STA.ixDate) 'Date','-' AS '     ' ,MAX(STA.ixDate) 'Range',  
        FORMAT(count(*),'##,##0') AS 'Rows     ', '#.##GB' AS 'Storage', CONVERT(VARCHAR, GETDATE(), 101) AS 'as of'
    FROM [SMIArchive].dbo.tblSKUTransactionArchive STA
    /*
    ixDates	        Date Ranges         Rows   	    Storage as of   
    ===========     ================   ==========   ======= ==========
    17899-18748	    01/01/17-04/30/19  43,994,322	5.12GB	05/18/2021
    17899-18628	    01/01/17-12/31/18  37,232,948	4.34GB	05/18/2021
    17168-18629	    01/01/15-01/01/19  67,982,387	6.23GB  01/15/2021  
    17168-18323	    01/01/15-03/01/18  53,100,407	?       08/13/2020


    SELECT iYear, FORMAT(COUNT(distinct STA.ixDate),'###,###') 'Days'
    from [SMIArchive].dbo.tblSKUTransactionArchive STA
    LEFT join tblDate D on STA.ixDate = D.ixDate
    GROUP BY iYear
    ORDER BY iYear desc

    iYear	Days
    =====   ====
    2018	365
    2017	365

*/



-- tblSKUTransaction    LIVE table   
-- NOW REPLICATES TO AWS!!!!  AS OF 6-10-2019
--  need to batch update/delete
    SELECT MIN(ST.ixDate) 'Date','-' AS ' ' ,MAX(ST.ixDate) 'Range',  
        FORMAT(count(*),'##,##0') AS 'Rows     ', CONVERT(VARCHAR, GETDATE(), 101) AS 'as of'
    FROM tblSKUTransaction ST
    /*
    ixDates	        Date Ranges         Rows   	    as of
    ===========     ================   ==========   ==========
    18629-19497	    01/01/19-05/18/21  52,337,611	05/18/2021
    18629-19377	    01/01/19-01/15/21  42,234,007	01/18/2021
    18324-19374	    03/01/18-01/15/21  56,872,966	01/15/2021
    18203-19073	    11/1/17-03/20/20   42,259,603	03/20/2020
    18203-18959	    11/1/17-11/27/19   36,222,306	11/27/2019
    17899-18636     1/1/17-01/08/19    33,434,278	01/08/2019

    
    AFCO
    ixDates	        Date Ranges         Rows   	    as of
    ===========     =================   ==========  ==========
    17899-19377	    01/01/17-01/18/21   17,846,328  01/18/2021
    17533-18670	    01/01/16-02/11/19   13,135,599	02/11/2019


    SELECT iYear, FORMAT(COUNT(distinct STA.ixDate),'###,###') 'Days'
    from [SMIArchive].dbo.tblSKUTransactionArchive STA
        LEFT join tblDate D on STA.ixDate = D.ixDate
    GROUP BY iYear
    ORDER BY iYear desc

    SELECT iYear, FORMAT(COUNT(distinct STA.ixDate),'###,###') 'Days'
    from tblSKUTransaction STA
        LEFT join tblDate D on STA.ixDate = D.ixDate
    GROUP BY iYear
    ORDER BY iYear desc

    */

select count(1) from tblSKUTransaction
where ixDate = 19377

SELECT FORMAT(COUNT(1),'##,##0') AS 'Rows     ' FROM tblSKUTransaction 
WHERE ixDate  <= 18748 --	04/30/2019  -- 6,761,374

SELECT FORMAT(COUNT(1),'##,##0') AS 'Rows     ' FROM [SMIArchive].dbo.tblSKUTransactionArchive
WHERE ixDate <= 18748 --	04/30/2019  -- 37,232,948


SELECT @@trancount as 'Open Transactions'

-- copy to Archive table
 -- BEGIN TRAN
     insert into [SMIArchive].dbo.tblSKUTransactionArchive    -- 6,761,374 v
     SELECT * FROM tblSKUTransaction  
     WHERE ixDate <= 18748 --	04/30/2019
 ROLLBACK TRAN

 SET ROWCOUNT 0

 -- TEST to see how long DELETE TAKES
BEGIN TRAN 
   -- SELECT FORMAT(COUNT(1),'###,###') -- 9.9m     5.4m left
    DELETE top (650000)    -- 1400k DELETED OUT OF 1.8m   -- .4-1.3min/batch
    FROM tblSKUTransaction  
    WHERE ixDate <= 18748 --	04/30/2019        Archive up to 18629 -- 01/01/2019
ROLLBACK TRAN

 -- DELETE from tblSKUTransaction
     WHILE EXISTS(SELECT top 1 1 -- takes about 5 mins/month
                  FROM tblSKUTransaction 
                  WHERE ixDate <= 18110 -- 07/31/2017
                  )
    DELETE top (10000)    -- 10,000 seems to be optimal batch size
    FROM tblSKUTransaction  
    WHERE ixDate <= xxx --11/01/2019
    WAITFOR DELAY '00:01:00'; -- 9:38 TO DELETE 3.1m rows

-- CHECK to see how long it takes dw2 to catch up
    SELECT FORMAT(COUNT(*),'##,##0') AS 'Rows     ' , 'SQL-LIVE-1' AS 'Server'
    FROM tblSKUTransaction -- 0
    WHERE ixDate <= 18323 --	04/01/2017
    GO
    SELECT FORMAT(COUNT(*),'##,##0') AS 'Rows     ', 'AWS' AS 'Server'
    FROM [DW.SPEEDWAY2.COM].SmiReportingRawData.Transfer.tblSKUTransaction -- 0
    WHERE ixDate <= 18323--	04/01/2017

-- 281,390	AWS @1:38



SELECT COUNT(*)
    FROM [SMIArchive].dbo.tblSKUTransactionArchive 
    WHERE ixDate >= 18203



