-- SMIHD-6745 - SKU report for Edelbrock and Russell brands
SELECT * from tblBrand
WHERE Upper(sBrandDescription) like '%EDELBROCK%'
or Upper(sBrandDescription) like '%RUSSELL%'
/*
ixBrand	sBrandDescription
10018	Edelbrock
10832	Russell Performance
*/
Edelbrock and Russell Performance SKUs
select MAX(dtLastTNGUpdate) from tblBrand -- 2017-03-08 23:10:01.477

SELECT S.ixBrand, S.ixSKU, S.sDescription--, S.dtLastTNGUpdate
FROM tblSKU S
WHERE ixBrand in (10018,10832)
    and flgDeletedFromSOP = 0
order by S.ixBrand, S.ixSKU   


SELECT S.ixBrand, COUNT(S.ixSKU) 'SKUcnt'
FROM tblSKU S
WHERE ixBrand in (10018,10832)
    and flgDeletedFromSOP = 0
Group by S.ixBrand
/*
Brand	SKUcnt
10832	   39   Russell Performance
10018	4,149   Edelbrock

Ron verified 100% match on the counts by SKU variant in TNG!
*/
