-- tblSnapshotSKU Archive and Clean-up

SELECT @@SPID -- 70 = Current SPID

/**********************    DATES   **********************/
    select ixDate, FORMAT(dtDate,'yyyy.MM.dd') 'Date'
    from [SMI Reporting].dbo.tblDate 
    where ixDate in (17533,17899, 18110, 18264,18629,18748,18789, 18846)
    order by ixDate  desc
    /*
    ixDate	Date
    ======  ==========
    18846	2019.08.06
    18789	2019.06.10
    18748	2019.04.30
    18629	2019.01.01
    18264	2018.01.01
    18110	2017.07.31  <-- archived up to and including this date
    17899	2017.01.01
    17533	2016.01.01

    */
    select * from tblDate where dtDate = '04/30/2019'

    -- LIVE
    select MIN(ixDate),'-',MAX(ixDate), FORMAT(count(1),'###,###') 'Records', FORMAT(GETDATE(),'yyyy.MM.dd') 'as of' from [SMI Reporting].dbo.tblSnapshotSKU              
    /*                                  records     As Of

    18111-19497	 08/01/2017-05/18/2021  617,381,680	2021.05.18
    18111-18846	 08/01/2017-08/06/2019  303,896,646	2019.08.06
    17989-18789	 04/01/2017-06/10/2019  321,251,979	2019.06.10
    17930-18726	 02/01/2017-03/31/2019  313,389,616	2019.04.09
    17593-18650	 03/01/2016-01/22/2019 	386,670,014 2019.01.22
    17047-17858	 09/02/2014-11/21/2016  220,347,089	2016.11.21
    16954-17641	 06/01/2014-04/17/2016  169,863,244 2016.01.18
    */

    -- ARCHIVED  (query takes 15+ minutes!)
    select MIN(ixDate),'-',MAX(ixDate), FORMAT(count(*),'###,###') 'Records', FORMAT(GETDATE(),'yyyy.MM.dd') 'as of'  from [SMIArchive].dbo.tblSnapshotSKUArchive         
    /*                                  records     As Of
    15342-18110	 01/01/2010-07/31/2017  281,707,893	2021.05.18
    15342-18110	 01/01/2010-07/31/2017  281,585,001	2019.08.27
    15342-18110	 01/01/2010-07/31/2017  281,585,001	2019.06.11
    15342-17988	 01/01/2010-01/31/2017  238,732,881	2019.06.10
    15342-17898	 01/01/2010-12/31/2016  208,519,841	2019.02.04
    15342-17592	 01/01/2010-12/31/2014  182,654,838	2017.05.20
    */

                        
    -- DAYS ARCHIVED by Year
    SELECT D.iYear, count(distinct SS.ixDate) 'DayCount' -- runtime = 7:26
    FROM [SMIArchive].dbo.tblSnapshotSKUArchive SS
        join [SMI Reporting].dbo.tblDate D on SS.ixDate = D.ixDate
    GROUP BY D.iYear
    ORDER BY D.iYear desc
    /*      Day
    iYear	Count   As of 
    =====   =====   ==========
    2017	212     2019.08.27
    2016	1       <-- keep Jan 1 of each year when clearing older archive data
    2015	1          
    2014	1
    2013	1       
    2012	1
    2011	1
    2010	1
    */ 
   

