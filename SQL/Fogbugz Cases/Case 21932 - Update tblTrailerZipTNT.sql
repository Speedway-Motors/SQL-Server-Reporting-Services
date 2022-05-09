-- Case 21932 - Update tblTrailerZipTNT

select * from tblTrailerZipTNT
where ixZipCode = 501

select ixTrailer, sDescription
from tblTrailer
where ixCarrier = 'UPS'
/*
filename                ixTrailer   sDescription
Denver Night =          DEN         UPS Denver
Lincoln =               LNK	        UPS Lincoln	
Omaha Night  =          OMN	        UPS Omaha (Midnight)	
Omaha Twilight =        OMH	        UPS Omaha (Twilight)	
Omaha Monday Sunrise =  OMS	        UPS Omaha (Sunrise)	
*/

-- counts and sample data from temp tables
select count(*) from [SMITemp].dbo.PJC_NewDEN_TNT                   -- 41,260
select count(distinct ixZipCode) from [SMITemp].dbo.PJC_NewDEN_TNT  -- 41,260
select count(*) from [SMITemp].dbo.PJC_NewLNK_TNT                   -- 41,260
select count(distinct ixZipCode) from [SMITemp].dbo.PJC_NewLNK_TNT  -- 41,260
select count(*) from [SMITemp].dbo.PJC_NewOMN_TNT                   -- 41,260
select count(distinct ixZipCode) from [SMITemp].dbo.PJC_NewOMN_TNT  -- 41,260
select count(*) from [SMITemp].dbo.PJC_NewOMH_TNT                   -- 41,260
select count(distinct ixZipCode) from [SMITemp].dbo.PJC_NewOMH_TNT  -- 41,260
select count(*) from [SMITemp].dbo.PJC_NewOMS_TNT                   -- 41,146
select count(distinct ixZipCode) from [SMITemp].dbo.PJC_NewOMS_TNT  -- 41,146

select DEN.*
from [SMITemp].dbo.PJC_NewDEN_TNT DEN
 join tblTrailerZipTNT TZT on TZT.ixZipCode = DEN.ixZipCode AND TZT.ixTrailer = 'DEN' -- 6,770 matches
WHERE TZT.ixTrailer = 'DEN' 

select LNK.*
from [SMITemp].dbo.PJC_NewLNK_TNT LNK
 join tblTrailerZipTNT TZT on TZT.ixZipCode = LNK.ixZipCode AND TZT.ixTrailer = 'LNK' -- 174 matches
WHERE TZT.ixTrailer = 'LNK' 

select OMN.*
from [SMITemp].dbo.PJC_NewOMN_TNT OMN
 join tblTrailerZipTNT TZT on TZT.ixZipCode = OMN.ixZipCode AND TZT.ixTrailer = 'OMN' -- 40,608 matches
WHERE TZT.ixTrailer = 'OMN' 

select OMH.*
from [SMITemp].dbo.PJC_NewOMH_TNT OMH
 join tblTrailerZipTNT TZT on TZT.ixZipCode = OMH.ixZipCode AND TZT.ixTrailer = 'OMH' -- 40,361 matches
WHERE TZT.ixTrailer = 'OMH' 

select OMS.*
from [SMITemp].dbo.PJC_NewOMS_TNT OMS
 join tblTrailerZipTNT TZT on TZT.ixZipCode = OMS.ixZipCode AND TZT.ixTrailer = 'OMS' -- 40,493 matches
WHERE TZT.ixTrailer = 'OMS' 



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

select top 10 * from [SMITemp].dbo.PJC_NewDEN_TNT order by newid()
select top 10 * from [SMITemp].dbo.PJC_NewLNK_TNT order by newid()
select top 10 * from [SMITemp].dbo.PJC_NewOMH_TNT order by newid()
select top 10 * from [SMITemp].dbo.PJC_NewOMN_TNT order by newid()
select top 10 * from [SMITemp].dbo.PJC_NewOMS_TNT order by newid()

select * from [SMITemp].dbo.PJC_NewDEN_TNT where iTNT is NULL OR iTNT NOT between 1 and 7
select * from [SMITemp].dbo.PJC_NewLNK_TNT where iTNT is NULL OR iTNT NOT between 1 and 7
select * from [SMITemp].dbo.PJC_NewOMH_TNT where iTNT is NULL OR iTNT NOT between 1 and 7
select * from [SMITemp].dbo.PJC_NewOMN_TNT where iTNT is NULL OR iTNT NOT between 1 and 7
select * from [SMITemp].dbo.PJC_NewOMS_TNT where iTNT is NULL OR iTNT NOT between 1 and 7



