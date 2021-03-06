select * 
into PJC_Formerly_Flagged_Deceased_By_RRD
from PJC_Potentially_Deceased_Customers


select distinct FD.ixCustomer -- 212
from PJC_Formerly_Flagged_Deceased_By_RRD FD 
    join tblCustomerOffer CO on CO.ixCustomer = FD.ixCustomer
    join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
    --join PJC_345_Deceased_from_RRD REFLAGGED on FD.ixCustomer = REFLAGGED.ixCustomer
where SC.ixCatalog = '345'
order by FD.ixCustomer

select distinct FD.ixCustomer -- 212  -- 127 (60%) still flagged as deceased
from PJC_Formerly_Flagged_Deceased_By_RRD FD 
    join tblCustomerOffer CO on CO.ixCustomer = FD.ixCustomer
    join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
    join PJC_345_Deceased_from_RRD REFLAGGED on FD.ixCustomer = REFLAGGED.ixCustomer
where SC.ixCatalog = '345'


-- drop table PJC_345_Deceased_from_RRD

select ixCustomer from PJC_345_Deceased_from_RRD


select O.ixCustomer, max(O.dtOrderDate) MostRecOrder
from PJC_345_Deceased_from_RRD REFLAGGED
  left join  tblOrder O  on O.ixCustomer = REFLAGGED.ixCustomer 
group by O.ixCustomer  
having max(O.dtOrderDate) > '05/15/2012' 
order by MostRecOrder desc



-- zombies that did NOT receive Cat 345 and have ordered since
select ixCustomer, max(dtShippedDate) from tblOrder
where ixCustomer in (select distinct FD.ixCustomer -- 212  -- 127 (60%) still flagged as deceased
                    from PJC_Formerly_Flagged_Deceased_By_RRD FD 
                        join tblCustomerOffer CO on CO.ixCustomer = FD.ixCustomer
                        join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
                        join PJC_345_Deceased_from_RRD REFLAGGED on FD.ixCustomer = REFLAGGED.ixCustomer
                    where SC.ixCatalog = '345'
                    )
and dtOrderDate > '08/22/2012'   
group by ixCustomer                 
