-- SMIHD-3496 - Unmark & Remark customers that received Source Code 50913

-- TEMP table to store customers that were initially marked with SC
select * 
--into [SMITemp].dbo.PJC_SMIHD3496_CustsInitialyMarkedWithSC50913             -- 41,053
from tblCustomerOffer where ixSourceCode = '50913'

-- List from Quad of the customers that did NOT receive the SC 
SELECT * from [SMITemp].dbo.PJC_SMIHD3496_CustsThatDidNOTReceiveSC50913     -- 30,818

-- List of customers that DID receive the SC and need to be re-loaded
SELECT ixCustomer, ixSourceCode                                             -- =======
into [SMITemp].dbo.PJC_SMIHD3496_CustsDIDReceiveSC50913                     -- 10,235
FROM [SMITemp].dbo.PJC_SMIHD3496_CustsInitialyMarkedWithSC50913             
WHERE ixCustomer NOT IN (SELECT distinct Customer_Number 
                        from [SMITemp].dbo.PJC_SMIHD3496_CustsThatDidNOTReceiveSC50913) 


SELECT COUNT(ixCustomer) from [SMITemp].dbo.PJC_SMIHD3496_CustsInitialyMarkedWithSC50913        -- 41,053
SELECT COUNT(Customer_Number) from [SMITemp].dbo.PJC_SMIHD3496_CustsThatDidNOTReceiveSC50913    -- 30,818
SELECT COUNT(ixCustomer) from [SMITemp].dbo.PJC_SMIHD3496_CustsDIDReceiveSC50913                -- 10,235


PJC_SMIHD3496_CustsInitialyMarkedWithSC50913 -- 41,053
PJC_SMIHD3496_CustsThatDidNOTReceiveSC50913 -- 30,818
PJC_SMIHD3496_CustsDIDReceiveSC50913 -- 10,235


-- DELETE ALL current records with that SC
BEGIN TRAN
DELETE FROM tblCustomerOffer
where ixSourceCode = '50913'
ROLLBACK TRAN
LAST SOP ATTEMPT 10:28

select * 
FROM tblCustomerOffer
where ixSourceCode = '50913' -- 0


-- CUSTOMERS OFFERS TO REFEED TO SOP
SELECT ixCustomer,',',ixSourceCode
from [SMITemp].dbo.PJC_SMIHD3496_CustsDIDReceiveSC50913                -- 10,235



select * 
FROM tblCustomerOffer
where ixSourceCode = '50913' -- 10,233