/********    COPY DATA TO ARCHIVE TABLE IN 10 DAY BATCHES    ********/
    -- BEGIN TRAN
    SELECT FORMAT(getdate(),'hh:mm') 'Started'      -- archived up to and including 18748	2019.04.30 
    GO
        INSERT INTO [SMIArchive].dbo.tblSnapshotSKUArchive
        SELECT * FROM [SMI Reporting].dbo.tblSnapshotSKU
        WHERE ixDate between 18111 and 18120 -- @26:32    
    WAITFOR DELAY '00:00:10';
        INSERT INTO [SMIArchive].dbo.tblSnapshotSKUArchive
        SELECT * FROM [SMI Reporting].dbo.tblSnapshotSKU 
        WHERE ixDate between 18121 and 18130   -- @0:45   
    WAITFOR DELAY '00:00:10';
        INSERT INTO [SMIArchive].dbo.tblSnapshotSKUArchive
        SELECT * FROM [SMI Reporting].dbo.tblSnapshotSKU
        WHERE ixDate between 18131 and 18140    -- @1:19  
    WAITFOR DELAY '00:00:10';
        INSERT INTO [SMIArchive].dbo.tblSnapshotSKUArchive
        SELECT * FROM [SMI Reporting].dbo.tblSnapshotSKU
        WHERE ixDate between 18141 and 18150   -- @1:09
    WAITFOR DELAY '00:00:10';
        INSERT INTO [SMIArchive].dbo.tblSnapshotSKUArchive
        SELECT * FROM [SMI Reporting].dbo.tblSnapshotSKU
        WHERE ixDate between 18151 and 18160   -- @1:05       
    WAITFOR DELAY '00:00:10';                                
        INSERT INTO [SMIArchive].dbo.tblSnapshotSKUArchive
        SELECT * FROM [SMI Reporting].dbo.tblSnapshotSKU
        WHERE ixDate between 18161 and 18170 -- END WITH 17988
    GO
    SELECT FORMAT(getdate(),'hh:mm') 'Finished'
    -- ROLLBACK TRAN


-- VERIFY Archive table counts match live table for date range prior to deleting from production table

SELECT FORMAT(count(*),'###,###') 'Records' FROM [SMI Reporting].dbo.tblSnapshotSKU
WHERE ixDate between 17989 and 18049 -- 42,852,120         

SELECT FORMAT(count(*),'###,###') 'Records' FROM [SMIArchive].dbo.tblSnapshotSKUArchive
WHERE ixDate between  18080 and  18110 -- 11,298,553 v




/********   BATCH DELETE from tblSnapshotSKU    *********/
    -- run AFTER records have been inserted into Archive table    
    -- Notify RON before running so he can monitor AWS queue
    -- Run query below if you don't care about the order records are deleted in
    WHILE EXISTS(select top 1 1 
                from tblSnapshotSKU 
                WHERE ixDate between 18080 and 18110 -- started 10:16
                )
    DELETE top (10000)
    FROM tblSnapshotSKU 
    WHERE ixDate between 18080 and 18110; 
    WAITFOR DELAY '00:00:01'; -- approx 37k/min   600k/hour

    select FORMAT(count(*),'###,###') from tblSnapshotSKU WHERE ixDate <= 18110 -- 2,408,553 @4:35    166mins
    select FORMAT(count(*),'###,###') from tblSnapshotSKU WHERE ixDate = 18079






-- avg update time/day for tblSnapshotSKU
-- FIND THE FILE "Avg time to populate tblSnapshotSKU.xlsx" to add new values
    SELECT SS.ixDate,  D.dtDate, D.sDayOfWeek3Char 'Day'
      --  , MIN(ixTimeLastSOPUpdate) 'Started'
      --  , MAX(ixTimeLastSOPUpdate) 'Finished'
        ,(MAX(ixTimeLastSOPUpdate)-MIN(ixTimeLastSOPUpdate)) 'TotSec'
        ,(MAX(ixTimeLastSOPUpdate)-MIN(ixTimeLastSOPUpdate))/3600.0 'Hours'
        , FORMAT(count(ixSKU),'###,###') 'TotRec'
        ,(count(ixSKU)/(MAX(ixTimeLastSOPUpdate)-MIN(ixTimeLastSOPUpdate))) 'Rec/Sec'
    from [SMI Reporting].dbo.tblSnapshotSKU SS
        join [SMI Reporting].dbo.tblDate D on SS.ixDate = D.ixDate
    WHERE SS.ixDate BETWEEN 18629 AND 18718 -- 1/1/2019 and today
     --and ixTimeLastSOPUpdate> 23038
    GROUP BY SS.ixDate, D.dtDate, D.sDayOfWeek3Char
    order by SS.ixDate
    /* PAST SPEEDS*

    Year/Mo Avg

    Year/Mo  Avg         Avg                Rec/
    Avg      TotSec      Hours   TotRec	    Sec 	Notes
    =======  ======      =====   =======    ====    ========================================
    2019.03	 12,689 	 3.5 	 435,993 	34.4
    2019.02	 10,920 	 3.0 	 433,896 	39.7
    2019.01	 10,602 	 2.9 	 431,084 	40.7

    2018.12	 10,645 	 3.0 	 429,299 	40.3	
    2018.11	 10,427 	 2.9 	 427,425 	41.0	
    2018.10	 11,171 	 3.1 	 425,687 	38.1	
    2018.09	 10,315 	 2.9 	 423,425 	41.0	
    2018.08	 11,116 	 3.1 	 421,432 	37.9	
    2018.07	 14,583 	 4.1 	 414,493 	28.4	
    2018.06	 13,607 	 3.8 	 409,087 	30.1	
    2018.05	 12,955 	 3.6 	 406,365 	31.4	
    2018.04	 11,577 	 3.2 	 402,465 	34.8	
    2018.03	 12,449 	 3.5 	 397,682 	31.9	 LNK-SQL-LIVE-1 w/96GB RAM
    2018.02	 15,361 	 4.4 	 390,920 	25.4	01/14/18-03/02/18  avg on LNK-SQL-LIVE-1
    2018.01	 16,970 	 4.7 	 387,314 	22.8	01/01/18-01/12/18  avg on DW1
    */


