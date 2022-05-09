-- Case 15882 - CID Transaction history subreport

SELECT top 4
    D.dtDate as 'Date',
    T.chTime as 'Time',
    ST.sUser, sTransactionType, 
    --sCID, ixSKU, 
    iQty as 'Qty',
sLocation as 'Location', 
sToLocation as 'ToLocation', 
    sBin as 'Bin', 
    sToBin as 'ToBin', 
    sGID as 'GID', 
    sToGID as 'ToGID', 
    sTransactionInfo as 'TransactionInfo'
FROM tblSKUTransaction ST 
    left join tblDate D on D.ixDate = ST.ixDate
    left join tblTime T on T.ixTime = ST.ixTime 
WHERE sCID = '1315345'
ORDER BY ST.ixDate desc, ST.ixTime desc

select * from tblSourceCode
where sSourceCodeType like 'WEB%'

select distinct sSourceCodeType
from tblSourceCode

 
select ixSourceCode, COUNT(*)
from tblCustomer
where ixSourceCode like 'EBAY%'
group by ixSourceCodeI


select * from tblEmployee where flgCurrentEmployee = 1

select * from tblDepartment



SELECT * FROM tblVendor
where sName like 'SPARC%'