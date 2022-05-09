-- Case 21112 - add unique constraint to tblFIFODetail

USE [AFCOReporting]
-- USE [SMI Reporting]

alter table tblFIFODetail add constraint uc_SKUDateOrdinality unique (ixSKU, ixDate, iOrdinality, ixLocation)

select COUNT(ixID) FROM tblFIFODetail       -- 97,115,336 @SMI

select COUNT(DISTINCT ixID) FROM tblFIFODetail -- 97,115,336  @SMI

--select * from tblFIFODetail
select ixSKU, ixDate, iOrdinality, ixLocation, count(*) 
from tblFIFODetail
--where ixSKU = 'OIL'
group by ixSKU, ixDate, iOrdinality, ixLocation
HAVING count(*) > 1
order by count(*) desc
-- RETURNS 53,726 ROWS@AFCO      386,763 ROWS @SMI

-- SHOULD be unique combo of all fields (except ixID)
select min(ixID) ixID, ixSKU, ixDate, iOrdinality, iFIFOQuantity, ixFIFODate, mFIFOCost, sFIFOSourceType, ixLocation
into tblFIFODetailTEMP
from tblFIFODetail
group by ixSKU, ixDate, iOrdinality, iFIFOQuantity, ixFIFODate, mFIFOCost, sFIFOSourceType, ixLocation


select ixSKU, ixDate, iOrdinality, ixLocation, count(*) 
from tblFIFODetailTEMP
where ixSKU = 'OIL'
group by ixSKU, ixDate, iOrdinality, ixLocation
HAVING count(*) > 1
order by count(*) desc

select top 1500 * from tblFIFODetailTEMP
where ixSKU = 'OIL'
and ixDate = 16468
order by ixDate, iOrdinality

select top 1500 * from tblFIFODetail
where ixSKU = 'OIL'
and ixDate = 16468
order by ixDate, iOrdinality

select top 1 ixSKU, ixDate, iOrdinality, ixLocation
from tblFIFODetail
where ixSKU = 'OIL'
group by ixSKU, ixDate, iOrdinality, ixLocation
HAVING count(*) > 1
order by count(*) desc 






select count(ixID)from tblFIFODetail            14,040,080
select count(distinct ixID) from tblFIFODetail  14,040,080




/*
--FROM SSA JOB AFCO Bulk Upload

bulk insert tblFIFODetail
    from 'e:\DataWarehouse\AFCO\tblFIFODetail.txt'
    with
    (
        MAXERRORS = 5,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    )
*/

