-- tblSKU Checks

/**************** ERROR CODES & ERROR LOG history ***********************/

SELECT * from tblErrorCode where sDescription like '%tblSKU%'
--  ixErrorCode	sDescription
--  1163	    Failure to update tblSKU.


-- ERROR COUNTS by Day
SELECT DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1163'
  and dtDate >=  DATEADD(dd, -100, getdate())  -- past X days
GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
--HAVING count(*) > 10
ORDER BY dtDate desc
/*                              Error
    DB          	Date    	Qty
    SMI Reporting	01/09/2020	1082
    SMI Reporting	10/08/2019	2009
    SMI Reporting	08/21/2019	5
    SMI Reporting	07/16/2019	32
    SMI Reporting	07/12/2019	4
    SMI Reporting	07/11/2019	4
    SMI Reporting	07/10/2019	4
    SMI Reporting	07/09/2019	4
    SMI Reporting	06/28/2019	10
    SMI Reporting	06/27/2019	20
    SMI Reporting	06/24/2019	40
    SMI Reporting	04/22/2019	10
    SMI Reporting	04/11/2019	5
    SMI Reporting	04/10/2019	5
    SMI Reporting	04/05/2019	10
    SMI Reporting	04/04/2019	10
    SMI Reporting	04/03/2019	15
    SMI Reporting	03/29/2019	5
    SMI Reporting	03/28/2019	10
    SMI Reporting	03/22/2019	20
    SMI Reporting	03/13/2019	5
    SMI Reporting	03/08/2019	5
    SMI Reporting	03/06/2019	5
    SMI Reporting	02/27/2019	10
    SMI Reporting	02/26/2019	15
    SMI Reporting	02/22/2019	5
    SMI Reporting	02/19/2019	10
    SMI Reporting	02/12/2019	10
    SMI Reporting	02/04/2019	10
    SMI Reporting	01/25/2019	5
    SMI Reporting	12/11/2018	10
    SMI Reporting	12/29/2017	10>  >-- all 212 failed SKUs from 12/29/2017 to 12/11/2019 refed with no issues
    SMI Reporting	12/27/2017	215  >-- all failed SKUs from 07/21/2016 to 12/27/2017 refed with no issues

    SMI Reporting	07/21/2016	742
    SMI Reporting	06/29/2016	52   \
    SMI Reporting	06/22/2016	36    \
    SMI Reporting	06/21/2016	16     > 26 dif BOX SKUs (e.g. BOX-104, BOX-105 etc)
    SMI Reporting	06/16/2016	44    /
    SMI Reporting	06/14/2016	80   /
    
    SMI Reporting	04/01/2016	5686
    
    SMI Reporting	06/30/2014	300    
    SMI Reporting	03/20/2014	1331
    
    AFCOReporting	09/23/2020	10
    AFCOReporting	09/10/2020	6
    AFCOReporting	09/01/2020	1
    AFCOReporting	08/26/2020	24
    AFCOReporting	07/30/2020	14
    AFCOReporting	07/07/2020	2
    AFCOReporting	07/06/2020	2
    AFCOReporting	05/05/2020	1
    AFCOReporting	04/24/2020	1
    AFCOReporting	04/01/2020	3
    AFCOReporting	01/09/2020	119
    AFCOReporting	06/24/2019	5
    AFCOReporting	02/14/2019	5
    AFCOReporting	12/19/2018	10
    AFCOReporting	10/15/2018	5
    AFCOReporting	05/14/2018	35  \
    AFCOReporting	05/10/2018	70   >-- all failed SKUs from 05/09/18 to 05/14/18 refed with no issues
    AFCOReporting	05/09/2018	20  /
    AFCOReporting	01/24/2018	5
    AFCOReporting   02/10/2017	5302    -- ixProductLine was incorrectly commented out. >-- all failed SKUs refed with no issues
    AFCOReporting	08/14/2015	333
    AFCOReporting	01/26/2015	60
*/


