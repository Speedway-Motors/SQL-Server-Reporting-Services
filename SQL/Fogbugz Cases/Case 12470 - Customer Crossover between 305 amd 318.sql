select top 10 * from tblCustomerOffer
select top 10 * from tblSourceCode


select * from tblSourceCode
where  ixCatalog = '305'
  and sSourceCodeType <> 'CAT-H'



select count(distinct ixCustomer) -- 40495, 36200
from tblCustomerOffer CO
   join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
where ixCatalog = '305'
  and sSourceCodeType = 'CAT-H'
AND ixCustomer in 
   -- 12 month customers
   (select distinct ixCustomer 
   from tblOrder O
   where dtOrderDate >= DATEADD(mm, -12, getdate()) -- 12 months ago
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
    and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 
    )
AND ixCustomer in
   (select ixCustomer -- 283K
   from tblCustomerOffer CO
      join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
   where ixCatalog = '318'
     and sSourceCodeType = 'CAT-H'
   )




