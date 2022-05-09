-- Print Catalog Gross Sales by Period based on Matchback
-- compiled for Betsy on 12-9-15
SELECT D.iYear, D.iPeriod,
    SUM(O.mMerchandise) GrossSales
FROM tblOrder O
    left join tblDate D on O.ixOrderDate = D.ixDate
    left join tblSourceCode SC on O.sMatchbackSourceCode = SC.ixSourceCode
WHERE     O.sOrderStatus = 'Shipped'
    and O.ixOrderDate between 17142 and 17505
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- 
    --and SC.ixCatalog = '504' <-- to test, I compared this Catalog to results on Catalog Performance Summary report... almost identical results
    and SC.sSourceCodeType = 'CAT-H'
GROUP BY D.iYear, D.iPeriod
ORDER BY D.iYear, D.iPeriod    

/*
ixDate	Date
17142	12/06/2014 -- first day of P12 2014
17505	12/04/2015 -- last day of P11 2015
*/


select * from tblDate where ixDate = 17142