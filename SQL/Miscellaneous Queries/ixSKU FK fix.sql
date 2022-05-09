-- truncate table PJC_Orphaned_SKUs
insert into PJC_Orphaned_SKUs
select distinct 
ixSKU
,NULL, NULL, NULL, NULL, NULL ,NULL, NULL, NULL
, 'SKU DELETED FROM SOP'-- sDescription
, 'UNKWN'				-- flgUnitOfMeasure
, 1						-- flgTaxable
, 0						-- iQAV
, 0						-- iQOS
, NULL, NULL, NULL, NULL, NULL
, 0						-- flgActive
, NULL, NULL, NULL
, 0						-- flgAdditionalHandling
, 10013					-- ixBrand
, NULL,NULL
, 0						-- flgIsKit
, NULL, NULL, NULL ,NULL, NULL, NULL
, 0						-- flgShipAloneStatus
, 0						-- flgIntangible
, NULL
, 0						-- iLeadTime
, NULL, NULL, NULL  
from tblCreditMemoDetail
where ixSKU not in (select ixSKU from tblSKU)
  AND ixSKU not in (select ixSKU from PJC_Orphaned_SKUs)


select * from PJC_Orphaned_SKUs

select distinct ixSKU from PJC_Orphaned_SKUs
where ixSKU in (select ixSKU from tblSKU) -- 2594


select count(*) from tblSKU -- 85157

insert into tblSKU
select * from PJC_Orphaned_SKUs


-- tables with over 1000 SKUs
tblCreditMemoDetail -- 983
tblSnapshotSKU		-- 1K+
tblOrderLine		-- 2583
tblPODetail			-- 3353

