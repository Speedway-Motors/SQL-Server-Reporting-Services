-- Case 25922 - SMIHD-697 Email addresses for Cat 404 Customer Offers 

/* POTENTIAL ISSUE: Depending on if the customer # in their excel file is formated as test or numeric, SQL could sort differently than Excel
   making it difficult to match the result sets to the right spreadsheet record.
   
   SOLUTION: add an int column (SortNum) to their spreadsheets and have it number the records 1 to X before
   importing into a temp table. Then the result set can be sorted based on that column and the results can be pasted
   directly into their spreadsheet.
*/

--SourceCode	PromoCode	CustNum	SortNum	EmailAddress
--Offer	        OTUCode	    CustNum	SortNum	EmailAddress

-- Easiest way to create new table with correct datatype on each field
-- DROP TABLE [SMITemp].dbo.PJC_25922_Customers  
SELECT TOP 0 *
INTO [SMITemp].dbo.PJC_25922_Customers
FROM [SMITemp].dbo.PJC_25854_Customers
   
 
select * from [SMITemp].dbo.PJC_25922_Customers
order by SortNum


select count(*) from [SMITemp].dbo.PJC_25922_Customers                  -- 40,403
select count(distinct CustNum)  from [SMITemp].dbo.PJC_25922_Customers  -- 40,403

SELECT * from [SMITemp].dbo.PJC_25922_Customers 
where CustNum in (select CustNum
                     from [SMITemp].dbo.PJC_25922_Customers 
                     group by CustNum
                     having COUNT(*) > 1)
order by Offer desc

                     
update SP
set SP.EmailAddress = C.sEmailAddress
from [SMITemp].dbo.PJC_25922_Customers SP
    left join [SMI Reporting].dbo.tblCustomer C on SP.CustNum = C.ixCustomer -- 40,403
    
select count(*)
from [SMITemp].dbo.PJC_25922_Customers    -- 7126
where  EmailAddress is NULL   

-- DUPES
select EmailAddress, count(*)
from [SMITemp].dbo.PJC_25922_Customers
group by EmailAddress
having count(*) > 1 -- 123 (excluding NULL)
order by count(*) desc

    select * from [SMITemp].dbo.PJC_25922_Customers
    where EmailAddress in ('CLPLAYA10@GMAIL.COM','HARLEY1669@YAHOO.COM','2724SLIKER@GMAIL.COM','CHRISTYTHEULEN@GMAIL.COM','JABOYEA@FRONTIERNET.NET')
    order by EmailAddress

SELECT EmailAddress, CustNum, SortNum
FROM [SMITemp].dbo.PJC_25922_Customers
ORDER BY SortNum



/*
Leslie, results are attached.

There were 262,510 records in the file. 
Out of those 51,885 had no email address.
3,176 email addresses are assigned to 2 or more accounts within the same file.

Let me know if you have any questions/concerns.

-Pat

*/
