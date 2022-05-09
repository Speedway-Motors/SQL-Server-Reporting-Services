-- tblInventoryReceipt checks

/**************** ERROR CODES & ERROR LOG history ***********************/

select * from tblErrorCode where sDescription like '%tblInventoryReceipt%'
--  ixErrorCode	sDescription
--  1155	Failure to update tblInventoryReceipt

-- ERROR COUNTS by Day
SELECT dtDate, DB_NAME() AS 'DB          '
    ,CONVERT(VARCHAR(10), dtDate, 101) AS 'Date    '
    ,count(*) AS 'ErrorQty'
FROM tblErrorLogMaster
WHERE ixErrorCode = '1155'
  and dtDate >=  DATEADD(month, -7, getdate())  -- past X months
GROUP BY dtDate,CONVERT(VARCHAR(10), dtDate, 101)  
--HAVING count(*) > 10
ORDER BY dtDate desc
/*
DB          	Date    	ErrorQty
SMI Reporting	01/13/2016	58
SMI Reporting	12/08/2015	2
SMI Reporting	11/16/2015	62
SMI Reporting	10/19/2015	7
SMI Reporting	07/21/2015	2
SMI Reporting	06/17/2015	1
SMI Reporting	06/11/2015	62
SMI Reporting	05/28/2015	36
SMI Reporting	05/04/2015	30
SMI Reporting	04/17/2015	62
SMI Reporting	02/19/2015	6
SMI Reporting	02/17/2015	63
SMI Reporting	12/19/2014	62
SMI Reporting	10/13/2014	59
SMI Reporting	09/08/2014	63
SMI Reporting	06/25/2014	2
SMI Reporting	05/08/2014	8
SMI Reporting	04/23/2014	3
SMI Reporting	04/21/2014	56
SMI Reporting	04/01/2014	3
SMI Reporting	03/13/2014	4
SMI Reporting	03/07/2014	49
SMI Reporting	02/24/2014	2
SMI Reporting	02/07/2014	7
SMI Reporting	01/08/2014	1
SMI Reporting	12/30/2013	3
SMI Reporting	12/05/2013	62
SMI Reporting	08/19/2013	61
SMI Reporting	06/25/2013	2
SMI Reporting	06/21/2013	104

*/
SELECT *
FROM tblErrorLogMaster
WHERE ixErrorCode = '1155'
  and dtDate >=  '05/08/2015'


/*****************  TABLE GROWTH  *************************************/
exec spGetTableGrowth tblInventoryReceipt
/*
DB          	Rows   	Date
SMI Reporting	426,982	01-01-16
SMI Reporting	356,654	01-01-15
SMI Reporting	297,167	01-01-14
SMI Reporting	238,570	01-01-13
SMI Reporting	184,228	03-01-12
*/
select sError from tblErrorLogMaster -- 181   10 distinct
where ixErrorCode = '1155'
and dtDate >= '06/01/2015'
-- dtDateLastSOPUpdate = '07/19/2013'



/***************** DATA FRESHNESS *************************************/
SELECT DB_NAME() AS 'DB          '
    ,REPLACE(CONVERT(varchar, CAST(Records AS money), 1), '.00', '') 'Records'
    ,DaysOld ,CONVERT(varchar, GETDATE(), 110) AS 'DateChecked'
FROM vwDataFreshness 
WHERE sTableName = 'tblInventoryReceipt'

/*
DB          	Records	DaysOld	DateChecked
SMI Reporting	566	     <=1	01-13-2016
SMI Reporting	1,662	 2-7	01-13-2016
SMI Reporting	4,387	 8-30	01-13-2016
SMI Reporting	66,651	31-180	01-13-2016
SMI Reporting	333,313	 181 +	01-13-2016
SMI Reporting	23,344	  UK	01-13-2016
*/
 
 
 select * from tblInventoryReceipt
 
