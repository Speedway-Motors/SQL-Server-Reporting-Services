-- Case 23261 - validate UPS TNT times in tblTrailerZipTNT are the same as SOPs 

select * from tblTrailerZipTNT
where ixZipCode = 501

select ixTrailer, sDescription
from tblTrailer
where ixCarrier = 'UPS'
and sOrigin = 'Lincoln'
/*
ixTrailer   sDescription
KC	        UPS KC
LNK	        UPS Lincoln
OMS	        UPS Omaha (Sunrise)    
OMH 	    UPS Omaha (Twilight)    
DEN	        UPS Denver
OMN	        UPS Omaha (Midnight)
FSD	        UPS SF (M-Th) -- both Sioux Falls

FSF	        UPS SF (Fri)  -- both Sioux Falls NOT IN tblTrailerZipTNT
OGP	        2 Day Economy -- ALWAYS 2 DAYS
UPSMI	    UPS USPS MI -- no guaranteed TNT for UPSMI so no tracking for those (they're all Canada Post)
*/

-- MAKE SURE TEMP TABLES HAVE THE RIGHT DATA TYPE
-- ixZipCode (int) <-- yes int, tblTrailerZipTNT is formatted that way...so zipcode "00123" is stored as 123
-- iTNT (smallint)

/* AFTER first temp table is formatted run this to make empty copies of the other Trailer tables */
select top 0 *
into [SMITemp].dbo.PJC_23261_TNT_LNK
from [SMITemp].dbo.PJC_23261_TNT_KC

select top 0 *
into [SMITemp].dbo.PJC_23261_TNT_OMS
from [SMITemp].dbo.PJC_23261_TNT_KC

select top 0 *
into [SMITemp].dbo.PJC_23261_TNT_OMH
from [SMITemp].dbo.PJC_23261_TNT_KC

select top 0 *
into [SMITemp].dbo.PJC_23261_TNT_DEN
from [SMITemp].dbo.PJC_23261_TNT_KC

select top 0 *
into [SMITemp].dbo.PJC_23261_TNT_OMN
from [SMITemp].dbo.PJC_23261_TNT_KC

select top 0 *
into [SMITemp].dbo.PJC_23261_TNT_FSD
from [SMITemp].dbo.PJC_23261_TNT_KC

select * from [SMITemp].dbo.PJC_23261_TNT_LNK

-- counts and sample data from temp tables
select count(*) from [SMITemp].dbo.PJC_23261_TNT_KC                     -- 19945
select count(distinct ixZipCode) from [SMITemp].dbo.PJC_23261_TNT_KC    -- 19945
select count(*) from [SMITemp].dbo.PJC_23261_TNT_LNK                    -- 212
select count(distinct ixZipCode) from [SMITemp].dbo.PJC_23261_TNT_LNK   -- 212
select count(*) from [SMITemp].dbo.PJC_23261_TNT_DEN                    -- 7246
select count(distinct ixZipCode) from [SMITemp].dbo.PJC_23261_TNT_DEN   -- 7246
-- TRUNCATE TABLE [SMITemp].dbo.PJC_23261_TNT_OMN
select count(*) from [SMITemp].dbo.PJC_23261_TNT_OMN                    -- 41750
select count(distinct ixZipCode) from [SMITemp].dbo.PJC_23261_TNT_OMN   -- 41750
-- TRUNCATE TABLE [SMITemp].dbo.PJC_23261_TNT_OMH
select count(*) from [SMITemp].dbo.PJC_23261_TNT_OMH                    -- 41476
select count(distinct ixZipCode) from [SMITemp].dbo.PJC_23261_TNT_OMH   -- 41476
select count(*) from [SMITemp].dbo.PJC_23261_TNT_OMS                    -- 41572
select count(distinct ixZipCode) from [SMITemp].dbo.PJC_23261_TNT_OMS   -- 41572
select count(*) from [SMITemp].dbo.PJC_23261_TNT_FSD                    -- 1482
select count(distinct ixZipCode) from [SMITemp].dbo.PJC_23261_TNT_FSD   -- 1482