/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblSKU
/*      tblSKU	
DB          	Rows   	Date        New Rows 
=============   ======= ========    ===========
SMI Reporting	473,109	01-01-20    33K in 2019
SMI Reporting	440,996	01-01-19    44K in 2018
SMI Reporting	396,973	01-01-18    58K in 2017
SMI Reporting	338,240	01-01-17    43K in 2016
SMI Reporting	295,162	01-01-16    67K in 2015
SMI Reporting	227,832	01-01-15    55K in 2014
SMI Reporting	173,776	01-01-14    37K in 2013
SMI Reporting	137,004	01-01-13 
SMI Reporting	 94,411	03-01-12

AFCOReporting	76,289	01-01-20    5k in 2019
AFCOReporting	72,723	01-01-19    5k in 2018
AFCOReporting	68,130	01-01-18    8k in 2017
AFCOReporting	60,333	01-01-17    5k in 2016
AFCOReporting	55,117	01-01-16    5k in 2015
AFCOReporting	50,494	01-01-15    3k in 2014
AFCOReporting	47,683	01-01-14
AFCOReporting	46,340	10-01-13
*/

-- SKUs created by Yr (excludes deleted SKUs)
SELECT  DB_NAME() AS 'DB          ',
    FORMAT(COUNT(S.ixSKU),'###,##0') as SKUQty,
    D.iYear
