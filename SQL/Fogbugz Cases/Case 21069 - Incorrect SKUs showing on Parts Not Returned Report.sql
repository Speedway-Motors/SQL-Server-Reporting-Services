-- Case 21069 - Incorrect SKUs showing on Parts Not Returned Report

select * from tblSKUTransaction where ixSKU = '582WB95'
and ixDate >= 16810 -- 1/8/14
order by ixDate desc, ixTime desc


select D.dtDate, T.chTime,
sUser, iSeq, sTransactionType, ixSKU, iQty, sBin, sToBin, sCID, sTransactionInfo
from tblSKUTransaction ST
join tblDate D on ST.ixDate = D.ixDate
join tblTime T on ST.ixTime = T.ixTime
where ixSKU = '582WB95'
and ST.ixDate >= 16810 -- 1/8/14
order by ST.ixDate desc, ST.ixTime desc
