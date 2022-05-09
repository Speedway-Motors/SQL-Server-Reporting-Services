-- tblSKULocation checks

-- SKUs missing from 1 or more locations
SELECT TOP 1000
    ixSKU, COUNT(ixLocation) 'LocCnt', SUM(iQAV) 'TotQAV' -- 80,734
FROM tblSKULocation 
group by ixSKU
having  COUNT(ixLocation) < 4
order by SUM(iQAV) desc, ixSKU -- QAV 20-11
   -- COUNT(ixLocation) desc


SELECT * FROM tblSKULocation
where ixSKU = ''


BEGIN TRAN
    --DELETE FROM tblSKULocation
    WHERE ixSKU = ''
ROLLBACK TRAN

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblSKULocation%'
--  ixErrorCode	sDescription
--  1126	    Failure to update tblSKULocation

-- ERROR COUNTS by Day
    SELECT --dtDate, 
        DB_NAME() AS 'DB          '
        ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
        ,count(*) AS 'ErrorQty'
    FROM tblErrorLogMaster
    WHERE ixErrorCode = '1126'
      --and dtDate >=  DATEADD(month, -4, getdate())  -- past X months '05/06/2014'
    GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
    --HAVING count(*) > 10
    ORDER BY dtDate desc

/*
DB          	Date    	ErrorQty
SMI Reporting	07/23/2016	1
SMI Reporting	10/12/2015	1


AFCOReporting	10/05/2020	1
AFCOReporting	10/01/2020	2

*/


/************************************************************************/
-- TABLE GROWTH
exec spGetTableGrowth tblSKULocation
/*  tblSKULocation

    SMI Reporting
  Rows   	   Date
=========   ==========
1,847,856	2020.01.01
1,350,135	2019.01.01
1,540,305	2018.01.01
1,380,278	2017.01.01
1,150,301	2016.01.01
445,430	    2015.01.01	
307,518	    2014.01.01
241,389	    2013.01.01
165,903	    2012.03.01


    AFCO Reporting
 Rows     Date
======= ==========
 76,732	2020.10.01
 74,783	2020.01.01
139,781	2019.01.01
133,471	2018.01.01
294,144	2017.01.01
214,843	2016.01.01
 98,872	2015.01.01
 98,684	2014.01.01
 96,170	2013.10.01
*/

                                   
select ixLocation, FORMAT(count(*),'###,###') 'Records' 
from tblSKULocation 
group by ixLocation
order by ixLocation
/*
   SMI
Loc	  Qty   As Of
=== ======= ======
20	495,051 2020.10.9
47	495,051
85	495,051
99	495,051

  AFCO
Loc	  Qty   As Of
=== ======= ======
99	76,757  2020.10.9

*/
    



select distinct sError from tblErrorLogMaster -- 593 errors in past 3 days... 124 unique
where dtDate >= '10/09/2020'
    and ixErrorCode = 1126    
order by    sError 

-- all of the SKUs having issues are the 31 SKUs Jeff Carls asked Carol to manually insert into SOP
select * from tblSKU where ixSKU in ('6341334','6341721','63441733','63441773','63441783','63463506','63463508','63463515','63463516','63470037','63470077','63470087','63471431','63471471','63471481','63473037','63473077','63473087','63473137','63473177','63473187','63473506','63473508','63473515','63473516','63473631','63473671','63473681','63490037','63490077','63490087')

tblSKULocation Insert Error 91029012.P*85 [U2][SQL Client][ODBC][Microsoft][ODBC SQL Server Driver][SQL Server]Incorrect syntax near ','.

/**********************************
*****   REFEED FAILED SKUS   ******
***********************************/ 
-- REFED all failed SKUS from 11/1/2013 to 12/30/2013 @12/31/2013
                    
-- 1) COUNT ERRORS
    select * --count(*)  -- 74 total errors          
    from tblErrorLogMaster
    where dtDate >= '05/06/2014' --DATEADD(month, -1, getdate()) -- past X months
        and ixErrorCode = 1126   
