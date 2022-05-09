        -- multiple primary vendors
        select VS.*
        from tblVendorSKU VS
            join (
                        select ixSKU, count(*) QTY -- NONE
                        from tblVendorSKU
                        where iOrdinality = 1
                        group by ixSKU
                        having count(*) > 1
                        ) DUPES on DUPES.ixSKU = VS.ixSKU
        order by VS.ixSKU,VS.iOrdinality, ixVendor


        -- SKU's with multiple matching iOrdinality
        select VS.*
        from tblVendorSKU VS
            join (
                        select ixSKU, count(*) QTY
                        from tblVendorSKU
                        where iOrdinality = 8
                        group by ixSKU
                        having count(*) > 1
                        ) DUPES on DUPES.ixSKU = VS.ixSKU
        order by VS.ixSKU,VS.iOrdinality, ixVendor
        /*
        iOrdinality rows
         2          812     0 
         3          143     0
         4 to 9       0     0
        */

        select max(iOrdinality) from tblVendorSKU -- 9



-- active SKUs with QOS that are NULL for ixVendor when joining thru to the Vendor table
select SKU.ixSKU, V.ixVendor -- 47296  47359
from tblSKU SKU
 left join tblVendorSKU VS on VS.ixSKU = SKU.ixSKU and VS.iOrdinality = 1
 left join tblVendor V on V.ixVendor = VS.ixVendor and VS.iOrdinality = 1
where SKU.flgActive = 1
    and SKU.iQOS > 0
order by V.ixVendor


        -- No Primary Vendors
        select distinct ixSKU -- 285    0
        from tblVendorSKU
        where ixSKU NOT IN 
                (select ixSKU
                from tblVendorSKU
                where iOrdinality = 1)




-- SKUs in tblSKU but not tblVendorSKU
SELECT distinct ixSKU -- 13715    41        5,338   7  where QOS > 0
FROM tblSKU
WHERE iQOS > 0 and
    ixSKU NOT IN
    (SELECT ixSKU
        FROM tblVendorSKU)  




select count (distinct ixSKU) -- 63,758
from tblSKU 

select count (distinct ixSKU) -- 63,747
from tblVendorSKU 


select distinct ixSKU -- 30
from tblVendorSKU 
where ixSKU NOT IN
 (select distinct ixSKU 
from tblSKU)



select count(distinct ixVendor) -- 1,135   1,154
from tblVendorSKU 

select count(distinct ixVendor) -- 1,135   1,565
from tblVendor

        select distinct ixSKU -- NONE
        from tblVendorSKU 
        where ixVendor is null

        select distinct ixSKU -- NULL
        from tblVendorSKU 
        where iOrdinality is null

select * from tblVendorSKU
--order by ixSKU, iOrdinality
order by iOrdinality



-- Vendors in tblVendorSKU but not tblVendor
SELECT distinct ixVendor
FROM tblVendorSKU
WHERE ixVendor NOT IN
    (SELECT ixVendor
        FROM tblVendor)   
/*
550
595
25060
0387
751
*/

-- BIG test if every SKU should have a primary vendor that exists in the Vendor table
select SKU.ixSKU,V.ixVendor,VS.iOrdinality -- 49 still null
from tblSKU SKU
    left join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU 
                             and iOrdinality = 1
    left join tblVendor V on V.ixVendor = VS.ixVendor
order by iOrdinality,V.ixVendor


/* Observations as of 9-17-10 AM

tblSKU:
    there are 13715 SKUs that are not in tblVendorSKU 

tblVendorSKU:
    285 SKUs do not have a vendor with iOrdinality = 1
    812 rows returned for SKUs with multiple values of iOrdinality = 2
    143 "                                                        " = 3
      0 "                                                        " = 4 thru 8
    there are currently no SKUs that have iOrdinality or ixVendor as null in tblVendorSKU -- Yay!

tblVendor:
    these vendors are tblVendorSKU but not tblVendor ('25060','0387','','751')

*/



-- SKUs in tblSKU but not tblVendorSKU
SELECT SKU.ixSKU, sum(OL.mExtendedPrice) Sales -- 13715    5,338 where QOS > 0
FROM tblSKU SKU
    left join tblOrderLine OL on SKU.ixSKU = OL.ixSKU
                        and OL.dtOrderDate > '09/01/08'
                        and OL.flgLineStatus = 'Shipped' 
WHERE --SKU.iQOS > 0and 
SKU.ixSKU NOT IN
    (SELECT ixSKU
        FROM tblVendorSKU)  
GROUP by SKU.ixSKU
order by SKU.ixSKU -- sum(OL.mExtendedPrice) desc

-- SKUs in tblSKU but not tblVendorSKU
SELECT VS.ixVendor, SKU.ixSKU SKU, SKU.sDescription, SKU.ixPGC PGC, SKU.iQOS QOS, SKU.dtCreateDate -- 13715   7 where QOS > 0
FROM tblSKU SKU
    left join tblVendorSKU VS on VS.ixSKU = SKU.ixSKU
WHERE SKU.iQOS > 0 and 
SKU.ixSKU NOT IN
    (SELECT ixSKU
        FROM tblVendorSKU)  
ORDER BY SKU.ixSKU