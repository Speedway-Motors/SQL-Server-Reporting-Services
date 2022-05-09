-- tblBOMTransferDetail checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblBOMTransferDetail%'
--  ixErrorCode	sDescription
--  1159	    Failure to update tblBOMTransferDetail.

-- ERROR COUNTS by Day
SELECT dtDate, DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1159'
  and dtDate >=  DATEADD(month, -1, getdate())  -- past X months
GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)   
--HAVING count(*) > 10
ORDER BY dtDate desc
/*
DB          	Date    	ErrorQty
SMI Reporting	03/23/2016	54
SMI Reporting	02/01/2016	1
SMI Reporting	01/25/2016	7
SMI Reporting	01/11/2016	9
SMI Reporting	10/19/2015	1
SMI Reporting	09/15/2015	63
SMI Reporting	02/19/2014	364
SMI Reporting	02/13/2014	14
SMI Reporting	02/11/2014	518
SMI Reporting	01/31/2014	1
*/



/****** PROC LOG INFO **************
 The log shows 177 errors between 02/11 and 02/19 from tblBOMTransferMaster all with the following Message:
 
        The INSERT statement conflicted with the FOREIGN KEY constraint "FK_ixFinishedSKU_tblBOMTransferMaster". 
        The conflict occurred in database "SMI Reporting", table "dbo.tblSKU", column 'ixSKU'.

  

************************************************************************/

-- TABLE GROWTH
exec spGetTableGrowth tblBOMTransferDetail
/*
DB          	TABLE                   Rows   	Date
SMI Reporting	tblBOMTransferDetail	257,697	03-01-16

SMI Reporting	tblBOMTransferDetail	250,406	01-01-16
SMI Reporting	tblBOMTransferDetail	226,897	07-01-15
SMI Reporting	tblBOMTransferDetail	204,723	01-01-15
SMI Reporting	tblBOMTransferDetail	191,801	07-01-14
SMI Reporting	tblBOMTransferDetail	177,552	01-01-14
SMI Reporting	tblBOMTransferDetail	153,466	01-01-13
SMI Reporting	tblBOMTransferDetail	138,070	03-01-12
*/

-- tblBOMTransferDetail is populated by spUpdateBOMTransferMaster

/*******************************************
*****   REFEED FAILED BOM Transfers   ******
********************************************/ 
-- REFED all failed BOM Transfers from 01/01/2014 to 02/20/2014 @
                    
-- 1) COUNT ERRORS
    select count(*)  -- 897 total errors          
    from tblErrorLogMaster
    where dtDate >=  '01/01/2016' --DATEADD(month, -1, getdate()) -- past X months
        and ixErrorCode = 1159   

-- 2) EXTRACT SKUS from the sError field                                    
    -- 68 unique SKUs 
    TRUNCATE table [SMITemp].dbo.PJC_SKUs_toRefeed  
    
    INSERT into [SMITemp].dbo.PJC_SKUs_toRefeed                                 
    select distinct sError,
    replace(substring(sError,32,200),' failed to update','') as 'ixTransferNumber'
        /*(CASE when sError like '%*47 failed to update' then replace(substring(sError,5,200),'*47 failed to update','')
              when sError like '%*99 failed to update' then replace(substring(sError,5,200),'*99 failed to update','')
              else replace(substring(sError,5,200),' failed to update','')
              end
              )'ixSKU'*/
    from tblErrorLogMaster
    where dtDate >=  '01/01/2016' --DATEADD(month, -2, getdate()) -- past X months
        and ixErrorCode = 1159    
    --order by 'ixSKU' 
    
    -- HOW MANY OF THE ixTransferNumber RECORDS EXIST IN tblBOMTransferMaster?
    select * from tblBOMTransferMaster where ixTransferNumber in ( select replace(substring(sError,32,200),' failed to update','') as 'ixTransferNumber'
                                                                   from tblErrorLogMaster
                                                                   where dtDate >=  '01/01/2016' --DATEADD(month, -2, getdate()) -- past X months
                                                                        and ixErrorCode = 1159)
                                                                        
    
    
    
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

    
-- 3) REFEED these SKUs from SOP
    select distinct ixSKU from [SMITemp].dbo.PJC_SKUs_toRefeed    

    select ixTime from tblTime where chTime = '10:32:00' -- 37920
    
    -- AFTER Reefeeding
    SELECT RF.ixSKU, 
        (CASE when SKU.ixSKU is NULL then 'NO'
         else 'Y'
         end) as 'In_tblSKU',
         CONVERT(VARCHAR, SKU.dtDateLastSOPUpdate, 101) AS 'LastSOPUpdate',
         SKU.ixTimeLastSOPUpdate,  SKU.flgDeletedFromSOP
    FROM [SMITemp].dbo.PJC_SKUs_toRefeed RF
            left join tblSKU SKU on RF.ixSKU = SKU.ixSKU
    ORDER BY 'In_tblSKU',SKU.dtDateLastSOPUpdate,SKU.ixTimeLastSOPUpdate  

    /* ALL refed except for 
    21347-7-00-10-STD
    21357-7-00-10-STD
    */
/*******   DONE   **********************/



SELECT * 
from tblBOMTransferMaster TM
left join tblBOMTransferDetail TD on TM.ixTransferNumber = TD.ixTransferNumber
where TM.ixTransferNumber = '62232-1'



SELECT * 
from tblBOMTemplateMaster TM
left join tblBOMTemplateDetail TD on TM.ixFinishedSKU = TD.ixFinishedSKU
where TM.ixFinishedSKU in ('350206.3','350700','350700.1','350700.1.1','350700.1.2','350700.1.2.2','350700.1.3','350700.2.1','350700.2.1.1','350700.2.1.2','350700.2.2-LH','350700.2.2-RH','350700.2.3','350700.2.4-LH','350700.2.4-RH','350700.2.5','350700.2.5.1','350700.2.5.2','350700.2.5.3','350700.2.6','350700.3','350700.3.1','350700.3.1.1','350700.4','350700.5','91037222.1','96627700.1')


SELECT * from tblSKU where ixSKU = '3253891'

select * from tblTime where ixTime = 48767