/**********  KC trailer  **********/
select KC.ixZipCode, KC.iTNT as SOPTNT, TZT.iTNT as 'TZT_TNT', (KC.iTNT - TZT.iTNT) AS 'Delta'
from [SMITemp].dbo.PJC_23261_TNT_KC KC
 join tblTrailerZipTNT TZT on TZT.ixZipCode = KC.ixZipCode AND TZT.ixTrailer = 'KC' 
WHERE TZT.ixTrailer = 'KC'                          -- 19,851 MATCHES
    and TZT.iTNT <> KC.iTNT                         --      8 NON-MATCHES
ORDER BY (KC.iTNT - TZT.iTNT)

select KC.*
from [SMITemp].dbo.PJC_23261_TNT_KC KC
where ixZipCode not in (select ixZipCode
                        from tblTrailerZipTNT TZT 
                        where TZT.ixTrailer = 'KC') -- 94 in SOP but NOT IN tblTrailerZipTNT
                         
select TZT.*
from tblTrailerZipTNT TZT
where TZT.ixTrailer = 'KC'
 and ixZipCode NOT IN (select ixZipCode             --  145 in tblTrailerZipTNT but NOT IN the new UPS file
                       from [SMITemp].dbo.PJC_23261_TNT_KC) 
                         
                         
/**********  DEN trailer  **********/
select DEN.ixZipCode, DEN.iTNT as SOPTNT, TZT.iTNT as 'TZT_TNT', (DEN.iTNT - TZT.iTNT) AS 'Delta'
from [SMITemp].dbo.PJC_23261_TNT_DEN DEN
 join tblTrailerZipTNT TZT on TZT.ixZipCode = DEN.ixZipCode AND TZT.ixTrailer = 'DEN' 
WHERE TZT.ixTrailer = 'DEN'                         -- 7,017 MATCHES
    and TZT.iTNT <> DEN.iTNT                        --   110 NON-MATCHES.  show 3 days in tblTrailerZipTNT but 4 days in SOP
ORDER BY (DEN.iTNT - TZT.iTNT)

select DEN.*
from [SMITemp].dbo.PJC_23261_TNT_DEN DEN
 where ixZipCode not in (select ixZipCode
                         from tblTrailerZipTNT TZT 
                         where TZT.ixTrailer = 'DEN') -- 229 in SOP but NOT IN tblTrailerZipTNT
                         
select TZT.*
from tblTrailerZipTNT TZT
 where TZT.ixTrailer = 'DEN'
 and ixZipCode NOT IN (select ixZipCode               --  0 in tblTrailerZipTNT but NOT IN the new UPS file
                       from [SMITemp].dbo.PJC_23261_TNT_DEN)  
                         

/**********  LNK trailer  **********/
select LNK.ixZipCode, LNK.iTNT as SOPTNT, TZT.iTNT  as 'TZT_TNT', (LNK.iTNT - TZT.iTNT) AS 'Delta'
from [SMITemp].dbo.PJC_23261_TNT_LNK LNK
 join tblTrailerZipTNT TZT on TZT.ixZipCode = LNK.ixZipCode AND TZT.ixTrailer = 'LNK' 
WHERE TZT.ixTrailer = 'LNK' --  175 MATCHES
    and TZT.iTNT <> LNK.iTNT--    0 NON-MATCHES

select LNK.*
from [SMITemp].dbo.PJC_23261_TNT_LNK LNK
 where ixZipCode not in (select ixZipCode
                         from tblTrailerZipTNT TZT 
                         where TZT.ixTrailer = 'LNK') -- 37 NEW ZIPS (not currently in tblTrailerZipTNT)
                         
select TZT.*
from tblTrailerZipTNT TZT
 where TZT.ixTrailer = 'LNK' -- 0 zip matches
 and ixZipCode NOT IN (select ixZipCode
                         from [SMITemp].dbo.PJC_23261_TNT_LNK)  --  ALL zips in tblTrailerZipTNT for the given trailer are in the new UPS file
                         

    
