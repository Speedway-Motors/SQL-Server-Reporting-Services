-- Case 25579 - Email addresses for Cat 502 Customer Offers 

/* POTENTIAL ISSUE: Depending on if the customer # in their excel file is formated as test or numeric, SQL could sort differently than Excel
   making it difficult to match the result sets to the right spreadsheet record.
   
   SOLUTION: add an int column (SortNum) to their spreadsheets and have it number the records 1 to X before
   importing into a temp table. Then the result set can be sorted based on that column and the results can be pasted
   directly into their spreadsheet.
*/

--SourceCode	PromoCode	CustNum	SortNum	EmailAddress
--Offer	        OTUCode	    CustNum	SortNum	EmailAddress

-- Case 25579 Email addresses for Customer Offers (Cat 502) - Results.xlsx
   
select * from [SMITemp].dbo.PJC_25579_Customers


select count(*) from [SMITemp].dbo.PJC_25579_Customers                  -- 153,225
select count(distinct CustNum)  from [SMITemp].dbo.PJC_25579_Customers  -- 153,225

update SP
set SP.EmailAddress = C.sEmailAddress
from [SMITemp].dbo.PJC_25579_Customers SP
    left join [SMI Reporting].dbo.tblCustomer C on SP.CustNum = C.ixCustomer -- 153,225
    
select count(*)
from [SMITemp].dbo.PJC_25579_Customers    -- 41,933
where  EmailAddress is NULL   

-- DUPES
select EmailAddress, count(*)
from [SMITemp].dbo.PJC_25579_Customers
group by EmailAddress
having count(*) > 1 -- 682 (excluding NULL)
order by count(*) desc

    select * from [SMITemp].dbo.PJC_25579_Customers
    where EmailAddress in ('CLPLAYA10@GMAIL.COM','HARLEY1669@YAHOO.COM','2724SLIKER@GMAIL.COM','CHRISTYTHEULEN@GMAIL.COM','JABOYEA@FRONTIERNET.NET')
    order by EmailAddress

SELECT EmailAddress, CustNum, SortNum
FROM [SMITemp].dbo.PJC_25579_Customers
ORDER BY SortNum



/*
Leslie, results are attached.

There were 153,225 records in the file. 
Out of those 41,933 had no email address.
682 email addresses are assigned to 2 or more accounts within the same file.

Let me know if you have any questions/concerns.

-Pat

*/
