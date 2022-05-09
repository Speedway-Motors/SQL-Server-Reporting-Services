-- tblInventoryForecast Checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select ixErrorCode,ixErrorType,sDescription
from tblErrorCode where sDescription like '%tblInventoryForecast%'
/*
ixErrorCode	ixErrorType	sDescription
1174	    SQLDB	    Failure to update tblInventoryForecast.
*/

-- ERROR COUNTS by Day
SELECT DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1174'
  and dtDate >=  DATEADD(month, -11, getdate())  -- past X months
GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
-- HAVING count(*) > 10
ORDER BY dtDate desc
/*
    DB          	Date    	ErrorQty
    SMI Reporting	02/04/2019	22
    SMI Reporting	02/03/2019	37
    SMI Reporting	02/02/2019	40
    SMI Reporting	02/01/2019	49
    SMI Reporting	01/31/2019	22
    SMI Reporting	01/29/2019	6
    SMI Reporting	01/28/2019	38
    SMI Reporting	01/04/2019	2
    SMI Reporting	12/31/2018	13
    SMI Reporting	12/19/2018	13
    SMI Reporting	12/18/2018	24
    SMI Reporting	11/16/2018	1
    SMI Reporting	11/06/2018	1
    SMI Reporting	10/17/2018	2
    SMI Reporting	10/12/2018	1
    SMI Reporting	10/11/2018	37
    SMI Reporting	10/10/2018	26
    SMI Reporting	10/09/2018	5
    SMI Reporting	09/11/2018	1
    SMI Reporting	09/07/2018	5
    SMI Reporting	09/06/2018	16
    SMI Reporting	09/05/2018	6
    SMI Reporting	09/04/2018	4
    SMI Reporting	09/03/2018	1
    SMI Reporting	09/02/2018	1
    SMI Reporting	09/01/2018	1
    SMI Reporting	08/31/2018	4
    SMI Reporting	08/30/2018	2
    SMI Reporting	08/29/2018	2
    SMI Reporting	08/28/2018	2
    SMI Reporting	08/27/2018	2
    SMI Reporting	08/26/2018	2
    SMI Reporting	08/25/2018	2
    SMI Reporting	08/24/2018	2
    SMI Reporting	08/23/2018	2
    SMI Reporting	08/22/2018	2
    SMI Reporting	08/21/2018	2
    SMI Reporting	08/20/2018	2
    SMI Reporting	08/19/2018	2
    SMI Reporting	08/18/2018	2
    SMI Reporting	08/17/2018	2
    SMI Reporting	08/16/2018	2
    SMI Reporting	08/15/2018	3
    SMI Reporting	08/14/2018	2
    SMI Reporting	08/13/2018	1
    SMI Reporting	08/12/2018	2
    SMI Reporting	08/11/2018	2
    SMI Reporting	08/10/2018	2
    SMI Reporting	08/09/2018	2
    SMI Reporting	08/08/2018	2
    SMI Reporting	08/07/2018	2
    SMI Reporting	08/06/2018	2
    SMI Reporting	08/05/2018	2
    SMI Reporting	08/04/2018	2
    SMI Reporting	08/03/2018	2
    SMI Reporting	08/02/2018	2
    SMI Reporting	08/01/2018	2
    SMI Reporting	07/31/2018	2
    SMI Reporting	07/30/2018	2
    SMI Reporting	07/29/2018	2
    SMI Reporting	07/28/2018	2
    SMI Reporting	07/27/2018	2
    SMI Reporting	07/26/2018	2
    SMI Reporting	07/25/2018	2
    SMI Reporting	07/24/2018	2
    SMI Reporting	07/23/2018	2
    SMI Reporting	07/22/2018	2
    SMI Reporting	07/21/2018	2
    SMI Reporting	07/20/2018	2
    SMI Reporting	07/19/2018	114
    SMI Reporting	07/18/2018	601
    SMI Reporting	07/17/2018	2
    SMI Reporting	07/16/2018	2
    SMI Reporting	07/15/2018	2
    SMI Reporting	07/14/2018	2
    SMI Reporting	07/13/2018	2
    SMI Reporting	07/12/2018	2
    SMI Reporting	07/11/2018	2
    SMI Reporting	07/10/2018	4
    SMI Reporting	07/09/2018	2
    SMI Reporting	07/08/2018	3
    SMI Reporting	07/07/2018	1
    SMI Reporting	07/06/2018	2
    SMI Reporting	07/05/2018	2
    SMI Reporting	07/04/2018	2
    SMI Reporting	07/03/2018	2
    SMI Reporting	07/02/2018	2
    SMI Reporting	07/01/2018	2
    SMI Reporting	06/30/2018	2
    SMI Reporting	06/29/2018	2
    SMI Reporting	06/28/2018	2
    SMI Reporting	06/27/2018	2
    SMI Reporting	06/26/2018	2
    SMI Reporting	06/25/2018	2
    SMI Reporting	06/24/2018	2
    SMI Reporting	06/23/2018	2
    SMI Reporting	06/22/2018	7
    SMI Reporting	06/21/2018	2
    SMI Reporting	06/20/2018	2
    SMI Reporting	06/19/2018	2
    SMI Reporting	06/18/2018	2
    SMI Reporting	06/17/2018	2
    SMI Reporting	06/16/2018	2
    SMI Reporting	06/15/2018	2
    SMI Reporting	06/14/2018	2
    SMI Reporting	06/13/2018	2
    SMI Reporting	06/12/2018	2
    SMI Reporting	06/11/2018	2
    SMI Reporting	06/10/2018	2
    SMI Reporting	06/09/2018	2
    SMI Reporting	06/08/2018	2
    SMI Reporting	06/07/2018	2
    SMI Reporting	06/06/2018	2
    SMI Reporting	06/05/2018	2
    SMI Reporting	06/04/2018	2
    SMI Reporting	06/03/2018	2
    SMI Reporting	06/02/2018	2
    SMI Reporting	06/01/2018	2
    SMI Reporting	05/31/2018	2
    SMI Reporting	05/30/2018	2
    SMI Reporting	05/29/2018	2
    SMI Reporting	05/28/2018	2
    SMI Reporting	05/27/2018	2
    SMI Reporting	05/26/2018	2
    SMI Reporting	05/25/2018	2
    SMI Reporting	05/24/2018	2
    SMI Reporting	05/23/2018	2
    SMI Reporting	05/22/2018	5
    SMI Reporting	05/21/2018	2
    SMI Reporting	05/20/2018	2
    SMI Reporting	05/19/2018	2
    SMI Reporting	05/18/2018	2
    SMI Reporting	05/17/2018	2
    SMI Reporting	05/16/2018	2
    SMI Reporting	05/15/2018	3
    SMI Reporting	05/14/2018	2
    SMI Reporting	05/13/2018	2
    SMI Reporting	05/12/2018	2
    SMI Reporting	05/11/2018	2
    SMI Reporting	05/10/2018	2
    SMI Reporting	05/09/2018	2
    SMI Reporting	05/08/2018	2
    SMI Reporting	05/07/2018	2
    SMI Reporting	05/06/2018	2
    SMI Reporting	05/05/2018	2
    SMI Reporting	05/04/2018	2
    SMI Reporting	05/03/2018	2
    SMI Reporting	05/02/2018	2
    SMI Reporting	05/01/2018	2
    SMI Reporting	04/30/2018	3
    SMI Reporting	04/29/2018	3
    SMI Reporting	04/28/2018	3
    SMI Reporting	04/27/2018	3
    SMI Reporting	04/26/2018	3
    SMI Reporting	04/25/2018	3
    SMI Reporting	04/24/2018	3
    SMI Reporting	04/23/2018	3
    SMI Reporting	04/22/2018	3
    SMI Reporting	04/21/2018	3
    SMI Reporting	04/20/2018	3
    SMI Reporting	04/19/2018	27
    SMI Reporting	04/18/2018	1
    SMI Reporting	04/17/2018	1
    SMI Reporting	04/16/2018	1
    SMI Reporting	04/15/2018	1
    SMI Reporting	04/14/2018	1
    SMI Reporting	04/13/2018	1
    SMI Reporting	04/12/2018	1
    SMI Reporting	04/11/2018	1
    SMI Reporting	04/10/2018	1
    SMI Reporting	04/09/2018	1
    SMI Reporting	04/08/2018	1
    SMI Reporting	04/07/2018	1
    SMI Reporting	04/06/2018	1
    SMI Reporting	04/05/2018	1
    SMI Reporting	04/04/2018	1
    SMI Reporting	04/03/2018	1
    SMI Reporting	04/02/2018	1
    SMI Reporting	04/01/2018	1
    SMI Reporting	03/31/2018	1
    SMI Reporting	03/30/2018	1
    SMI Reporting	03/29/2018	1
    SMI Reporting	03/28/2018	1
    SMI Reporting	03/27/2018	1
    SMI Reporting	03/26/2018	1
    SMI Reporting	03/25/2018	1
    SMI Reporting	03/24/2018	1
    SMI Reporting	03/23/2018	1
    SMI Reporting	03/22/2018	1
    SMI Reporting	03/21/2018	1
    SMI Reporting	03/20/2018	1
    SMI Reporting	03/19/2018	45
    SMI Reporting	03/06/2018	25
    SMI Reporting	03/01/2018	16
    SMI Reporting	02/19/2018	18
    SMI Reporting	02/05/2018	32
    SMI Reporting	02/01/2018	16
    SMI Reporting	01/06/2018	25
    SMI Reporting	12/20/2017	37
    SMI Reporting	12/19/2017	16
    SMI Reporting	12/18/2017	15
    SMI Reporting	12/17/2017	17
    SMI Reporting	12/16/2017	17
    SMI Reporting	12/15/2017	17
    SMI Reporting	12/14/2017	18
    SMI Reporting	12/13/2017	27
    SMI Reporting	12/12/2017	20
    SMI Reporting	12/11/2017	17
    SMI Reporting	12/10/2017	17
    SMI Reporting	12/09/2017	19
    SMI Reporting	12/08/2017	17
    SMI Reporting	12/07/2017	15
    SMI Reporting	12/06/2017	18
    SMI Reporting	12/05/2017	19
    SMI Reporting	12/04/2017	15
    SMI Reporting	12/03/2017	15
    SMI Reporting	12/02/2017	19
    SMI Reporting	12/01/2017	17
    SMI Reporting	11/30/2017	13
    SMI Reporting	11/29/2017	19
    SMI Reporting	11/28/2017	19
    SMI Reporting	11/27/2017	17
    SMI Reporting	11/26/2017	17
    SMI Reporting	11/25/2017	17
    SMI Reporting	11/24/2017	17
    SMI Reporting	11/23/2017	17
    SMI Reporting	11/22/2017	17
    SMI Reporting	11/21/2017	17
    SMI Reporting	11/20/2017	17
    SMI Reporting	11/19/2017	17
    SMI Reporting	11/18/2017	17
    SMI Reporting	11/17/2017	21
    SMI Reporting	11/16/2017	13
    SMI Reporting	11/15/2017	23
    SMI Reporting	11/14/2017	16
    SMI Reporting	11/13/2017	17
    SMI Reporting	11/12/2017	17
    SMI Reporting	11/11/2017	17
    SMI Reporting	11/10/2017	17
    SMI Reporting	11/09/2017	24
    SMI Reporting	11/08/2017	13
    SMI Reporting	11/07/2017	21
    SMI Reporting	11/06/2017	15
    SMI Reporting	11/05/2017	21
    SMI Reporting	11/04/2017	11
    SMI Reporting	11/03/2017	19
    SMI Reporting	11/02/2017	19
    SMI Reporting	11/01/2017	19
    SMI Reporting	10/31/2017	17
    SMI Reporting	10/30/2017	23
    SMI Reporting	10/29/2017	21
    SMI Reporting	10/28/2017	17
    SMI Reporting	10/27/2017	17
    SMI Reporting	10/26/2017	23
    SMI Reporting	10/25/2017	21
    SMI Reporting	10/24/2017	21
    SMI Reporting	10/23/2017	21
    SMI Reporting	10/22/2017	15
    SMI Reporting	10/21/2017	23
    SMI Reporting	10/20/2017	19
    SMI Reporting	10/19/2017	19
    SMI Reporting	10/18/2017	19
    SMI Reporting	10/17/2017	19
    SMI Reporting	10/16/2017	19
    SMI Reporting	10/15/2017	15
    SMI Reporting	10/14/2017	21
    SMI Reporting	10/13/2017	21
    SMI Reporting	10/12/2017	19
    SMI Reporting	10/11/2017	19
    SMI Reporting	10/10/2017	19
    SMI Reporting	10/09/2017	19
    SMI Reporting	10/08/2017	17
    SMI Reporting	10/07/2017	21
    SMI Reporting	10/06/2017	17
    SMI Reporting	10/05/2017	21
    SMI Reporting	10/04/2017	22
    SMI Reporting	10/03/2017	21
    SMI Reporting	10/02/2017	39
    SMI Reporting	10/01/2017	19
    SMI Reporting	09/30/2017	19
    SMI Reporting	09/29/2017	21
    SMI Reporting	09/28/2017	29723
    SMI Reporting	09/27/2017	19
    SMI Reporting	09/26/2017	20
    SMI Reporting	09/25/2017	20
    SMI Reporting	09/24/2017	18
    SMI Reporting	09/23/2017	24
    SMI Reporting	09/22/2017	18
    SMI Reporting	09/21/2017	22
    SMI Reporting	09/20/2017	20
    SMI Reporting	09/19/2017	18
    SMI Reporting	09/18/2017	25
    SMI Reporting	09/17/2017	16
    SMI Reporting	09/16/2017	26
    SMI Reporting	09/15/2017	18
    SMI Reporting	09/14/2017	21
    SMI Reporting	09/13/2017	20
    SMI Reporting	09/12/2017	21
    SMI Reporting	09/11/2017	16
    SMI Reporting	09/10/2017	23
    SMI Reporting	09/09/2017	24
    SMI Reporting	09/08/2017	21
    SMI Reporting	09/07/2017	21
    SMI Reporting	09/06/2017	21
    SMI Reporting	09/05/2017	19
    SMI Reporting	09/04/2017	21
    SMI Reporting	09/03/2017	18
    SMI Reporting	09/02/2017	29
    SMI Reporting	09/01/2017	20
    SMI Reporting	08/31/2017	22
    SMI Reporting	08/30/2017	29
    SMI Reporting	08/29/2017	41
    SMI Reporting	08/28/2017	37
    SMI Reporting	07/31/2017	11
    SMI Reporting	07/28/2017	19
    SMI Reporting	07/11/2017	13
    SMI Reporting	07/05/2017	14
    SMI Reporting	06/15/2017	57
    SMI Reporting	06/09/2017	24
    SMI Reporting	06/07/2017	64
    SMI Reporting	06/06/2017	41
    SMI Reporting	05/22/2017	11
    SMI Reporting	04/25/2017	17
    SMI Reporting	04/24/2017	19
    SMI Reporting	04/08/2017	22
    SMI Reporting	04/07/2017	22
    SMI Reporting	04/06/2017	24
    SMI Reporting	04/05/2017	22
    SMI Reporting	04/04/2017	25
    SMI Reporting	03/24/2017	28
    SMI Reporting	03/23/2017	28
    SMI Reporting	03/22/2017	28
    SMI Reporting	12/01/2016	35
    SMI Reporting	10/28/2016	18
    SMI Reporting	10/27/2016	20
    SMI Reporting	10/26/2016	23
    SMI Reporting	10/25/2016	23
    SMI Reporting	10/24/2016	27
    SMI Reporting	09/28/2016	15
    SMI Reporting	05/18/2016	86
    SMI Reporting	05/16/2016	12
    SMI Reporting	05/10/2016	124
    SMI Reporting	04/01/2016	22
    SMI Reporting	03/31/2016	23
    SMI Reporting	03/30/2016	24
    SMI Reporting	03/29/2016	24
    SMI Reporting	03/28/2016	24
    SMI Reporting	01/22/2016	30
    SMI Reporting	01/21/2016	25
    SMI Reporting	01/20/2016	14
    SMI Reporting	01/19/2016	14
    SMI Reporting	01/18/2016	14
    SMI Reporting	12/14/2015	38
    SMI Reporting	11/02/2015	18

    DB          	Date    	ErrorQty
    AFCOReporting	08/19/2015	1
    AFCOReporting	05/04/2015	1
    AFCOReporting	06/10/2014	2
    AFCOReporting	06/06/2014	2
*/

