-- SMIHD-2940 - analysis on catalogs dot com value

SELECT * from tblSourceCode
where upper(sDescription) like '%CATALOGS%'

-- 
SELECT * from tblSourceCode
where upper(ixSourceCode) like 'CC%'
/*
ixSourceCode	sDescription
CCR	            Cat.com RaceReq
CCSM	        Cat.com SMReq
CCSR	        Cat.com StrReq
CCTB	        Cat.com TbktReq
*/
-- are CCR (race), CCSM (sprint/midget), CCSR (street), CCTB (tbucket). 


select * from tblCustomer
where ixSourceCode in ('CCR','CCSM','CCSR','CCTB') -- 12,454
and flgDeletedFromSOP = 0
order by dtAccountCreateDate desc


-- DROP TABLE [SMITemp].dbo.[PJC_SMIHD_2940_CatDotComCustomers]
SELECT C.ixCustomer, -- 12,454
    D.iYearMonth, D.iYear, D.iQuarter, D.iPeriod, D.iMonth,
    TS.TotSales 'LTV',
    OC.OrderCount 'TotOrders'
INTO [SMITemp].dbo.[PJC_SMIHD_2940_CatDotComCustomers]
from tblCustomer C
    left join tblDate D on C.ixAccountCreateDate = D.ixDate
    left join (-- Total Sales
                select O.ixCustomer, SUM(O.mMerchandise) TotSales
                from tblOrder O
                where O.sOrderStatus = 'Shipped'
                    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                    and O.sOrderType <> 'Internal'   -- USUALLY filtered
                group by O.ixCustomer                    
                ) TS on TS.ixCustomer = C.ixCustomer    
    left join (-- # of Orders
                select O.ixCustomer, COUNT(ixOrder) OrderCount
                from tblOrder O
                where O.sOrderStatus = 'Shipped'
                    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                    and O.sOrderType <> 'Internal'   -- USUALLY filtered
                    and O.ixOrder NOT LIKE '%-%'
                group by O.ixCustomer                    
                ) OC on OC.ixCustomer = C.ixCustomer        
where C.ixSourceCode in ('CCR','CCSM','CCSR','CCTB') -- 12,454
    and C.flgDeletedFromSOP = 0
    and C.dtAccountCreateDate > = '01/01/2009'


SELECT iYear, 
--iQuarter, 
COUNT(ixCustomer) AccountsCreated,
SUM(LTV) TotLTV,
SUM(TotOrders) 'TotOrders'
FROM [SMITemp].dbo.[PJC_SMIHD_2940_CatDotComCustomers]
GROUP by iYear--, iQuarter
ORDER by iYear--, iQuarter
/*      Accounts            Tot
iYear	Created	TotLTV	    Orders
2009	2279	22098.37	131
2010	3580	42799.02	266
2011	2070	31181.18	209
2012	2098	37452.29	252
2013	1130	 9810.65	66
2014	815	    13575.49	74
2015	477	     3937.63	21
*/


-- BUYERS ONLY
SELECT * -- 372
INTO [SMITemp].dbo.[PJC_SMIHD_2940_CatDotComCustomersBuyers]
FROM [SMITemp].dbo.[PJC_SMIHD_2940_CatDotComCustomers] 
WHERE LTV > 0   

SELECT iYear,
COUNT(ixCustomer) AccountsCreated,
SUM(LTV) TotLTV,
SUM(TotOrders) 'TotOrders'
FROM [SMITemp].dbo.[PJC_SMIHD_2940_CatDotComCustomersBuyers]
GROUP by iYear--, iQuarter
ORDER by iYear
/*      Accounts            Tot
iYear	Created	TotLTV	    Orders
2009	59	    22098.37	131
2010	98	    42799.02	266
2011	75	    31181.18	209
2012	69	    37452.29	252
2013	31	    9810.65 	66
2014	30	    13575.49	74
2015	10	    3937.63	    21
*/
    
SELECT iYear, 
    COUNT(ixCustomer) 'NoOrders'
FROM [SMITemp].dbo.[PJC_SMIHD_2940_CatDotComCustomers]
where LTV = 0
GROUP by iYear
ORDER by iYear



select distinct ixCustomer
from tblOrder O
where ixCustomer in (select ixCustomer from tblCustomer C where C.ixSourceCode in ('CCR','CCSM','CCSR','CCTB') and flgDeletedFromSOP = 0)


SELECT COUNT(*) FROM vwCSTStartingPool
where ixCustomer in (select ixCustomer FROM [SMITemp].dbo.[PJC_SMIHD_2940_CatDotComCustomersBuyers])

SELECT * FROM [SMITemp].dbo.[PJC_SMIHD_2940_CatDotComCustomersBuyers] -- 5 
where ixCustomer NOT in (select ixCustomer FROM vwCSTStartingPool)

SELECT * FROM tblCustomer
where ixCustomer in ('1811111','1002525','1944718','1948678','1378132')

-- how many catalogs have we mailed to these customers?
SELECT SC.* 
from tblCustomerOffer CO -- 74,876
join [SMITemp].dbo.[PJC_SMIHD_2940_CatDotComCustomers] CC on CO.ixCustomer = CC.ixCustomer
join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
where SC.sSourceCodeType = 'CAT-H'
and SC.ixSourceCode NOT LIKE '%!%'