FROM tblSKU S
    left JOIN tblDate D on S.ixCreateDate = D.ixDate
  --  JOIN vwGarageSaleSKUs GS on GS.ixSKU = S.ixSKU   <-- to see how many are GS (roughly 
WHERE S.flgDeletedFromSOP = 0
--and D.iYear > 2012
and S.ixSKU NOT LIKE 'UP%' -- excluding GS SKUs
GROUP BY D.iYear
ORDER BY D.iYear DESC 
/*              NEW SKUs
DB              CREATED   YR
SMI Reporting	28,771	2018   
SMI Reporting	46,003	2017
SMI Reporting	28,844	2016
SMI Reporting	54,332	2015
SMI Reporting	41,569	2014
SMI Reporting	27,667	2013
SMI Reporting	28,491	2012
SMI Reporting	 8,293	2011
SMI Reporting	62,071	<2011

AFCOReporting	1,007	2018    <-- as of 5/16/18
AFCOReporting	7,473	2017
AFCOReporting	3,879	2016
AFCOReporting	2,856	2015
AFCOReporting	1,726	2014
AFCOReporting	2,700	2013
AFCOReporting  41,520	<2013
*/

        -- GARAGE SALE SKUs created by Yr (excludes deleted SKUs)
        SELECT  DB_NAME() AS 'DB          ',
            COUNT(S.ixSKU) SKUQty,
            D.iYear
        FROM tblSKU S
            left JOIN tblDate D on S.ixCreateDate = D.ixDate
            left JOIN vwGarageSaleSKUs GS on GS.ixSKU = S.ixSKU -- to see how many are GS (roughly 
        WHERE S.flgDeletedFromSOP = 0
            --and S.ixSKU NOT LIKE 'UP%'
            --and D.iYear > 2012
            and GS.ixSKU is NOT NULL
        GROUP BY D.iYear
        ORDER BY D.iYear DESC 
        /*              NEW SKUs
        DB              CREATED   YR
        SMI Reporting	 6,190	2018     
        SMI Reporting	 7,587	2017
        SMI Reporting	 8,107	2016
        SMI Reporting	 9,621	2015
        SMI Reporting	12,473	2014
        SMI Reporting	7,566	2013
        SMI Reporting	7,278	2012
        SMI Reporting   18,987	<2012
        */

/***************** DATA FRESHNESS *************************************/
SELECT DB_NAME() AS 'DB          '
    ,CONVERT(varchar, GETDATE(), 110) AS 'DateChecked'
    ,DaysOld 
    ,REPLACE(CONVERT(varchar, CAST(Records AS money), 1), '.00', '') 'Records'
FROM vwDataFreshness 
WHERE sTableName = 'tblSKU'
order by DaysOld

/*
DB          	DateChecked	DaysOld	Records
=============   =========== ======= =======
SMI Reporting	01-09-2020	   <=1	 25,957
SMI Reporting	01-09-2020	   2-7	174,952
SMI Reporting	01-09-2020	  8-30	 57,913
SMI Reporting	01-09-2020	 31-180	204,099

SMI Reporting	01-11-2019	   <=1	 36,156
SMI Reporting	01-11-2019	   2-7	 82,682
SMI Reporting	01-11-2019	  8-30	 95,225
SMI Reporting	01-11-2019	 31-180	216,727

SMI Reporting	10-30-2018	   <=1	19,196
SMI Reporting	10-30-2018	   2-7	103,928
SMI Reporting	10-30-2018	  8-30	259,323
SMI Reporting	10-30-2018	 31-180	44,209

SMI Reporting	05-16-2018	   <=1	57,239
SMI Reporting	05-16-2018	   2-7	61,427
SMI Reporting	05-16-2018	  8-30	51,206
SMI Reporting	05-16-2018	 31-180	237,189
SMI Reporting	05-16-2018	181 +	152

SMI Reporting	02-13-2017	   <=1	83,119
SMI Reporting	02-13-2017	   2-7	50,208
SMI Reporting	02-13-2017	  8-30	136,144
SMI Reporting	02-13-2017	 31-180	69,010

SMI Reporting	06-30-2016	   <=1	27,056
SMI Reporting	06-30-2016	   2-7	111,579
SMI Reporting	06-30-2016	  8-30	170,091
SMI Reporting	06-30-2016	 31-180	  3,601

SMI Reporting	08-07-2015	   <=1	 47,879
SMI Reporting	08-07-2015	   2-7	 91,275
SMI Reporting	08-07-2015	  8-30	135,604
SMI Reporting	08-07-2015	  31+	      0



AFCOReporting	10-30-2018	   <=1	2,768
AFCOReporting	10-30-2018	   2-7	16,477
AFCOReporting	10-30-2018	  8-30	49,236
AFCOReporting	10-30-2018	 31-180	107

AFCOReporting	02-23-2018	   <=1	 4,972
AFCOReporting	02-23-2018	   2-7	13,586
AFCOReporting	02-23-2018	  8-30	 1,603
AFCOReporting	02-23-2018	 31-180	21,192
AFCOReporting	02-23-2018	181 +	26,201
*/
 
       
    SELECT *   -- 186 total errors   (25 unique SKUs)
    from tblErrorLogMaster
    where dtDate >=  '01/01/2020' --DATEADD(month, -1, getdate()) -- past X months
        and ixErrorCode = 1163 
     --   and sError LIKE '%permission was denied%'  
        and sError LIKE '%expects parameter%'
    ORDER BY ixTime    --  1,086
    -- permission denied -- 50
    -- expects parameter X which was not supplied -- 1,199
    SELECT sError, count(*)   -- 186 total errors   (25 unique SKUs)
    from tblErrorLogMaster
    where dtDate >=  '01/01/2020' --DATEADD(month, -1, getdate()) -- past X months
        and ixErrorCode = 1163   
    group by sError
    ORDER BY ixTime    

            SELECT ixSKU, sDescription, ixPGC, ixCreator, dtCreateDate from tblSKU where dtCreateDate >= '06/14/2016'
            and ixSKU like 'UP%'
            
            SELECT ixSKU, sDescription, dtDateLastSOPUpdate, ixTimeLastSOPUpdate, flgActive, flgDeletedFromSOP
            from tblSKU
            where ixSKU in ('CMBB1','CMBB2','CMBB4','CMBB6','CMBB7','0000507','0000532','0000646','0000647','0001138','CMBB0.5','CMBB1.5','CMBB2.5','CMBB0.25','0000429.03','0000438.10','0000508.21','0000510.01','0000534.01','0000644.01','0000644.02','0000644.03','0001096.03','0001138.01','PRADJ5-000')
                        --between 'BOX-101' and 'BOX-192' -- ('BOX-101','BOX-103','BOX-104','BOX-107','BOX-108','BOX-109','BOX-111','BOX-112','BOX-116','BOX-117','BOX-123','BOX-130','BOX-135','BOX-147','BOX-151','BOX-155','BOX-161','BOX-170','BOX-177','BOX-178')
                and flgDeletedFromSOP = 0
            ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate
            
           
/**********************************
*****   REFEED FAILED SKUS   ******
***********************************/ 
-- REFED all failed SKUS from 11/1/2013 to 12/30/2013 @12/31/2013
                    
-- 1) COUNT ERRORS
    SELECT count(*)  -- 687 total errors          
    from tblErrorLogMaster
    where dtDate >= '09/01/2020' --DATEADD(month, -1, getdate()) -- past X months
        and ixErrorCode = 1163   

-- 2) EXTRACT SKUS from the sError field                                    
    -- 212 unique SKUs 
    -- DROP TABLE [SMITemp].dbo.PJC_SKUs_toRefeed
    TRUNCATE table [SMITemp].dbo.PJC_SKUs_toRefeed  
    
    INSERT into [SMITemp].dbo.PJC_SKUs_toRefeed                                 
    SELECT distinct sError,
        (CASE when sError like '%*47 failed to update' then replace(substring(sError,5,200),'*47 failed to update [U2][SQL Client][ODBC][Microsoft][ODBC SQL Server Driver][SQL Server]The EXECUTE permission was denied on the object ''spUpdateSKU'', database ''SMI Reporting'', schema ''dbo''.','')
              when sError like '%*99 failed to update' then replace(substring(sError,5,200),'*99 failed to update','')
             -- else replace(substring(sError,5,27),' failed to update','')
              end
              )'ixSKU'
    --into [SMITemp].dbo.PJC_SKUs_toRefeed               
    from tblErrorLogMaster
    where dtDate >= '09/01/2020' -- DATEADD(month, -1, getdate()) -- past X months
        and ixErrorCode = 1163    
    ORDER BY 'ixSKU' 

    SKU 1011001108*47 failed to update [U2][SQL Client][ODBC][Microsoft][ODBC SQL Server Driver][SQL Server]The EXECUTE permission was denied on the object 'spUpdateSKU', database 'SMI Reporting', schema 'dbo'.
    