/**********  OMN trailer  **********/       
select OMN.ixZipCode, OMN.iTNT as SOPTNT, TZT.iTNT as TZT_TNT
from [SMITemp].dbo.PJC_23261_TNT_OMN OMN
 join tblTrailerZipTNT TZT on TZT.ixZipCode = OMN.ixZipCode AND TZT.ixTrailer = 'OMN' 
WHERE TZT.ixTrailer = 'OMN' -- 4,126 MATCHES
    and TZT.iTNT <> OMN.iTNT--     0 NON-MATCHES

select OMN.*
from [SMITemp].dbo.PJC_23261_TNT_OMN OMN
 where ixZipCode not in (select ixZipCode
                         from tblTrailerZipTNT TZT 
                         where TZT.ixTrailer = 'OMN') -- 324 NEW (not currently in tblTrailerZipTNT)
                         
select TZT.*
from tblTrailerZipTNT TZT
 where TZT.ixTrailer = 'OMN' -- 0 zip matches
 and ixZipCode NOT IN (select ixZipCode
                         from [SMITemp].dbo.PJC_23261_TNT_OMN) --  ALL zips in tblTrailerZipTNT for the given trailer are in the new UPS file
                         
/**********  OMH trailer  **********/       
select OMH.ixZipCode, OMH.iTNT as SOPTNT, TZT.iTNT as TZT_TNT
from [SMITemp].dbo.PJC_23261_TNT_OMH OMH
 join tblTrailerZipTNT TZT on TZT.ixZipCode = OMH.ixZipCode AND TZT.ixTrailer = 'OMH' 
WHERE TZT.ixTrailer = 'OMH' -- 41,327 MATCHES
    and TZT.iTNT <> OMH.iTNT--      0 NON-MATCHES

select OMH.*
from [SMITemp].dbo.PJC_23261_TNT_OMH OMH
 where ixZipCode not in (select ixZipCode
                         from tblTrailerZipTNT TZT 
                         where TZT.ixTrailer = 'OMH') -- 149 NEW (not currently in tblTrailerZipTNT)
                         
select TZT.*
from tblTrailerZipTNT TZT
 where TZT.ixTrailer = 'OMH' -- 0 zip matches
 and ixZipCode NOT IN (select ixZipCode
                         from [SMITemp].dbo.PJC_23261_TNT_OMH)--  418 zips in tblTrailerZipTNT for the given trailer are in the new UPS file                         
                         
                         
                         


/**********  OMS trailer  **********/      
select OMS.ixZipCode, OMS.iTNT as SOPTNT, TZT.iTNT as TZT_TNT, (OMS.iTNT - TZT.iTNT) AS delta
from [SMITemp].dbo.PJC_23261_TNT_OMS OMS
 join tblTrailerZipTNT TZT on TZT.ixZipCode = OMS.ixZipCode AND TZT.ixTrailer = 'OMS' 
WHERE TZT.ixTrailer = 'OMS' -- 40,428 MATCHES
    and TZT.iTNT <> OMS.iTNT-- 40,537 NON-MATCHES
ORDER BY (OMS.iTNT - TZT.iTNT)

select OMS.*
from [SMITemp].dbo.PJC_23261_TNT_OMS OMS
 where ixZipCode not in (select ixZipCode
                         from tblTrailerZipTNT TZT 
                         where TZT.ixTrailer = 'OMS') -- 147 NEW (not currently in tblTrailerZipTNT)
                         
select TZT.*
from tblTrailerZipTNT TZT
 where TZT.ixTrailer = 'OMS' -- 0 zip matches
 and ixZipCode NOT IN (select ixZipCode
                         from tblTrailerZipTNT TZT 
                         where TZT.ixTrailer = 'OMS') --  ALL zips in tblTrailerZipTNT for the given trailer are in the new UPS file




/*****
tblTrailerZipTNT SEEMS TO BE SEVERELY OUT OF SYNCH WITH WHAT SOP SHOWS FOR TNTs
WE NEED TO CHECK OUT EVERY REPORT, FUNCTION, PROC AND VIEW THAT CURRENTLY USES tblTrailerZipTNT AND TALK TO CCC ABOUT WHAT TO DO
IN THE MEANTIME I WILL ATTEMPT TO MERGE THESE FILES FROM SOP INTO A TEMP TABLE FOR A ONE-OFF ANALYSIS FOR KORTH
******/