and ixTime >= 43000
-- 2) EXTRACT SKUS from the sError field                                    
    -- 29 unique SKUs 
    TRUNCATE table [SMITemp].dbo.PJC_SKUs_toRefeed  
    
    INSERT into [SMITemp].dbo.PJC_SKUs_toRefeed                                 
    select distinct sError,
        (CASE when sError like '%*' then replace(substring(sError,29,200),'*%','')
              when sError like '%*' then replace(substring(sError,29,200),'*%','')
              else replace(substring(sError,29,200),' failed to update','')
              end
              )'ixSKU'
    from tblErrorLogMaster
    where ixErrorCode = 1126
        and dtDate >= '05/01/2014' -- dtDate >=  DATEADD(month, -1, getdate()) -- past X months
    order by 'ixSKU' 

    select ixSKU, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
    from tblSKU where ixSKU in ('1011001402','1825303','2752005','5478361','603CUSTOM','603WAIST','60528500','63012-A','63012-C','63025-BLK-7',
                                '6304000','820BC4812','820BC4912','820BC4941','820BCAC4872','820BCAC4912','820BCAC4931','820BZAC4871','820Z4872','820Z4912',
                                '820Z4971','820Z4981','820Z4981FH','820ZAC4912','820ZAC4931','820ZAC4981','820ZAC5041','820ZAC5091','9171015LSPH')

    select ixSKU, ixLocation, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
    from tblSKULocation where ixSKU in ('1011001402','1825303','2752005','5478361','603CUSTOM','603WAIST','60528500','63012-A','63012-C','63025-BLK-7',
                                '6304000','820BC4812','820BC4912','820BC4941','820BCAC4872','820BCAC4912','820BCAC4931','820BZAC4871','820Z4872','820Z4912',
                                '820Z4971','820Z4981','820Z4981FH','820ZAC4912','820ZAC4931','820ZAC4981','820ZAC5041','820ZAC5091','9171015LSPH')
    order by dtDateLastSOPUpdate desc, ixTimeLastSOPUpdate 
    
    
    
    
    select ixSKU, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
    from tblSKU where ixSKU in ('1011001402','1825303','2752005','5478361','603CUSTOM','603WAIST','60528500','63012-A','63012-C','63025-BLK-7',
                                '6304000','820BC4812','820BC4912','820BC4941','820BCAC4872','820BCAC4912','820BCAC4931','820BZAC4871','820Z4872','820Z4912',
                                '820Z4971','820Z4981','820Z4981FH','820ZAC4912','820ZAC4931','820ZAC4981','820ZAC5041','820ZAC5091','9171015LSPH')
    order by ixTimeLastSOPUpdate 
                                    
                                        
    -- HOW MANY EXIST IN tblSKU ?
    select * from tblSKU SKU -- 35 out of 35
    join [SMITemp].dbo.PJC_SKUs_toRefeed RF on SKU.ixSKU = RF.ixSKU
    
    
    -- BEFORE Reefeeding
     SELECT RF.ixSKU, 
        (CASE when TM.ixFinishedSKU is NULL then 'NO'
         else 'Y'
         end) as 'In_tblBOMTemplateMaster',
         CONVERT(VARCHAR, TM.dtDateLastSOPUpdate, 101) AS 'LastSOPUpdate', 
         TM.ixTimeLastSOPUpdate,  TM.flgDeletedFromSOP
    FROM [SMITemp].dbo.PJC_SKUs_toRefeed RF
        left join tblBOMTemplateMaster TM on RF.ixSKU = TM.ixFinishedSKU
    ORDER BY 'In_tblBOMTemplateMaster',TM.dtDateLastSOPUpdate,TM.ixTimeLastSOPUpdate  
       
      
    /*
    ixSKU	In_tblBOMTemplateMaster	LastSOPUpdate	ixTimeLastSOPUpdate	flgDeletedFromSOP
    634-1334	NO	NULL	NULL	NULL
    634-1721	NO	NULL	NULL	NULL
    634-41733	NO	NULL	NULL	NULL
    634-41773	NO	NULL	NULL	NULL
    634-41783	NO	NULL	NULL	NULL
    634-63506	NO	NULL	NULL	NULL
    ... etc. 
 
    */

    
-- 3) REFEED these SKUs from SOP
    select distinct ixSKU from [SMITemp].dbo.PJC_SKUs_toRefeed    

    select ixTime from tblTime where chTime = '10:32:00' -- 37920
    
    -- AFTER Reefeeding
     SELECT RF.ixSKU, 
        (CASE when TM.ixFinishedSKU is NULL then 'NO'
         else 'Y'
         end) as 'In_tblBOMTemplateMaster',
         CONVERT(VARCHAR, TM.dtDateLastSOPUpdate, 101) AS 'LastSOPUpdate', 
         TM.ixTimeLastSOPUpdate,  TM.flgDeletedFromSOP
    FROM [SMITemp].dbo.PJC_SKUs_toRefeed RF
        left join tblBOMTemplateMaster TM on RF.ixSKU = TM.ixFinishedSKU
    ORDER BY 'In_tblBOMTemplateMaster',TM.dtDateLastSOPUpdate,TM.ixTimeLastSOPUpdate  

    
    */