-- NOTE!!!    tblInventoryForecast DOES NOT UPDATE when SKUs are refed manually with the Reporting Feeds Menu in SOP.


-- Proc Log showed these 10 SKUs didnt' exist.  They were not in SMI Reporting, but when I refed them manually, they all came over
select * from tblSKU where ixSKU in ('910352-20.5','910357-20','UP45026','UP45023','UP45022','UP45021','UP45020','910352-21','910352-20','910357-20.5')

select * from tblInventoryForecast where ixSKU in ('910352-20.5','910357-20','UP45026','UP45023','UP45022','UP45021','UP45020','910352-21','910352-20','910357-20.5')


select count(*) from tblSKU where flgDeletedFromSOP = 0 and ixSKU <> '999' -- 193212

/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblInventoryForecast
/*
DB          	TABLE                   Rows   	Date
SMI Reporting	tblInventoryForecast	432,394	02-01-19

SMI Reporting	tblInventoryForecast	430,096	01-01-19
SMI Reporting	tblInventoryForecast	386,428	01-01-18
SMI Reporting	tblInventoryForecast	328,725	01-01-17
SMI Reporting	tblInventoryForecast	285,715	01-01-16
SMI Reporting	tblInventoryForecast	219,318	01-01-15
SMI Reporting	tblInventoryForecast	166,162	01-01-14
SMI Reporting	tblInventoryForecast	  9,916	01-01-13
SMI Reporting	tblInventoryForecast	 35,107	03-01-12


DB          	TABLE                   Rows   	Date
AFCOReporting	tblInventoryForecast	71,422	02-01-19

AFCOReporting	tblInventoryForecast	71,294	01-01-19
AFCOReporting	tblInventoryForecast	66,727	01-01-18
AFCOReporting	tblInventoryForecast	58,941	01-01-17
AFCOReporting	tblInventoryForecast	58,941	01-01-17
AFCOReporting	tblInventoryForecast	49,538	01-01-15
AFCOReporting	tblInventoryForecast	46,974	01-01-14
AFCOReporting	tblInventoryForecast	38,731	10-01-13
*/

