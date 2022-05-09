-- Case 15975 - Customers being excluded from CST

select top 10 * from tblCustomer

select sMailingStatus, COUNT(*) CustCount
from tblCustomer
group by sMailingStatus

select sCustomerType, COUNT(*) CustCount
from tblCustomer
group by sCustomerType

-- FIRST VERSION
-- DROP TABLE PJC_15975_CST_Custs_ExcludedbyStatus
select ixCustomer   -- 7,724
into PJC_15975_CST_Custs_ExcludedbyStatus
from [SMI Reporting].dbo.tblCustomer
where ixCustomerType not in ('1','4', '30','40')
    AND ixCustomerType < '90'
    AND flgDeletedFromSOP = 0


-- SECOND VERSION
-- DROP TABLE PJC_15975_CST_Custs_ExcludedbyStatus
-- cust is not in CST starting pool but has placed 1+ orders in the last 6 years
select ixCustomer   -- 494,433
into PJC_15975_CST_Custs_ExcludedbyStatus
from [SMI Reporting].dbo.tblCustomer
where ixCustomer not in (select ixCustomer from [SMI Reporting].dbo.vwCSTStartingPoolRequestors)
  and ixCustomer IN (select distinct ixCustomer  -- checking to see if customer has placed an order in last 6 years
                     from [SMI Reporting].dbo.tblOrder
                     where sOrderStatus = 'Shipped'
                     and dtShippedDate >= DATEADD(yy, -6, getdate()) 
                     )     




select count(*) from PJC_15975_CST_Custs_ExcludedbyStatus -- 494,433

    

SELECT C.ixCustomer, C.ixCustomerType, C.sCustomerType, C.sMailingStatus,
        isNull(Sales.Sales12Mo,0) Sales12Mo,
        isNull(Sales.OrderCount,0) OrderCount,
        Sales.MostRecOrder
        -- # of otders last 12 mo.
        -- most recent order date 
FROM PJC_15975_CST_Custs_ExcludedbyStatus CEBS
    JOIN [SMI Reporting].dbo.tblCustomer C on CEBS.ixCustomer = C.ixCustomer
left join (select O.ixCustomer,sum(O.mMerchandise) Sales12Mo,
            count(distinct ixOrder) OrderCount,
            max(dtOrderDate) MostRecOrder
           
           from [SMI Reporting].dbo.tblOrder O
           where O.sOrderStatus = 'Shipped'
            and O.sOrderType <> 'Internal'
            and O.sOrderChannel <> 'INTERNAL'
            and O.mMerchandise > 0 -- > 1 if looking at non-US orders
            and O.dtShippedDate between '11/28/2011' and '11/28/2012'
           group by ixCustomer
           ) Sales on C.ixCustomer = Sales.ixCustomer
           
ORDER BY ixCustomer           
    
    
/* ROW 7
ixCustomer	ixCustomerType	sCustomerType	Sales12Mo	OrderCount
10588	    56	            Other	        1125.69	        6
*/
    
select O.*
           from [SMI Reporting].dbo.tblOrder O
           where O.sOrderStatus = 'Shipped'
            and O.sOrderType <> 'Internal'
            and O.sOrderChannel <> 'INTERNAL'
            and O.mMerchandise > 0 -- > 1 if looking at non-US orders
            and O.dtShippedDate between '11/28/2011' and '11/28/2012'
            and O.ixCustomer = '10588'


select sCustomerType, count(*)
from [SMI Reporting].dbo.tblCustomer
group by sCustomerType


    
select * from tblCustomer
where sCustomerType in ('MRR', 'PRS')
    
    