SELECT ixSKU, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblSKU 
where ixSKU in ('1011001108','105170036','12119301685','121401126','121CP55LTRB','1240115-BK/S-10','131545','201729','2058926','282111000P1','282159','2821590','282159012','282211001P1','282271100P1','282311000P3','282311038P1','282311098P1','282371000P1','282371000P2','282371000P3','282371000P4','282371002P1','282371038P1','282371100P1','282371100P2','282371402P1','282411400P1','282950600','282950610','282950620','282950630','282950640','282950641','282950650','282950655','31177232520','318101','318104-CHR','3241024901','3259300','350810.2','35512498544','35512611424','35519210009','40812775','425120007','42516567HKR','42522112','425562047ERL','425RM6057SFI','447H7260','447H7265','452645-BLK-CLG','45736050','55528001','57100','580557WL','59240501','60715206','60757906','6171724','6173413','6179022','6741496-WHT','7022852F','721HK02GMF1','72819417','72851885','79570506','9100081','91001024','91001026','91001258','91001259','91001262','91001280','91004600-36','91004754.45','910056-XL','910056-XXL','9100814','9100820','9100822','9100826','9100842','9100843','9100844','9100845','9100847','9100848','9100849','91010051','9101019','91011075','91011159','91011212','9101155','9101255','9101256','9101257','9101263','91012705','9101284','9101287','9101353','9101356','9101366','9101376','91013761','91013894','91017807','9101965','9101968-SIL-15X7','91020210','91020225','91022210','91022225','91028075.1','91028200.1','91028200.2','910310','91031315-1/2','9103160','91032105','91032189','91032498','91034514-L','91035127-44','91035127-46','91035127-48','91035127-50','91035127-CUSTOM','91035127.1-44','91035127.1-46','91035127.1-48','91035127.1-50','91035128-44','91035128-46','91035128-48','91035128-50','91035128-CUSTOM','91035128.1-44','91035128.1-46','91035128.1-48','91035128.1-50','910382011','91043107','910454','91046222','91048345-28-300','91048345-31-300','91048345-31-325','91048424.58.1','91048424.60.1','91048425.62.1','91053453','91054730','9106120','9106200','91062980-6','91066415','91072304','91076522.1.1','91076522.1.2','91088417-99','91088519-99','91088520-99','91088522-99','91088523-99','91088805-99','91088RACE','9109990','910AFCORACE17','91123332','91127004-L','91127004-R','91134000','91139604','913390000','91603540','91657007','91657055','91657057','91658000','92610485','92611753','92613391','92616838','92618458','92633916-L','92633916-M','92633916-XL','92633916-XXL','92633916-XXXL','9300099','94091111','95637101-.25','95637101-.50','95637101-1.0','96012822','97456930','97617400','AUP4562','AUP4575','AUP5738','AUP5755','AUP5771','BOX-171','INS201802','TECHELP-DTS','TECHELP-HAP','UP9886')
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate desc
-- 43997
SELECT S.ixSKU, S.dtDateLastSOPUpdate 
FROM [SMITemp].dbo.PJC_SKUs_toRefeed RF
 join tblSKU S on RF.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
