-- tblBinSku checks
/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblBin%'
--  ixErrorCode	sDescription
--  1154	Failure to update tblBinSKU

-- ERROR COUNTS by Day
SELECT dtDate, DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1154'
 -- and dtDate >=  DATEADD(month, -5, getdate())  -- past X months
GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
--HAVING count(*) > 10
ORDER BY dtDate desc
/* 
    DB          	Date    	ErrorQty
    SMI Reporting	02/24/2014	42
    SMI Reporting	02/23/2014	1339
    SMI Reporting	02/17/2014	114
    SMI Reporting	02/16/2014	1189
    SMI Reporting	02/15/2014	52
    SMI Reporting	02/14/2014	26
    SMI Reporting	01/17/2014	1
    SMI Reporting	01/16/2014	462
    SMI Reporting	01/15/2014	174
    SMI Reporting	01/01/2014	8
    SMI Reporting	12/31/2013	318
    SMI Reporting	12/30/2013	29
    SMI Reporting	12/28/2013	164
    SMI Reporting	12/26/2013	294
    SMI Reporting	12/25/2013	33
*/

/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblBinSku
/*
DB          	TABLE       	Rows   	Date
SMI Reporting	tblBinSku	1,166,603	07-01-16
SMI Reporting	tblBinSku	1,117,274	04-01-16
SMI Reporting	tblBinSku	1,052,599	01-01-16

SMI Reporting	tblBinSku	1,025,630	10-01-15
SMI Reporting	tblBinSku	  945,192	07-01-15
SMI Reporting	tblBinSku	  910,759	06-01-15
SMI Reporting	tblBinSku	  711,867	05-01-15
SMI Reporting	tblBinSku	  547,528	04-01-15
SMI Reporting	tblBinSku	  359,295	01-01-15
SMI Reporting	tblBinSku	  267,009	01-01-14
SMI Reporting	tblBinSku	  299,811	01-01-13
SMI Reporting	tblBinSku	  226,646	03-01-12
*/

/***************** DATA FRESHNESS *************************************/
SELECT DB_NAME() AS 'DB          '
    ,REPLACE(CONVERT(varchar, CAST(Records AS money), 1), '.00', '') 'Records'
    ,DaysOld ,CONVERT(varchar, GETDATE(), 110) AS 'DateChecked'
FROM vwDataFreshness 
WHERE sTableName = 'tblBinSku'
ORDER BY DaysOld
/*
DB          	Records	DaysOld	DateChecked
SMI Reporting	105,325	   <=1	07-07-2016
SMI Reporting	212,967	   2-7	07-07-2016
SMI Reporting	821,974	  8-30	07-07-2016
SMI Reporting	 27,715	 31-180	07-07-2016
SMI Reporting	      8	  181 +	07-07-2016
*/
 
/**********************************
*****   REFEED FAILED SKUS   ******
***********************************/ 
-- REFED all failed SKUS from 11/1/2013 to 12/30/2013 @12/31/2013
                    
-- 1) COUNT ERRORS
    select count(*)  -- 2726 total errors          
    from tblErrorLogMaster
    where dtDate >=  DATEADD(month, -4, getdate()) -- past X months
        and ixErrorCode = 1154   


-- 2) EXTRACT SKUS from the sError field                                    
    -- 68 unique SKUs 
    TRUNCATE table [SMITemp].dbo.PJC_SKUs_toRefeed  
    
    INSERT into [SMITemp].dbo.PJC_SKUs_toRefeed                                 
    select distinct sError,
        (CASE when sError like '%*47 failed to update' then replace(substring(sError,8,200),'*47 failed to update','')
              when sError like '%*99 failed to update' then replace(substring(sError,8,200),'*99 failed to update','')
              else replace(substring(sError,8,200),'*99 failed to update','')
              end
              )'ixSKU'
    from tblErrorLogMaster
    where dtDate >=  '02/24/2014' -- DATEADD(month, -1, getdate()) -- past X months
        and ixErrorCode = 1154    
    order by 'ixSKU' 
    
    -- HOW MANY EXIST IN tblSKU ?
    select * from tblSKU SKU -- 37
    join [SMITemp].dbo.PJC_SKUs_toRefeed RF on SKU.ixSKU = RF.ixSKU
    
    106332.6GS*47 [U2][SQL Client][ODBC][Microsoft][ODBC SQL Server Driver][SQL Server]Could not find stored procedure 'spUpdateSKU'.
    -- BEFORE Reefeeding
    SELECT RF.ixSKU, 
        (CASE when SKU.ixSKU is NULL then 'NO'
         else 'Y'
         end) as 'In_tblSKU',
         CONVERT(VARCHAR, SKU.dtDateLastSOPUpdate, 101) AS 'LastSOPUpdate', 
         SKU.ixTimeLastSOPUpdate,  SKU.flgDeletedFromSOP
    FROM [SMITemp].dbo.PJC_SKUs_toRefeed RF
        left join tblSKU SKU on RF.ixSKU = SKU.ixSKU
    ORDER BY 'In_tblSKU',SKU.dtDateLastSOPUpdate,SKU.ixTimeLastSOPUpdate    
    /*
    ixSKU	In_tblSKU	LastSOPUpdate	ixTimeLastSOPUpdate	flgDeletedFromSOP
    634-1334	NO	NULL	NULL	NULL
    634-1721	NO	NULL	NULL	NULL
    634-41733	NO	NULL	NULL	NULL
    634-41773	NO	NULL	NULL	NULL
    634-41783	NO	NULL	NULL	NULL
    634-63506	NO	NULL	NULL	NULL
    ... etc. 
 
    */



select top 30000 ixSKU, dtDateLastSOPUpdate    -- kicked off @2:44 UNSORTED.  Tot seconds run =
from tblSKU                                    -- kicked off @     SORTED.    Tot seconds run =
where flgDeletedFromSOP = 0
and dtDateLastSOPUpdate < '06/01/2014' -- 118K
order by dtDateLastSOPUpdate