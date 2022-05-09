-- SMIHD-2388 - research why SMI backorders of AFCO parts aren't always getting filled

-- created "Backorders for AFCO SKUs (Vendor 0106)" report that is in the Purchasing folder/project


select * from tblSKULocation
where ixSKU in ('1034','19060','20008','20019RM-1','20026RM-1','20027RM-1','20194-11D','3770HSRZ','6630310','7241-9002','7241-9005','7242-0005','80137-S-SS-N','80138-P-NA-Y','80142-S-NA-N','80146-P-SB-Y','81164-P-NA-N','701-17210')
and ixLocation = 99
order by ixSKU


select * from tblSKUTransaction where ixSKU = '20194-11D'
order by ixDate desc, iSeq desc


select * from tblFIFODetail
where ixSKU = '20194-11D'
order by ixDate desc

select distinct sFIFOSourceType
from tblFIFODetail
where ixSKU = '20194-11D'

/*****   Source Type info from Connie  

BOM – Bill of Materials (qos updated)
DCF – DC Transfer Finalize
ICS – Inter-Company Sale
IICS – Inter-Company Sale (mdse originally owned by SMI)
M – Memo Entry
QC – Quantity Correction
R - Receiving
TI – Inter Transfer (between different locations)

*/