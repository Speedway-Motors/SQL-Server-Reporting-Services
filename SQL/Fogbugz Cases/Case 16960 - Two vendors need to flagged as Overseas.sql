-- Case 16960 - Two vendors need to flagged as Overseas

/* 
    This flag field is manually set by us based on a list of vendors Moss provides us.
    After this change was made there were 20 vendors flagged as Overseas @4-24-2013
*/   
   
update tblVendor
set flgOverseas = 1
where ixVendor in ('0345','1914')



select ixVendor, flgOverseas
from tblVendor where ixVendor in ('0345','1914')


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
1	3415	ZHEJIANG ANHE ECONOMY & TRAD
1	3895	SPEEDWAY SHANGHAI-YUN ZHEN
*/
