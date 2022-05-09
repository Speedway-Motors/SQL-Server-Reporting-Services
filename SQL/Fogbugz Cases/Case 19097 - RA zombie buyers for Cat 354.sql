-- Case 19097 - RA zombie buyers for Cat 354

--[vwSourceCodePerformance]    Script Date: 10/14/2013 16:04:22 ******/
SELECT
    CM.ixCatalog, SC.sSourceCodeType, 
    SC.ixSourceCode,
    --SC.ixSourceCode, 
    SC.sDescription,
    SC.iQuantityPrinted                 QtyPrinted,
    count(distinct O.ixOrder)           ActOrdersToDate,    -- OrderCount,
    count(distinct O.ixCustomer)        ActBuyersToDate,    -- CustCount,
    sum(O.mMerchandise)                 SalesToDate,        -- Total Sales
    sum(O.mMerchandiseCost)             COGSToDate,
    (CASE WHEN sum(O.mMerchandise) = 0 THEN 0 
     ELSE (sum(O.mMerchandise) - sum(O.mMerchandiseCost)) / sum(O.mMerchandise) 
     END
    ) GMPercent
FROM tblSourceCode SC
    left join tblOrder O on O.sMatchbackSourceCode = SC.ixSourceCode
    join tblCatalogMaster CM    on CM.ixCatalog = SC.ixCatalog
    left join [SMITemp].dbo.PJC_19014_CustsDeceasedFlgCleared ALIVE on O.ixCustomer = ALIVE.ixCustomer     
WHERE CM.ixCatalog = '354'
  and ALIVE.ixCustomer is NULL -- excluding RA buyers
  and O.sOrderType <> 'Internal'
  and O.sOrderStatus = 'Shipped' 
  and O.dtShippedDate > '01/01/2013' -- to decrease runtime
  and O.dtShippedDate >= SC.dtStartDate
  and O.dtShippedDate < (SC.dtEndDate+1)
GROUP BY CM.ixCatalog,SC.sSourceCodeType,
SC.ixSourceCode,
SC.sDescription,
SC.iQuantityPrinted

UNION

--[vwSourceCodePerformance]    Script Date: 10/14/2013 16:04:22 ******/
SELECT
    CM.ixCatalog, SC.sSourceCodeType, 
    SC.ixSourceCode+'RA' as SourceCode,
    --SC.ixSourceCode, 
    SC.sDescription,
    SC.iQuantityPrinted                 QtyPrinted,
    count(distinct O.ixOrder)           ActOrdersToDate,    -- OrderCount,
    count(distinct O.ixCustomer)        ActBuyersToDate,    -- CustCount,
    sum(O.mMerchandise)                 SalesToDate,        -- Total Sales
    sum(O.mMerchandiseCost)             COGSToDate,
    (CASE WHEN sum(O.mMerchandise) = 0 THEN 0 
     ELSE (sum(O.mMerchandise) - sum(O.mMerchandiseCost)) / sum(O.mMerchandise) 
     END
    ) GMPercent
FROM tblSourceCode SC
    left join tblOrder O on O.sMatchbackSourceCode = SC.ixSourceCode
    join tblCatalogMaster CM    on CM.ixCatalog = SC.ixCatalog
    left join [SMITemp].dbo.PJC_19014_CustsDeceasedFlgCleared ALIVE on O.ixCustomer = ALIVE.ixCustomer     
WHERE CM.ixCatalog = '354'
  and ALIVE.ixCustomer is NOT NULL -- excluding RA buyers
  and O.sOrderType <> 'Internal'
  and O.sOrderStatus = 'Shipped' 
  and O.dtShippedDate > '01/01/2013' -- to decrease runtime
  and O.dtShippedDate >= SC.dtStartDate
  and O.dtShippedDate < (SC.dtEndDate+1)
GROUP BY CM.ixCatalog,SC.sSourceCodeType,
SC.ixSourceCode+'RA', 
SC.sDescription,
SC.iQuantityPrinted



/*  How many zombies received offers for each SC? */

select CO.ixSourceCode, count(Z.ixCustomer) Qty
from [SMITemp].dbo.PJC_19014_CustsDeceasedFlgCleared Z
    join [SMI Reporting].dbo.tblCustomerOffer CO on Z.ixCustomer = CO.ixCustomer
where CO.ixSourceCode like '354%'   
group by  CO.ixSourceCode
order by CO.ixSourceCode



select count(distinct RA.ixCustomer)
from [SMITemp].dbo.PJC_19014_CustsDeceasedFlgCleared RA
where ixCustomer in (Select distinct ixCustomer from tblOrder where dtOrderDate >= '07/01/2013')

select count(distinct RA.ixCustomer)
from [SMITemp].dbo.PJC_19014_CustsDeceasedFlgCleared RA
where ixCustomer in (Select ixCustomer from vwCSTStartingPool)


select ixCustomer, sSourceCodeGiven, sMatchbackSourceCode, mMerchandise
from tblOrder where dtOrderDate >= '07/01/2013'
and ixCustomer in (Select ixCustomer from [SMITemp].dbo.PJC_19014_CustsDeceasedFlgCleared)
order by sMatchbackSourceCode

select sMailingStatus, count(C.ixCustomer)
from tblCustomer C
join [SMITemp].dbo.PJC_19014_CustsDeceasedFlgCleared RA on C.ixCustomer = RA.ixCustomer
group by sMailingStatus

order by sMatchbackSourceCode


select (C.ixCustomer)
from tblCustomer C
join [SMITemp].dbo.PJC_19014_CustsDeceasedFlgCleared RA on C.ixCustomer = RA.ixCustomer
where sMailingStatus = 9
group by sMailingStatus



SELECT RA.ixCustomer, max(O.dtOrderDate) 'Latest Order'
from [SMITemp].dbo.PJC_19014_CustsDeceasedFlgCleared RA 
    join tblOrder O on RA.ixCustomer = O.ixCustomer
    left join vwCSTStartingPool CST on RA.ixCustomer = CST.ixCustomer
    left join vwCSTStartingPoolRequestors CSTR  ON RA.ixCustomer = CSTR.ixCustomer    
WHERE CST.ixCustomer is NULL
and CSTR.ixCustomer is NULL
group by   RA.ixCustomer  
order by max(O.dtOrderDate) 


select RA.ixCustomer
from [SMITemp].dbo.PJC_19014_CustsDeceasedFlgCleared RA
where ixCustomer NOT in (Select ixCustomer from vwCSTStartingPool)


select count(distinct RA.ixCustomer)
from [SMITemp].dbo.PJC_19014_CustsDeceasedFlgCleared RA
where ixCustomer NOT in (Select ixCustomer from vwCSTStartingPool)

select count(distinct RA.ixCustomer)
from [SMITemp].dbo.PJC_19014_CustsDeceasedFlgCleared RA
    left JOIN vwCSTStartingPool CST ON RA.ixCustomer = CST.ixCustomer
    left join vwCSTStartingPoolRequestors CSTR  ON RA.ixCustomer = CSTR.ixCustomer
where CST.ixCustomer is NULL
and CSTR.ixCustomer is NOT NULL
-- 935 not in CST    
-- 673 of them are in the RequestorStartingPool 
-- 251     
    
    
  and ixCustomer in (Select ixCustomer from vwCSTStartingPoolRequestors) 
  
  
  
  
  