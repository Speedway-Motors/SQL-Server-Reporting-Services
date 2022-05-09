-- Garage Sale (UP) SKU inventory values by month based on FIFO values

SELECT @@SPID as 'Current SPID' -- 130    <-- run first to check for blocking issues

-- first day of each fiscal period
select ixDate
from tblDate D
where D.iDayOfFiscalPeriod = 1 and D.dtDate >= '08/01/2017'
order by ixDate


-- tblSnapshotSKU ( goes back to 08/01/2017 )
SELECT D.iPeriodYear, D.iPeriod, D.dtDate, 
    sum(mFIFOExtendedCost) 'ExtFIFOCost'
from tblSnapshotSKU SS
    LEFT JOIN tblDate D on D.ixDate = SS.ixDate
where SS.ixDate in -- the ixDates that are the 1st day of the period
    (18143,18171,18199,18234,18262,18290,18325,18353,18381,18416,18444,18472,18507,18535,18563,18598,18626,18654,18689,18717,18745,18780,18808,18836,18871,18899,18927,18962,18990,19018,19053,19081,19109,19144,19172,19200,19235,19263,19291,19326)
    and ixSKU like 'UP%'
group by D.iPeriodYear, D.iPeriod, D.dtDate
order by D.dtDate desc



-- tblSnapshotSKUArchive
SELECT D.iPeriodYear, D.iPeriod, D.dtDate, 
    sum(mFIFOExtendedCost) 'ExtFIFOCost'
from [SMIArchive].dbo.tblSnapshotSKUArchive SS
    LEFT JOIN tblDate D on D.ixDate = SS.ixDate
where SS.ixDate in -- the ixDates that are the 1st day of the period
    (16438,16803,17170,17198,17233,17261,17289,17324,17352,17380,17415,17443,17471,17506,17534,17562,17597,17625,17653,17688,17716,17744,17779,17807,17835,17870,17898,17926,17961,17989,18017,18052,18080,18108)
    and ixSKU like 'UP%'
group by D.iPeriodYear, D.iPeriod, D.dtDate
order by D.dtDate desc