select * from [SMITemp].dbo.PJC_23261_TNT_OMS order by ixZipCode

-- DROP TABLE [SMITemp].dbo.PJC_23261_CombinedTrailerTNT 
SELECT 'DEN' as ixTrailer, 
    ixZipCode as iZip,
    RIGHT ('00000'+ CAST (ixZipCode AS varchar), 5) as 'ixZipCode',
    iTNT 
into [SMITemp].dbo.PJC_23261_CombinedTrailerTNT
from [SMITemp].dbo.PJC_23261_TNT_DEN      
order by ixZipCode

insert into [SMITemp].dbo.PJC_23261_CombinedTrailerTNT
SELECT 'FSD' as ixTrailer, 
    ixZipCode as iZip,
    RIGHT ('00000'+ CAST (ixZipCode AS varchar), 5) as 'ixZipCode',
    iTNT 
from [SMITemp].dbo.PJC_23261_TNT_FSD      
order by ixZipCode

insert into [SMITemp].dbo.PJC_23261_CombinedTrailerTNT
SELECT 'KC' as ixTrailer, 
    ixZipCode as iZip,
    RIGHT ('00000'+ CAST (ixZipCode AS varchar), 5) as 'ixZipCode',
    iTNT 
from [SMITemp].dbo.PJC_23261_TNT_KC      
order by ixZipCode

insert into [SMITemp].dbo.PJC_23261_CombinedTrailerTNT
SELECT 'LNK' as ixTrailer, 
    ixZipCode as iZip,
    RIGHT ('00000'+ CAST (ixZipCode AS varchar), 5) as 'ixZipCode',
    iTNT 
from [SMITemp].dbo.PJC_23261_TNT_LNK      
order by ixZipCode

insert into [SMITemp].dbo.PJC_23261_CombinedTrailerTNT
SELECT 'OMH' as ixTrailer, 
    ixZipCode as iZip,
    RIGHT ('00000'+ CAST (ixZipCode AS varchar), 5) as 'ixZipCode',
    iTNT 
from [SMITemp].dbo.PJC_23261_TNT_OMH      
order by ixZipCode

insert into [SMITemp].dbo.PJC_23261_CombinedTrailerTNT
SELECT 'OMN' as ixTrailer, 
    ixZipCode as iZip,
    RIGHT ('00000'+ CAST (ixZipCode AS varchar), 5) as 'ixZipCode',
    iTNT 
from [SMITemp].dbo.PJC_23261_TNT_OMN      
order by ixZipCode

insert into [SMITemp].dbo.PJC_23261_CombinedTrailerTNT
SELECT 'OMS' as ixTrailer, 
    ixZipCode as iZip,
    RIGHT ('00000'+ CAST (ixZipCode AS varchar), 5) as 'ixZipCode',
    iTNT 
from [SMITemp].dbo.PJC_23261_TNT_OMS     
order by ixZipCode

-- VERIFY combo table counts by zip match file quantities
select count(*) from [SMITemp].dbo.PJC_23261_TNT_LNK                    -- 212
select count(*) from [SMITemp].dbo.PJC_23261_TNT_FSD                    -- 1482
select count(*) from [SMITemp].dbo.PJC_23261_TNT_DEN                    -- 7246
select count(*) from [SMITemp].dbo.PJC_23261_TNT_KC                     -- 19945
select count(*) from [SMITemp].dbo.PJC_23261_TNT_OMH                    -- 41476
select count(*) from [SMITemp].dbo.PJC_23261_TNT_OMS                    -- 41572
select count(*) from [SMITemp].dbo.PJC_23261_TNT_OMN                    -- 41750



select ixTrailer, count(*) 'Qty'
from [SMITemp].dbo.PJC_23261_CombinedTrailerTNT
group by ixTrailer
order by count(*)
/* 
ixTrailer	Qty     <-- matches!
LNK	        212
FSD	        1482
DEN	        7246
KC	        19945
OMH	        41476
OMS	        41572
OMN	        41750
*/


