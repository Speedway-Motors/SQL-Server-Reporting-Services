-- Case 23027 - Clean-up of Customer Source Code data for new Rod Run & Race Banquet customers

select count(*) from PJC_Banquet_and_RodRun_newCusts -- 21,444

select * from PJC_Banquet_and_RodRun_newCusts 

select distinct LEN(Zip), Zip from PJC_Banquet_and_RodRun_newCusts 
order by LEN(Zip)

select ixCustomer from PJC_NewStreetRequestsFromDHL -- 6083

select * from [SMI Reporting].dbo.tblCatalogRequest CR
where ixCustomer in (select ixCustomer from PJC_NewStreetRequestsFromDHL)
and dtRequestDate >= '08/20/2014'
order by ixSourceCode

-- clean-up table data
select *
from PJC_NewStreetRequestsFromDHL where len(Junk) > 0 
order by Junk

update PJC_NewStreetRequestsFromDHL
set ixSourceCode = ixCustomer
where len(Junk) > 0 

update PJC_NewStreetRequestsFromDHL
set ixCustomer = Junk
where len(Junk) > 0 


-- these custs tblCustomer.ixSourceCode whould be 338801
-- and ideally their CustOffer record for SC 38898 CHANGED TO 338801
select distinct C.ixCustomer, C.ixSourceCode CustSC, C.dtAccountCreateDate,
    CR.ixSourceCode CustOfferSC --DHL.ixSourceCode
from [SMI Reporting].dbo.tblCustomer C
    join PJC_NewStreetRequestsFromDHL DHL on C.ixCustomer = DHL.ixCustomer
    left join [SMI Reporting].dbo.tblCatalogRequest CR on C.ixCustomer = CR.ixCustomer
where C.dtAccountCreateDate >= '08/20/2014'
--and C.ixSourceCode = '338801'
order by C.ixSourceCode
--C.dtAccountCreateDate
--where CR.dtRequestDate >= '08/20/2014'
--and CR.ixSourceCode <> DHL.ixSourceCode



select * from tblSourceCode where ixSourceCode in ('338801','38898') -- ROD RUN
/*
ixSourceCode	sDescription
338801	        ROD RUN 2012 NAMES
38898	        DHL Bulk Center
*/ 

select * from tblSourceCode where ixSourceCode in ('347500','37898') -- BANQUET
/*
ixSourceCode	sDescription
347500	        2012 Race Banquet Package
37898	        DHL Bulk Center
*/         


                        
select * from tblSourceCode where sDescription like '%BANQUET%' 
-- ROD RUN Customers
select * from tblCustomerOffer where ixSourceCode = '38898' -- 9,997 offers need to have the sourcecode changed to '338801'
and dtCreateDate >= '08/13/2014'

-- RACE BANQUET Customers
select * from tblCustomerOffer where ixSourceCode = '37898' -- 9,997 offers need to have the sourcecode changed to '338801'
and dtCreateDate >= '08/13/2014'

select len(Junk), Junk 
from PJC_NewStreetRequestsFromDHL where Junk is not NULL
order by len(Junk)

select * from [SMI Reporting].dbo.tblSourceCode
where ixSourceCode = '338801'


select * from [SMI Reporting].dbo.tblCatalogRequest CR
where ixCustomer in (select ixCustomer from PJC_NewStreetRequestsFromDHL)
and dtRequestDate >= '08/20/2014'
order by ixSourceCode

select CR.ixSourceCode, DHL.ixSourceCode
from [SMI Reporting].dbo.tblCatalogRequest CR
join PJC_NewStreetRequestsFromDHL DHL on CR.ixCustomer = DHL.ixCustomer
where CR.dtRequestDate >= '08/20/2014'
and CR.ixSourceCode <> DHL.ixSourceCode

select COUNT(*) from [SMI Reporting].dbo.tblCustomerOffer where ixSourceCode = '38898' -- 




-- non RR/Banquest customers that should have processed via DHL normally
select * from PJC_NewStreetRequestsFromDHL 
where ixCustomer NOT in (select ixCustomer 
                         from [SMI Reporting].dbo.tblCatalogRequest
                         where dtRequestDate >= '08/20/2014')




order by ixSourceCode
-- 6064 ALL OF WHICH are in iBatchNumber 270


select * from [SMI Reporting].dbo.tblCatalogRequest --10,838
where iBatchNumber = 870
and ixCatalogMarket = 'SR'


