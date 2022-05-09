select sTransactionType, count(*) QTY
from tblSKUTransaction
--where sTransactionType like '%UNIT%'
group by sTransactionType
order by sTransactionType



select top 2 sTransactionType, (D.dtDate) LastTransactionDate, ST.ixTime, 'QTY'
from tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
where sTransactionType = 'SETINVRU' -- ('SETINVRU','SETRESTOCKMAX','SETRESTOCKMIN')
order by ST.ixDate desc, ST.ixTime Desc
--group by sTransactionType


-- STEP 1 GET A LIST OF ALL THE SKUs that were modified during the time range

SELECT distinct ST.ixSKU
from tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
where ST.sTransactionType in ('SETINVRU','SETRESTOCKMAX','SETRESTOCKMIN')
  and D.dtDate between '11/01/2011' and '11/28/2011' -- @StartDate and @EndDate



-- nested TOP statements
SELECT TOP 1 FName 
FROM 
( 
    SELECT TOP 10 FName 
    FROM Names 
    ORDER BY FName 
) sub 
ORDER BY FName DESC 
 