where S.flgDeletedFromSOP = 0
and dtDateLastSOPUpdate = '02/13/17' -- 1,358
order by dtDateLastSOPUpdate

select COUNT(*) from tblSKU
where flgDeletedFromSOP = 0 -- 338,481
    
SELECT DB_NAME() AS 'DB          ',* 
from tblLocation
/*
DB          	ixLocation	sDescription	            ixState
AFCOReporting	30	        Eagle	                    NE
AFCOReporting	31	        Trackside Support Services	NE
AFCOReporting	68	        Lincoln	                    NE
AFCOReporting	99	        Boonville	                IN

SMI Reporting	47	        Boonville	                IN
SMI Reporting	97	        Trackside Support Services	NE
SMI Reporting	98	        Eagle	                    NE
SMI Reporting	99	        Lincoln	                    NE
*/
    
    -- HOW MANY EXIST IN tblSKU ?
    SELECT * from tblSKU SKU -- 37
    JOIN [SMITemp].dbo.PJC_SKUs_toRefeed RF on SKU.ixSKU = RF.ixSKU
    

    -- BEFORE Reefeeding
    SELECT RF.ixSKU, 
        (CASE when SKU.ixSKU is NULL then 'NO'
         else 'Y'
         end) as 'In_tblSKU',
         CONVERT(VARCHAR, SKU.dtDateLastSOPUpdate, 101) AS 'LastSOPUpdate', 
         SKU.ixTimeLastSOPUpdate,  SKU.flgDeletedFromSOP
    FROM [SMITemp].dbo.PJC_SKUs_toRefeed RF
        left JOIN tblSKU SKU on RF.ixSKU = SKU.ixSKU
    ORDER BY 'In_tblSKU',SKU.dtDateLastSOPUpdate,SKU.ixTimeLastSOPUpdate    
    /*
    ixSKU	In_tblSKU	LastSOPUpdate	ixTimeLastSOPUpdate	flgDeletedFromSOP
    67401203-WHT-36	Y	12/12/2014	    26226	            0                   <-- oldest
    .
    .
    .
    6741244S-RED-40	Y	12/15/2014	    58480	            0                   <-- most recent
 
    */

    
-- 3) REFEED these SKUs from SOP
    SELECT distinct ixSKU from [SMITemp].dbo.PJC_SKUs_toRefeed    

    SELECT ixTime from tblTime where chTime = '10:32:00' -- 37920
    
    -- AFTER Reefeeding
    SELECT RF.ixSKU, 
        (CASE when SKU.ixSKU is NULL then 'NO'
         else 'Y'
         end) as 'In_tblSKU',
         CONVERT(VARCHAR, SKU.dtDateLastSOPUpdate, 101) AS 'LastSOPUpdate',
         SKU.ixTimeLastSOPUpdate,  SKU.flgDeletedFromSOP
    FROM [SMITemp].dbo.PJC_SKUs_toRefeed RF
            left JOIN tblSKU SKU on RF.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    ORDER BY 'In_tblSKU',SKU.dtDateLastSOPUpdate,SKU.ixTimeLastSOPUpdate  

    /* ALL refed except for 
    67401157
    */
/*******   DONE   **********************/


-- general checks
  
