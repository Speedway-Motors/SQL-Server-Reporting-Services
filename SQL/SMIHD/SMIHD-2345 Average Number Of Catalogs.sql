-- SMIHD-2345 Average Number Of Catalogs

--/****** Object:  StoredProcedure [dbo].[spRebuildCSTCustSummaryRollup]    Script Date: 09/24/2015 14:35:36 ******/
--SET ANSI_NULLS ON

insert into [SMI Reporting].dbo.PJC_SMIHD_2345_CatalogsPerCustomer

select                                         -- 566,158 @12-03-2014
    CST.ixCustomer,                                          -- 570,689 @01-08-2015
    C.dtAccountCreateDate,                          -- 571,612 @01-22-2015
    R.Recency,                          -- how many months old is their most recent order?
 --   isnull(F.LFrequency,0) 'Frequency', -- Lifetime Frequency
 --   ISNULL(ML.Monetary,0) 'MLTotal', 
    --(ISNULL(ML.Monetary,0) / isnull(F.LFrequency,9999)) 'AOV', -- set the isnull value on LFrequency high to avoid DIV/0 errors      
    MOIR.sOptInStatus   'OptInRace',
    MRO.LatestOrder,
    isnull(CR.CatsSinceLastOrder,0) 'CatsSinceLastOrder',
    isnull(CR24Mo.CatsRecvd24Mo,0) 'CatsLast24Mo'
--into [SMI Reporting].dbo.PJC_SMIHD_2345_CatalogsPerCustomer
from 
    --[SMI Reporting].dbo.vwCSTStartingPool CST               -- BUYERS 541,656       run-time < 1 min
    [SMI Reporting].dbo.vwCSTStartingPoolRequestors CST     -- REQUESTORS 44,475   run-time < 1 min
    LEFT JOIN [SMI Reporting].dbo.tblCustomer C on CST.ixCustomer = C.ixCustomer
    LEFT JOIN (-- RECENCY (Regardless of Market)           
                select SP.ixCustomer, 
                    DATEDIFF(M,MAX(O.dtOrderDate),GETDATE()) 'Recency' -- how many months old is their most recent order?
                from [SMI Reporting].dbo.vwCSTStartingPool SP
                    join [SMI Reporting].dbo.tblOrder O on O.ixCustomer = SP.ixCustomer                                 
                where  O.dtOrderDate >= DATEADD(MM, -24, getdate())  -- Lifetime
                   and O.sOrderType <> 'Internal'
                   and O.sOrderStatus = 'Shipped'
                   and O.mMerchandise > 1
                group by SP.ixCustomer
              ) R on CST.ixCustomer = R.ixCustomer 
      
    /**** MONETARY for each of the 5 MAIN markets *****/  
                                                                   
    /**** OPT-IN STATUS FOR EACH OF THE 5 MARKETS *****/           
    LEFT JOIN [SMI Reporting].dbo.tblMailingOptIn MOIR on CST.ixCustomer = MOIR.ixCustomer and MOIR.ixMarket = 'R'  
    LEFT JOIN (-- most recent order date
               select ixCustomer, MAX(dtOrderDate) LatestOrder
               from tblOrder O
               where sOrderStatus in ('Shipped','Backordered')
               group by ixCustomer) MRO on MRO.ixCustomer = CST.ixCustomer
    LEFT JOIN (-- how many catalogs received since customer's last order
               select CO.ixCustomer,MRO.LatestOrder, 
               --COUNT(distinct CO.ixSourceCode) CatsSinceLastOrder           <-- INCORRECT some customers where marked with multiple SCs for the Same Catalog.  Need to count distinct Catalogs instead of SCs.
               COUNT(distinct SC.ixCatalog) CatsSinceLastOrder
               from tblCustomerOffer CO
                  join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
                  left join (-- most recent order date
                               select ixCustomer, MAX(dtOrderDate) LatestOrder
                               from tblOrder O
                               where sOrderStatus in ('Shipped','Backordered')
                               group by ixCustomer
                              ) MRO on CO.ixCustomer = MRO.ixCustomer
               where SC.sSourceCodeType like 'CAT%'
                 and SC.dtStartDate > MRO.LatestOrder 
                 and SC.dtStartDate between '9/23/13' and  '9/24/15'
               group by CO.ixCustomer,MRO.LatestOrder
                ) CR on CR.ixCustomer = CST.ixCustomer

    LEFT JOIN (-- how many catalogs received last 24 Months
               select CO.ixCustomer,
               --COUNT(distinct CO.ixSourceCode) CatsSinceLastOrder           <-- INCORRECT some customers where marked with multiple SCs for the Same Catalog.  Need to count distinct Catalogs instead of SCs.
               COUNT(distinct SC.ixCatalog) CatsRecvd24Mo
               from tblCustomerOffer CO
                  join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
               where SC.sSourceCodeType like 'CAT%'
                 and SC.dtStartDate between '9/23/13' and  '9/24/15'
               group by CO.ixCustomer
                ) CR24Mo on CR24Mo.ixCustomer = CST.ixCustomer
