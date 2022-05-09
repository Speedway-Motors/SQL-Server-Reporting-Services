-- SMIHD-24677 - SKU Purchases Received by Date Range

/* BASE CODE TAKEN FROM : Yesterday's SKU PO Receipts.rdl
      ver 20.27.1
*/
DECLARE @StartDate datetime = '01/01/2021',
		@EndDate datetime = '12/31/2021'

SELECT DISTINCT --dtDate 
     --, ST.sCID 
      ST.ixSKU 
     , SUM(iQty) AS QtyRcvd 
    -- , S.ixABCCode 'ABCCode'
    -- , S.sCycleCode 'CycleCode'
   --  , PO.ixPO AS PO
    -- , sToBin AS CurLoc 
   --  , SL.QtyCommitted 
--, SL.QtyBkr 
   --  , PO.ixReceiver
   --  , R.ixCreateUser 'ReciverUser'
FROM tblSKUTransaction ST 
LEFT JOIN tblDate D ON D.ixDate = ST.ixDate 
LEFT JOIN (SELECT SUBSTRING(sTransactionInfo, CHARINDEX('*', sTransactionInfo) + 1, LEN(sTransactionInfo)) AS ixPO 
                  -- (above) used to parse out the PO number from the info
                , sCID 
			    , ixSKU 
			    , ixReceiver 			    
		   FROM tblSKUTransaction 
		   WHERE sTransactionType = 'R'
          ) PO ON PO.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS = ST.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS AND PO.sCID = ST.sCID  
LEFT JOIN tblReceiver R on R.ixReceiver COLLATE SQL_Latin1_General_CP1_CS_AS = PO.ixReceiver COLLATE SQL_Latin1_General_CP1_CS_AS                                                                                               
--LEFT JOIN (SELECT ixSKU 
--            , ISNULL(iQOS,0) - ISNULL(iQAV,0) AS QtyCommitted 
--                -- (above) iQC + iQCB + iQCBOM + iQCXFER + Qty in Bins NOT Available for Orders (i.e. RBOM) 
--            , ISNULL(iQCB,0) AS QtyBkr
--        FROM tblSKULocation 
--        WHERE ixLocation = 99 
--        ) SL ON SL.ixSKU = ST.ixSKU     
LEFT JOIN tblSKU S on S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS = ST.ixSKU
WHERE dtDate BETWEEN '01/01/2021' AND  '12/31/2021'
  AND sTransactionType = 'T' 
 -- AND sLocation = '99' 
  AND sBin = 'RCV' 
GROUP BY --dtDate 
        ST.ixSKU 
     --  , S.ixABCCode
     --  , S.sCycleCode 
     --  , PO.ixPO 
     --  , sToBin   
     --  , SL.QtyCommitted
     --  , SL.QtyBkr
     --  , PO.ixReceiver  
     --  , R.ixCreateUser
ORDER BY ixSKU


-- 32-SPFRH	90 x2