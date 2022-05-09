-- case 20731 - Email Addresses for Cat 377 catalog

-- verifying no dupe customers
select COUNT(*) from PJC_20731_Cat377_CustList                    --  266,306
select COUNT(distinct ixCustomer) from PJC_20731_Cat377_CustList  --  266,306


select CL.ixCustomer, C.sEmailAddress   -- 266,271   <-- 35 Custs have since been flagged as deleted
from PJC_20731_Cat377_CustList CL
    left join [SMI Reporting].dbo.tblCustomer C
on CL.ixCustomer = C.ixCustomer
where C.flgDeletedFromSOP = 0   


select -- CL.ixCustomer, C.sEmailAddress    -- 210,469 have email addresses
     CL.ixCustomer+',"'+C.sEmailAddress+'"'   -- Concat so that the results can just be pasted into a .csv file
from PJC_20731_Cat377_CustList CL
    left join [SMI Reporting].dbo.tblCustomer C
on CL.ixCustomer = C.ixCustomer
where C.flgDeletedFromSOP = 0   
  and C.sEmailAddress is NOT NULL
  
  
            
PJC_20731_EmailList_FromAl

select * from PJC_20731_EmailList_FromAl

select sEmailAddress, count(*) TimesInFile
from PJC_20731_EmailList_FromAl
where sEmailAddress not like 'NONE ON%'
group by sEmailAddress
order by count(*) desc

group by sEmailAddress
having count(*) > 1
order by count(*) desc, sEmailAddress


select sEmailAddress
from PJC_20731_EmailList_FromAl
where sEmailAddress like 'NONE ON%/%/06%'
order by sEmailAddress


select sEmailAddress
from PJC_20731_EmailList_FromAl
where sEmailAddress NOT like 'NONE ON%'
order by sEmailAddress






select * from [SMI Reporting].dbo.tblCustomer
 where sEmailAddress  in
 ('DYNAMICRIDES@HOTMAIL.COM','VANCEE@STRATAROCKS.COM','JEREMY.ATER@GMAIL.COM','KICKASSUPERSTAN@YAHOO.COM','NONE@AOL.COM'
 ,'DILLN89@AOL.COM','JEFFREY_ANNA39@YAHOO.COM','BECKETT.ROY@GMAIL.COM','DONALD45N@YAHOO.COM')
order by   sEmailAddress, sCustomerLastName, sCustomerFirstName      


select * from  [SMI Reporting].dbo.tblCustomer
 where sEmailAddress like '%,%'
 and flgDeletedFromSOP = 0  
 
  select * from PJC_20731_EmailList_FromAl
  where ixCustomer not in (select C.ixCustomer   -- 266,271   <-- 35 Custs have since been flagged as deleted
                            from PJC_20731_Cat377_CustList CL
                                left join [SMI Reporting].dbo.tblCustomer C
                            on CL.ixCustomer = C.ixCustomer
                            where C.flgDeletedFromSOP = 0   )
  
  
  
  
 select * from PJC_20731_EmailList_FromAl -- 213,148
 select distinct(ixCustomer) from PJC_20731_EmailList_FromAl 

  
  not in (
                            select C.sEmailAddress   -- 266,271   <-- 35 Custs have since been flagged as deleted
                            from PJC_20731_Cat377_CustList CL
                                left join [SMI Reporting].dbo.tblCustomer C
                            on CL.ixCustomer = C.ixCustomer
                            where C.flgDeletedFromSOP = 0   )