/*
Table	RowCount	Non-DeletedSkuCount	ActiveCount	RunDate	NonDelMinUpdate	MaxUpdate	NULLUpdate
tblSKU	157343	149723	112725	2013-05-06 10:39:21.237	2013-03-05	2013-05-06	0

Table	RowCnt	Non-DelSkuCnt	ActiveCount	RunDate	    NonDelMinUPD	MaxUpdate	NULLUpdate
tblSKU	157343	149723	        12725	    05/06/2013	03/05/2013	    05/06/2013	0
 */



/****************** tblSKU flags ******************/

select ixSKU, sDescription, flgActive, flgAdditionalHandling, flgShipAloneStatus, flgUnitOfMeasure, flgBackorderAccepted, flgORMD, flgMSDS 
    , dtCreateDate, dtDiscontinuedDate, dtDateLastSOPUpdate
from tblSKU
where flgDeletedFromSOP = 0
    AND (flgUnitOfMeasure is NULL
           or flgTaxable is NULL    
           or flgActive is NULL
           or flgAdditionalHandling is NULL
           or flgIsKit is NULL
           or flgShipAloneStatus is NULL           
           or flgIntangible is NULL           
           or flgMadeToOrder is NULL
           or flgDeletedFromSOP is NULL          
           or flgBackorderAccepted is NULL        
           or flgORMD is NULL
           or flgMSDS is NULL
)

select * from tblOrderLine where ixSKU = 'M3T0.16G01Q'

select * from tblSKU where ixSKU = 'M3T0.16G01Q'
select ixSKU, sDescription, flgDeletedFromSOP from tblSKU where ixSKU = '999'
-- Temp SKU for misc purposes - DO NOT FLAG AS DELETED FROM SOP
/*
ixSKU	sDescription	flgDeletedFromSOP
999	Temp SKU for misc purposes - DO NOT FLAG AS DELETED FROM SOP	1
*/

/*
-- DWSTAGING ONLY!
BEGIN TRAN

    update tblSKU
    set flgORMD = 0
    where ixSKU = '999'
    
ROLLBACK TRAN    
*/

select distinct flgUnitOfMeasure, count(*) 
from tblSKU
where flgDeletedFromSOP = 0
group by flgUnitOfMeasure
order by count(*) desc






-- Active, Non GS, Non Del SKUs that 
-- haven't been updated in the last X days
SELECT ixSKU,flgActive, dtCreateDate, dtDateLastSOPUpdate
from tblSKU
where flgDeletedFromSOP = 0
    and dtDateLastSOPUpdate < DATEADD(day, -43, GetDate()) -- try to all updated within last 30 days
    and flgActive = 1
    and ixSKU NOT like 'UP%'
    and ixSKU NOT like 'AUP%'    
ORDER BY dtDateLastSOPUpdate -- ixSKU, dtCreateDate
-- 9,125 kicked off 13:52

    
/****** SEMA checks **********************************/
-- Active, Non GS, Non Del, Tangible SKUs 
SELECT count(*) as 'w/o SEMAValues' -- 19,320 @5-6-2013
from tblSKU                         -- 19,170 @12-21-2013
where flgDeletedFromSOP = 0         -- 23,196 @1-28-2014
    and flgActive = 1
    and ixSKU NOT like 'UP%'
    and flgIntangible = 0    
    and (sSEMACategory is NULL
         or sSEMASubCategory is NULL
         or sSEMAPart is NULL)
GO         
SELECT count(*) as 'w SEMAValues' -- 72,207
from tblSKU
where flgDeletedFromSOP = 0
    and flgActive = 1
    and ixSKU NOT like 'UP%'
    and flgIntangible = 0
    and (sSEMACategory is NOT NULL
         AND sSEMASubCategory is NOT NULL
         AND sSEMAPart is NOT NULL) 
/*   
w/o         with        As          %
SEMAValues  SEMAValues  of          Categorized
18,831      72,179      04/08/13    79.3%
     
*/         

-- active SKUs shipped in last 90 days with no SEMAValues         
-- excludes:
-- SKUs starting with UP
SELECT 
    SKU.ixSKU, SKU.sDescription,
    SKU.ixPGC,
    SKU.dtCreateDate, SKU.ixCreator,
    SKU.ixBrand,  
    VS.ixVendor         as 'Current PV#',
    V.sName             as 'PV Name',
    sum(OL.iQuantity)   as'QtyShipped'
