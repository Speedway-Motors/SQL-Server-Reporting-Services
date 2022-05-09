-- SMIHD-19632 - Wholesale Catalog data 2020 vs 2021
select CM.ixCatalog, FORMAT(count(CD.ixSKU),'###,###') 'SKUCnt', FORMAT(GETDATE(),'yyyy.MM.dd hh:mm')  'AsOf'
from tblCatalogMaster CM
    left join tblCatalogDetail CD on CM.ixCatalog = CD.ixCatalog
where CD.ixCatalog IN ('MRR.20','MRR.21', 'PRS.20','PRS.21')
group by CM.ixCatalog
order by CM.ixCatalog
/*
ix      SKU
Catalog	Count	AsOf
======= ======= ================
MRR.20	164,681	2020.12.28 09:44
MRR.21	164,680	
PRS.20	191,675	
PRS.21	191,685	

*/


-- SKUs missing from 1 of the 2 annual catalogs
select * from tblCatalogDetail
where ixCatalog = 'MRR.20'
and ixSKU NOT IN (select ixSKU from tblCatalogDetail where ixCatalog = 'MRR.21') -- 7 as of 2020.12.28 09:44

select * from tblCatalogDetail
where ixCatalog = 'MRR.21'
and ixSKU NOT IN (select ixSKU from tblCatalogDetail where ixCatalog = 'MRR.20') -- 6

-- SKUs missing from 1 of the 2 annual catalogs
select * from tblCatalogDetail
where ixCatalog = 'PRS.20'
and ixSKU NOT IN (select ixSKU from tblCatalogDetail where ixCatalog = 'PRS.21') -- 1

select * from tblCatalogDetail
where ixCatalog = 'PRS.21'
and ixSKU NOT IN (select ixSKU from tblCatalogDetail where ixCatalog = 'PRS.20') -- 11