select O.ixOrder, O.dtShippedDate, O.iShipMethod,
    ORT.ixPrintPrimaryTrailer,
    TMP1.iTNT as 'PrintTNT',
    ORT.ixVerifyPrimaryTrailer,
    TMP2.iTNT as 'VerificationTNT',
    (TMP2.iTNT - TMP1.iTNT) as 'DaysDelayed'
from tblOrder O
    join tblOrderRouting ORT on O.ixOrder = ORT.ixOrder
    join [SMITemp].dbo.PJC_23261_CombinedTrailerTNT TMP1 on TMP1.ixTrailer = ORT.ixPrintPrimaryTrailer and TMP1.ixZipCode = O.sShipToZip
    join [SMITemp].dbo.PJC_23261_CombinedTrailerTNT TMP2 on TMP2.ixTrailer = ORT.ixVerifyPrimaryTrailer and TMP2.ixZipCode = O.sShipToZip  
where   O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between '06/01/2014' and '06/30/2014'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.iShipMethod in (2,3,4,5,10,11,12) -- verify with Al these are the ones we want
    and ORT.ixPrintPrimaryTrailer <> ORT.ixVerifyPrimaryTrailer 
    and TMP2.iTNT > TMP1.iTNT
order by (TMP2.iTNT - TMP1.iTNT) desc
-- looks like 695 orders (2.53%) out of the 27,428 orders meeting the conditions and ship methods were delayed by one or more days 


select * from tblShipMethod    
where ixCarrier = 'UPS'    






-- SOP values (in temp table) VS.  TNT in tblTrailerZipTNT
select  T.ixTrailer 'ixTrailer_SOP',    -- 153,683 in temp table
        T.iZip      'Zip_SOP',          -- 154,246 between both tables
        T.iTNT      'TNT_SOP',
        TZ.ixTrailer 'ixTrailer_DB',
        TZ.ixZipCode 'Zip_DB',
        TZ.iTNT     'TNT_DB'
from [SMITemp].dbo.PJC_23261_CombinedTrailerTNT T-- 153693
    FULL OUTER JOIN tblTrailerZipTNT TZ ON T.ixTrailer = TZ.ixTrailer
                                       AND T.iZip      = TZ.ixZipCode
WHERE T.ixTrailer in ('DEN','FSD','KC','LNK','OMH','OMN','OMS')
    OR TZ.ixTrailer in ('DEN','FSD','KC','LNK','OMH','OMN','OMS')
order by iZip



select distinct ixTrailer from [SMITemp].dbo.PJC_23261_CombinedTrailerTNT order by ixTrailer
DEN
FSD
KC
LNK
OMH
OMN
OMS
select distinct ixTrailer from tblTrailerZipTNT order by ixTrailer
-- also in the temp table
DEN
FSD
KC
LNK
OMH
OMN
OMS
-- NOT in the temp table
DSM
EVN
FDM
FSF
LFF
LNF
LPU
UPSMI


SELECT * FROM tblTrailer


select * from [SMITemp].dbo.PJC_23261_CombinedTrailerTNT order by iZip
select * from [SMITemp].dbo.PJC_23261_TNT_DEN  order by iZip


-- The code below this line has not been modified or used YET for this analysis



SELECT ixTrailer, count(*) Qty, CONVERT(VARCHAR, GETDATE(), 10)  AS 'As of'
from tblTrailerZipTNT
group by ixTrailer
order by ixTrailer
/*
ixTrailer	Qty	    As of
   *DEN	    7017	03-13-14
   *OMH	    41745	03-13-14
   *OMN	    41426	03-13-14
   *OMS	    41425	03-13-14
   *LNK	    175	    03-13-14
         
    DSM	    5993	03-13-14
    EVN	    41128	03-13-14
    FDM	    41232	03-13-14
    FSD	    1482	03-13-14
    FSF	    1482	03-13-14
    KC	    19996	03-13-14
    LFF	    41232	03-13-14
    LNF	    41232	03-13-14

    LPU	    5993	03-13-14

*/
select ixTrailer, count(*) RecCount, min(iTNT) MinTNT, max(iTNT) MaxTNT
from tblTrailerZipTNT 
group by ixTrailer
/*
	Rec     Min Max
	Count	TNT	TNT
DEN	7017	1	4
LNK	175	    1	1
OMH	41745	1	5
OMN	41426	1	5
OMS	41425	2	6
	
KC	19996	1	4
FSF	1482	1	1
LPU	5993	1	2
LNF	41232	1	6
LFF	41232	1	6
FDM	41232	1	7
EVN	41128	1	5
FSD	1482	1	1
DSM	5993	1	2
*/

