-- CUSTOMERS for SOP to Refeed

--insert into PJC_SMI_CUSTOMERS_toRefeed -- 5,059
select top 100000
    ixCustomer
    ,dtDateLastSOPUpdate --,ixTimeLastSOPUpdate,dtAccountCreateDate
from [SMI Reporting].dbo.tblCustomer
where  flgDeletedFromSOP = 0
order by dtDateLastSOPUpdate -- oldest not updated = 10-15-2013

-- truncate table PJC_SMI_CUSTOMERS_toRefeed
select count(*) from PJC_SMI_CUSTOMERS_toRefeed

select * from PJC_SMI_CUSTOMERS_toRefeed


select min(dtDateLastSOPUpdate) from [SMI Reporting].dbo.tblCustomer -- 2012-08-23 when dtDateLastSOPUpdate field was added


select min(C.ixTimeLastSOPUpdate) MinTime,
       max(C.ixTimeLastSOPUpdate) MaxTime
from PJC_SMI_CUSTOMERS_toRefeed RF
                    join [SMI Reporting].dbo.tblCustomer C on RF.ixCustomer = C.ixCustomer   


-- Customers that have not been updated
select count(*) from [SMI Reporting].dbo.tblCustomer
where dtDateLastSOPUpdate is NULL
    and flgDeletedFromSOP = 0 -- NONE @11-22-2013






-- DELETED customers
select count(*) from [SMI Reporting].dbo.tblCustomer 
where flgDeletedFromSOP = 1    -- 30,724 @11-20-13 8:10AM




/* CONFIRM CUSTOMERS THAT DIDN'T UPDATE ARE IN SOP
   THEN... run this to flag them as deleted */
UPDATE [SMI Reporting].dbo.tblCustomer 
set flgDeletedFromSOP = 1
--select * from [SMI Reporting].dbo.tblCustomer
where ixCustomer in (
                    select RF.ixCustomer
                    from PJC_SMI_CUSTOMERS_toRefeed RF
                    join [SMI Reporting].dbo.tblCustomer C on RF.ixCustomer = C.ixCustomer
                    where C.dtDateLastSOPUpdate is NULL
                    and C.ixCustomer <= 255153 -- the highest cust # in the first file
                    )





select * from [SMI Reporting].dbo.tblTime where chTime like '08%'

select count(*) from tblOrder -- 2942190

select count(*) from tblOrderLine -- 12,554,105  





select * from tblSKU where ixSKU = '917340-28'