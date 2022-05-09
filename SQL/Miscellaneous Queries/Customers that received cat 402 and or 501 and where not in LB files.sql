-- Customers that received cat 402 and or 501 and where not in LB files
select * from PJC_LB_AWOL_Customers



select M.ixCustomer, C.dtAccountCreateDate, C.ixCustomerType, C.sCustomerType, C.sMailToCountry, C.sMailToState, C.sMailToZip, C.sMailingStatus,
CO.ixSourceCode 'SC402', 
CO2.ixSourceCode 'SC501' ,
MAX(dtRequestDate) 'LatestCRDate',
(Case when SP.ixCustomer is not null then 'Y'
 else 'N'
 end) as 'CST_US_StartingPool_NOW'
from PJC_LB_AWOL_Customers M
left join [SMI Reporting].dbo.tblCustomerOffer CO on M.ixCustomer = CO.ixCustomer and CO.ixSourceCode like '402%'
left join [SMI Reporting].dbo.tblCustomerOffer CO2 on M.ixCustomer = CO2.ixCustomer and CO2.ixSourceCode like '501%'
left join [SMI Reporting].dbo.tblCustomer C on M.ixCustomer = C.ixCustomer
left join [SMI Reporting].dbo.tblCatalogRequest CR on CR.ixCustomer = M.ixCustomer
left join [SMI Reporting].dbo.vwCSTStartingPool SP on SP.ixCustomer = M.ixCustomer
group by M.ixCustomer, C.dtAccountCreateDate, C.ixCustomerType, C.sCustomerType, C.sMailToCountry, C.sMailToState, C.sMailToZip, C.sMailingStatus,
    CO.ixSourceCode, 
    CO2.ixSourceCode ,
    (Case when SP.ixCustomer is not null then 'Y'
     else 'N'
     end)
order by C.sMailingStatus, C.sMailToCountry, M.ixCustomer

select top 10 * from [SMI Reporting].dbo.tblCatalogRequest