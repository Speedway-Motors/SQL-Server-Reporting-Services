-- refeed SKUS to populate mZone4Rate

-- TRUNCATE TABLE [SMITemp].dbo.PJC_Deleted_SKUs
-- INSERT into [SMITemp].dbo.PJC_Deleted_SKUs
select ixSKU    -- 25,451
    ,dtDateLastSOPUpdate 
from tblSKU
where flgDeletedFromSOP = 0
and mZone4Rate is NULL                  --- 117K@ 7-29-15
and dtDateLastSOPUpdate < '07/25/2015'  --- 113K@ 7-29-15
and flgActive = 1                       ---  87K@ 7-29-15
    -- and flgBackorderAccepted = 1            ---  61K@ 7-29-15
    -- and flgIsKit = 0                        ---  52K@ 7-29-15
    -- and mPriceLevel1 > 0
order by dtDateLastSOPUpdate


select mZone4Rate, COUNT(*)
from tblSKU
group by mZone4Rate
order by mZone4Rate desc