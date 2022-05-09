-- Transaction Types in tblSKUTransaction

SELECT top 100 
    D.dtDate,
    T.chTime,
    TT.sDescription 'TransactionType',
    ST.sTransactionType, 
    ST.sUser, ST.ixSKU, ST.iQty, 
    ST.mAverageCost, ST.sLocation, ST.sToLocation, ST.sWarehouse, ST.sToWarehouse, ST.sBin, ST.sToBin, 
    ST.sTransactionInfo,
    ST.sCID, ST.sToCID, ST.sGID, ST.sToGID, ST.ixReceiver, ST.ixJob, ST.flgBinScanned
FROM tblSKUTransaction ST
    LEFT JOIN tblDate D on D.ixDate = ST.ixDate
    LEFT JOIN tblTime T on T.ixTime = ST.ixTime
    LEFT JOIN tblTransactionType TT on ST.sTransactionType = TT.ixTransactionType
WHERE (sBin = 'REVIEW'
       OR
       sToBin = 'REVIEW')
    AND sLocation = 99
ORDER BY ST.ixDate desc, ST.ixTime desc
    
-- select * from tblTransactionType
/* 
filter out Transactions be eliminating Transaction Types  
-- and ST.sTransactionType IN (your list) -- or NOT IN

*/





SELECT --DISTINCT ST.sTransactionType
    top 100 
    D.dtDate,
    T.chTime,
    TT.sDescription 'TransactionType',
    ST.sTransactionType, 
    ST.sUser, ST.ixSKU, ST.iQty, 
    ST.mAverageCost, ST.sLocation, ST.sToLocation, ST.sWarehouse, ST.sToWarehouse, ST.sBin, ST.sToBin, 
    ST.sTransactionInfo,
    ST.sCID, ST.sToCID, ST.sGID, ST.sToGID, ST.ixReceiver, ST.ixJob, ST.flgBinScanned
FROM tblSKUTransaction ST
    LEFT JOIN tblDate D on D.ixDate = ST.ixDate
    LEFT JOIN tblTime T on T.ixTime = ST.ixTime
    LEFT JOIN tblTransactionType TT on ST.sTransactionType = TT.ixTransactionType
WHERE (sBin = 'REVIEW'
       OR
       sToBin = 'REVIEW')
    AND sLocation = 99
ORDER BY ST.ixDate desc, ST.ixTime desc


SELECT * FROM tblTransactionType
where ixTransactionType in ('M','MX','QC','T','TI')

select sTransactionType, count(*) -- 47 out of 113 transaction types are in tblSKUTransaction
from tblSKUTransaction
group by sTransactionType

-- Transaction types that ARE FED to tblSKUTransaction
select ixTransactionType, sDescription
from tblTransactionType
where ixTransactionType IN (select distinct sTransactionType from tblSKUTransaction)

-- Transaction types that ARE NOT FED to tblSKUTransaction
select ixTransactionType, sDescription
from tblTransactionType
where ixTransactionType NOT IN (select distinct sTransactionType from tblSKUTransaction)
