-- Case 21807 - Kit Retail and Cost Summary report displaying some non-kit SKUs



select * from tblSKU where ixSKU = '1603102.1'


select * from tblKit where ixKitSKU = '1603102.1' -- 2013-10-02 00:00:00.000



select * from vwDataFreshness
where sTableName = 'tblKit'
order by DaysOld

-- Carol refed ALL kits
select min(ixTimeLastSOPUpdate) FirstRec, max(ixTimeLastSOPUpdate) LastRec
from tblKit
where dtDateLastSOPUpdate = '03/03/2014'
--59232	59920    <-- 66,565 recs in 688 seconds


select count(*) from tblKit
where dtDateLastSOPUpdate < '03/03/2014' -- 89

-- Carol confirmed the 35 kit skus are no longer kits in SOP
select distinct ixKitSKU
from tblKit
where dtDateLastSOPUpdate < '03/03/2014'



-- backing up the data to purge
select * 
into [SMITemp].dbo.tblKit_DataDeleted03042014
    from tblKit where ixKitSKU in
    (select distinct ixKitSKU
    from tblKit
    where dtDateLastSOPUpdate < '03/03/2014')

-- DELTING non-kit SKUs
DELETE
FROM tblKit
    where dtDateLastSOPUpdate < '03/03/2014'   