-- Catalogs with recent or upcoming Inhome dates
-- possible sub-report for DOT or other reports to show catalog releases that may impact sales performance
-- keywords for searches   inhome in-home release event upcoming

SELECT ixCatalog+' '+sDescription 'Cat'
    ,sMarket
    ,CONVERT(VARCHAR,D.dtDate, 1)   'In-Home'
FROM tblCatalogMaster CM
    join tblDate D on CM.ixInHomeDate = D.ixDate
where ixInHomeDate between 18328 and 18388 -- will need to determine the days out threshold.  e.g. Catalogs released within 2 weeks of @StartDate
    and SUBSTRING(ixCatalog,1,1) IN ('4','5','6','8')
    and ixCatalog NOT LIKE '%N'
    and ixCatalog NOT LIKE '%P'

SELECT ixCatalog+' '+sDescription 'Cat'
    ,sMarket
    ,CONVERT(VARCHAR,D.dtDate, 1)   'In-Home'
FROM tblCatalogMaster CM
    join tblDate D on CM.ixInHomeDate = D.ixDate
where ixInHomeDate between 17963 and 18023 -- will need to determine the days out threshold.  e.g. Catalogs released within 2 weeks of @EndDate
and SUBSTRING(ixCatalog,1,1) IN ('4','5','6','8')
and ixCatalog NOT LIKE '%N'
and ixCatalog NOT LIKE '%P'

