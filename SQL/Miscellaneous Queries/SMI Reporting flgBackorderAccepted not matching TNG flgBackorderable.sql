-- SMI Reporting flgBackorderAccepted not matching TNG flgBackorderable

-- FINAL RESULTS
-- TNG tblskuvariant.flgBackorderable = 1 if the SKU is Backordable OR IF IT'S AN MTO SKU.  Therefore it will never match with SMI Reporting because the logic is different.
select * from tblSKU
where ixSKU in ('10621940WRG', '10622746', '10621753DWRG')


select * from tblSKU
where ixSKU in ('10621940WRG', '10622746', '10621753DWRG')


select S.ixSKU, S.flgBackorderAccepted 'SMIReporting_tblSKU_flgBackorderAccepted', TNG.TNG_tblskuvariant_flgBackorderable -- 7,087
from tblSKU S
full outer join (
        SELECT * 
        from openquery([TNGREADREPLICA], '
        SELECT ixSOPSKU, flgBackorderable AS TNG_flgBackorderable
        from tblskuvariant
        ')
) TNG ON S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = TNG.ixSOPSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE S.ixSKU = '1060514-20-20-0'  AND 
        S.flgDeletedFromSOP = 0
    AND S.flgBackorderAccepted <> TNG.TNG_flgBackorderable



select SKUM.ixSKU, SKUM.flgBackorderAccepted, SKUM.dtDiscontinuedDate, --SKUM.dtDateLastSOPUpdate,
 SKUM.iQAV--, SKUM.*
from vwSKUMultiLocation SKUM --on S.ixSKU = SKUM.ixSKU
where SKUM.ixSKU = '1060514-20-20-0' -- 
/*
ixSKU	            flgBackorderAccepted	dtDateLastSOPUpdate
1060514-20-20-0	    0	                    2016-03-03 00:00:00.000
*/
 
 SELECT * from tblSKUTransaction
 where ixSKU = '1060514-20-20-0'
 order by ixDate desc, ixTime desc
 
 select * from tblDate where ixDate = 17385