-- ERROR CODE 1060

select ixDate, ixErrorCode, COUNT(*) QTY
from tblErrorLogMaster
where ixErrorCode = 1060
and ixDate >= 18086
group by ixDate, ixErrorCode
order by ixDate desc

select sError, COUNT(*)
from tblErrorLogMaster
where ixErrorCode = 1060
and ixDate > = 18084
and ixTime > 54000 -- 3pm       57600 -- 4pm
GROUP BY sError

SELECT * from tblTime where chTime like '15:00%'

SELECT chTime from tblTime where ixTime = 61476 -- 16:06:27  @4:09
select * from tblOrder where ixOrder = '7616031'

select MAX(ixTime) 
from tblErrorLogMaster
where ixDate = 18084

select ixDate, ixErrorCode, COUNT(*) QTY
from tblErrorLogMaster
where ixErrorCode = 1060
and ixDate >= 18084
group by ixDate, ixErrorCode
order by ixDate desc