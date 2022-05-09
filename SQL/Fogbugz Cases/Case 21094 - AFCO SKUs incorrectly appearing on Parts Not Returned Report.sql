-- Case 21094 - AFCO SKUs incorrectly appearing on Parts Not Returned Report

select * from tblSKUTransaction
where ixSKU = '9850-6120'
order by ixDate desc


-- 16789	12/18/2013	WEDNESDAY

select * from tblVendorSKU where sVendorSKU = '10698506120'


select * from tblVendorSKU where sVendorSKU = '98506120'


select * from tblVendorSKU where sVendorSKU = '9850-6120'


select * from tblSKU where ixSKU = '9850-6120'




-- REFEED ST on AFCO side for SKUs