/************************************************
*****   REFEED FAILED INVENTORY RECEIPTS   ******
*************************************************/ 
-- REFED all failed SKUS from 11/1/2013 to 12/30/2013 @12/31/2013
                    
-- 1) COUNT ERRORS
    select count(*)  -- 181 total errors          
    from tblErrorLogMaster
    where dtDate >=   '06/08/2015' --DATEADD(month, -1, getdate()) -- past X months
        and ixErrorCode = 1155   

-- 2) EXTRACT SKUS from the sError field                                    
    -- 10 unique ixInventoryReceipt 
    TRUNCATE table [SMITemp].dbo.PJC_InventoryReceipts_toRefeed  
    
    INSERT into [SMITemp].dbo.PJC_InventoryReceipts_toRefeed                                 
    select distinct sError,
        (CASE when sError like '%*47 failed to update' then replace(substring(sError,8,200),'*47 failed to update','')
              when sError like '%*99 failed to update' then replace(substring(sError,8,200),'*99 failed to update','')
              else replace(substring(sError,8,200),' failed to update','')
              end
              )'ixInventoryReceipt'
    --into [SMITemp].dbo.PJC_InventoryReceipts_toRefeed         
    from tblErrorLogMaster
    where dtDate >=   '06/08/2015' -- DATEADD(month, -1, getdate()) -- past X months
        and ixErrorCode = 1155    
    order by 'ixInventoryReceipt' 
    
    -- HOW MANY EXIST IN tblInventoryReceipt ?
    select * from tblInventoryReceipt IR -- 4
    join [SMITemp].dbo.PJC_InventoryReceipts_toRefeed RF on IR.ixInventoryReceipt = RF.ixInventoryReceipt
    
    -- BEFORE Reefeeding
    SELECT RF.ixInventoryReceipt, 
        (CASE when IR.ixInventoryReceipt is NULL then 'NO'
         else 'Y'
         end) as 'In_tblInventoryReceipt',
         CONVERT(VARCHAR, IR.dtDateLastSOPUpdate, 101) AS 'LastSOPUpdate', 
         IR.ixTimeLastSOPUpdate--,  IR.flgDeletedFromSOP
    FROM [SMITemp].dbo.PJC_InventoryReceipts_toRefeed RF
        left join tblInventoryReceipt IR on RF.ixInventoryReceipt = IR.ixInventoryReceipt
    ORDER BY 'In_tblInventoryReceipt',IR.dtDateLastSOPUpdate,IR.ixTimeLastSOPUpdate    
    /*
    ixInventoryReceipt	        In_tblInventoryReceipt	LastSOPUpdate	ixTimeLastSOPUpdate
91078004*167407*102306	        NO	                    NULL	        NULL
91078004*170945*104181	        NO	                    NULL	        NULL
91078004*180013*107954	        NO	                    NULL	        NULL
91099000*173476*104690	        NO	                    NULL	        NULL
AUP4810*181215*108848	        NO	                    NULL	        NULL
M2Y0.06A01N*171288*104510	    NO	                    NULL	        NULL
91099000*163517*101113	        Y	                    02/17/2015	    31334     
91003915*168388*97754	        Y	                    05/04/2015	    32886     
8352300542*169993*100958	    Y	                    05/28/2015	    38086     
91078004*183170*109381	        Y	                    01/13/2016	    54215            
    */

    -- AFTER Reefeeding
    /*
    The only record that did not update was:
    ixInventoryReceipt	        In_tblInventoryReceipt	LastSOPUpdate	ixTimeLastSOPUpdate    
    91099000*144724*93632	    NO	                    NULL	        NULL        
    */

select * from tblInventoryReceipt
where ixInventoryReceipt in 
    ('91078004*167407*102306','91078004*170945*104181','91078004*180013*107954','91099000*173476*104690','AUP4810*181215*108848','M2Y0.06A01N*171288*104510','91099000*163517*101113','91003915*168388*97754','8352300542*169993*100958','91078004*183170*109381')
    
    
    