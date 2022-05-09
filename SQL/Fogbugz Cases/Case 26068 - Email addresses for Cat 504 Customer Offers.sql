-- Case 26068 - Email addresses for Cat 504 Customer Offers 

/* ISSUE: Depending on if the customer # in their excel file is formated as text or numeric, SQL could sort differently than Excel
   making it difficult to match the result sets to the right spreadsheet record.
   
   SOLUTION: add an int column (SortNum) to their spreadsheets and have it number the records 1 to X before
   importing into a temp table. Then the result set can be sorted based on that column and the results can be pasted
   directly into their spreadsheet.
*/

--SourceCode	PromoCode	CustNum	SortNum	EmailAddress
--Offer	        OTUCode	    CustNum	SortNum	EmailAddress

-- Easiest way to create new table with correct datatype on each field
-- DROP TABLE [SMITemp].dbo.PJC_26068_Customers  
SELECT TOP 0 *
INTO [SMITemp].dbo.PJC_26068_Customers
FROM [SMITemp].dbo.PJC_25922_Customers
   
 
select * from [SMITemp].dbo.PJC_26068_Customers
order by SortNum


select count(*) 'CustCnt',  
    count(distinct CustNum) 'DistCnt',
    (count(*) - count(distinct CustNum)) 'Dupes'
from [SMITemp].dbo.PJC_26068_Customers                  
/*
CustCnt	DistCnt	Dupes
298527	298527	0
*/


SELECT * from [SMITemp].dbo.PJC_26068_Customers 
where CustNum in (select CustNum
                     from [SMITemp].dbo.PJC_26068_Customers 
                     group by CustNum
                     having COUNT(*) > 1)
order by Offer desc

-- INSERT EMAIL addresses                     
update SP
set SP.EmailAddress = C.sEmailAddress
from [SMITemp].dbo.PJC_26068_Customers SP
    left join [SMI Reporting].dbo.tblCustomer C on SP.CustNum = C.ixCustomer -- 298,527
    
select count(*)
from [SMITemp].dbo.PJC_26068_Customers    -- 52,968
where  EmailAddress is NULL   

-- DUPES
select EmailAddress, count(*)               -- 2,815
from [SMITemp].dbo.PJC_26068_Customers
where EmailAddress is NOT NULL
group by EmailAddress
having count(*) > 1 -- 123 (excluding NULL)
order by count(*) desc

    select * from [SMITemp].dbo.PJC_26068_Customers
    where EmailAddress in ('CLPLAYA10@GMAIL.COM','HARLEY1669@YAHOO.COM','2724SLIKER@GMAIL.COM','CHRISTYTHEULEN@GMAIL.COM','JABOYEA@FRONTIERNET.NET')
    order by EmailAddress

-- DATA to past into the Excel sheet
SELECT EmailAddress, CustNum, SortNum
FROM [SMITemp].dbo.PJC_26068_Customers
ORDER BY SortNum



/*
Leslie, results are attached.

There were  298,527 records in the file. 
Out of those 52,968 had no email address.
2,815 email addresses are assigned to 2 or more accounts within the same file.

Let me know if you have any questions/concerns.

-Pat

*/
