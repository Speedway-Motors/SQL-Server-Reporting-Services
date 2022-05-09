-- BOM Usage by month
WITH
ctePreAgg AS
(
SELECT D.iYear,
        D.iMonth,
        ST.ixSKU,
        ISNULL(SUM(ST.iQty),0) * -1 AS TotalQty 
FROM tblSKUTransaction ST 
    LEFT JOIN tblSKU SKU on ST.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = SKU.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
WHERE D.dtDate BETWEEN '01/01/2016' AND '03/31/2016' -- be sure to start with the 1st of a month and end with the last day of a month for accurate results
    AND ST.sTransactionType = 'BOM' 
    AND ST.iQty < 0
    AND SKU.ixPGC like 'P%' -- PRO
GROUP BY ST.ixSKU, D.iYear, D.iMonth
)
 SELECT ixSKU,
        iYear,
        [Jan] = SUM(CASE WHEN iMonth =  1 THEN TotalQty ELSE 0 END),
        [Feb] = SUM(CASE WHEN iMonth =  2 THEN TotalQty ELSE 0 END),
        [Mar] = SUM(CASE WHEN iMonth =  3 THEN TotalQty ELSE 0 END),
        [Apr] = SUM(CASE WHEN iMonth =  4 THEN TotalQty ELSE 0 END),
        [May] = SUM(CASE WHEN iMonth =  5 THEN TotalQty ELSE 0 END),
        [Jun] = SUM(CASE WHEN iMonth =  6 THEN TotalQty ELSE 0 END),
        [Jul] = SUM(CASE WHEN iMonth =  7 THEN TotalQty ELSE 0 END),
        [Aug] = SUM(CASE WHEN iMonth =  8 THEN TotalQty ELSE 0 END),
        [Sep] = SUM(CASE WHEN iMonth =  9 THEN TotalQty ELSE 0 END),
        [Oct] = SUM(CASE WHEN iMonth = 10 THEN TotalQty ELSE 0 END),
        [Nov] = SUM(CASE WHEN iMonth = 11 THEN TotalQty ELSE 0 END),
        [Dec] = SUM(CASE WHEN iMonth = 12 THEN TotalQty ELSE 0 END),
        [Total] = SUM(TotalQty)
 FROM ctePreAgg
 GROUP BY ixSKU, iYear
 ORDER BY ixSKU, iYear
/*
ixSKU	            iYear	Jan	Feb	Mar	Apr	May	Jun	Jul	Aug	Sep	Oct	Nov	Dec	Total
91800231-VNL-YEL	2016	10	0	0	0	0	0	0	0	0	0	0	0	10
91800231.1	        2016	10	0	0	0	0	0	0	0	0	0	0	0	10


