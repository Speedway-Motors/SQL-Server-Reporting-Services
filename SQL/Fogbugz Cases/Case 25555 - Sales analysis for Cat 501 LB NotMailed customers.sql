-- refeed SKUS to populate mZone4Rate
select dtDateLastSOPUpdate, ixSKU -- 24642
from tblSKU
where mZone4Rate is NULL
and dtDateLastSOPUpdate < '07/25/2015'
and flgActive = 1
and flgDeletedFromSOP = 0
and flgBackorderAccepted = 1
and flgIntangible = 0
and flgIsKit = 0
and mPriceLevel1 > 220
order by dtDateLastSOPUpdate