select top 10 * from [SMITemp].dbo.PJC_23261_TNT_DEN order by newid()
select top 10 * from [SMITemp].dbo.PJC_23261_TNT_LNK order by newid()
select top 10 * from [SMITemp].dbo.PJC_23261_TNT_OMH order by newid()
select top 10 * from [SMITemp].dbo.PJC_23261_TNT_OMN order by newid()
select top 10 * from [SMITemp].dbo.PJC_23261_TNT_OMS order by newid()

select * from [SMITemp].dbo.PJC_23261_TNT_DEN where iTNT is NULL OR iTNT NOT between 1 and 7
select * from [SMITemp].dbo.PJC_23261_TNT_LNK where iTNT is NULL OR iTNT NOT between 1 and 7
select * from [SMITemp].dbo.PJC_23261_TNT_OMH where iTNT is NULL OR iTNT NOT between 1 and 7
select * from [SMITemp].dbo.PJC_23261_TNT_OMN where iTNT is NULL OR iTNT NOT between 1 and 7
select * from [SMITemp].dbo.PJC_23261_TNT_OMS where iTNT is NULL OR iTNT NOT between 1 and 7



-- BACKUP data before running UPDATE
-- DROP TABLE [SMITemp].dbo.tblTrailerZipTNT_BU_07072014
select * into [SMIArchive].dbo.tblTrailerZipTNT_BU_07072014 from tblTrailerZipTNT -- 347,941
select count(*) from [SMIArchive].dbo.tblTrailerZipTNT_BU_07072014                -- 347,941



/************  UPDATE Production Table  ***************
-- !!!! be sure to 
--      CHANGE THE TRAILER TO THE MATCH TEMP TABLE !!!
*******************************************************/
    -- DEN Trailer
    UPDATE TZT 
    set iTNT = NEW.iTNT
        ,dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0, GETDATE())) -- 6770 rows updated
    from tblTrailerZipTNT TZT
     join [SMITemp].dbo.PJC_23261_TNT_DEN NEW 
        on TZT.ixZipCode = NEW.ixZipCode 
            and TZT.ixTrailer = 'DEN' 

    -- LNK Trailer
    UPDATE TZT 
    SELECT NEW.*
    set iTNT = NEW.iTNT
       ,dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0, GETDATE())) -- 174 rows updated
    from tblTrailerZipTNT TZT
     join [SMITemp].dbo.PJC_23261_TNT_LNK NEW 
        on TZT.ixZipCode = NEW.ixZipCode 
            and TZT.ixTrailer = 'LNK' 

    -- OMH Trailer
    UPDATE TZT 
    set iTNT = NEW.iTNT
        ,dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0, GETDATE())) -- 40361 rows updated
    from tblTrailerZipTNT TZT
     join [SMITemp].dbo.PJC_23261_TNT_OMH NEW 
        on TZT.ixZipCode = NEW.ixZipCode 
            and TZT.ixTrailer = 'OMH' 

    -- OMN Trailer
    UPDATE TZT 
    set iTNT = NEW.iTNT
        ,dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0, GETDATE())) -- 40608 rows updated
    from tblTrailerZipTNT TZT
     join [SMITemp].dbo.PJC_23261_TNT_OMN NEW 
        on TZT.ixZipCode = NEW.ixZipCode 
            and TZT.ixTrailer = 'OMN' 
     
    -- OMS Trailer
    UPDATE TZT 
    set iTNT = NEW.iTNT
        ,dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0, GETDATE())) -- 40493 rows updated
    from tblTrailerZipTNT TZT
     join [SMITemp].dbo.PJC_23261_TNT_OMS NEW 
        on TZT.ixZipCode = NEW.ixZipCode 
            and TZT.ixTrailer = 'OMS'           


