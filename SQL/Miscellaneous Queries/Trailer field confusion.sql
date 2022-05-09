-- Trailer field confusion

/* these fields are in tblOrderRouting
    ccc also added them to tblOrder
    when both sets have values, they match 100% of the time so far
    approx 2/3 of the time when there is a value in one table...
        the same order shows NULL for the value in the other table
*/
select O.ixOrder O_ixOrder
   -- ,ORT.ixOrder ORT_ixOrder
    ,O.ixPrintPrimaryTrailer O_PPTrailer
    ,ORT.ixPrintPrimaryTrailer ORT_PPTrailer
    ,O.ixPrintSecondaryTrailer O_PSTrailer
    ,ORT.ixPrintSecondaryTrailer ORT_PSTrailer
   -- ,ORT.dtDateLastSOPUpdate ORT_LastSOPUpdate
from tblOrder O
full outer join tblOrderRouting ORT on O.ixOrder = ORT.ixOrder
where O.dtShippedDate >= '03/01/2014'
AND (O.ixPrintPrimaryTrailer is NOT NULL
    OR 
    ORT.ixPrintPrimaryTrailer is NOT NULL)
AND ORT.dtDateLastSOPUpdate >=  '03/16/2014'     
AND ORT.ixPrintPrimaryTrailer IS NOT null
and O.ixPrintPrimaryTrailer IS null
and O.ixOrder like '%-%'
order by newid()
    
select * from tblOrder where ixOrder in ('5324455','5506752','5484057')
    
AND  (O.ixPrintSecondaryTrailer =  ORT.ixPrintSecondaryTrailer  
    OR O.ixPrintSecondaryTrailer = ORT.ixPrintSecondaryTrailer)
--AND ORT.dtDateLastSOPUpdate <>   '03/19/2014'

select count(*) from tblOrder where ixPrintPrimaryTrailer is NOT NULL -- 3504
select count(*) from tblOrder where 

select ixOrder from tblOrder 
where dtOrderDate >= '03/01/2014'  --105
and sOrderStatus = 'Shipped'
and ixPrintPrimaryTrailer is NULL 
AND dtDateLastSOPUpdate <> '03/19/2014'


select min(dtShippedDate) from tblOrder
where ixPrintPrimaryTrailer is NOT NULL 
dtShippedDate

select
       o.ixOrder,
       o.ixPrintPrimaryTrailer,
       ort.ixPrintPrimaryTrailer
from
       tblOrder o
       left join tblOrderRouting ort on o.ixOrder=ort.ixOrder
where o.dtOrderDate >= '03/14/14'

       o.ixPrintPrimaryTrailer <> ort.ixPrintPrimaryTrailer
       and o.dtOrderDate >= '03/14/14'