/***************** DATA FRESHNESS *************************************/
SELECT DB_NAME() AS 'DB          '
    ,CONVERT(varchar, GETDATE(), 110) AS 'DateChecked'  
    ,REPLACE(CONVERT(varchar, CAST(Records AS money), 1), '.00', '') 'Records'
    ,DaysOld 
FROM vwDataFreshness 
WHERE sTableName = 'tblInventoryForecast'
ORDER BY DaysOld

/*
DB          	Records	    DaysOld	DateChecked
SMI Reporting	02-05-2019	   <=1	432,481
SMI Reporting	02-05-2019	   2-7	     75
SMI Reporting	02-05-2019	  8-30	      3
SMI Reporting	02-05-2019	 31-180	     23
SMI Reporting	02-05-2019	181 +	     43

DB          	DateChecked	Records	DaysOld
AFCOReporting	03-28-2018	67,680	   <=1          -- after deleting approx 15 SKUs that had been deleted from SOP
*/
 


-- DELETE SKUs that have been deleted in SOP
    select distinct ixSKU 
    -- DELETE                   -- deleted 69 @2-5-2019
    from tblInventoryForecast 
    where ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS in (SELECT ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS 
                                                         from tblSKU 
                                                         where flgDeletedFromSOP = 1)

-- record that did not update today
SELECT ixSKU, sVendorSKU, dtDateLastSOPUpdate
FROM  tblInventoryForecast 
WHERE dtDateLastSOPUpdate < DATEADD(dd,-1,DATEDIFF(dd,0,getdate())) -- did NOT updated today
 
