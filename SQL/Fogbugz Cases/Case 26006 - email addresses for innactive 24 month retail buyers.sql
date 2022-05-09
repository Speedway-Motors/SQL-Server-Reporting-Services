-- Case 26006 - email addresses for innactive 24 month retail buyers

-- DROP TABLE [SMITemp].dbo.PJC_26006_24MonthInnactiveBuyers
SELECT C.ixCustomer,
    C.sEmailAddress
--INTO [SMITemp].dbo.PJC_26006_24MonthInnactiveBuyers    
FROM tblCustomer C  
WHERE sCustomerType = 'Retail'
  and flgDeletedFromSOP = 0
  and (sMailToCountry = 'USA'    
       OR sMailToCountry is NULL OR sMailToCountry = '')
  and sEmailAddress is NOT NULL
  and ixCustomer in (-- 24 month BUYERS        -- 267K
                     SELECT distinct ixCustomer
                     FROM tblOrder
                     WHERE sOrderStatus = 'Shipped'
                        and dtShippedDate >= DATEADD(yy, -2, getdate()) 
                        and sOrderType <> 'Internal'
                        and mMerchandise > 1 
                     ) 
  and ixCustomer NOT in (-- 12 month BUYERS  
                     SELECT distinct ixCustomer
                     FROM tblOrder
                     WHERE sOrderStatus = 'Shipped'
                        and dtShippedDate >= DATEADD(yy, -1, getdate()) 
                        and sOrderType <> 'Internal'
                        and mMerchandise > 1 
                     )   

SELECT COUNT(*)
FROM [SMITemp].dbo.PJC_26006_24MonthInnactiveBuyers -- 96,009
order by ixCustomer

SELECT COUNT(distinct sEmailAddress) 
FROM [SMITemp].dbo.PJC_26006_24MonthInnactiveBuyers -- 95,469                                     

-- Dupe email addresses
SELECT sEmailAddress, COUNT(*)
FROM [SMITemp].dbo.PJC_26006_24MonthInnactiveBuyers 
GROUP BY sEmailAddress
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DEsc