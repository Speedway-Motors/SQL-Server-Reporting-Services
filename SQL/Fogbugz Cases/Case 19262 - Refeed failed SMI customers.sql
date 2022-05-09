-- Case 19262 - Refeed failed SMI customers

-- 1) Extract the customer numbers from the sError field in the query below
--    and ask Al to Refeed them:

-- RUN on STAGING
select distinct sError 
from tblErrorLogMaster
where ixErrorCode = '1143'
    and dtDate >= '07/01/2013'
    
    
-- 2) take the cleaned up customer list (dedupe too) and import them into  [SMITemp]dbo.SMI_CUSTOMERS_toRefeed   
 
-- DROP table [SMITemp]dbo.SMI_CUSTOMERS_toRefeed      

-- file to sent to Al
select * from SMI_CUSTOMERS_toRefeed
order by ixCustomer



-- get BEFORE & AFTER counts from feeds
select RF.* from dbo.SMI_CUSTOMERS_toRefeed RF -- #### BEFORE refeeding    #### AFTER
left join [SMI Reporting].dbo.tblCustomer C on RF.ixCustomer = C.ixCustomer
where (C.flgDeletedFromSOP is NULL
        or C.flgDeletedFromSOP = 0)
and 
       (C.dtDateLastSOPUpdate is NULL
        or C.dtDateLastSOPUpdate < '07/12/2013')

