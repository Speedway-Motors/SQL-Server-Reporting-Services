-- SMIHD-8625 - Analysis on BOMs
select ---D.iYear, 
count(S.ixSKU) BOMsCreated
from tblBOMTemplateMaster BTM 
join tblSKU S on BTM.ixFinishedSKU = S.ixSKU -- 9,341 current BOM SKUs
join tblDate D on S.ixCreateDate = D.ixDate
where S.flgDeletedFromSOP = 0
and S.flgActive = 1
group by D.iYear
order by D.iYear desc


select D.iYear, count(S.ixSKU) BOMsCreated
from tblBOMTemplateMaster BTM 
join tblSKU S on BTM.ixFinishedSKU = S.ixSKU -- 9,341 current BOM SKUs
join tblDate D on S.ixCreateDate = D.ixDate
where S.flgDeletedFromSOP = 0
-- and S.flgActive = 1 it doesn't mattees
group by D.iYear
order by D.iYear desc
/*
9,341 current BOM SKUs
            
        	   Created
2017 YTD	  933
2016	    1,718
2015	    1,081
2014	    1,177
2013	    1,148