/********   TABLE SIZE    *********/
select FORMAT(dtDate,'yyyy.MM.dd') as 'Date      ' , FORMAT(sRowCount,'###,###') 'Rows'
from [SMI Reporting].dbo.tblTableSizeLog
where sTableName = 'tblSnapshotSKU'
    and dtDate = '04/09/2019'
order by dtDate desc
/*
Date      	Rows
2019.04.09	293,401,439
2019.04.01	310,010,246
2019.01.01	377,205,725
2018.01.01	338,966,785
2017.01.01	214,885,427
2015.08.17	105,291,898
*/

  


/***** RON's CODE TO ARCHIVE tblSnapshotSKU IN BATCHES ****/
set nocount off
/* You can change the batch size */
Declare @BatchSize int
set @BatchSize = 5000
Declare @TestMode bit;
set @TestMode = 0 ; --When set to one it will rollback the transaction and only do one pass.

Declare @Date bigint -- This is the internal Pick Date number
set @Date = 18112 --<A Valid Pic Date Number>

Declare @TABLE table ([ixSKU] [varchar](30) NOT NULL,
                      [ixDate] [smallint] NOT NULL
                     )

Declare @Count int
set @Count = 999
while exists( select top 1 1 from tblSnapshotSKU where ixDate < @Date )
begin
       begin transaction
              insert into SMIArchive.[dbo].[tblSnapshotSKUArchive]
              output INSERTED.ixSKU,
                     INSERTED.ixDate
              into @TABLE
              select top (@BatchSize) * 
              from tblSnapshotSKU
              where ixDate < @Date 

       DELETE FROM tblSnapshotSKU 
       from tblSnapshotSKU S
            INNER JOIN @TABLE t on S.ixSKU = t.ixSKU and S.ixDate = t.ixDate
       delete from @TABLE
       if @TestMode = 1
           begin
                  rollback transaction
                  set @Date = 0 -- For testing this gets us out of the loop
           end 
       else
           begin
                  COMMIT transaction
           end
       print cast(@Count * @BatchSize as nvarchar(max)) + ' Archived'
       set @Count = @Count + 1
end

SELECT COUNT(1)
FROM tblSnapshotSKU -- 361,577
where ixDate = 18111 

SELECT COUNT(1)
FROM [SMIArchive].dbo.tblSnapshotSKUArchive --  ## minutessu5r      zz- 6,740
where ixDate = 18111 

SELECT ixSKU
-- DELETE  
FROM tblSnapshotSKU -- 362,167
where ixDate = 18111 
and ixSKU in (SELECT ixSKU 
              FROM [SMIArchive].dbo.tblSnapshotSKUArchive --  ## minutessu5r      zz- 6,650
                where ixDate = 18111
                )

                                                                 