/*******   DONE   **********************/






select count(*) from tblBOMTransferMaster -- 44,940 
where dtDateLastSOPUpdate < '01/31/2014'    -- 44,881

select min(ixTimeLastSOPUpdate), max(ixTimeLastSOPUpdate) from tblBOMTransferMaster
42777	44310

select chTime from 

select count(*) from tblBOMTransferDetail --179943 
where dtDateLastSOPUpdate < '01/31/2014'    -- 179748


select * from tblErrorCode where ixErrorCode = 1160




/************* BEGIN CHECKS for DDC being permanently shut down **************/

            SELECT getdate() 'As of', ixLocation 'Loc', SUM(iQAV) 'TotQAV'
            from [SMI Reporting].dbo.tblSKULocation
            group by ixLocation
            order by ixLocation

            /*
            As of	            Loc	  TotQAV
            ================    === =========
            2016-05-05 13:12	47	  432,218
            2016-05-05 13:12	97	  368,745
            2016-05-05 13:12	98	  631,439
            2016-05-05 13:12	99	7,142,538
            */

            select * from tblLocation

            SELECT getdate() 'As of', ixLocation 'Loc', SUM(iQAV) 'TotQAV'
            from [AFCOReporting].dbo.tblSKULocation
            group by ixLocation
            order by ixLocation

            /*
            As of	            Loc	  TotQAV
            ================    === =========
            2016-05-05 13:13	30	  192,002
            2016-05-05 13:13    31	  192,027
            2016-05-05 13:13	68	  186,665
            2016-05-05 13:13	99	8,292,386

            2016-05-10 10:15	30	192,002
            2016-05-10 10:15	31	192,027
            2016-05-10 10:15	68	0
            2016-05-10 10:15	99	8,188,354
            */

            SELECT --S.ixSKU, sDescription, flgIntangible, flgDeletedFromSOP, dWeight, iLength, iWidth, iHeight, SL.iQAV, S.mPriceLevel1, (SL.iQAV*S.mPriceLevel1) 'ExtRetailValue'
                SL.ixLocation,
                SUM(SL.iQAV*S.mPriceLevel1) 'ExtRetailValue'
            from tblSKU S
            join [SMI Reporting].dbo.tblSKULocation SL on S.ixSKU = SL.ixSKU --and SL.ixLocation = 97
            where SL.iQAV <> 0
            and flgDeletedFromSOP = 0
            and flgIntangible = 0
            -- and S.ixSKU like '%LABOR%'
            GROUP BY SL.ixLocation
            order by (SL.iQAV*S.mPriceLevel1) desc




            SELECT SUM(SL.iQAV) 'TotQAV'               -- 8,574,725
            from [SMI Reporting].dbo.tblSKULocation SL -- 8,574,940
            JOIN [SMI Reporting].dbo.tblSKU S on S.ixSKU = SL.ixSKU
            WHERE S.flgDeletedFromSOP = 1



            SELECT SUM(SL.iQAV) 'TotQAV' 
            from [AFCOReporting].dbo.tblSKULocation SL -- 8,574,940
            JOIN [AFCOReporting].dbo.tblSKU S on S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = SL.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
            WHERE S.flgDeletedFromSOP = 1

            SELECT distinct ixSKU--, iQAV
            from [SMI Reporting].dbo.tblSKULocation 
            where ixSKU IN (select ixSKU from [SMI Reporting].dbo.tblSKU where flgDeletedFromSOP = 1)
            order by iQAV desc 

            SELECT distinct ixSKU
            from [AFCOReporting].dbo.tblSKULocation 
            where ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS IN (select ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS from [AFCOReporting].dbo.tblSKU where flgDeletedFromSOP = 1)

            SELECT * FROM [SMI Reporting].dbo.tblSKU where flgDeletedFromSOP = 0 and ixSKU NOT IN (select ixSKU FROM [SMI Reporting].dbo.tblSKULocation )

            SELECT * FROM [AFCOReporting].dbo.tblSKU where flgDeletedFromSOP = 0 and ixSKU  COLLATE SQL_Latin1_General_CP1_CI_AS NOT IN 
                                (select ixSKU  COLLATE SQL_Latin1_General_CP1_CI_AS FROM [AFCOReporting].dbo.tblSKULocation )


/************* END CHECKS for DDC being permanently shut down **************/

