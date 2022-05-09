-- Loyalty Builder Data vs CST

/**** RESULTS:
 out of the 140,709 "Mail To" customers from LB:
 
 3,520 are not in the CST Starting Pool
 
 Of those:
  1,218 are not US or CANADA customers    
    897 have sMailingStatus 7,8,9
      8 are not Retail customers


1397     
     
 */
 
 
 
 
/**** basic data checks  ***/

    select * from PJC_LB_streetrod20140711 -- cursoury visual check looks clean
    order by ixCustomer

    -- NO DUPE CUSTOMERS
    select COUNT(*) from PJC_LB_streetrod20140711                   -- 388,757
    select count(distinct ixCustomer) from PJC_LB_streetrod20140711 -- 388,757
    select count(distinct [rank]) from PJC_LB_streetrod20140711     -- 388,757

    select MIN([rank]) MinRank, MAX([rank]) MaxRank 
    from PJC_LB_streetrod20140711
    /*
    MinRank	MaxRank
    1	    388757      -- good
    */

    SELECT MailTo, COUNT(*) Qty
    from PJC_LB_streetrod20140711
    group by MailTo
    /*
    Mail
    To	Qty
    Y	140,709
    N	248,048
        =======
        388,747 good
    */



-- Saving a copy of the original data set from LB Prior to mods
SELECT * INTO PJC_LB_streetrod20140711_unmodified
FROM PJC_LB_streetrod20140711


/******** CHECKS against vwCSTStartingPool ***********/
select LB.* from PJC_LB_streetrod20140711 LB
where ixCustomer IN (select ixCustomer from [SMI Reporting].dbo.tblCustomer where flgDeletedFromSOP = 1)
-- 267 of the customers have been deleted from SOP

-- removing the deleted customers
DELETE
from PJC_LB_streetrod20140711 
where ixCustomer IN (select ixCustomer from [SMI Reporting].dbo.tblCustomer where flgDeletedFromSOP = 1)
-- REMOVING THE 267 FROM THE WORK TABLE

select COUNT(*) from PJC_LB_streetrod20140711       -- 388,490

select COUNT(*) from PJC_LB_streetrod20140711  
where ixCustomer in (select ixCustomer
                     from [SMI Reporting].dbo.tblCustomer
                     where flgDeletedFromSOP = 0)   -- 388,490



select COUNT(*) from PJC_LB_streetrod20140711 LB
where LB.MailTo = 'Y'                                            -- 140,633               
and ixCustomer in (select ixCustomer
                   from [SMI Reporting].dbo.vwCSTStartingPool)   -- 137,113
                   
-- Marked MailTo but NOT in the CST StartingPool                   
select * from PJC_LB_streetrod20140711 LB
where LB.MailTo = 'Y'                                            -- 3,520 NOT in the CST starting Pool             
and ixCustomer NOT in (select ixCustomer
                   from [SMI Reporting].dbo.vwCSTStartingPool)                   
    
    -- MailingStatus               
    select LB.*, C.sMailingStatus, C.ixCustomerType, C.sCustomerType
    from PJC_LB_streetrod20140711 LB
    left join [SMI Reporting].dbo.vwCSTStartingPool SP on LB.ixCustomer = SP.ixCustomer
    join [SMI Reporting].dbo.tblCustomer C on LB.ixCustomer = C.ixCustomer
    where LB.MailTo = 'Y'                                            -- 3,520          
        and SP.ixCustomer is NULL
        and C.flgDeletedFromSOP = 0
    order by sMailingStatus, ixCustomerType desc
    -- 897 have sMailingStatus 7,8,9
    
    
    -- ixCustomerType
    select LB.*, C.sMailingStatus, C.ixCustomerType, C.sCustomerType
    from PJC_LB_streetrod20140711 LB
    left join [SMI Reporting].dbo.vwCSTStartingPool SP on LB.ixCustomer = SP.ixCustomer
    join [SMI Reporting].dbo.tblCustomer C on LB.ixCustomer = C.ixCustomer
    where LB.MailTo = 'Y'                                            -- 2,623          
        and SP.ixCustomer is NULL
        and C.flgDeletedFromSOP = 0
        and (C.sMailingStatus is NULL
             OR
             C.sMailingStatus = 0)
    order by ixCustomerType desc
    -- 8 have ixCustomerType OTHER THAN 1  
    
    
    -- US Customers
    select LB.*, C.sMailingStatus, C.ixCustomerType, C.sCustomerType, C.sMailToCountry, C.sMailToZip, C.dtAccountCreateDate
    from PJC_LB_streetrod20140711 LB
    left join [SMI Reporting].dbo.vwCSTStartingPool SP on LB.ixCustomer = SP.ixCustomer
    join [SMI Reporting].dbo.tblCustomer C on LB.ixCustomer = C.ixCustomer
    where LB.MailTo = 'Y'                                            -- 44  <--37 of those have zips that we exclude from CST
        and SP.ixCustomer is NULL -- not in CST Starting Pool
        and C.flgDeletedFromSOP = 0
        and sCustomerType = 'Retail'
        and (C.sMailingStatus is NULL
             OR
             C.sMailingStatus = 0)
        and ( C.sMailToCountry is NULL
             OR
              C.sMailToCountry = 'USA')
    order by C.sMailToZip --C.sMailToCountry desc