SELECT TOP 10 * FROM tblTrailerZipTNT

SELECT ixTrailer, count(*) Qty, CONVERT(VARCHAR, GETDATE(), 10)  AS 'As of'
from tblTrailerZipTNT
group by ixTrailer
order by ixTrailer
/*
ixTrailer	Qty	    As of
    DEN	    7017	03-13-14
    DSM	    5993	03-13-14
    EVN	    41128	03-13-14
    FDM	    41232	03-13-14
    FSD	    1482	03-13-14
    FSF	    1482	03-13-14
    KC	    19996	03-13-14
    LFF	    41232	03-13-14
    LNF	    41232	03-13-14
    LNK	    175	    03-13-14
    LPU	    5993	03-13-14
    OMH	    41745	03-13-14
    OMN	    41426	03-13-14
    OMS	    41425	03-13-14
*/

-- BEFORE UPDATES
select ixTrailer, iTNT, count(*)
from [SMITemp].dbo.tblTrailerZipTNT_BU_07072014
where ixTrailer in ('DEN','LNK', 'OMH','OMN','OMS')
GROUP BY ixTrailer, iTNT order by ixTrailer, iTNT
/*
DEN	1	632
DEN	2	2075
DEN	3	4198
DEN	4	112
LNK	1	175
OMH	1	3114
OMH	2	15663
OMH	3	13578
OMH	4	9273
OMH	5	117
OMN	1	1372
OMN	2	10791
OMN	3	19144
OMN	4	10002
OMN	5	117
OMS	2	3231
OMS	3	15453
OMS	4	13649
OMS	5	8975
OMS	6	117
*/

--AFTER UPDATES
select ixTrailer, iTNT, count(*)
from tblTrailerZipTNT--, tblTrailerZipTNT
where ixTrailer in ('DEN','LNK', 'OMH','OMN','OMS')
GROUP BY ixTrailer, iTNT order by ixTrailer, iTNT
/*
DEN	1	599
DEN	2	2091
DEN	3	4275
DEN	4	52
LNK	1	175
OMH	1	3108
OMH	2	15848
OMH	3	13389
OMH	4	9048
OMH	5	80
OMH	6	241
OMH	7	31
OMN	1	1372
OMN	2	10970
OMN	3	18949
OMN	4	10055
OMN	5	80
OMS	1	9978
OMS	2	20735
OMS	3	10126
OMS	4	266
OMS	5	319
OMS	6	1
*/










/*
Q1. How many zips have a faster TNT via LNK than OMH but were not already in tblTrailerZipTNT
*/
select LNK.* from [SMITemp].dbo.PJC_23261_TNT_LNK LNK
    left join [SMITemp].dbo.PJC_23261_TNT_LNK OMH on LNK.ixZipCode = OMH.ixZipCode
where    LNK.iTNT <> OMH.iTNT
or OMH.iTNT is NULL


/*
Q2. How many zips have a faster TNT via LNK than KC but were not already in tblTrailerZipTNT
*/
select LNK.* from [SMITemp].dbo.PJC_23261_TNT_LNK LNK
    left join tblTrailerZipTNT KC on KC.ixZipCode = LNK.ixZipCode and KC.ixTrailer = 'KC' -- no new file so looking at old values in tblTrailerZipTNT
where   LNK.iTNT < KC.iTNT
        OR 
        KC.iTNT is NULL
order by iTNT


-- LNK times that changed
select LNK_NEW.* from [SMITemp].dbo.PJC_23261_TNT_LNK LNK_NEW
   -- left join tblTrailerZipTNT KC on KC.ixZipCode = LNK.ixZipCode and KC.ixTrailer = 'KC'
    left join tblTrailerZipTNT LNK_OLD on LNK_OLD.ixZipCode = LNK_NEW.ixZipCode  and LNK_OLD.ixTrailer = 'LNK'
where   LNK_NEW.iTNT < LNK_OLD.iTNT


