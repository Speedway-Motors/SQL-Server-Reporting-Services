-- SMIHD-5445 - New report - SKUs loaded per Catalog
SELECT CM.ixCatalog 'Catalog', 
    M.sDescription 'Market', 
    CM.sDescription 'CatalogDescription', 
    CONVERT(VARCHAR, CM.dtStartDate, 101) AS 'StartDate',
    CONVERT(VARCHAR, CM.dtEndDate, 101) AS 'EndDate',
 --   CM.dtEndDate, CM.dtStartDate, -- for sorting purposes only
    ISNULL(COUNT(distinct ixSKU),0) 'UniqueSKUs',
    COUNT(distinct ixSKU)
from tblCatalogMaster CM
    left join tblCatalogDetail CD on CM.ixCatalog = CD.ixCatalog
    left join tblMarket M on CM.sMarket = M.ixMarket
where CM.dtEndDate > GETDATE() -- ends in the future
and CM.dtStartDate < DATEADD(dd, 14, getdate()) -- has started or will start within the next 2 weeks
group by CM.ixCatalog, M.sDescription, CM.sDescription, 
    CONVERT(VARCHAR, CM.dtStartDate, 101), CONVERT(VARCHAR, CM.dtEndDate, 101), CM.dtEndDate, CM.dtStartDate
-- order by CM.dtStartDate desc -- CM.dtStartDate desc --COUNT(distinct ixSKU), CM.dtStartDate
order by ISNULL(COUNT(distinct ixSKU),0), CM.dtStartDate