from tblSKU SKU
    JOIN tblOrderLine OL on OL.ixSKU = SKU.ixSKU
    JOIN tblOrder O on OL.ixOrder = O.ixOrder
    JOIN tblVendorSKU VS on VS.ixSKU = SKU.ixSKU
    JOIN tblVendor V on V.ixVendor = VS.ixVendor
where SKU.flgDeletedFromSOP = 0
    and SKU.flgActive = 1
    and SKU.ixSKU NOT like 'UP%'
    and (SKU.sSEMACategory is NULL
         or SKU.sSEMASubCategory is NULL
         or SKU.sSEMAPart is NULL)
    and O.dtShippedDate >= '01/08/2013'    
    and OL.flgLineStatus in ('Shipped','Dropshipped')
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and VS.iOrdinality = 1
GROUP BY     SKU.ixSKU, 
    SKU.sDescription,
    SKU.ixPGC,
    SKU.dtCreateDate,
    SKU.ixCreator,
    SKU.ixBrand,
    VS.ixVendor,
    V.sName
ORDER BY VS.ixVendor
/*******   DONE   **********************/                  
  
/*******    INSERTING DELETED SKUs to satisty FK restraints     *******/
insert tblSKU (
    ixSKU, mPriceLevel1, mPriceLevel2, mPriceLevel3, mPriceLevel4, mPriceLevel5, mLatestCost, mAverageCost, ixPGC, sDescription, flgUnitOfMeasure, flgTaxable, 
    /*iQAV and iQOS do not use!*/ ixCreateDate, dtCreateDate, ixRoyaltyVendor, ixDiscontinuedDate, dtDiscontinuedDate, flgActive, sBaseIndex, dWeight, 
    sOriginalSource, flgAdditionalHandling, ixBrand, ixOriginalPart, ixHarmonizedTariffCode, flgIsKit, iLength, iWidth, iHeight, iMaxQOS, iRestockPoint, flgShipAloneStatus, flgIntangible, ixCreator, iLeadTime, flgMadeToOrder,ixForecastingSKU,
    flgDeletedFromSOP,iMinOrderQuantity, sCountryOfOrigin, sAlternateItem1, sAlternateItem2, sAlternateItem3, flgBackorderAccepted,
    dtDateLastSOPUpdate,ixTimeLastSOPUpdate,
    ixReasonCode, sHandlingCode, ixProductLine, sWebUrl, sWebDescription, mMSRP, iDropshipLeadTime, ixCAHTC )
values
    ('9193382-4',/*ixSKU*/    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL, 
    'DELETED FROM SOP',/*sDescription*/ NULL,NULL,NULL,NULL,NULL,NULL,NULL, 
    0,/*flgActive*/ NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL, NULL,NULL,NULL,NULL,NULL,NULL,NULL, 
    1,/*flgDeletedFromSOP*/   NULL,NULL,NULL,NULL,NULL,NULL, 
    DATEADD(dd,0,DATEDIFF(dd,0,getdate())),/*dtDateLastSOPUpdate*/ 
    dbo.GetCurrentixTime (),/*ixTimeLastSOPUpdate*/
    NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)








-- refeed all SKUs currently flagged as Deleted From SOP 
SELECT ixSKU from tblSKU where flgDeletedFromSOP = 1 -- 7,766
    and dtDateLastSOPUpdate < '12/02/2013'
    
    

SELECT count(*) from tblSKU where dtDateLastSOPUpdate = '02/20/2014' and ixTimeLastSOPUpdate > 32400





SELECT ixSKU, dtCreateDate, ixCreator, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblSKU
where ixSKU in ('282159','410740','410740','410740','410740','445251','447304','540115','550052','550150','550179','550200','550916','91028A','917600','917601','930C7H','960530','960532','960533','960540','NCSHIP','PLONLY')
ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate

SELECT * from tblTime where ixTime = 48646