SELECT ixSKU, flgDeletedFromSOP, dtCreateDate, dtDateLastSOPUpdate
from tblSKU
where ixSKU in ('91604005','91604006','91604007','91604008','91604009','91604010','91604011','91604012','91604013','91604014','91604015','91604017','91604018','91604019','91604020','91604022','91604023','91604024','91604026','91604027','91604028','91604029','91604030','91604031','91604032','91604033','91604034','91604035','91604036','91604037','91604038','91604039','91604040','91604041','91604042','91604043','91604044','91604045','91604046','91604047','91604048','91604049','91604050','91604051','91604052','91604053','91604054','91604055','91604056','91604057','91604058','91604059','91604060','91604061','91604062','91604063','91604064','91604065','91604066','91604067','91604068','91604069','91604070','91604071','91604072','91604073','91604074','91604075','91604076','9105330','9105333','27230-1037','M2N0.75M01F','M2N0.75M01H','M2N0.75M01N')

BEGIN TRAN
    UPDATE tblSKU
    set flgDeletedFromSOP = 1
    where ixSKU in ('100327X')
ROLLBACK TRAN


select ixSKU, dtDateLastSOPUpdate
from tblVendorSKU 
where ixSKU in ('100327X')

SELECT INVF.ixSKU 
from tblInventoryForecast INVF
    join tblSKU S on INVF.ixSKU = S.ixSKU