-- removing Catalog Request from customers that are already buyers from last 24 Months or have already requested a catalog in the last 24 Months

select * -- DELETE 
from [SMI Reporting].dbo.tblCatalogRequest 
where ixCustomer in (select ixCustomer 
                        from PJC_NewStreetRequestsFromDHL)
and (ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblOrder where sOrderStatus = 'Shipped' and dtShippedDate >= '08/20/2012')                         
     OR 
     ixCustomer in (select ixCustomer from [SMI Reporting].dbo.tblCatalogRequest where dtRequestDate between '08/20/2012' and '08/19/2014')
     )
and dtRequestDate >= '08/20/2014'     


/***** RACE customers ********/

select ixCustomer from PJC_NewRaceRequestsFromDHL -- 4716

update PJC_NewRaceRequestsFromDHL
set ixCustomer = ixSourceCode
where len(ixCustomer) = 0

update PJC_NewRaceRequestsFromDHL
set ixSourceCode = '37898'

select *
from PJC_NewRaceRequestsFromDHL
order by ixSourceCode


select * from [SMI Reporting].dbo.tblCatalogRequest CR
where ixCustomer in (select ixCustomer from PJC_NewRaceRequestsFromDHL) -- 3520
and dtRequestDate >= '08/20/2014'
order by ixSourceCode


-- these custs tblCustomer.ixSourceCodes should be 347500
-- and ideally their CustOffer record for SC 38898 CHANGED TO 347500
select distinct C.ixCustomer, C.ixSourceCode CustSC, C.dtAccountCreateDate,
    CR.ixSourceCode CustOfferSC --DHL.ixSourceCode
from [SMI Reporting].dbo.tblCustomer C
    join PJC_NewRaceRequestsFromDHL DHL on C.ixCustomer = DHL.ixCustomer
    left join [SMI Reporting].dbo.tblCatalogRequest CR on C.ixCustomer = CR.ixCustomer
where C.dtAccountCreateDate >= '08/20/2014'
--and C.ixSourceCode = '338801'
order by C.ixSourceCode
--C.dtAccountCreateDate
--where CR.dtRequestDate >= '08/20/2014'
--and CR.ixSourceCode <> DHL.ixSourceCode





select len(Junk), Junk 
from PJC_NewRaceRequestsFromDHL where Junk is not NULL
order by len(Junk)

select * from [SMI Reporting].dbo.tblSourceCode
where ixSourceCode = '338801'


select * from [SMI Reporting].dbo.tblCatalogRequest CR
where ixCustomer in (select ixCustomer from PJC_NewRaceRequestsFromDHL)
and dtRequestDate >= '08/20/2014'
order by ixSourceCode

select CR.ixSourceCode, DHL.ixSourceCode
from [SMI Reporting].dbo.tblCatalogRequest CR
join PJC_NewRaceRequestsFromDHL DHL on CR.ixCustomer = DHL.ixCustomer
where CR.dtRequestDate >= '08/20/2014'
and CR.ixSourceCode <> DHL.ixSourceCode

select COUNT(*) from [SMI Reporting].dbo.tblCustomerOffer where ixSourceCode = '38898' -- 



347572

customerNumber
date
time
catalogCode (R, S, T, etc)
sourceCode
zip



select C.ixCustomer,
  --  17040 as ixDate,
  --  1 as ixTime,
    (Case when C.ixSourceCode = 1 then 'SR'
           when C.ixSourceCode = 2 then 'R'
           else 'ERROR'
      end) CatalogCode,
    C.ixSourceCode,       
    C.sMailToZip 
from tblCustomer C
    left join tblCatalogRequest CR on C.ixCustomer = CR.ixCustomer
    left join tblCustomerOffer CO on C.ixCustomer = CO.ixCustomer
where C.ixSourceCode in ('338801','347500')
    and C.dtAccountCreateDate >= '08/20/2014'-- 15,916
    and C.flgDeletedFromSOP = 0                -- 15,814 
    and CR.ixCustomer is NULL -- Not in tblCatalogRequest   
    and CO.ixCustomer is NULL -- Not in tblCustomerOffer
group by C.ixSourceCode, 
    CO.ixSourceCode, 
    CR.ixSourceCode
    
    
select C.ixCustomer, 
    C.ixSourceCode, 
    (Case when C.ixSourceCode = 1 then 'SR'
           when C.ixSourceCode = 2 then 'R'
           else 'ERROR'
      end) CatalogCode,
    C.sMailToZip                                       