/****  SAMPLE of OLD METHOD       
    SET ROWCOUNT 30000
    GO    
    SELECT @@SPID as 'Current SPID' -- 121
    GO                                                             
    SELECT FORMAT(COUNT(*),'###,###') 'RecCount' , CONVERT(VARCHAR,GETDATE(),22) 'START@'                 
    FROM tblSnapshotSKU                                                                        
    WHERE ixDate <= 17929     
    --                                                                                              
    GO                                                                                                                    
                              DELETE FROM [SMI Reporting].dbo.tblSnapshotSKU WITH(READPAST) WHERE ixDate <= 17929; SELECT CONVERT(VARCHAR,GETDATE(),22) 'END SET 1'   
    GO                                                   
    WAITFOR DELAY '00:00:15'; DELETE FROM [SMI Reporting].dbo.tblSnapshotSKU WITH(READPAST) WHERE ixDate <= 17929; SELECT CONVERT(VARCHAR,GETDATE(),22) 'END SET 2'                                 
    GO
    WAITFOR DELAY '00:00:15'; DELETE FROM [SMI Reporting].dbo.tblSnapshotSKU WITH(READPAST) WHERE ixDate <= 17929; SELECT CONVERT(VARCHAR,GETDATE(),22) 'END SET 3'
    GO
*/



set rowcount 1000000 -- 400k
-- set rowcount 0

/*  select * from tblDate where ixDate in (17534,17898) -- 17534 and 17898
17534	01/02/2016
17898	12/31/2016
*/
SELECT FORMAT(getdate(),'hh:mm') 'Started'
GO
DELETE FROM [SMIArchive].dbo.tblSnapshotSKUArchive
where ixDate between 17534 and 17898 -- 1/2/15 and 12/31/15
GO                                                   
    WAITFOR DELAY '00:00:15'
DELETE FROM [SMIArchive].dbo.tblSnapshotSKUArchive
where ixDate between 17534 and 17898 -- 1/2/15 and 12/31/15
GO                                                   
    WAITFOR DELAY '00:00:15'
DELETE FROM [SMIArchive].dbo.tblSnapshotSKUArchive
where ixDate between 17534 and 17898 -- 1/2/15 and 12/31/15
GO                                                   
    WAITFOR DELAY '00:00:15'
DELETE FROM [SMIArchive].dbo.tblSnapshotSKUArchive
where ixDate between 17534 and 17898 -- 1/2/15 and 12/31/15
GO                                                   
    WAITFOR DELAY '00:00:15'
DELETE FROM [SMIArchive].dbo.tblSnapshotSKUArchive -- 5th batch
where ixDate between 17534 and 17898 -- 1/2/15 and 12/31/15
GO   
    WAITFOR DELAY '00:00:15'                                                
  DELETE FROM [SMIArchive].dbo.tblSnapshotSKUArchive
where ixDate between 17534 and 17898 -- 1/2/15 and 12/31/15
GO                                                   
    WAITFOR DELAY '00:00:15'
DELETE FROM [SMIArchive].dbo.tblSnapshotSKUArchive
where ixDate between 17534 and 17898 -- 1/2/15 and 12/31/15
GO                                                   
    WAITFOR DELAY '00:00:15'
DELETE FROM [SMIArchive].dbo.tblSnapshotSKUArchive
where ixDate between 17534 and 17898 -- 1/2/15 and 12/31/15
GO                                                   
    WAITFOR DELAY '00:00:15'
DELETE FROM [SMIArchive].dbo.tblSnapshotSKUArchive
where ixDate between 17534 and 17898 -- 1/2/15 and 12/31/15
GO                                                   
    WAITFOR DELAY '00:00:15'
DELETE FROM [SMIArchive].dbo.tblSnapshotSKUArchive -- 10th batch
where ixDate between 17534 and 17898 -- 1/2/15 and 12/31/15
GO 
SELECT FORMAT(getdate(),'hh:mm') 'Finished'

/*
Tot     Records
Time    Left
Mins    (million)
====    =========
-- 10 batches of 1m
3       108m
.
.
3       70
4       60
4       50
12      40
9       30
13      20
4       10

*/

