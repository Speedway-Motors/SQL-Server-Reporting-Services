-- Case 25508 - Email addresses for Customer Offers

/* POTENTIAL ISSUE: Depending on if the customer # in their excel file is formated as test or numeric, SQL could sort differently than Excel
   making it difficult to match the result sets to the right spreadsheet record.
   
   SOLUTION: add an int column (SortNum) to their spreadsheets and have it number the records 1 to X before
   importing into a temp table. Then the result set can be sorted based on that column and the results can be pasted
   directly into their spreadsheet.
*/

--Segment	Promo	Cust #	SortNum	Email

   
select * from PJC_25508_Customers


select count(*) from PJC_25508_Customers                   -- 37,176
select count(distinct ixCustomer)  from PJC_25508_Customers-- 37,176

update SP
set SP.Email = C.sEmailAddress
from PJC_25508_Customers SP
    left join [SMI Reporting].dbo.tblCustomer C on SP.ixCustomer = C.ixCustomer -- 37,176
    
select count(*)
from PJC_25508_Customers    -- 11,544
where  Email is NULL   

-- DUPES
select Email, count(*)
from PJC_25508_Customers
group by Email
having count(*) > 1 -- 52 (excluding NULL)
order by count(*) desc

    select * from PJC_25508_Customers
    where Email in ('CLPLAYA10@GMAIL.COM','HARLEY1669@YAHOO.COM','2724SLIKER@GMAIL.COM','CHRISTYTHEULEN@GMAIL.COM','JABOYEA@FRONTIERNET.NET')
    order by Email

SELECT Email, ixCustomer, SortNum
FROM PJC_25508_Customers
ORDER BY SortNum



/*
Leslie, results are attached.

There were 37,176 records in the file. 
Out of those 11,544 had no email address.
52 email addresses are assigned to 2 or more accounts within the same file.
*/