/*    
  and sMailToZip not like '962%' -- APO/FPO AP
  and sMailToZip not like '963%' -- APO/FPO AP
  and sMailToZip not like '964%' -- APO/FPO AP
  and sMailToZip not like '965%' -- APO/FPO AP
  and sMailToZip not like '966%' -- FPO AP
  and sMailToZip not like '09%' -- ALL are APO/FPO, AE 
*/

-- THE 7 CUSTOMERS NOT INCLUDED IN CST FOR THE ABOVE REASONS
-- 1487267,1529870,1064200,902754,1184679,1195685,1161684

select * from [SMI Reporting].dbo.tblCustomer where ixCustomer in ('1487267','1529870','1064200','902754','1184679','1195685','1161684')
select * from  [SMI Reporting].dbo.vwCSTStartingPool where ixCustomer in ('1487267','1529870','1064200','902754','1184679','1195685','1161684') 

select * from [SMI Reporting].dbo.tblOrder
where ixCustomer in ('1487267','1529870','1064200','902754','1184679','1195685','1161684')
and sOrderStatus = 'Shipped'
order by ixCustomer, dtShippedDate desc
  
  
  
  
  
  
  
  
  
    -- CANADIAN Customers 
    select LB.*, C.sMailingStatus, C.ixCustomerType, C.sCustomerType, C.sMailToCountry, C.sMailToZip, C.dtAccountCreateDate
    from PJC_LB_streetrod20140711 LB
    left join [SMI Reporting].dbo.vwCSTStartingPoolCANADA SP on LB.ixCustomer = SP.ixCustomer
    join [SMI Reporting].dbo.tblCustomer C on LB.ixCustomer = C.ixCustomer
    where LB.MailTo = 'Y'                                            -- 15
        and SP.ixCustomer is NULL
        and C.flgDeletedFromSOP = 0
        and sCustomerType = 'Retail'
        and (C.sMailingStatus is NULL
             OR
             C.sMailingStatus = 0)
        and ( C.sMailToCountry = 'CANADA')
    order by C.sMailToCountry desc    

 
    
        
    select LB.*, C.sMailingStatus, C.ixCustomerType, C.sCustomerType
    from PJC_LB_streetrod20140711 LB
    left join [SMI Reporting].dbo.vwCSTStartingPool SP on LB.ixCustomer = SP.ixCustomer
    join [SMI Reporting].dbo.tblCustomer C on LB.ixCustomer = C.ixCustomer
    where LB.MailTo = 'Y'                                            -- 2,623        
        and SP.ixCustomer is NULL
        and C.flgDeletedFromSOP = 0
        and (C.sMailingStatus is NULL
             OR
             C.sMailingStatus = 0)
    order by ixCustomerType desc                




select 