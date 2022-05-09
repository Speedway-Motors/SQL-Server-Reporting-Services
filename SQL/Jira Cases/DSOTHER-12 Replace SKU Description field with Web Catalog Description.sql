-- DSOTHER-12 Replace SKU Description field with Web Catalog Description

select * from tblProductLine

select count(*) from tblCatalogDetail -- 2,033,443
select count(*) from tblCatalogDetail --   108,228
where ixCatalog = 'WEB.13'

select count(*) from tblCatalogDetail --   284,841
where ixCatalog LIKE 'WEB%'


SELECT distinct ixCatalog 
from tblCatalogDetail
where ixCatalog LIKE 'WEB%'

SELECT *
from tblCatalogMaster
where ixCatalog LIKE 'WEB%'


select top 10 * from  tblCatalogDetail 

select dtDateLastSOPUpdate , ixTimeLastSOPUpdate
/*sDescription, ixBrand*/ from tblSKU where ixSKU = '96012813'
    -- ixBrand = '10200'

select * from tblProductLine where ixBrand = 10200

select SKU.ixSKU
from tblSKU SKU
    join tblCatalogDetail CD on SKU.ixSKU = CD.ixSKU -- 108,223
where CD.ixCatalog = 'WEB.13'
and SKU.flgDeletedFromSOP = 1

-- 91062154 flagged deleted


select * from tblSKU


select ixSKU, sWebDescription, 
--sWebUrl, sWebImageUrl, 
dtDateLastSOPUpdate, ixTimeLastSOPUpdate
,getDate()
from tblSKU where ixSKU in ('9134060')
/*
ixSKU	sWebDescription	dtDateLastSOPUpdate	ixTimeLastSOPUpdate	(No column name)
9134060	Garage Sale - Bronze Boy	2013-11-26 00:00:00.000	73373	2013-11-27 12:10:30.733
*/                                                          44222

select ixSKU, sWebDescription, dtCreateDate, sWebImageUrl
where sWebImageUrl is NOT NULL
order by dtCreateDate





select ixSKU, sWebDescription, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblSKU 
where ixSKU = '9134060'



SKU	    WebDescription	                    LastSOPUpdate	    TimeLastSOPUpdate
9134060	Garage Sale - Bronze Boy Statue	    2013-12-19          41085
9134060	Garage Sale - Bronze Boy Figure	    2013-12-23          40087
9134060	Garage Sale - Bronze Boy Statue	    2013-12-23          48795


select SKU.dtDateLastSOPUpdate, count(*)
from tblSKU SKU
join tblCatalogDetail CD on SKU.ixSKU = CD.ixSKU
where CD.ixCatalog = 'WEB.13'
GROUP BY SKU.dtDateLastSOPUpdate
ORDER BY SKU.dtDateLastSOPUpdate DESC


select --top 20000 -- 81,780
SKU.ixSKU --SKU.dtDateLastSOPUpdate, count(*) -808
from tblSKU SKU
join tblCatalogDetail CD on SKU.ixSKU = CD.ixSKU and CD.ixCatalog = 'WEB.13'
where SKU.dtDateLastSOPUpdate = '12/20/2013'
and SKU.flgDeletedFromSOP = 0

ORDER BY SKU.dtDateLastSOPUpdate DESC



select count(*) from tblSKU where flgDeletedFromSOP = 0 -- 165,626 @12-23-2013

/* who modify's web descriptions and needs permissions set-up in SQL Server?
Jeremy
Wyatt
Tyler Wesely
Brady Britten
Zach Votipka
*/

select *-- ixSKU, sWebDescription, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblSKU 
where ixSKU = '9134060'

select *-- ixSKU, sWebDescription, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblVendorSKU 
where ixSKU = '9134060'

Brand = 10191 Speedway
Vendor = 1729 RICHARD HUNG ENT CO LTD


select * from tblVendor where ixVendor = '1729'
select * from tblBrand where ixBrand = '10191'


select SKU.ixSKU, SKU.sDescription, SKU.sWebDescription
    , V.sName, B.sBrandDescription
from tblSKU SKU
join tblCatalogDetail CD on SKU.ixSKU = CD.ixSKU
join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU and VS.iOrdinality = 1
join tblVendor V on VS.ixVendor = V.ixVendor
join tblBrand B on B.ixBrand = SKU.ixBrand
where CD.ixCatalog = 'WEB.13'
    and SKU.sDescription <> SKU.sWebDescription
    and SKU.flgDeletedFromSOP = 0
    and SKU.sWebDescription is NOT NULL
    and B.sBrandDescription <> 'No Brand Assigned'

