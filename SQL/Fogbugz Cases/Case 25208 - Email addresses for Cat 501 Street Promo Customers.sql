-- Case 25208 - Email addresses for Cat 501 Street Promo Customers 

select * from PJC_25208_Street_Promo_Customers


select count(*) from PJC_25208_Street_Promo_Customers                   -- 10260
select count(distinct ixCustomer)  from PJC_25208_Street_Promo_Customers-- 10260

update SP
set SP.sEmail = C.sEmailAddress
from PJC_25208_Street_Promo_Customers SP
    left join [SMI Reporting].dbo.tblCustomer C on SP.ixCustomer = C.ixCustomer -- 10260
    
select count(*)
from PJC_25208_Street_Promo_Customers
where  sEmail is NULL   

-- DUPES
select sEmail, count(*)
from PJC_25208_Street_Promo_Customers
group by sEmail
having count(*) > 1

    select * from PJC_25208_Street_Promo_Customers
    where sEmail in ('CLPLAYA10@GMAIL.COM','HARLEY1669@YAHOO.COM','2724SLIKER@GMAIL.COM','CHRISTYTHEULEN@GMAIL.COM','JABOYEA@FRONTIERNET.NET')
    order by sEmail

SELECT * 
FROM PJC_25208_Street_Promo_Customers
ORDER BY sEmail



select * from PJC_25208_Street_Promo_Customers
order by sEmail desc

select distinct sEmailAddress, sMailingStatus, dtDeceasedStatusUpdateDate,flgDeceasedMailingStatusExempt
from [SMI Reporting].dbo.tblCustomer 
where sEmailAddress like '%ZOMBI%'
order by sMailingStatus, flgDeceasedMailingStatusExempt --sEmailAddress

