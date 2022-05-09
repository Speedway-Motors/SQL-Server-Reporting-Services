-- SMIHD-6147 - SKUs sent to and from QAHOLD
/* ver 17.35.1

DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '08/28/17',    @EndDate = '08/28/17'  
*/

SELECT ST.ixSKU 'SKU', 
    D.dtDate, CONVERT(VARCHAR, D.dtDate, 10)  AS 'TransDate',T.chTime 'TransTime'
    , ST.sUser 'User'
    , ST.sTransactionType 'Trans Type'
    , ST.iQty 'Qty'
    , ST.sBin 'From Bin'
    , ST.sToBin 'To Bin'
    , ST.sCID 'CID'
    , ST.sTransactionInfo 'Transaction Info'
FROM tblSKUTransaction ST
    join tblDate D on ST.ixDate = D.ixDate
    join tblTime T on ST.ixTime = T.ixTime
where D.dtDate between @StartDate and @EndDate
    AND ST.sTransactionType  IN ('QC','T','TI')
    AND (ST.sBin = 'QAHOLD' or ST.sToBin = 'QAHOLD')
ORDER BY ST.ixSKU, ST.ixDate desc, T.chTime desc






SELECT sTransactionType, COUNT(*)
FROM tblSKUTransaction
WHERE ixDate >= 17533
GROUP BY sTransactionType
ORDER BY COUNT(*) DESC