-- BACKUP data before running UPDATE
-- DROP TABLE [SMITemp].dbo.tblTrailerZipTNT_BU_03142014
select * into [SMITemp].dbo.tblTrailerZipTNT_BU_03142014 from tblTrailerZipTNT -- 331,558
select count(*) from [SMITemp].dbo.tblTrailerZipTNT_BU_03142014                -- 331,558



/************  UPDATE Production Table  ***************
-- !!!! be sure to 
--      CHANGE THE TRAILER TO THE MATCH TEMP TABLE !!!
*******************************************************/
    -- DEN Trailer
    UPDATE TZT 
    set iTNT = NEW.iTNT
        ,dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0, GETDATE())) -- 6770 rows updated
    from tblTrailerZipTNT TZT
     join [SMITemp].dbo.PJC_NewDEN_TNT NEW 
        on TZT.ixZipCode = NEW.ixZipCode 
            and TZT.ixTrailer = 'DEN' 

    -- LNK Trailer
    UPDATE TZT 
    SELECT NEW.*
    set iTNT = NEW.iTNT
       ,dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0, GETDATE())) -- 174 rows updated
    from tblTrailerZipTNT TZT
     join [SMITemp].dbo.PJC_NewLNK_TNT NEW 
        on TZT.ixZipCode = NEW.ixZipCode 
            and TZT.ixTrailer = 'LNK' 

    -- OMH Trailer
    UPDATE TZT 
    set iTNT = NEW.iTNT
        ,dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0, GETDATE())) -- 40361 rows updated
    from tblTrailerZipTNT TZT
     join [SMITemp].dbo.PJC_NewOMH_TNT NEW 
        on TZT.ixZipCode = NEW.ixZipCode 
            and TZT.ixTrailer = 'OMH' 

    -- OMN Trailer
    UPDATE TZT 
    set iTNT = NEW.iTNT
        ,dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0, GETDATE())) -- 40608 rows updated
    from tblTrailerZipTNT TZT
     join [SMITemp].dbo.PJC_NewOMN_TNT NEW 
        on TZT.ixZipCode = NEW.ixZipCode 
            and TZT.ixTrailer = 'OMN' 
     
    -- OMS Trailer
    UPDATE TZT 
    set iTNT = NEW.iTNT
        ,dtDateLastSOPUpdate = DATEADD(dd,0,DATEDIFF(dd,0, GETDATE())) -- 40493 rows updated
    from tblTrailerZipTNT TZT
     join [SMITemp].dbo.PJC_NewOMS_TNT NEW 
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
from [SMITemp].dbo.tblTrailerZipTNT_BU_03142014
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
select LNK.* from [SMITemp].dbo.PJC_NewLNK_TNT LNK
    left join [SMITemp].dbo.PJC_NewLNK_TNT OMH on LNK.ixZipCode = OMH.ixZipCode
where    LNK.iTNT <> OMH.iTNT
or OMH.iTNT is NULL


/*
Q2. How many zips have a faster TNT via LNK than KC but were not already in tblTrailerZipTNT
*/
select LNK.* from [SMITemp].dbo.PJC_NewLNK_TNT LNK
    left join tblTrailerZipTNT KC on KC.ixZipCode = LNK.ixZipCode and KC.ixTrailer = 'KC' -- no new file so looking at old values in tblTrailerZipTNT
where   LNK.iTNT < KC.iTNT
        OR 
        KC.iTNT is NULL
order by iTNT


-- LNK times that changed
select LNK_NEW.* from [SMITemp].dbo.PJC_NewLNK_TNT LNK_NEW
   -- left join tblTrailerZipTNT KC on KC.ixZipCode = LNK.ixZipCode and KC.ixTrailer = 'KC'
    left join tblTrailerZipTNT LNK_OLD on LNK_OLD.ixZipCode = LNK_NEW.ixZipCode  and LNK_OLD.ixTrailer = 'LNK'
where   LNK_NEW.iTNT < LNK_OLD.iTNT


