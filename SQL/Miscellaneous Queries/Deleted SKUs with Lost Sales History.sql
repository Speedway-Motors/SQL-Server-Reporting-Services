-- SKUs deleted from SOP that have sales in the past 12 months
SELECT OL.ixSKU SKU, 
    SUM(OL.mExtendedPrice) Sales36Mo,
    SKU.sDescription 'SKU Description',
    --SKU.sSEMACategory 'SEMA Cat',
    --SKU.sSEMASubCategory 'SEMA SubCat',
    --SKU.sSEMAPart 'SEMA Part',
    SKU.ixPGC 'PGC'
    ,ST.sUser 'Deleted by'
   -- ,ST.ixDate 
    ,D.dtDate 'Deleted Date'
FROM tblOrderLine OL
    join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    left join tblSKUTransaction ST on SKU.ixSKU = ST.ixSKU and ST.sTransactionType = 'DELETE' -- condition must stay on the join
    left join tblDate D on ST.ixDate = D.ixDate
where SKU.flgDeletedFromSOP = 1
--SKU.ixSKU in ('91076236','97052094','9708200','910950','91800423GB','91011010')
  and OL.flgLineStatus in( 'Shipped','Dropshipped')
  and OL.dtShippedDate >= '05/13/2012'  -- @StartDate
 -- and ST.sUser = 'JMM'
group by OL.ixSKU,
    SKU.sDescription,
    --SKU.sSEMACategory,
    --SKU.sSEMASubCategory,
    --SKU.sSEMAPart,
    SKU.ixPGC
   ,ST.sUser
   ,D.dtDate
having SUM(OL.mExtendedPrice) <> 0
order by D.dtDate desc 
--ST.sUser, Sales36Mo desc

select * FROM tblOrderLine where ixSKU = '91800808-BLK'
order by ixOrderDate desc

select * from tblEmployee where ixEmployee = 'JAK'
-- JAK	KARLS	JEFFREY

select * from tblOrderLine
where ixSKU = '91050149'
order by dtOrderDate desc

select --* 
ixSKU, flgDeletedFromSOP, flgActive
from tblSKU
where ixSKU in ('91076236','97052094','9708200','910950','91800423GB','91011010')

update tblSKU
set flgDeletedFromSOP = 1
where ixSKU in ('91076236','97052094','9708200','910950','91800423GB','91011010')--= '97652010' 

select * from tblSKUTransaction
where ixSKU IN('910950')
    and ixDate >= 14611
order by ixSKU, ixDate desc, ixTime desc




select flgLineStatus, count(*)
from tblOrderLine
group by flgLineStatus


select * from tblSKU where ixSKU like '910501%'




select OL.ixSKU, SUM(OL.mExtendedPrice) Sales
from tblOrderLine OL
    join tblSKU SKU on OL.ixSKU = SKU.ixSKU
   -- join tblSKUTransaction ST on ST.ixSKU = SKU.ixSKU
where SKU.flgDeletedFromSOP = 1
  and OL.flgLineStatus in( 'Shipped','Dropshipped')
  and OL.dtShippedDate >= '01/01/2012'
group by OL.ixSKU  

select * from tblOrderLine


select SUM(OL.mExtendedPrice)
from tblOrderLine OL
where ixSKU in ('910950-BLK','910950-RED')