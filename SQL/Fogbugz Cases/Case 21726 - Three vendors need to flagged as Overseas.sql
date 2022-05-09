-- Case 21726 - Three vendors need to flagged as Overseas

/* 
    This flag field is manually set by us based on a list of vendors Moss provides us.
    vendors flagged as Overseas: 
        20 @4-24-2013 
        23 @2-25-2014
*/   
 
-- BEFORE UPDATE 
 select ixVendor, flgOverseas
from tblVendor where ixVendor in ('1618','3896','3014')

  
update tblVendor
set flgOverseas = 1
where ixVendor in ('1618','3896','3014')

-- AFTER UPDATE 
select ixVendor, flgOverseas
from tblVendor where ixVendor in ('1618','3896','3014')
/*
ixVendor	flgOverseas
1618	1
3014	1
3896	1
*/


select flgOverseas, ixVendor, sName
from tblVendor where flgOverseas = 1
order by ixVendor

/* flagged as Overseas @4-24-2013

flag
Ovrs ixVendor sName
1	0099	SPEEDWAY IMPORT ITEM
1	0345	FINISHLINE RACEWEAR USA, LLC
1	1024	GLOBAL SERVICING LLC
1	1089	APPLEGATE PERFORMANCE PRODUCT
1	1265	CHINA FIRST AUTOMOTIVE
1	1275	CHINA AUTO GROUP
1	1363	DALIAN QI MING METAL
1	1618	GOLDEN WHEEL DIE CAST LTD
1	1625	GRAND ARTISAN PRODUCTS INC
1	1729	RICHARD HUNG ENT CO LTD
1	1735	HIMET TECHNOLOGIES CO
1	1825	IUMBA INT'L LLC
1	1914	JPS RACEGEAR LLC
1	2240	MOTOR PARTS S.A.
1	2423	ORPHIC INTERNATIONAL, INC
1	2558	PARTSALL INC
1	2838	PRORACE PRODUCTS INC
1	2895	SPEEDWAY MOTORS SHANGHAI
1	2920	SHANGHAI HONGDA METAL CO
1	3014	US PEDAL CAR INC
1	3415	ZHEJIANG ANHE ECONOMY & TRAD
1	3895	SPEEDWAY SHANGHAI-YUN ZHEN
1	3896	SPEEDWAY SHANGHAI FITTING
*/


select * from tblTableSizeLog
where sTableName = 'tblOrderTNT'

