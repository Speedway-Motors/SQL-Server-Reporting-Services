-- Case 25309 - tblNameflowCustSummary_Rollup

/*
tblNetNameRollUp (no idea) 
*/
-- TRUNCATE Table [SMI Reporting].dbo.tblNameflowCustSummary_Rollup
INSERT INTO [SMI Reporting].dbo.tblNameflowCustSummary_Rollup
SELECT C.ixCustomer,
   isNULL(S12M.Sales,0) 'mSales12Month',
   isNULL(SLT.Sales,0) 'mSalesLifetime',   
   isNULL(F12M.OrderCount,0) 'iOrderCount12Month',
   isNULL(FLT.OrderCount,0) 'iOrderCountLifetime'
-- INTO [SMI Reporting].dbo.tblNameflowCustSummary_Rollup
FROM [SMI Reporting].dbo.tblCustomer C 
    LEFT JOIN (--  Sales 12 Mo
                select O.ixCustomer, 
                    SUM(isNULL(O.mMerchandise,0))    'Sales' 
                from [SMI Reporting].dbo.tblOrder O 
                where  O.dtOrderDate >= DATEADD(MM, -12, getdate()) -- 12 Month
                   and O.sOrderType <> 'Internal'
                   and O.sOrderStatus  = 'Shipped'
                   and O.ixOrder NOT LIKE '%-%' 
                   and O.mMerchandise > 1                  
                group by O.ixCustomer
               ) S12M on C.ixCustomer = S12M.ixCustomer                
    LEFT JOIN (--  Sales Lifetime
                select O.ixCustomer, 
                    SUM(isNULL(O.mMerchandise,0))    'Sales' 
                from [SMI Reporting].dbo.tblOrder O
                where  O.dtOrderDate >= DATEADD(MM, -72, getdate()) -- Lifetime
                   and O.sOrderType <> 'Internal'
                   and O.sOrderStatus  = 'Shipped'
                   and O.ixOrder NOT LIKE '%-%' 
                   and O.mMerchandise > 1                   
                group by O.ixCustomer
               ) SLT on C.ixCustomer = SLT.ixCustomer   
    LEFT JOIN (-- FREQUENCY Order Count 12 Mo 
                select O.ixCustomer,
                 COUNT(O.ixOrder) AS 'OrderCount'
                from [SMI Reporting].dbo.tblOrder O 
                where  O.dtOrderDate >= DATEADD(MM, -12, getdate())  -- 12 Month
                   and O.sOrderType <> 'Internal'
                   and O.sOrderStatus = 'Shipped'
                   AND O.ixOrder NOT LIKE '%-%'
                   and O.mMerchandise > 1 
                group by O.ixCustomer   
              ) F12M on C.ixCustomer = F12M.ixCustomer  
    LEFT JOIN (-- FREQUENCY Order Count (within Lifetime)   
                select O.ixCustomer,
                 COUNT(O.ixOrder) AS 'OrderCount'
                from [SMI Reporting].dbo.tblOrder O 
                where  O.dtOrderDate >= DATEADD(MM, -72, getdate())  -- Lifetime
                   and O.sOrderType <> 'Internal'
                   and O.sOrderStatus = 'Shipped'
                   AND O.ixOrder NOT LIKE '%-%'
                   and O.mMerchandise > 1 
                group by O.ixCustomer   
              ) FLT on C.ixCustomer = FLT.ixCustomer                                
WHERE    isNULL(SLT.Sales,0)  > 0     -- has Sales
    AND  isNULL(FLT.OrderCount,0) > 0 
               
-- full table 1.6M rows in 28 SEC
-- must have F>0 and $>0        

select COUNT(*) from tblNameflowCustSummary_Rollup
select COUNT(distinct ixCustomer) from tblNameflowCustSummary_Rollup


select distinct sOrderStatus from tblOrder    

select * from tblNameflowCustSummary_Rollup   
order by iOrderCountLifetime desc,
mSalesLifetime desc

select * from tblNameflowCustSummary_Rollup   
order by --iOrderCountLifetime desc,
mSalesLifetime desc

select * from tblCustomer where ixCustomer in ('1770000','450169','380866','299695','526820','533015','1073350','359650','526884','154939')

select * from tblNameflowCustSummary_Rollup NFRU
join tblCustomer C on C.ixCustomer = NFRU.ixCustomer
where C.flgDeletedFromSOP = 1

select * from tblOrder  -- 47 
where ixCustomer in 
('1556038','1978644','843227','2219542','1863502','1079210','994869','1632767','383125','1060356','1149986','1626270','1867005','1549219')
ORDER BY dtDateLastSOPUpdate desc


select distinct ixOrder, O.dtDateLastSOPUpdate
from tblOrder O
join tblCustomer C on O.ixCustomer = C.ixCustomer
and C.flgDeletedFromSOP = 1