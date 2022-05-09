-- Recent STOCK-OUT SKUs for Larkins
select skum.ixSKU
from 
	[SMI Reporting].dbo.vwSKUMultiLocation skum left join [SMI Reporting].dbo.tblSKU s on skum.ixSKU=s.ixSKU 
	left join [SMI Reporting].dbo.tblVendorSKU vs on skum.ixSKU=vs.ixSKU and vs.iOrdinality=1
	left join [SMI Reporting].dbo.tblVendor v on vs.ixVendor=v.ixVendor
	left join [SMI Reporting].dbo.tblSKULocation sl on skum.ixSKU=sl.ixSKU and sl.ixLocation=99
 where skum.iQAV <= 0 
	and s.flgIsKit=0
	and s.flgIntangible=0
	and s.flgDeletedFromSOP=0
	and s.dtDiscontinuedDate > getdate()
	and s.flgActive=1
	and vs.ixVendor <> '9999'
	and s.ixSKU not like 'UP%'
	and vs.ixVendor <> '0106'
	and vs.ixVendor <> '0108'
	and vs.ixVendor <> '0311'
	and vs.ixVendor <> '0313'
	and sl.sPickingBin <> '999'
	and vs.ixVendor <> '0999'
	and vs.ixVendor <> '0009' 
	and v.ixBuyer in ('JDS','jds','KDL')
	and skum.ixSKU not in (select so.ixSKU from [SMI Reporting].dbo.tblStockOut so)
	
	select * from tblSKU where ixSKU = '91048340-567'
	
	select * from tblVendorSKU where ixSKU = '91048340-567'