and INVF.ixSKU in ('100327X')

/**********************************
*****   REFEED FAILED SKUS   ******
***********************************/ 
-- REFED all failed SKUS from 11/1/2013 to 12/30/2013 @12/31/2013
                    
-- 1) COUNT ERRORS
    select count(*)  -- 224 total errors          
    from tblErrorLogMaster
    where dtDate >=  '01/01/2018' --DATEADD(month, -1, getdate()) -- past X months
        and ixErrorCode = 1174   

-- 2) EXTRACT SKUS from the sError field                                    
    -- 68 unique SKUs 
    TRUNCATE table [SMITemp].dbo.PJC_ForecastSKUs_toRefeed  
    
    INSERT into [SMITemp].dbo.PJC_ForecastSKUs_toRefeed                                 
    select distinct sError,
        (CASE when sError like '%*47 failed to update' then replace(substring(sError,20,200),'*47 failed to update','')
              when sError like '%*99 failed to update' then replace(substring(sError,20,200),'*99 failed to update','')
              else replace(substring(sError,20,200),' failed to update','')
              end
              )'ixForecastSKU'
    from tblErrorLogMaster
    where dtDate >=  '01/01/2018' -- DATEADD(month, -1, getdate()) -- past X months
        and ixErrorCode = 1174    
    order by 'ixForecastSKU' 
    
    
    -- HOW MANY EXIST IN tblSKU ?
    select * from tblInventoryForecast SKU -- 1
    join [SMITemp].dbo.PJC_ForecastSKUs_toRefeed RF on SKU.ixSKU = RF.ixForecastSKU
    

    -- BEFORE Reefeeding
    SELECT RF.ixForecastSKU, 
        (CASE when SKU.ixSKU is NULL then 'NO'
         else 'Y'
         end) as 'In_tblSKU',
         CONVERT(VARCHAR, SKU.dtDateLastSOPUpdate, 101) AS 'LastSOPUpdate', 
         SKU.ixTimeLastSOPUpdate,  SKU.flgDeletedFromSOP
    FROM [SMITemp].dbo.PJC_ForecastSKUs_toRefeed RF
        left join tblSKU SKU on RF.ixForecastSKU = SKU.ixSKU
    ORDER BY 'In_tblSKU',SKU.dtDateLastSOPUpdate,SKU.ixTimeLastSOPUpdate    
    /*
    ixSKU	    In_tblSKU	LastSOPUpdate	ixTimeLastSOPUpdate	flgDeletedFromSOP
    582C300WB	Y	        06/10/2014	    26467	            0
    ... etc. 
 
    */

    
-- 3) REFEED these SKUs from SOP
    select distinct ixForecastSKU from [SMITemp].dbo.PJC_ForecastSKUs_toRefeed    

    select ixTime from tblTime where chTime = '10:32:00' -- 37920
    
    -- AFTER Reefeeding
    SELECT RF.ixForecastSKU, 
        (CASE when SKU.ixSKU is NULL then 'NO'
         else 'Y'
         end) as 'In_tblSKU',
         CONVERT(VARCHAR, SKU.dtDateLastSOPUpdate, 101) AS 'LastSOPUpdate',
         SKU.ixTimeLastSOPUpdate--,  SKU.flgDeletedFromSOP
    FROM [SMITemp].dbo.PJC_ForecastSKUs_toRefeed RF
            left join tblSKU SKU on RF.ixForecastSKU = SKU.ixSKU
    ORDER BY 'In_tblSKU',SKU.dtDateLastSOPUpdate,SKU.ixTimeLastSOPUpdate  

    /* ALL refed except for 
    21347-7-00-10-STD
    21357-7-00-10-STD
    */
/*******   DONE   **********************/


