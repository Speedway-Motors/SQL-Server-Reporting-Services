select * from PJC_FasterZips -- 13091 (distinct pulls exact qty too)
order by ixZipCode 

select COUNT(distinct sShipToZip) -- 30736 total zips  -- 8932
from tblOrder
    join PJC_FasterZips FZ on FZ.ixZipCode = tblOrder.sShipToZip
where sOrderStatus = 'Shipped'
and (sShipToCountry is NULL
    or sShipToCountry = 'US'
    or sShipToCountry = 'USA'
    )
    
  
    
select COUNT(distinct ixCustomer) 
from PJC_CST_Output_341  -- 267,604   (distinct pulls exact qty too)

/*
counts by segment where exact match to CST

select ixSourceCode, COUNT(*)
from PJC_CST_Output_341
group by ixSourceCode
order by ixSourceCode

SC	    Qty
34102	32126
34103	10396
34104	14687
34105	19360
34106	4165
34107	486
34108	2265
34109	12237
34110	21160
34111	35320
34112	2811
34113	235
34114	1267
34115	7783
34116	14365
34117	24760
34118	2192
34119	184
34120	933
34121	5495
34122	10376
34170	45001
*/





select COUNT(distinct CST.ixCustomer) -- 267,604   of which 86,425 are in the faster zips  32.3%
from PJC_CST_Output_341 CST
join tblCustomer C on CST.ixCustomer = C.ixCustomer
join PJC_FasterZips FZ on FZ.ixZipCode = C.sMailToZip








-- populating customers zips
update A 
set sMailToZip = C.sMailToZip
from PJC_CST_Output_341 A
 join tblCustomer C on A.ixCustomer = C.ixCustomer

-- assign new source codes if there zips are in the improved TNT list
update PJC_CST_Output_341
set ixNewSourceCode = (CASE when ixSourceCode <= 34122 and sMailToZip in (select ixZipCode from PJC_FasterZips) then ixSourceCode+30
                       else ixSourceCode
                       end) 

-- update PJC_CST_Output_341 set ixNewSourceCode = NULL


select ixNewSourceCode, COUNT(*)
from PJC_CST_Output_341
group by ixNewSourceCode
order by ixNewSourceCode

select top 10 * from PJC_CST_Output_341


select ixCustomer+','+ixNewSourceCode
from PJC_CST_Output_341


select distinct (BS.sBinType) from tblBin




select ixSourceCode, COUNT(*)
from tblCustomerOffer
where ixSourceCode between '34101' and '34199'
group by ixSourceCode
order by ixSourceCode
