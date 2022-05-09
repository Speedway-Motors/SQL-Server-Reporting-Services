-- drop table PJC_Older_Requestors
select distinct 
    NULL                  as ixGUID,
    C.ixCustomer, 
    C.ixAccountCreateDate as ixRequestDate,
    1                     as ixRequestTime,
    C.dtAccountCreateDate as dtRequestDate,
    CM.sMarket            as ixCatalogMarket,
    C.ixSourceCode,
    C.sMailToZip          as ixZipCode,
    NULL                  as iBatchNumber
into PJC_Older_Requestors
from tblCustomer C -- 121042
    left join tblSourceCode SC on SC.ixSourceCode = C.ixSourceCode
    left join tblCatalogMaster CM on SC.ixCatalog = CM.ixCatalog
where dtAccountCreateDate between '03/21/2007' and '08/30/2010'
    and ixCustomer not in (select ixCustomer from tblCatalogRequest)
    and ixCustomer not in(select distinct ixCustomer  -- checking to see if customer has placed an order
                         from tblOrder
                         where sOrderStatus = 'Shipped'
                         )
and  ixCustomerType < '90'
   and (sMailingStatus is NULL
        OR (sMailingStatus not in ('4','9'))
        )
   and (ixCustomerType NOT like '%.%' 
        OR ixCustomerType is NULL)
  and (ISNUMERIC(ixCustomerType) = 1 -- eliminates types with chars
      OR ixCustomerType is NULL)
  and sCustomerType = 'Retail'
  and flgDeletedFromSOP = 0
  and sMailToZip BETWEEN '01000' AND '99999'
  and (sMailToCountry = 'USA'    
       OR sMailToCountry is NULL OR sMailToCountry = '') -- says USA only in SOP
  and sMailToZip not like '962%' -- APO/FPO AP
  and sMailToZip not like '963%' -- APO/FPO AP
  and sMailToZip not like '964%' -- APO/FPO AP
  and sMailToZip not like '965%' -- APO/FPO AP
  and sMailToZip not like '966%' -- FPO AP
  and sMailToZip not like '09%' -- ALL are APO/FPO, AE     
and ixCustomer not in ('921332','1530517','1686804')  
and C.ixSourceCode <> ' '


select ixCatalogMarket, COUNT(*) CustCnt
from PJC_Older_Requestors
group by ixCatalogMarket


select ixCatalogMarket, COUNT(*) CustCnt
from tblCatalogRequest
group by ixCatalogMarket
-- select MIN(ixTime) from tblTime

/*

select MIN(dtRequestDate)-- 2010-08-31 00:00:00.000
from tblCatalogRequest

select *
from tblCatalogRequest
where ixGUID is null


select * from PJC_Older_Requestors
order by ixSourceCode


select top 10 * from tblCatalogRequest

*/


select *
into PJC_tblCatalogRequestBACKUP -- 141136
from tblCatalogRequest

insert into tblCatalogRequest
select * from PJC_Older_Requestors

