/**************************************************** 
 ****** TESTING when adding new fields **************
 ****************************************************/
 
    /********   SMI     ********/
    SELECT sCycleCode, count(*) Qty
    from [SMI Reporting].dbo.tblSKU
    GROUP BY sCycleCode
    ORDER BY sCycleCode
    /*
    sCycleCode	Qty
    NULL	281619
    .98	    1
    0	    257
    0.00	1
    0000	1
    192.83	3
    39.95	11
    A	    479
    B	    697
    C	    1514
    D	    860
    K	    47
    N	    40
    NN	    1 
    */
    set rowcount 30000 -- set rowcount = 0
    UPDATE tblSKU
    set sCycleCode = 0
    where sCycleCode is NUll
    
        -- test records
        SELECT ixSKU, sCycleCode, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM [SMI Reporting].dbo.tblSKU
        WHERE ixSKU in ('91315484','91315444','91315459')
        /*                  dtDateLast  ixTime
        ixSKU	    sCycleCode	SOPUpdate	LastSOPUpdate
        4988800	    1	    2015-09-02	49139
        91034558-9	0	    2015-09-02	49140
        UP6792	    0	    2015-09-02	49141
        */


    /********   AFCO     ********/
    SELECT sCycleCode, count(*) Qty
    from [AFCOReporting].dbo.tblSKU
    GROUP BY sCycleCode
    ORDER BY sCycleCode
    /*
    sCycleCode	Qty
    NULL	48836
    3PLAB	1
    COMP	1567
    cycle c	1
    DISC	135
    DLML	187
    DMOD	954
    DPLM	55
    DRAG	102
    EXPENSE	2
    MODI	113
    N	    2
    OWHE	535
    PLAB	132
    PLML	100
    PMOD	100
    QMID	86
    SCMO	1
    SMI	    2
    SROD	26
    SSDM	43
    SSMO	19
    SSTO	12
    STRUT	3 
    */

        -- test records
        SELECT ixSKU, sCycleCode, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        FROM [AFCOReporting].dbo.tblSKU
        WHERE ixSKU in ('90002292','169201SA','3865SP')
        /*                      dtDateLast  ixTime
        ixSKU	    sCycleCode	    SOPUpdate	LastSOPUpdate
        89099-L	    0	        2015-09-02	49444
        89099-M	    1	        2015-09-02	49297
        */


-- DROPSHIP only SKUs
SELECT sPickingBin, COUNT(ixSKU)
from tblSKULocation -- 74,939
where ixLocation = 99
and sPickingBin LIKE '%999%'
--and iQAV > 0
GROUP BY sPickingBin
ORDER BY COUNT(ixSKU)
/*
sPickingBin	QTY
9999	    43,435 @01/06/16
*/




/******      SKU Breakdown      ********/

SELECT COUNT(S.ixSKU) 
FROM tblSKU S                 --  391,915 total records
WHERE S.flgDeletedFromSOP = 0 --  381,344 SKUs not deleted from SOP



        /*****      the following three groups have OVERLAP.  e.g. an innactive SKU can be a GS SKU and start with UP     ******/
            SELECT COUNT(S.ixSKU) 
            FROM tblSKU S                 
            WHERE S.flgDeletedFromSOP = 0 
                and S.flgActive = 1     --  259,911 Active SKUs
                

            SELECT COUNT(S.ixSKU) 
            FROM tblSKU S                 
                join vwGarageSaleSKUs GS on S.ixSKU = GS.ixSKU    
            WHERE S.flgDeletedFromSOP = 0   --  70,075 GS SKUs    
                
                
            SELECT COUNT(S.ixSKU) 
            FROM tblSKU S                 
            WHERE S.flgDeletedFromSOP = 0 
                and S.ixSKU LIKE 'UP%'       --  88,007 UP SKUs    
        



SELECT COUNT(S.ixSKU) 
FROM tblSKU S
    left join vwGarageSaleSKUs GS on S.ixSKU = GS.ixSKU
where S.flgDeletedFromSOP = 0 --  381,344
    and S.flgActive = 1       --  259,911
    and GS.ixSKU is NULL      --  248,111    
    and S.ixSKU NOT LIKE 'UP%'--  224,262



