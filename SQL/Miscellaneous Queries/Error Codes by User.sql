-- Error Codes by User

SELECT  count(ELM.ixErrorID) 'QTY', ELM.sUser 'User      ', EC.sDescription 'Error Description'
FROM tblErrorLogMaster ELM
    JOIN tblErrorCode EC on ELM.ixErrorCode = EC.ixErrorCode
WHERE dtDate >= DATEADD(dd, -5, getdate()) --  PAST X DAYS
  and ixErrorType = 'SQLDB'
GROUP BY ELM.sUser, EC.sDescription
ORDER BY COUNT(*) desc
    /*
    QTY	User      	Error Description
    === =========== =========================================
    52	SAHARRIFELD	Failure to update tblSKU.
    26	SAHARRIFELD	Failure to update tblPODetail
    15	NULL	    Failure to update tblBOMTransferDetail
    12	NULL	    Failure to update tblInventoryForecast.
    2	NULL	    Failure to update tblOrder
    1	PHOENIX	    Failure to update tblOrder
    */    
        
        
select * from tblCustomer
        


-- errors for specific users
SELECT count(ELM.ixErrorID) 'QTY', 
    ELM.sUser'User      ', 
    EC.sDescription 'Error Description'
FROM tblErrorLogMaster ELM
    JOIN tblErrorCode EC on ELM.ixErrorCode = EC.ixErrorCode
WHERE dtDate >= '06/01/2016'
    -- and ixErrorType <> 'SQLDB'
    and sUser = 'SAHARRIFELD'
GROUP BY ELM.sUser, EC.sDescription
ORDER BY COUNT(*) desc
    /*
    QTY	User      	Error Description
    === =========== =================================================================
    228	SAHARRIFELD	Failure to update tblSKU.
    114	SAHARRIFELD	Failure to update tblPODetail
    14	SAHARRIFELD	Failure to write to tblPOMaster [REPORTING.EXPORT.TBLPOMASTER.SUB]
    3	SAHARRIFELD	Could not read from TNF in PACKAGE.WEIGHT.SUB
    */    
        

-- errors by date AND user
SELECT count(*) 'QTY' 
	,CONVERT(VARCHAR, ELM.dtDate, 102)  AS 'Date     '
    ,ELM.sUser 'User      '
	,ELM.ixErrorCode 'ErrorCode'
    ,isNULL(EC.sDescription, 'UNMAPPED ERROR CODE') 'Error Description	      '
	,EC.ixErrorType 'ErrorType'
FROM tblErrorLogMaster ELM
	left JOIN tblErrorCode EC on ELM.ixErrorCode = EC.ixErrorCode
WHERE ELM.dtDate >= DATEADD(dd,-90,DATEDIFF(dd,0,getdate())) -- PAST X DAYS
      and (EC.ixErrorType is NULL
           OR
           EC.ixErrorType = 'SQLDB')          
GROUP BY CONVERT(VARCHAR, ELM.dtDate, 102), ELM.sUser, ELM.ixErrorCode, EC.sDescription, EC.ixErrorType
ORDER BY CONVERT(VARCHAR, ELM.dtDate, 102) desc, QTY desc    
    /*                          Error                                           Error
    QTY	Date     	User      	Code	Error Description	                    Type
    === ==========  =========== =====   ======================================= =====
    52	2016.06.29	SAHARRIFELD	1163	Failure to update tblSKU.	            SQLDB
    26	2016.06.29	SAHARRIFELD	1145	Failure to update tblPODetail	        SQLDB
    15	2016.06.29	NULL	    1159	Failure to update tblBOMTransferDetail	SQLDB
    2	2016.06.29	NULL	    1174	Failure to update tblInventoryForecast.	SQLDB
    6	2016.06.28	NULL	    1174	Failure to update tblInventoryForecast.	SQLDB
    2	2016.06.28	NULL	    1141	Failure to update tblOrder	            SQLDB
    1	2016.06.28	PHOENIX	    1141	Failure to update tblOrder	            SQLDB
    */
    
select * from tblEmployee where ixEmployee = 'SAH'
SELECT * FROM tblDepartment where ixDepartment =  80   -- Warehouse

select POM.ixIssuer, COUNT(POM.ixPO)
from tblPOMaster POM
    join tblEmployee E on POM.ixIssuer = E.ixEmployee and E.ixDepartment = 80 
where POM.ixPODate >= 17533
-- ixIssuer in (select ixEmployee from tblEmployee where flgCurrentEmployee = 1 and ixDepartment = 80)
GROUP BY POM.ixIssuer