SELECT COUNT(1)
FROM [SMIArchive].dbo.tblSnapshotSKUArchive
where ixDate between 17534 and 17898 -- 1/2/16 and 12/31/16 
/* start 113,000,999
90m
-- ~12m after current run
 


DELETE FROM tblSnapshotSKU
where ixDate = 18111
and ixSKU in ('10619-9-2-5','10619-9-2-6','10619-9-2-7','10619-9-2-8','10619-9-2-9','10619-9-3-0','10619-9-3-1','10619-9-3-10','10619-9-3-11','10619-9-3-12','10619-9-3-13','10619-9-3-2','10619-9-3-3','10619-9-3-4','10619-9-3-5','10619-9-3-6','10619-9-3-7','10619-9-3-8','10619-9-3-9','10619-9-4-0','10619-9-4-1','10619-9-4-10','10619-9-4-11','10619-9-4-12','10619-9-4-13','10619-9-4-2','10619-9-4-3','10619-9-4-4','10619-9-4-5','10619-9-4-6','10619-9-4-7','10619-9-4-8','10619-9-4-9','10619-9-5-0','10619-9-5-1','10619-9-5-10','10619-9-5-11','10619-9-5-12','10619-9-5-13','10619-9-5-2','10619-9-5-3','10619-9-5-4','10619-9-5-5','10619-9-5-6','10619-9-5-7','10619-9-5-8','10619-9-5-9','10619-9-6-0','10619-9-6-1','10619-9-6-10','10619-9-6-11','10619-9-6-12','10619-9-6-13','10619-9-6-2','10619-9-6-3','10619-9-6-4','10619-9-6-5','10619-9-6-6','10619-9-6-7','10619-9-6-8','10619-9-6-9','10619-9-7-0','10619-9-7-1','10619-9-7-10','10619-9-7-11','10619-9-7-12','10619-9-7-13','10619-9-7-2','10619-9-7-3','10619-9-7-4','10619-9-7-5','10619-9-7-6','10619-9-7-7','10619-9-7-8','10619-9-7-9','10619-9-8-0','10619-9-8-1','10619-9-8-10','10619-9-8-11','10619-9-8-12','10619-9-8-13','10619-9-8-2','10619-9-8-3','10619-9-8-4','10619-9-8-5','10619-9-8-6','10619-9-8-7','10619-9-8-8','10619-9-8-9','10619-9-9-0','10619-9-9-1','10619-9-9-10','10619-9-9-11','10619-9-9-12','10619-9-9-13','10619-9-9-2','10619-9-9-3','10619-9-9-4','10619-9-9-5','10619-9-9-6','10619-9-9-7','10619-9-9-8','10619-9-9-9','10619001','10619001S','10619002','10619002S','10619003','10619003S','10619004','10619004S','10619005','10619005.GS','10619005S','10619006','10619006S','10619007','10619007S','10619008','10619008S','10619009','10619009S','10619010','10619010.GS','10619010S','10619011','10619011S','10619012','10619013','106190132S','10619013S','10619014','10619060','10619065','10619066','10619316','1061940SP','1061940ST','1061940STA','1061940STPB','1061940X','1061945ST','10619463RTST','10619464ST','1061946ST','106195071','10619509','10619510','10619511','10619512','10619513','106195131','10619514','106195141','10619515','10619516','10619517','10619518','10619519','10619520','10619521','10619522','10619523','106195231','10619524','10619525','10619526','10619527','1061953','10619535','10619537','1061954','10619540','10619541','1061955','106196','106197','1061970','1061970SP','1061970SPA','1061970SPT','106197101','106197102','106197104','106197107','106197108','106197111','106197112','106197113','106197114','106197115','106197116','106197117','106197119','10619716','10619719','10619726','1061973','1061973.GS','10619735','10619735.GS','10619736','10619736HSR','10619737','10619738','10619738R','1061973GS','1061973HSRX2','1061973RT','1061973S3B6','1061973T','1061974','10619740','10619741','10619745','10619746','10619746.GS','10619746BNC','10619746T','10619747','10619748','10619749','1061974BNC6SRT','1061974HSRX2R','1061974RT','1061974S3B6','1061974T','1061975','1061975.GS','106197512','10619752','10619753','10619753.GS','10619753T','10619756','10619756.GS','10619757','10619758','10619759','1061975RT','1061975S3B6','1061975T','1061976','10619760','10619761','106197610','10619762','10619762.GS','10619762T','10619763','10619763RTR','10619764','10619764.GS','10619764T','10619765','1061976GS','1061976T','1061977','1061977.GS','10619772','10619772.GS','10619774','10619774.GS','10619776','1061977T','1061978','10619782','10619784','10619790','10619791','10619791.GS','10619792','106199','1061990','10619900','1061990SP','1061990SPA','1061990SPT','106199101','1061992','10619924','10619924.GS','1061993','10619934','10619934.GS','10619935','10619935.GS','10619936','10619937','10619938','1061993RT','1061994','1061994.GS','10619940','10619945','10619946','1061994RT','1061994RT.GS','1061994T','1061995','1061995.RTGS','10619952','10619953','10619956','10619956.GS','10619957','1061995RT','1061996','10619960','10619962','10619962SRTR','10619963','10619964','1061997','10619972','10619972BNC','10619973','10619974','1061998','1061998.GS','10619980','10619982','10619982T','10619983','10619984','1061999','10619990','10619991','10619992','10619993','10619994','10619994BNC','10619BVAC','10619E1LFB','10619E1LFRFB','10619E1LFS','10619E1LRB','10619E1LRRRHR','10619E1LRS','10619E1RFB','10619E1RFHR','10619E1RRB','10619E1RRHR','10619E1RRS','10619E27RRS','10619E2LFB','10619E2LFBGS','10619E2LFRFS','10619E2LRBS','10619E2LRHRRRB','10619E2RFBLFHR','10619E2RFHR','10619E2RRHR','10619E2RRS','10620-1000','10620-1150','10620-1250','10620-1300','10620-1350','10620-400','10620-450','10620-475','10620-500','10620-525','10620-550','10620-575','10620-600','10620-625','10620-650','10620-650GS','10620-700','10620-750','10620-800','10620-850','10620-900','10620-950','10620.600GS','106200','10620000','106200001','106200002','106200008','106200009','10620001','106200010','106200011','106200017','10620001GS','10620001S','10620002','10620002RL','10620002RLS','10620003','106200036','106200037','10620004','106200041','106200041S','10620004S','10620005','10620005S','10620006','10620006S','10620007','106200071','106200071S','10620007A','10620007S','10620008','10620008S','10620009','10620009GS','10620009S','1062000E','10620010','1062001001','1062001002','1062001003','1062001004','1062001005','1062001006','1062001007','1062001008','1062001009','106200101','1062001010','106200101S','106200102','106200103S','106200104S','10620010P','10620010S','10620010SP','10620011','106200112','106200113','10620011S','10620013K','10620018R1','10620018R1K','10620018R2','10620018R4K','10620018RM1','10620018RM1K','10620018RM3K','10620019R1','10620019R2','10620019RM1','1062001E','10620020-L','10620020-R','10620020K','10620020L','10620020R','10620021L','10620021R','10620022','10620022R1','10620023','10620023K','10620023R1','10620023R2','10620023RM1','10620023RM5','10620024','106200243','106200244','106200245','10620025','10620025R1','10620025R2','10620025RM1','10620025RM5','10620026','10620026R1','10620026R2','10620026RM1','10620026RM2','10620027','10620027R1','10620027R2','10620027RM1','10620027RM1.GS','10620027RP.GS','10620028R1','10620028R1K','10620028R2','10620028R4K','10620028RM1','10620028RM1K','10620028RM3K','10620028RM5','10620029R1','10620029R1.GS','10620029R2','10620029RM1','10620029RM5','10620031','106200312LF','10620031GS')


Batch   
size    Rows    Mins    Rec/Min
=====   ======= ====    =======
5       400     2       200
50      1,750   2       875
500     7,000   2       3,500
5,000   155,000 2       77,500

 400 rows -- 2 minutes @batchzide = 5
 1750 -- 2 minutes @batchzide = 50
 7000 -- 2 minutes @batchzide = 500


 235,000