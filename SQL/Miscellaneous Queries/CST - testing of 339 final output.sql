select ixSourceCode, COUNT(ixCustomer)
from ASC_337_Production_Pulls
where ixCustomer NOT in (select ixCustomer from ASC_CSTDeletedCustCheck)
group by ixSourceCode
order by ixSourceCode

select * from ASC_337_Production_Pulls PP
join tblCustomer C on PP.ixCustomer = C.ixCustomer
where sCustomerType <> 'Retail'

select * from ASC_337_Production_Pulls PP
join tblCustomer C on PP.ixCustomer = C.ixCustomer
where sMailingStatus in ('4','9')

select * from ASC_337_Production_Pulls PP
join tblCustomer C on PP.ixCustomer = C.ixCustomer
where ixCustomerType > '90'

select * from ASC_337_Production_Pulls PP
join tblCustomer C on PP.ixCustomer = C.ixCustomer
where ixCustomerType like '%.%' 
        OR ixCustomerType is NULL)

select * from ASC_337_Production_Pulls PP
join tblCustomer C on PP.ixCustomer = C.ixCustomer
where(ISNUMERIC(ixCustomerType) <> 1) -- eliminates types with chars
      OR ixCustomerType is NULL)

select PP.ixSourceCode, COUNT(ixCustomer)
from ASC_337_Production_Pulls PP
where PP.ixCustomer NOT in
(select distinct ixCustomer  -- checking to see if customer has placed an order
                     from tblOrder
                     where sOrderStatus = 'Shipped'
                     and dtShippedDate > '03/20/2006')
--and PP.ixSourceCode not in ('340708','340718','340728','33770','33771','33772','33773','33774')
group by PP.ixSourceCode
order by PP.ixSourceCode

/*
  and sMailToZip BETWEEN '01000' AND '99999'
  and (sMailToCountry = 'USA'    
       OR sMailToCountry is NULL OR sMailToCountry = '') -- says USA only in SOP
  -- excluding special military zips     
  and sMailToZip not like '962%' -- APO/FPO AP
  and sMailToZip not like '963%' -- APO/FPO AP
  and sMailToZip not like '964%' -- APO/FPO AP
  and sMailToZip not like '965%' -- APO/FPO AP
  and sMailToZip not like '966%' -- FPO AP
  and sMailToZip not like '09%' -- ALL are APO/FPO, AE 
*/


select * from ASC_337_Production_Pulls PP
join tblCustomer C on PP.ixCustomer = C.ixCustomer
where sMailToZip NOT BETWEEN '01000' AND '99999'
                   
select * from ASC_337_Production_Pulls PP
join tblCustomer C on PP.ixCustomer = C.ixCustomer
where sMailToCountry <> 'USA' AND sMailToCountry is not NULL     


select * from ASC_337_Production_Pulls PP
join tblCustomer C on PP.ixCustomer = C.ixCustomer
where sMailToZip like '09%'

 not like '962%', '963%', '964%', '965%', '966%','09%'      
 
 
 
 select * from ASC_337_Production_Pulls PP
join tblCustomer C on PP.ixCustomer = C.ixCustomer  
where PP.ixSourceCode NOT in ('340708','340718','340728','33770','33771','33772','33773','33774')
 and C.flgDeletedFromSOP = 1
 
         
         
/******************************************************************/
/*           AFTER customers loaded into SOP                      */
/******************************************************************/

select * from ASC_337_Production_Pulls

select ixSourceCode, COUNT(distinct ixCustomer) 
from ASC_337_Production_Pulls
group by ixSourceCode
order by ixSourceCode


select PP.ixSourceCode, PP.ixCustomer
from ASC_337_Production_Pulls PP
    join tblCustomer C on C.ixCustomer = PP.ixCustomer
where flgDeletedFromSOP = 1
order by  PP.ixSourceCode

select PP.ixSourceCode, PP.ixCustomer
from ASC_337_Production_Pulls PP    
where ixCustomer NOT in (select ixCustomer from tblCustomer)



select * from tblCustomer where ixCustomer = '1415738'



select PP.ixSourceCode, count(PP.ixCustomer) QTY
from PJC_337_Production_Pulls PP
group by PP.ixSourceCode
order by  PP.ixSourceCode




select top 10 * from tblCustomerOffer
select top 10 * from tblSourceCode

select CO.ixSourceCode, SC.sDescription 'Description',count(CO.ixCustomer) CustCnt
from tblCustomerOffer CO
    join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '337' -- IN IF THERE ARE MULTIPLE CATALOGS!!!
group by CO.ixSourceCode, SC.sDescription
order by CO.ixSourceCode

--  527,353 


select ixCustomer -- 218
-- drop table ASC_337NotPulled
into ASC_337NotPulled
from ASC_337_Production_Pulls 
where ixCustomer not in 
            (select ixCustomer
            from ASC_337Pulled)

select count(*) from ASC_337_Production_Pulls -- 527093  218
select count(*) from ASC_337Pulled -- 527353

CST counts were 99.96% accurate


delete from ASC_337NotPulled
where ixCustomer in (select ixCustomer from tblCustomer where flgDeletedFromSOP = 1)

select * from ASC_337NotPulled         



1687323 -- this CUSTOMER SHOULD HAVE LOADED


update tblCustomer
set flgDeletedFromSOP = 1
where ixCustomer in ('916971','1683820','1521812','1787422','917703','1764035','1226440','1318924','1713642','1145316',
                     '1710907','1709248','1535825','1639926','1388203','979416','1314422','1762616','1133719')


select * from tblCustomer where ixCustomer = '1687323'

