--SELECT TOP 10 * FROM tblSKUTransaction

SELECT ST.ixSKU 
     , ST.sCID
     , ST.sToCID 
     , D.dtDate 
     , T.chTime
     , ST.sUser 
     , ISNULL(ST.sTransactionInfo, '') + ' ' + TT.sDescription AS TransactionInfo
     , ST.sTransactionType  
     , ST.iQty
     , ST.sBin
     , ST.sToBin
FROM tblSKUTransaction ST 
JOIN tblDate D ON D.ixDate = ST.ixDate 
JOIN tblTime T ON T.ixTime = ST.ixTime  
JOIN tblTransactionType TT ON TT.ixTransactionType COLLATE SQL_Latin1_General_CP1_CI_AS  = ST.sTransactionType COLLATE SQL_Latin1_General_CP1_CI_AS  
WHERE dtDate BETWEEN '10/28/12' AND GETDATE() --@StartDate AND @EndDate  
  and ST.sUser IN ('LMC1') --(@User)  
  and ST.sLocation IN ('99') --(@Location) 
ORDER BY ST.sUser
       , D.dtDate 
       , T.chTime --ST.sUser 
