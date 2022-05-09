select SKU.ixSKU,SKU.sDescription,
        B.ixBin as Bin,
        '*'+B.ixBin+'*' as BinBarcode -- ,B.ixBinLocation,B.sBinType
from tblSKU SKU
    join 
        (select YDAY.ixSKU 
         from 
         -- yesterdays SKU's with 0 QOS
         (select SNAP.ixSKU
          from tblSnapshotSKU SNAP 
            join tblDate D on D.ixDate = SNAP.ixDate 
                          and D.dtDate = DATEADD(dd, DATEDIFF(dd,1,getdate()), 0) -- yesterday
          where SNAP.iFIFOQuantity = 0 or SNAP.iFIFOQuantity is null -- 32045
          ) YDAY

         join 
         -- SKUs that had QOS > 0 two days ago
            (select SNAP.ixSKU
             from tblSnapshotSKU SNAP                                       
                join tblDate D on D.ixDate = SNAP.ixDate 
                              and D.dtDate = DATEADD(dd, DATEDIFF(dd,2,getdate()), 0) -- 2 days ago
             where SNAP.iFIFOQuantity <> 0 and SNAP.iFIFOQuantity is not null-- 32781
             ) YDAY2 on YDAY2.ixSKU = YDAY.ixSKU
         ) NoQOS on NoQOS.ixSKU = SKU.ixSKU
     join tblBinSku BS on BS.ixSKU = SKU.ixSKU
     join tblBin B on B.ixBin = BS.ixBin
where (SKU.iQOS is null or SKU.iQOS = 0)
     and (SKU.dtDIscontinuedDate is null or SKU.dtDIscontinuedDate > getdate()) 
     and SKU.ixSKU not like 'UP%'
order by ixSKU--SKU.dtDIscontinuedDate













 -- yesterdays SKU's with 0 QOS
  select SNAP.ixSKU, D.dtDate 
  from tblSnapshotSKU SNAP 
    join tblSKU SKU on SKU.ixSKU = SNAP.ixSKU
    join tblDate D on D.ixDate = SNAP.ixDate 
                  and D.dtDate = DATEADD(dd, DATEDIFF(dd,1,getdate()), 0) -- yesterday
  where SNAP.iFIFOQuantity = 0 or SNAP.iFIFOQuantity is null -- 32045



select * into PJC_temp_tblSnapshotSKU_BU
from tblSnapshotSKU

select count(*) from tblSnapshotSKU -- 3391471 before dels
                                    -- 3390760 after dels
delete from tblSnapshotSKU
where ixSKU in (
select SNAP.ixSKU
from tblSnapshotSKU SNAP
    left join tblDate D on D.ixDate = SNAP.ixDate
where SNAP.ixSKU not in (select ixSKU from tblSKU)
    and D.dtDate = '01/01/2010')

group by SNAP.ixSKU
order by max(D.dtDate) desc


select SNAP.*, D.dtDate
from tblSnapshotSKU SNAP
    left join tblDate D on D.ixDate = SNAP.ixDate
where ixSKU in ('1061370-50,','91013860-POL','91082305-2','5506833','91082305-1','311PART','1061350-50')
order by dtDate, SNAP.ixSKU

select distinct ixSKU
from tblSnapshotSKU SNAP
    left join tblDate D on D.ixDate = SNAP.ixDate
where SNAP.ixSKU not in (select ixSKU from tblSKU)
