  SELECT distinct ixVendor
  FROM tblVendorSKU
  where iOrdinality <> 1
  and ixVendor NOT IN (select distinct ixVendor
  
  
  select count(distinct ixVendor) -- 1292
  from tblVendorSKU
  where iOrdinality = 1           -- 1164
  
  
select distinct VS.ixSKU, VS.iOrdinality, VS.ixVendor, SKU.dtDateLastSOPUpdate
from tblVendorSKU VS
    join tblSKU SKU on VS.ixSKU = SKU.ixSKU
where SKU.flgDeletedFromSOP = 0
    and ixVendor not in (select distinct ixVendor
                         from tblVendorSKU
                         where iOrdinality = 1)
order by VS.ixSKU, VS.iOrdinality


select VS.*
from tblVendorSKU VS
    join (
                select ixSKU, count(*) QTY
                from tblVendorSKU
                where iOrdinality = 1
              
                group by ixSKU
                having count(*) = 3
          ) DUPES on DUPES.ixSKU = VS.ixSKU
order by VS.ixSKU,VS.iOrdinality

-- SKUs in tblSKU but NOT tblVendorSKU
select ixSKU, flgIntangible, dtDateLastSOPUpdate
from tblSKU
where ixSKU not in (Select ixSKU from tblVendorSKU)
and flgDeletedFromSOP = 0

select distinct ixSKU--, dtDateLastSOPUpdate
from tblVendorSKU
where ixSKU not in (Select ixSKU from tblSKU) --where flgDeletedFromSOP = 0)

select count ( distinct ixVendor) from tblVendor