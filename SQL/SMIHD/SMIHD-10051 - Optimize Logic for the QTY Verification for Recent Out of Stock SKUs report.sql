-- SMIHD-10051 - Optimize Logic for the QTY Verification for Recent Out of Stock SKUs report


DECLARE @Date datetime
SELECT @Date = '2/4/2018'

select SKU.ixSKU,SKU.sDescription, -- 2/4/08 32 rows @0:24			2/7/2018 79 rows 21:24
        B.ixBin as Bin,
        '*'+B.ixBin+'*' as BinBarcode
from vwSKULocalLocation SKU
    join (select DISTINCT SNAP.ixSKU
		  from tblSnapshotSKU SNAP 
			join tblDate D on D.ixDate = SNAP.ixDate -- SKU's with 0 QOS for Date parameter
							and D.dtDate = (@Date+1) -- yesterday  *date in tblSnapshotSKU has the values of the PREVIOUS day!  eg. TUESDAY'S ixDate is really the final data from MONDAY
			join (-- SKUs that had QOS > 0 the day before
				  select SNAP.ixSKU
				  from tblSnapshotSKU SNAP                                       
					join tblDate D on D.ixDate = SNAP.ixDate 
									and D.dtDate = (@Date) -- day before   *date in tblSnapshotSKU has the values of the PREVIOUS day!  eg. TUESDAY'S ixDate is really the final data from MONDAY
				  where SNAP.iFIFOQuantity <> 0 and SNAP.iFIFOQuantity is not null
				  ) YDAY2 on YDAY2.ixSKU = SNAP.ixSKU
		  where SNAP.iFIFOQuantity = 0 or SNAP.iFIFOQuantity is null -- 32045
		 ) NoQOS on NoQOS.ixSKU = SKU.ixSKU
     join tblBinSku BS on BS.ixSKU = SKU.ixSKU
     join tblBin B on B.ixBin = BS.ixBin
			         and B.ixBin <> 'BOM'
where (SKU.iQOS is null or SKU.iQOS = 0) -- check for current QOS
     and (SKU.dtDiscontinuedDate is null or SKU.dtDiscontinuedDate > getdate()) 
     and SKU.ixSKU not like 'UP%'
    and BS.ixLocation = '99'
    and B.ixLocation = '99'
order by  B.ixBin




-- REWRITE NoQOS
DECLARE @Date datetime
SELECT @Date = '2/7/2018'  -- 306

select DISTINCT SNAP.ixSKU
from tblSnapshotSKU SNAP -- SKU's with 0 QOS for Date parameter
	join tblDate D on D.ixDate = SNAP.ixDate 
					and D.dtDate = (@Date+1) -- yesterday  *date in tblSnapshotSKU has the values of the PREVIOUS day!  eg. TUESDAY'S ixDate is really the final data from MONDAY
	join tblSnapshotSKU SNAP2 on SNAP.ixSKU = SNAP2.ixSKU                                       
	join tblDate D2 on D2.dtDate = (@Date) 
					and  D2.ixDate = SNAP2.ixDate -- day before   *date in tblSnapshotSKU has the values of the PREVIOUS day!  eg. TUESDAY'S ixDate is really the final data from MONDAY
where SNAP.iFIFOQuantity = 0 or SNAP.iFIFOQuantity is null -- 318,590
	and SNAP2.iFIFOQuantity <> 0 and SNAP2.iFIFOQuantity is not null


	) YDAY

join 
	-- SKUs that had QOS > 0 the day before
	(select SNAP.ixSKU
	from 
	where 
	) YDAY2 on YDAY2.ixSKU = YDAY.ixSKU





SELECT NoQOS.*
(  -- 306

DECLARE @Date datetime
SELECT @Date = '2/7/2018'

select DISTINCT SNAP.ixSKU
from tblSnapshotSKU SNAP 
	join tblDate D on D.ixDate = SNAP.ixDate -- SKU's with 0 QOS for Date parameter
    and D.dtDate = (@Date+1) -- yesterday  *date in tblSnapshotSKU has the values of the PREVIOUS day!  eg. TUESDAY'S ixDate is really the final data from MONDAY
join (-- SKUs that had QOS > 0 the day before
	select SNAP.ixSKU
	from tblSnapshotSKU SNAP                                       
	join tblDate D on D.ixDate = SNAP.ixDate 
			and D.dtDate = (@Date) -- day before   *date in tblSnapshotSKU has the values of the PREVIOUS day!  eg. TUESDAY'S ixDate is really the final data from MONDAY
	where SNAP.iFIFOQuantity <> 0 and SNAP.iFIFOQuantity is not null
	) YDAY2 on YDAY2.ixSKU = SNAP.ixSKU
where SNAP.iFIFOQuantity = 0 or SNAP.iFIFOQuantity is null -- 32045

         ) NoQOS on NoQOS.ixSKU = SKU.ixSKU
















		 
SELECT NoQOS.*
(  -- 306

DECLARE @Date datetime
SELECT @Date = '2/7/2018'

select DISTINCT SNAP.ixSKU
from tblSnapshotSKU SNAP 
	join tblDate D on D.ixDate = SNAP.ixDate -- SKU's with 0 QOS for Date parameter
    and D.dtDate = (@Date+1) -- yesterday  *date in tblSnapshotSKU has the values of the PREVIOUS day!  eg. TUESDAY'S ixDate is really the final data from MONDAY
join (-- SKUs that had QOS > 0 the day before
	select SNAP.ixSKU
	from tblSnapshotSKU SNAP                                       
	join tblDate D on D.ixDate = SNAP.ixDate 
			and D.dtDate = (@Date) -- day before   *date in tblSnapshotSKU has the values of the PREVIOUS day!  eg. TUESDAY'S ixDate is really the final data from MONDAY
	where SNAP.iFIFOQuantity <> 0 and SNAP.iFIFOQuantity is not null
	) YDAY2 on YDAY2.ixSKU = SNAP.ixSKU
where SNAP.iFIFOQuantity = 0 or SNAP.iFIFOQuantity is null -- 32045

         ) NoQOS on NoQOS.ixSKU = SKU.ixSKU