WHERE (MOIR.sOptInStatus is NULL or MOIR.sOptInStatus in ('UK','Y'))
  AND CST.ixCustomer NOT in (SELECT ixCustomer FROM [SMI Reporting].dbo.PJC_SMIHD_2345_CatalogsPerCustomer)
  AND (isnull(CR.CatsSinceLastOrder,0) > 0 OR isnull(CR24Mo.CatsRecvd24Mo,0) > 0 )
  AND CST.ixCatalogMarket = 'R' -- only when joining to requestors view









SELECT * FROM [SMI Reporting].dbo.vwCSTStartingPoolRequestors


/*
-- select distinct sSourceCodeType from sSourceCodeType
-- SELECT * FROM tblSourceCode
-- SELECT * FROM vwCSTStartingPoolRequestors
-- select * from [SMI Reporting].dbo.vwCSTStartingPool
-- SELECT * FROM [SMI Reporting].dbo.PJC_SMIHD_2345_CatalogsPerCustomer

-- SELECT COUNT(*) FROM [SMI Reporting].dbo.vwCSTStartingPool 




-- TRUNCATE TABLE [SMI Reporting].dbo.PJC_SMIHD_2345_CatalogsPerCustomer

-- CLEAN-UP
select COUNT(ixCustomer) CustCount, COUNT(Distinct ixCustomer) DistCount
from [SMI Reporting].dbo.PJC_SMIHD_2345_CatalogsPerCustomer
/*
CustCount	DistCount
586131	    586131
*/

-- REMOVING BUYS that haven't purchased in last 24 months
-- DELETE 
-- SELECT * 
FROM [SMI Reporting].dbo.PJC_SMIHD_2345_CatalogsPerCustomer
WHERE LatestOrder is NOT NULL
and LatestOrder < '9/24/13'

-- REMOVING anyone that hasn't received a catalog
-- DELETE 
-- SELECT * 
FROM [SMI Reporting].dbo.PJC_SMIHD_2345_CatalogsPerCustomer
WHERE CatsSinceLastOrder = 0
    AND CatsLast24Mo = 0


select COUNT(ixCustomer) CustCount, COUNT(Distinct ixCustomer) DistCount
from [SMI Reporting].dbo.PJC_SMIHD_2345_CatalogsPerCustomer
/*
CustCount	DistCount
343329	    343329
*/


SELECT * FROM [SMI Reporting].dbo.PJC_SMIHD_2345_CatalogsPerCustomer
WHERE 


select OptInRace, count(*)
from [SMI Reporting].dbo.PJC_SMIHD_2345_CatalogsPerCustomer
group by OptInRace

SELECT * FROM  [SMI Reporting].dbo.PJC_SMIHD_2345_CatalogsPerCustomer
WHERE CatsSinceLastOrder = (CatsLast24Mo+1)
ORDER BY LatestOrder

SELECT * FROM  [SMI Reporting].dbo.PJC_SMIHD_2345_CatalogsPerCustomer
WHERE CatsLast24Mo = 0
ORDER BY LatestOrder

SELECT ixCustomer, count(*)
from [SMI Reporting].dbo.PJC_SMIHD_2345_CatalogsPerCustomer
group by ixCustomer
having count(*) > 1
*/

SELECT * FROM tblCustomerOffer where ixCustomer = '2230657'