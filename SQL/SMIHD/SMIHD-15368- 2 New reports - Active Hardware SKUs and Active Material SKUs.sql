SMIHD-15368	- 2 New reports - Active Hardware SKUs and Active Material SKUs

select * from tblSKU
where flgDeletedFromSOP = 0
and flgActive = 1
and ixSKU like 'H%'



select *, len(ixSKU) from tblSKU
where ixSKU like 'H%'
and flgDeletedFromSOP = 0
order by len(ixSKU)

HABSP-.38-.88-.44
HABSP.P
HALFFRT
HALSP-.31-.63-3.38
HB5SHSBC-.31-.75
HB8BHCSF-1/4-3/8
HB8BSCSC-OK-.38
HB8FHCSC-8-32-.50
HB8FHCSM-08-150-35
HZZERK00F-.25-.52
HZTTHFW-USS-.75
HBWK-605
HBSP.38.63.13.P
HC5NLNC-.63
HBSP.3863163.C
HCSP-.44-.69.C
HE8HCSM-14-200-35
HNNGPW-.50-.75
HNSP-.17-.38-.25
HOR.008.N
HOR.1MMX6MM.N
HSSFHCSM-08-125-120
HZSP.P
HZ5TNLN-USS-.63
HZZERK00D-.19-.25